# NetworkServer.jl

A backend to do OPF calculations for [PanTaGruEl.jl](https://github.com/laurentpagnier/pantagruel.jl)

Simply add this repository to Julia by using
```julia
using Pkg
Pkg.add("https://github.com/julianfritzsch/networkserver.jl")
```

The just import the package and start the server
```julia
using NetworkServer
start_server()
```

To see the available API commands go to the displayed documentation website.
Per default it is [http://127.0.0.1:8080/docs](http://127.0.0.1:8080/docs)
