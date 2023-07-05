module NetworkServer
using PowerModels

using JuMP
using Ipopt
using HTTP
using JSON3
using Oxygen
using DataFrames
using Dates
using CSV
using Gurobi

include("exceptions.jl")
include("server.jl")
include("networks.jl")
include("opf.jl")
include("panta.jl")
include("entsoe.jl")
include("pf.jl")

const MODULE_FOLDER = pkgdir(@__MODULE__)
entsoe = DataFrame(CSV.File(MODULE_FOLDER * "/data/entsoe.csv"))
function __init__()
    try
        Gurobi.Env()
        global opti = Gurobi.Optimizer
    catch
        println("Gurobi does not work on your system. Falling back to IPOPT.")
        global opti = Ipopt.Optimizer
    end
end

precompile(start_server, ())
end
