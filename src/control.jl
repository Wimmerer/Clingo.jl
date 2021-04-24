struct Control
    p::Ptr{LibClingo.clingo_control}
end

function Control()
    p = Ref(Ptr{LibClingo.clingo_control}())
    @wraperror LibClingo.clingo_control_new(C_NULL, 0, C_NULL, C_NULL, 100, p)
    return Control(p[])
end

function add(ctl::Control, program::AbstractString)
    @wraperror LibClingo.clingo_control_add(ctl.p, pointer("base"), C_NULL, 0, pointer(program))
end

function add(ctl::Control, part::String, program::String)
    @wraperror LibClingo.clingo_control_add(ctl.p, pointer(part), C_NULL, 0, pointer(program))
end

function ground(ctl::Control, parts::Vector{LibClingo.clingo_part}=[LibClingo.clingo_part(pointer("base"),C_NULL, 0)], callback=C_NULL, callback_data=C_NULL)
    @wraperror LibClingo.clingo_control_ground(ctl.p, parts, length(parts), callback, callback_data)
end
