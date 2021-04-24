module Clingo
include("LibClingo/LibClingo.jl")
import .LibClingo
export LibClingo
include("errors.jl")
include("control.jl")
end
