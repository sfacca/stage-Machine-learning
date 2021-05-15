
# just use poormans_tokenizer
function stem_tokenize_doc(sd::StringDocument{String}; stemmer=Stemmer("english"), tokenizer=punctuation_space_tokenize)
    stem!(stemmer, sd)
    tokenizer(text(sd))
end

function stem_tokenize_doc(doc::Array{StringDocument{String},1}; stemmer=Stemmer("english"), tokenizer=punctuation_space_tokenize)
    [stem_tokenize_doc(x; stemmer = stemmer, tokenizer = tokenizer) for x in doc]
end