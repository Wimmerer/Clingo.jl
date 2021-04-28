struct Control
    p::Ptr{LibClingo.clingo_control}
end
function Control(args::Vector{String}, logger = C_NULL, logger_data=C_NULL, message_limit=20)
    return Control(LibClingo.clingo_control_new(args, length(args), logger, logger_data, message_limit))
end
function Control()
    return Control(["0"])
end


struct Model
    p::Ptr{LibClingo.clingo_model}
end

struct Handle
    p::Ptr{LibClingo.clingo_solve_handle}
end