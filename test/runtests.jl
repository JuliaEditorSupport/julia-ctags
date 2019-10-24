using Test

include("test_tags.jl")

function main()
    outputs = trygeneratetags(testfilepath)
    targets = gettargettags(testtagspath)
    # println("targets: ", targets)
    # println("outputs: ", outputs)
    testtags(targets, outputs)
end

main()

