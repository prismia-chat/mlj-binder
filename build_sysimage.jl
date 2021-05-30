# This software is licensed under the MIT License (MIT).

import Pkg

srcdir = @__DIR__

Pkg.activate(srcdir)

# Need to have PackageCompiler installed
Pkg.add("PackageCompiler", preserve = Pkg.PRESERVE_ALL)

prj_file = Pkg.project().path
prj_dir = dirname(prj_file)

@info("Building custom system image in project \"$prj_dir\".")

@info("Instantiating project.")
Pkg.instantiate()

@info("Precompiling packages.")
Pkg.precompile()

excluded = [
  "PyCall", 
  "SymPy", 
  "StatsPlots",
  "ImageMagick",
  "StatsBase",
  "PackageCompiler",
  "Ipopt",
  "SpecialFunctions",
]

prj_sysimage = get(Pkg.TOML.parsefile(prj_file), "deps", Dict{String,Any}())
sysimg_pkgs = filter(x -> x ∉ excluded, sort(collect(keys(prj_sysimage))))
@info("Package to include in system image: $(join(sysimg_pkgs, " "))")

@info("Building system image.")

import PackageCompiler, Libdl

sysimage_path = joinpath(srcdir, "JuliaSysimage." * Libdl.dlext)

PackageCompiler.create_sysimage(
    Symbol.(sysimg_pkgs),
    sysimage_path = sysimage_path,
    precompile_execution_file = joinpath(srcdir, "precompile_exec.jl"),
    cpu_target = PackageCompiler.default_app_cpu_target(),
    replace_default = false
)

@info "Created custom Julia system image"