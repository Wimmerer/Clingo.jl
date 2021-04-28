function Control()
    return Control(["0"])
end
function Control(args::Vector{String}, logger = C_NULL, logger_data=C_NULL, message_limit=20)
    p = Ref(Ptr{LibClingo.clingo_control}())
    @wraperror LibClingo.clingo_control_new(args, length(args), logger, logger_data, message_limit, p)
    return Control(p[])
end

function add(ctl::Control, program::String)
    add(ctl, "base", String[], program)
end

function add(ctl::Control, part::String, parameters::Vector{String}, program::String)
    @wraperror LibClingo.clingo_control_add(ctl.p, pointer(part), parameters, length(parameters), pointer(program))
end

function ground(ctl::Control, parts::Vector{LibClingo.clingo_part}=[LibClingo.clingo_part(pointer("base"),C_NULL, 0)], callback=C_NULL, callback_data=C_NULL)
    @wraperror LibClingo.clingo_control_ground(ctl.p, parts, length(parts), callback, callback_data)
end

function solve(ctl::Control)
    h = Ref(Ptr{LibClingo.clingo_solve_handle}())
    @wraperror LibClingo.clingo_control_solve(ctl.p, LibClingo.clingo_solve_mode_yield, C_NULL, 0, C_NULL, C_NULL, h)
    return Handle(h[])
end

function testsolve(str)
    ctl = Control()
    add(ctl, str)
    ground(ctl)
    h = solve(ctl)
    o = Vector{Vector{String}}()
    while true
        if !storemodelstr(h,o)
            break
        end
    end
    r = getresult(h)
    LibClingo.clingo_control_free(ctl.p)
    return r,o
end
