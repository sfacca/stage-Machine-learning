"""
The lexicon file is assumed to have one word per line.
"""
function make_lexicon(arr::Array)
    str = ""
    for word in arr
        str*="$word\n"
    end
    str[1:end-1]#removing trailing whitespac
end

function write_lexicon(arr::Array, name="vocab.lexicon")
    open(name, "w") do file
        write(file, make_lexicon(arr))
    end
end
function write_lexicon(str::String, name="vocab.lexicon")
    open(name, "w") do file
        write(file, str)
    end
end


