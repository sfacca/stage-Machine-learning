"""
The lexicon file is assumed to have one word per line.
"""
function make_lexicon(arr::Array, wordy=false)
    str = ""
    for i in 1:length(arr)
        str*="$(arr[i])\n"
        if wordy
            println("word $i out of $(length(arr))")
        end
    end
    str[1:end-1]#removing trailing whitespace
end

function write_lexicon(arr::Array, name="vocab.lexicon", wordy=false)
    open(name, "w") do file
        write(file, make_lexicon(arr, wordy))
    end
end
function write_lexicon(str::String, name="vocab.lexicon")
    open(name, "w") do file
        write(file, str)
    end
end

function write_embedded_lexicon(lexicon::Array{Float64,2}, name="embedded_vocab.lexicon")
    open(name, "w") do file
        x = 1
        wordlen = size(lexicon)[1]
        for i in 1:length(lexicon)
            # add item to line
            write(file, string(lexicon[i]))
            if x == wordlen
                write(file, "\n")
                x=1 
            else
                write(file, " ")
                x+=1
            end          
        end
    end
end
