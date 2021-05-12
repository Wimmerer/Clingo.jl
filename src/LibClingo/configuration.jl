struct Configuration
    p::Ptr{configuration_t}
    key::id_t
    type::configuration_type_bitset_t
end

function Configuration(p::Ptr{configuration_t}, key::id_t)
    return Configuration(p, key, configuration_type(p, key))
end

function Configuration(ctl::Control)
    p = control_configuration(ctl)
    return Configuration(p, configuration_root(p))
end

Base.unsafe_convert(::Type{Ptr{configuration_t}}, c::Configuration) = c.p

function subkey(c::Configuration, name::String)
    c.type == configuration_type_map || error("Configuration $(c.key) is not a map type")
    if configuration_map_has_subkey(c, c.key, name)
        return configuration_map_at(c, c.key, name)
    else
        return nothing
    end
end

type(c::Configuration, key::id_t) = configuration_type(c,key)
type(c) = configuration_type(c,c.key)

function Base.getproperty(c::Configuration, v::Symbol)
    if v ∈ fieldnames(Configuration)
        return getfield(c, v)
    end
    s = String(v)
    k = subkey(c,s)
    k === nothing && error("type Configuration has no field $(String(v))")
    if type(c,k) == configuration_type_value
        if configuration_value_is_assigned(c, k)
            return configuration_value_get(c, k)
        else
            return nothing
        end
    end
    return Configuration(c.p, k)
end

function Base.propertynames(c::Configuration)
    return Symbol.(keys(c))
end
function description(c::Configuration, key::id_t)
    return configuration_description(c, key)
end
description(c::Configuration) = description(c, c.key)
    
function keys(c::Configuration)
    if c.type == configuration_type_map
        v = Vector{String}()
        for k ∈ 0:(configuration_map_size(c, c.key) - 1)
            push!(v, configuration_map_subkey_name(c,c.key, k))
        end
        return v
    else
        return nothing
    end
end