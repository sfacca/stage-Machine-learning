using WordTokenizers

# just use poormans_tokenizer
function stem_tokenize_doc(sd::StringDocument; stemmer=Stemmer("english"), tokenizer=punctuation_space_tokenize)
    stem!(stemmer, sd)
    tokenizer(text(sd))
end