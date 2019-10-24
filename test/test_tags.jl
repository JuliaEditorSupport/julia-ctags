"Tags starting with this identifier are broken. Remove upon fix."
const brokenidentifiers = (
        "deprecated_returnsquarepower",
        "deprecated_squarepower",
        "DocTestSetup",
        "printgreeting",
        "returnsquarepower",
)
"Kinds that have not been added yet (and are therefore broken). Remove upon fix."
const brokenkinds = ('m', 's')

"Path to Ctags configuration file (the parser)."
const ctagsconfigpath = joinpath(@__DIR__, "..", "ctags")
"Test file to generate the tags from."
const testfilepath = joinpath(@__DIR__, "testfile.jl")
"File containing test tags to compare against."
const testtagspath = joinpath(@__DIR__, "testtags")

"Ctags binaries to sequentially try to call if one is not found."
const ctagsbins = (
        "uctags",
        "ectags",
        "universal-ctags",
        "exuberant-ctags",
        "u-ctags",
        "e-ctags",
        "ctags",
)
"Arguments to pass to a Ctags binary."
const ctagsargs = (
        "--options=$ctagsconfigpath",  # Include our tags file.
        "-f -"  # Write to stdout.
)


"Utility function to convert an `AbstractVector` of tags to a common format."
function converttags(tags::AbstractVector)
    tags = filter(s -> !isempty(s) && s[1] != '!', tags)
    Set(tags)
end

"Return tags generatad from the given file and convert them using [`converttags`](@ref)."
function generatetags(testfile::AbstractString, ctagsbin::AbstractString="ctags")
    ctagscmd = `$ctagsbin $ctagsargs $testfile`
    tags = open(ctagscmd, "r", stdout) do io
        readlines(io)
    end
    return converttags(tags)
end

function trygeneratetags(testfile::AbstractString)
    for ctagsbinary in ctagsbins
        try
            return generatetags(testfile, ctagsbinary)
        catch e
            # For compatibility accept either exception type.
            if !(err isa LoadError || err isa ErrorException
                 || err isa ProcessFailedException)
                rethrow()
            end
        end
    end
end

"""
Return tags to compare against.
The desired output of the Ctags program applied to [`testfilepath`](@ref).
"""
function gettargettags(testtags::AbstractString)
    tags = readlines(testtags)
    converttags(tags)
end


"Return the path listed in the output tags."
function getpath(outputs)
    # We are operating on a set, so we cannot use `lastindex`.
    refoutput = pop!(outputs)
    push!(outputs, refoutput)
    path = split(refoutput, '\t')[2]
end

"Return whether the given tag should be evaluated using [`test_broken`](@ref)."
function isbroken(target)
    columns = split(target, '\t')
    return columns[1] in brokenidentifiers || columns[4][1] in brokenkinds
end

"Replace the path listed in the given tag with the given path."
function replacepath(tag, path)
    arraytag = split(tag, '\t')
    arraytag[2] = path
    return join(arraytag, '\t')
end


"""
Test whether the given target is in the given outputs.
The target's listed path is replaced with `outputpath` to ensure static tests.
"""
function test_target_in_outputs(target, outputs, outputpath)
    target = replacepath(target, outputpath)
    target_in_outputs = target in outputs

    if isbroken(target)
        println("testing broken tag: ", target)
        result = @test_broken target_in_outputs
    else
        println("testing tag:        ", target)
        result = @test target_in_outputs
    end
    target_in_outputs && delete!(outputs, target)
end

"Test the two given tags against each other."
function testtags(targets, outputs)
    outputpath = getpath(outputs)
    @testset "Tags" begin
        for target in targets
            test_target_in_outputs(target, outputs, outputpath)
        end
        @test_broken isempty(outputs)
    end
end

