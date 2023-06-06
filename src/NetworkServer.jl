module NetworkServer
using PowerModels

try
    using Gurobi
    global gurobi = true
catch e
    global gurobi = false
    println("The Gurobi Package could not be found. Falling back to IPOPT. If you want to use Gurobi make sure it can be imported using `using Gurobi`.")
end 
using JuMP
using Ipopt
using HTTP
using JSON3
using Oxygen
using DataFrames
using Dates
using CSV

include("exceptions.jl")
include("server.jl")
include("networks.jl")
include("opf.jl")
include("panta.jl")
include("entsoe.jl")
include("pf.jl")
const MODULE_FOLDER = pkgdir(@__MODULE__)
entsoe = DataFrame(CSV.File(MODULE_FOLDER * "/data/entsoe.csv"))
println(gurobi)
end
