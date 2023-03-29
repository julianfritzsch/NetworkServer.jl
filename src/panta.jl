function dc_opf_entsoe(grid::Dict)
    country = get_entsoe_data(grid)
    grid = distribute_country_load(grid, country, false)
    grid = dc_opf(grid)
    return grid
end

# This is at the moment the same as for the DC case just with losses on the lines
function ac_opf_entsoe(grid::Dict)
    country = get_entsoe_data(grid)
    country = create_reactive_data(country)
    grid = distribute_country_load(grid, country, true)
    grid = ac_opf(grid)
    return grid
end

# This needs to be filled. At the moment it only creates the necessary entries to make the
# "AC" OPF work
function create_reactive_data(country::Dict)
    for (_, item) in country
        item["qd"] = 0.
    end
    return country
end
