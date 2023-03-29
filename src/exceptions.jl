struct ServerException <: Exception 
    msg::String
end

struct ClientException <: Exception 
    msg::String
end
