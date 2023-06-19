# Used for exceptions when the user provided data could be parsed but an
# error occured during processing (e.g., the optimization did not converge)
struct ServerException <: Exception
    msg::String
end

# Used when the provided data could not be parsed or is missing elements
struct ClientException <: Exception
    msg::String
end


