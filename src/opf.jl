function dc_opf(grid::Dict)
    grid = solve_model_opf(grid, DCPPowerModel)
    grid = remove_nan(grid)
    return grid
end

function ac_opf(grid::Dict)
    grid = solve_model_opf(grid, DCPLLPowerModel)
    # In case it is a DC Opf with lossy lines we still need to take care of 
    # NaN for the reactive power
    if isnan(grid["gen"][collect(keys(grid["gen"]))[1]]["qg"])
        grid = remove_nan(grid)
    end
    return grid
end

function dc_opf_country(grid::Dict, country::Dict)
    grid = distribute_country_load(grid, country, false)
    grid = dc_opf(grid)
    return grid
end

function ac_opf_country(grid::Dict, country::Dict)
    grid = distribute_country_load(grid, country, true)
    grid = ac_opf(grid)
    return grid
end

function solve_model_opf(grid::Dict, model::DataType)
    pm = 0
    try
        pm = instantiate_model(grid, model, PowerModels.build_opf)
    catch
        throw(ClientException("The grid could not be parsed. It probably has incorrect data or is missing entries. The full grid needs to be passed."))
    end
    set_silent(pm.model)
    result = optimize_model!(pm, optimizer=opti)
    # Check if optimization was successful
    if !(result["termination_status"] in [OPTIMAL LOCALLY_SOLVED ALMOST_OPTIMAL ALMOST_LOCALLY_SOLVED])
        throw(ServerException("The OPF did not converge."))
    end
    # Update data and set success
    update_data!(grid, result["solution"])
    return grid
end

function remove_nan(grid::Dict)
    for v in values(grid["gen"])
        isnan(v["pg"]) && (v["pg"] = 0)
        isnan(v["qg"]) && (v["qg"] = 0)
    end
    for v in values(grid["branch"])
        isnan(v["pf"]) && (v["pf"] = 0)
        isnan(v["pt"]) && (v["pt"] = 0)
        isnan(v["qf"]) && (v["qf"] = 0)
        isnan(v["qt"]) && (v["qt"] = 0)
    end
    return grid
end

function distribute_country_load(grid::Dict, country::Dict, reactive::Bool)
    Sb = 0
    try
        Sb = grid["baseMVA"]
    catch
        throw(ClientException("The grid could not be parsed. It probably has incorrect data or is missing entries. The full grid needs to be passed."))
    end
    for key in keys(grid["load"])
        ctry = grid["bus"][string(grid["load"][key]["load_bus"])]["country"]
        coeff = grid["bus"][string(grid["load"][key]["load_bus"])]["load_prop"]
        try
            grid["load"][key]["pd"] = country[ctry]["pd"] * coeff / Sb
            if reactive
                grid["load"][key]["qd"] = country[ctry]["qd"] * coeff / Sb
            end
        catch e
            if isa(e, KeyError)
                throw(ClientException("Could not find load data for country $ctry"))
            else
                throw(ClientException("Country load data is in the wrong format"))
            end
        end
    end
    return grid
end
