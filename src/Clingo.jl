module Clingo
include("LibClingo/LibClingo.jl")
import .LibClingo

function getVersion()
    major = Ref{Cint}(0)
    minor = Ref{Cint}(0)
    rev = Ref{Cint}(0)
    LibClingo.clingo_version(major,minor,rev)
    print("$(major[]).$(minor[]).$(rev[])")
end
end
