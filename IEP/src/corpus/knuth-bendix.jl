using KnuthBendix
# we want to build a rewriting system, based on our documents, to replace words with the same meaning

# RewritingSystem{W<:AbstractWord, O<:WordOrdering} <:AbstractRewritingSystem{W}
# need Word and WordOrdering
# Word{T}: a simple Base.Vector{T} based implementation
# BufferWord{T}: an implementation based on Vector{T} storage, which tries to pre-allocate storage to avoid unnecessary allocations for push!/pop! operations.

#1 create empty alphabet
#2 convert words by adding letters to alphabet if they're not in it already
#   ^ alphabet is a vector -> might cause a lot of realloc

# 1. create alphabet with common letters
# 2. same as 2 above
# ^ this just means there will be about 26-52 less reallocs

alph = Alphabet()


function makeWord(alphabet, word::String; update_alphabet = true)
    # convert word to array of chars
    word = [first(x) for x in split(word, "")]
    makeWord(alphabet, word; update_alphabet=update_alphabet)
end
function makeWord(alphabet, word::Array{Char,1}; update_alphabet = true)
    tmp = Array{Int,1}(undef , length(word))

    for i in 1:length(word)
        try
            tmp[i] = KnuthBendix.getindexbysymbol(alphabet, word[i])
        catch e
            if update_alphabet
                push!(alphabet, word[i])
                tmp[i] = KnuthBendix.getindexbysymbol(alphabet, word[i])
            else
                throw("letter $(word[i]) is not in alphabet and update_alphabet is set to false")
            end
        end
    end

    Word{Int}(tmp)
end
function makeWord(alphabet, word; update_alphabet = true)
    makeWord(alphabet, String(word); update_alphabet=update_alphabet)
end

# next we need orderings
# what is an ordering?
