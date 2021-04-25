struct Model
    p::Ptr{LibClingo.clingo_model}
end

struct Handle
    p::Ptr{LibClingo.clingo_solve_handle}
    
end

function Base.iterate(h::Handle, state=1)
    @wraperror LibClingo.clingo_solve_handle_resume(h.p)
    r = Ref(Ptr{LibClingo.clingo_model}())
    @wraperror LibClingo.clingo_solve_handle_model(h.p,r)
    m = Model(r[])

    return m.p == C_NULL ? nothing : m
end

function getmodel(h::Handle)
    @wraperror LibClingo.clingo_solve_handle_resume(h.p)
    r = Ref(Ptr{LibClingo.clingo_model}())
    @wraperror LibClingo.clingo_solve_handle_model(h.p,r)
    m = Model(r[])
    return (m.p == C_NULL ? nothing : m)
end

function storemodelstr(h::Handle, v::Vector{Vector{String}})
    @wraperror LibClingo.clingo_solve_handle_resume(h.p)
    r = Ref(Ptr{LibClingo.clingo_model}())
    @wraperror LibClingo.clingo_solve_handle_model(h.p,r)
    m = Model(r[])
    if m.p == C_NULL
        return false
    end
    push!(v, modeltostrings(m))
    print("$(getmodelnumber(m)): $(v[end])")
    return true
end
function getmodelnumber(m::Model)
    n = Ref{Csize_t}(0)
    @wraperror LibClingo.clingo_model_number(m.p, n)
    return n[]
end

function getresult(h::Handle)
    r = Ref{LibClingo.clingo_solve_result_bitset_t}(0)
    @wraperror LibClingo.clingo_solve_handle_get(h.p, r)
    @wraperror LibClingo.clingo_solve_handle_close(h.p)
    return LibClingo.clingo_solve_result_e(r[])
end

function modeltostrings(m::Model)
    numatoms = Ref{Csize_t}(0)
    @wraperror LibClingo.clingo_model_symbols_size(m.p, LibClingo.clingo_show_type_shown, numatoms)
    numatoms = numatoms[]
    atoms = Vector{LibClingo.clingo_symbol_t}(undef, numatoms)
    @wraperror LibClingo.clingo_model_symbols(m.p, LibClingo.clingo_show_type_shown, atoms, numatoms)
    symbols = Vector{String}()
    for i ∈ 1:numatoms
        strsize = Ref{Csize_t}(0)
        @wraperror LibClingo.clingo_symbol_to_string_size(atoms[i], strsize)
        strsize = strsize[]
        str = Vector{Cchar}(undef, strsize)
        @wraperror LibClingo.clingo_symbol_to_string(atoms[i], str, strsize)
        push!(symbols, unsafe_string(pointer(str)))
    end
    return symbols
end

