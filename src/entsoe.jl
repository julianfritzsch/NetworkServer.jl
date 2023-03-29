function get_entsoe_data(grid::Dict)
    date = DateTime(grid["date"]["year"], grid["date"]["month"], grid["date"]["day"], grid["date"]["hour"])    
    ix = findfirst(entsoe[:, :Date] .== date)
    if ix === nothing
        throw(ServerException("Date not in the available ENTSO-E data."))
    end
    country = Dict()
    for name in names(entsoe)
        if name == "Date"
            continue
        end
        country[name] = Dict()
        country[name]["pd"] = entsoe[ix, name]
    end
    return country
end

function get_available_dates()
    return entsoe[:, :Date]
end


