function load_embedded_lexicon(stream=open("./embedded_vocab.lexicon"))
    lines = readlines(stream)
    res = Array{Float64,2}(undef, length(_get_line(lines[1])), length(lines))
    for i in 1:length(lines)
        res[:,i] = _get_line(lines[i])
    end
    res
end

function _get_line(str::String)
    # parses a line
    [parse(Float64,x) for x in split(str, " ")]
end

function checcc(lexicon)
    lexicon == load_embedded_lexicon()
end