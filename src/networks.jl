using PowerModels

function ieee14()
    grid = PowerModels.parse_file(MODULE_FOLDER * "/networks/ieee14.json")
    return grid
end

function pantagruel()
    # NOT IMPLEMENTED YET - RETURNS IEEE 14
    grid = PowerModels.parse_file(MODULE_FOLDER * "/networks/ieee14.json")
    return grid
end
