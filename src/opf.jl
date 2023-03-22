using PowerModels
using Ipopt

function dc_opf(grid::Dict)
    result = PowerModels.solve_opf(grid, DCMPPowerModel, Ipopt.Optimizer)
    # Check if optimization was successful
    if !(result["termination_status"] in [OPTIMAL LOCALLY_SOLVED ALMOST_OPTIMAL ALMOST_LOCALLY_SOLVED])
        grid["success"] = false
        return grid
    end
    # Update data and set success
    update_data!(grid, result["solution"])
    grid["success"] = true
    # In DC OPF we need to set all "calculated" reactive power values to 0
    for key in keys(grid["gen"])
        grid["gen"][key]["qg"] = 0
    end
    for key in keys(grid["branch"])
        grid["branch"][key]["qf"] = 0
        grid["branch"][key]["qt"] = 0
    end
    return grid
end


function ac_opf(grid::Dict)
    result = PowerModels.solve_opf(grid, ACPPowerModel, Ipopt.Optimizer)
    # Check if optimization was successful
    if !(result["termination_status"] in [OPTIMAL LOCALLY_SOLVED ALMOST_OPTIMAL ALMOST_LOCALLY_SOLVED])
        grid["success"] = false
        return grid
    end
    # Update data and set success
    update_data!(grid, result["solution"])
    grid["success"] = true
    return grid
end
