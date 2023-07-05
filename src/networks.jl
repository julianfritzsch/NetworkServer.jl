function pantagruel()
    return load_grid(joinpath([MODULE_FOLDER, "networks", "pantagruel.json"]))
end

function load_grid(path::String)::Dict{String, Any}
    grid = Dict()
    try
        grid = PowerModels.parse_file(path)
    catch
        throw(ServerException("Could not load \"$path\""))
    end
    return grid
end
