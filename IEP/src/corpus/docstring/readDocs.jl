using TopicModels



function readDocs(stream)
    corpus = readlines(stream)
    docs = Array{Document,1}(undef,length(corpus))
    for i in 1:length(corpus)
      @inbounds terms = split(corpus[i], " ")[2:end]
      @inbounds docs[i] = Document(termToWordSequence(terms[1]))
      for ii in 2:length(terms)
        @inbounds append!(docs[i].terms, termToWordSequence(terms[ii]))
      end
    end
    return docs
end