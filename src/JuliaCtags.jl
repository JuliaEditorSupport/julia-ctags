module JuliaCtags

export get_config

function write_config(filename = "./julia_ctags")
    sourcefile = joinpath(@__DIR__, "ctags")
    cp(sourcefile, filename)
end

end # module
