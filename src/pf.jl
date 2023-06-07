function dc_pf(grid::Dict)
    grid = solve_model_pf(grid, DCMPPowerModel)
    grid = remove_reactive_nan(grid)
    return grid
end

function ac_pf(grid::Dict)
    grid = solve_model_pf(grid, DCPLLPowerModel)
    grid = remove_reactive_nan(grid)
    return grid
end

function solve_model_pf(grid::Dict, model::DataType)
    pm = 0
    try
        pm = instantiate_model(grid, model, PowerModels.build_pf)
    catch
        throw(ClientException("The grid could not be parsed. It probably has incorrect data."))
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
