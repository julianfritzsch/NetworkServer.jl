# NetworkServer.jl

A backend to do (optimal) power flow calculations for [PanTaGruEl.jl](https://github.com/laurentpagnier/pantagruel.jl).
A project using this package can be found [here](http://pantagruel-frontend.netlify.app).

# Table of Contents
1. [Quickstart](#quickstart)
2. [Detailed Installation Instructions](#detailed-installation-instructions)
    1. [Julia](#julia)
    2. [Gurobi](#gurobi)
    3. [Package Installation](#package-installation)
    4. [Starting the Server](#starting-the-server)
3. [API Documentation](#api-documentation)
4. [Contribute](#contribute)

# Quickstart
Simply add this repository to Julia by using
```julia
using Pkg
Pkg.add("https://github.com/julianfritzsch/networkserver.jl")
```

Then just import the package and start the server
```julia
using NetworkServer
start_server(port=8080)
```

To see the available API commands go to the displayed documentation website.
Per default it is [http://127.0.0.1:8080/docs](http://127.0.0.1:8080/docs).

# Detailed Installation Instructions
## Julia
Begin by installing Julia. 
This can be done by downloading the latest Julia release from their website [julialang.org](https://julialang.org/downloads/#current_stable_release) and following the instructions.
Alternatively, you can also use a package manager.

For MacOS
```bash
brew install julia
```

For Ubuntu
```bash
sudo apt install julia
```

## Gurobi
Next install the Gurobi optimizer.
First, create an account [here](https://portal.gurobi.com/iam/register/) then download and install the optimizer.
Note that you need to install Gurobi version 10.0.0 because this is the latest that is supported by [Gurobi.jl](https://github.com/jump-dev/Gurobi.jl).
If you have an academic affiliation you can get a free academic license and activate it by following the instructions on the Gurobi page.
Alternatively, if you are in the HEVS network you can use the site license by placing a file name `gurobi.lic` with the contents
```text
TOKENSERVER=gurobilm.hevs.ch
```
in your home folder.

## Package Installation
Start Julia by typing
```bash
julia
```
in a terminal.
In the REPL type the following
```julia
] # To enter the package managment. Your prompt should now read pkg>
add https://github.com/julianfritzsch/networkserver.jl
```
The installation requires Gurobi to be installed. If you don't have Gurobi installed, you can try setting the `GUROBI_JL_SKIP_LIB_CHECK` environment variable to any value.
NetworkServer.jl will automatically detect on startup if Gurobi can be used and fallback to [Ipopt.jl](https://github.com/jump-dev/Ipopt.jl) (note that this is significant slower).

## Starting the Server
Start Julia by typing
```bash
julia
```
in a terminal.
Afterwards, import the package and start the server
```julia
using NetworkServer
start_server()
```
This should set you up to use the [frontend](https://pantagruel-frontend.netlify.app).
If you want to send your own requests, you can find an API overview under [127.0.0.1:8080/docs](127.0.0.1:8080).

# API Documentation
To follow

# Contribute
If there are any problems with the package or you encounter any bugs you can report them [here](https://github.com/julianfritzsch/NetworkServer.jl/issues).
To contribute code please create a pull request to the `main` branch.
