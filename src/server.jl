export start_server
function start_server(port::Int64=8080)
    # Return the PanTaGruEl grid
    @get "/networks/pantagruel" function ()
        re = method_call(pantagruel)
        if isa(re, HTTP.Messages.Response)
            return re
        end
        return_json(re)
    end

    # Return the IEEE 14 grid
    @get "/networks/ieee14" function ()
        re = method_call(ieee14)
        if isa(re, HTTP.Messages.Response)
            return re
        end
        return_json(re)
    end

    # Do a DC OPF and save the results in the submitted grid.
    # If the OPF does not converge return the origina grid
    @post "/opf/dc_opf" function (req::HTTP.Request)
        inp = parse_json(req.body)
        if isa(inp, HTTP.Messages.Response)
            return inp
        end
        (grid, country) = separate_country_data(inp)
        re = method_call(dc_opf, grid)
        if isa(re, HTTP.Messages.Response)
            return re
        end
        grid = combine_country_data(re, country)
        return_json(re)
    end

    # Do a AC OPF and save the results in the submitted grid.
    # If the OPF does not converge return the origina grid
    @post "/opf/ac_opf" function (req::HTTP.Request)
        inp = parse_json(req.body)
        if isa(inp, HTTP.Messages.Response)
            return inp
        end
        (grid, country) = separate_country_data(inp)
        re = method_call(ac_opf, grid)
        if isa(re, HTTP.Messages.Response)
            return re
        end
        grid = combine_country_data(re, country)
        return_json(re)
    end

    # NOT IMPLEMENTED YET!!
    # Do a DC OPF and save the results in the submitted grid.
    # The loads are taken from the ENTSO-E database for a given date
    # If the OPF does not converge return the origina grid
    @post "/panta/dc_opf_entsoe" function (req::HTTP.Request)
        inp = parse_json(req.body)
        if isa(inp, HTTP.Messages.Response)
            return inp
        end
        (grid, country) = separate_country_data(inp)
        re = method_call(dc_opf_entsoe, grid)
        if isa(re, HTTP.Messages.Response)
            return re
        end
        grid = combine_country_data(re, country)
        return_json(re)
    end

    # Do a DC OPF and save the results in the submitted grid.
    # The loads have to be given per country
    # If the OPF does not converge return the origina grid
    @post "/opf/dc_opf_country" function (req::HTTP.Request)
        inp = parse_json(req.body)
        if isa(inp, HTTP.Messages.Response)
            return inp
        end
        (grid, country) = separate_country_data(inp)
        re = method_call(dc_opf_country, grid, country)
        if isa(re, HTTP.Messages.Response)
            return re
        end
        grid = combine_country_data(re, country)
        return_json(re)
    end

    # Do an AC OPF and save the results in the submitted grid.
    # The loads are taken from the ENTSO-E database for a given date
    # If the OPF does not converge return the origina grid
    @post "/panta/ac_opf_entsoe" function (req::HTTP.Request)
        inp = parse_json(req.body)
        if isa(inp, HTTP.Messages.Response)
            return inp
        end
        (grid, country) = separate_country_data(inp)
        re = method_call(ac_opf_entsoe, grid)
        if isa(re, HTTP.Messages.Response)
            return re
        end
        grid = combine_country_data(re, country)
        return_json(re)
    end

    # Do an AC OPF and save the results in the submitted grid.
    # The loads have to be given per country
    # If the OPF does not converge return the origina grid
    @post "/opf/ac_opf_country" function (req::HTTP.Request)
        inp = parse_json(req.body)
        if isa(inp, HTTP.Messages.Response)
            return inp
        end
        (grid, country) = separate_country_data(inp)
        re = method_call(ac_opf_country, grid, country)
        if isa(re, HTTP.Messages.Response)
            return re
        end
        grid = combine_country_data(re, country)
        return_json(re)
    end

    # Powerflow methods
    @post "/pf/dc_pf" function (req::HTTP.Request)
        inp = parse_json(req.body)
        if isa(inp, HTTP.Messages.Response)
            return inp
        end
        (grid, country) = separate_country_data(inp)
        re = method_call(dc_pf, grid)
        if isa(re, HTTP.Messages.Response)
            return re
        end
        grid = combine_country_data(re, country)
        return_json(re)
    end
    @post "/pf/ac_pf" function (req::HTTP.Request)
        inp = parse_json(req.body)
        if isa(inp, HTTP.Messages.Response)
            return inp
        end
        (grid, country) = separate_country_data(inp)
        re = method_call(ac_pf, grid)
        if isa(re, HTTP.Messages.Response)
            return re
        end
        grid = combine_country_data(re, country)
        return_json(re)
    end

    # Helper function to get the available entsoe-e dates
    @get "/entsoe/available_dates" function()
        re = method_call(get_available_dates)
        return_json(re)
    end

    serve(port=port)
end

function separate_country_data(grid::Dict)
    country = Dict()
    if haskey(grid, "country")
        country = grid["country"]
        delete!(grid, "country")
    else
        country = Dict()
    end
    return (grid, country)
end

function combine_country_data(grid::Dict, country::Dict)
    if !isempty(country)
        grid["country"] = country
    end
    return country
end

function return_json(vals::T) where {T}
    try
        return JSON3.write(vals)
    catch
        return html("Error converting grid to JSON", status=500)
    end
end

function method_call(method, args...)
    try
        return method(args...)
    catch e
        if isa(e, ServerException)
            return html(e.msg, status=500)
        elseif isa(e, ClientException)
            return html(e.msg, status=422)
        else
            return html("Internal server error", status=500)
        end
    end
end

function parse_json(inp)
    try
        return JSON3.read(inp, Dict)
    catch
        return html("Error parsing JSON", status=400)
    end
end
