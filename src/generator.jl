using Clang.Generators
using Clingo_jll

cd(@__DIR__)

const HEADER_BASE = joinpath(Clingo_jll.artifact_dir, "include")
const CLINGO_H = joinpath(HEADER_BASE, "clingo.h")

headers = [CLINGO_H]

options = load_options(joinpath(@__DIR__, "generator.toml"))

args = ["-I$HEADER_BASE"]

ctx = create_context(headers, args, options)

build!(ctx)