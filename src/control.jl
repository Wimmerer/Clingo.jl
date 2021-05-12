function load!(ctl::Control, file)
    isfile(file) || error("$file does not exist.")
    LibClingo.clingo_control_load(ctl, file)
end

function add!(ctl::Control, program::String; name::String = "base", parameters::Vector{String} = String[])
    LibClingo.clingo_control_add(ctl, name, parameters, length(parameters), program)
end

function ground!(ctl::Control; parts::Vector{LibClingo.clingo_part} = [LibClingo.clingo_part("base",C_NULL, 0)], callback = C_NULL, callback_data = C_NULL)
    LibClingo.clingo_control_ground(ctl, parts, length(parts), callback, callback_data)
end

function solve!(ctl::Control)
    return Handle(LibClingo.clingo_control_solve(ctl, LibClingo.clingo_solve_mode_yield, C_NULL, 0, C_NULL, C_NULL))
end

function solve!(f::Function, ctl)
    handle = solve!(ctl::Control)
    try
        f(handle)
    finally
        LibClingo.clingo_solve_handle_close(handle)
    end
end

