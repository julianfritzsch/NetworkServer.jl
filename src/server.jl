export start_server

using HTTP
using JSON3
using Oxygen

function start_server(port::Int64=8080)
    # Return the PanTaGruEl grid - NOT IMPLEMENTED YET
    @get "/networks/pantagruel" function (req::HTTP.Request)
        try
            return JSON3.write(pantagruel())
        catch
            return 0
        end
    end

    # Return the IEEE 14 grid
    @get "/networks/ieee14" function (req::HTTP.Request)
        try
            return JSON3.write(ieee14())
        catch
            return 0
        end
    end

    # Do a DC OPF and save the results in the submitted grid.
    # If the OPF does not converge return the origina grid
    @post "/opf/dc_opf" function (req::HTTP.Request)
        grid = json(req, Dict)
        try
            return JSON3.write(dc_opf(deepcopy(grid)))
        catch
            grid["success"] = false 
            return JSON3.write(grid)
        end
    end

    # Do a AC OPF and save the results in the submitted grid.
    # If the OPF does not converge return the origina grid
    @post "/opf/ac_opf" function (req::HTTP.Request)
        grid = json(req, Dict)
        try
            return JSON3.write(ac_opf(deepcopy(grid)))
        catch
            grid["success"] = false 
            return JSON3.write(grid)
        end
    end

    # NOT IMPLEMENTED YET!!
    # Everything below here is only for PanTaGruEl
    # Do a DC OPF and save the results in the submitted grid.
    # The loads are taken from the ENTSO-E database for a given date
    # If the OPF does not converge return the origina grid
    @post "/panta/dc_opf_entsoe" function (req::HTTP.Request)
        grid = json(req, Dict)
        try
            return JSON3.write(dc_opf(deepcopy(grid)))
        catch
            grid["success"] = false 
            return JSON3.write(grid)
        end
    end

    # Do a DC OPF and save the results in the submitted grid.
    # The loads have to be given per country
    # If the OPF does not converge return the origina grid
    @post "/panta/dc_opf_country" function (req::HTTP.Request)
        grid = json(req, Dict)
        try
            return JSON3.write(dc_opf(deepcopy(grid)))
        catch
            grid["success"] = false 
            return JSON3.write(grid)
        end
    end

    # Do an AC OPF and save the results in the submitted grid.
    # The loads are taken from the ENTSO-E database for a given date
    # If the OPF does not converge return the origina grid
    @post "/panta/ac_opf_entsoe" function (req::HTTP.Request)
        grid = json(req, Dict)
        try
            return JSON3.write(ac_opf(deepcopy(grid)))
        catch
            grid["success"] = false 
            return JSON3.write(grid)
        end
    end

    # Do an AC OPF and save the results in the submitted grid.
    # The loads have to be given per country
    # If the OPF does not converge return the origina grid
    @post "/opf/ac_opf_country" function (req::HTTP.Request)
        grid = json(req, Dict)
        try
            return JSON3.write(ac_opf(deepcopy(grid)))
        catch
            grid["success"] = false 
            return JSON3.write(grid)
        end
    end

    serve(port=port)
end
