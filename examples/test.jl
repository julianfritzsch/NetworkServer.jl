using HTTP
using JSON3

ieee_url = "http://127.0.0.1:8080/networks/ieee14"
panta_url = "http://127.0.0.1:8080/networks/pantagruel"

ieee_r = HTTP.get(ieee_url)
panta_r = HTTP.get(panta_url)

ieee = JSON3.read(String(ieee_r.body), Dict)
panta = JSON3.read(String(panta_r.body), Dict)

dc_url = "http://127.0.0.1:8080/opf/dc_opf"
ac_url = "http://127.0.0.1:8080/opf/ac_opf"

ieee_r = HTTP.post(ac_url, body=JSON3.write(ieee))
panta_r = HTTP.post(ac_url, body=JSON3.write(panta))

ieee = JSON3.read(String(ieee_r.body), Dict)
panta = JSON3.read(String(panta_r.body), Dict)

println("Panta success = ", panta["success"])
println("Panta success = ", ieee["success"])
