module JuliaCtags

export get_config

function get_config(destfile = "julia_ctags")
    sourcefile = (@__DIR__)*"/ctags"
    cp(sourcefile, destfile)
end

end # module
