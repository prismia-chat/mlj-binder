@info "Starting precompile exec"

ENV["PYTHON"] = "/srv/conda/envs/notebook/bin/python"

using LinearAlgebra, Statistics, DataFrames, Plots, SymPy, StatsPlots, Distributions

mean(randn(100))
randn(10, 10) \ randn(10)

df = DataFrame(a=[1,2,3], b=[4,5,6])
@df df scatter(:a, :b)

@vars x
expand((x+1)^10)

mean(Normal(0, 1))