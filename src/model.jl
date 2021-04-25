struct Model
    p::Ptr{LibClingo.clingo_model}
end

struct Handle
    p::Ptr{LibClingo.clingo_solve_handle}
end

function openhandle(f, h::Handle)
    f(h)
    @wraperror LibClingo.clingo_solve_handle_close(h.p)
end

function getmodel(h::Handle)
    @wraperror LibClingo.clingo_solve_handle_resume(h.p)
    r = Ref(Ptr{LibClingo.clingo_model}())
    @wraperror LibClingo.clingo_solve_handle_model(h.p,r)
    m = Model(r[])
    return (m.p == C_NULL ? nothing : m)
end



function getmodelnumber(m::Model)
    n = Ref{Csize_t}(0)
    @wraperror LibClingo.clingo_model_number(m.p, n)
    return n[]
end

function getresult(h::Handle)
    r = Ref{LibClingo.clingo_solve_result_bitset_t}(0)
    @wraperror LibClingo.clingo_solve_handle_get(h.p, r)
    
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

function modelinfo(m::Model)
    d = Dict{Symbol,Any}()
    d[:number] = getmodelnumber(m)
    s = modeltostrings(m)
    d[:symbols] = s
    return d
end

function storemodels(handle::Handle)
    v = Vector{Dict{Symbol, Any}}()
    openhandle(handle) do h
        while true
            m = getmodel(h)
            m !== nothing || break
            push!(v,modelinfo(m))
        end
    end
    return v
end