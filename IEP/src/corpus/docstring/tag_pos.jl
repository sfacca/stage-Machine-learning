
function _cln(asd::String)
    res = Array{String,1}(undef, 0)
    for  x in punctuation_space_tokenize(asd)
        try
            tmp = ascii(x)
            push!(res, tmp)
        catch
            #non ascii strings throw error and are dropped
        end
    end
    res
end

function _flt(asd::String, char::String)
    filter((x)->(!occursin(char, x)), x)
end

function _tag_pos(entity::Union{Corpus, TokenDocument, StringDocument})
    @warn "tag_pos! is deprecated, Use Perceptrontagger instead"
    tagger = TextModels.PerceptronTagger(true)
    if typeof(entity) == Corpus{StringDocument{String}}
        println("a corpus")
        len = length(entity.documents)
        res = Array{Any,1}(undef, len)
        for i in 1:len            
            res[i] = predict(tagger, _cln(entity.documents[i].text))
            println("doc $i out of $len done")
        end

    elseif typeof(entity) == StringDocument{String}
        println("a stringdoc")
        res = predict(tagger, string.(punctuation_space_tokenize(entity.text)))
    end
    res
end
"""
PerceptronTagger on sentences
"""
function PoSTag(str::String, tagger::TextModels.PerceptronTagger)    
    predict(tagger, _cln(str))
end
function PoSTag(data::Array{StringDocument{String},1}, tagger::TextModels.PerceptronTagger)    
    res = Array{Any,1}(undef, length(data))
    for i in 1:length(data)
        res[i] = PoSTag(data[i], tagger)
    end   
    res
end
function PoSTag(str::StringDocument{String}, tagger::TextModels.PerceptronTagger)    
    predict(tagger, _cln(str.text))
end
function PoSTag(data::Array{Any,1}, tagger::TextModels.PerceptronTagger)  
    res = Array{Any,1}(undef, length(data))
    for i in 1:length(data)
        res[i] = PoSTag(data[i], tagger)
    end   
    res
end

function postag_docstring(docstring::String, stemmer, tagger)
    #1 split sentences
    res = split_sentences(docstring)
    res = [StringDocument(string(x)) for x in res]

    #2 stem
    for str in res
        stem!(stemmer, str)
    end

    #3 tag
    PoSTag(res, tagger)
end
function postag_docstring(docstring::StringDocument{String}, stemmer, tagger)
    postag_docstring(docstring.text, stemmer, tagger)
end
function postag_docstring(data, stemmer, tagger)
    len = length(data)
    res = Array{Any,1}(undef, length(data))
    for i in 1:length(data)
        res[i] = postag_docstring(data[i], stemmer, tagger)
        println("docstring $i out of $len pos tagged")
    end
    res
end
