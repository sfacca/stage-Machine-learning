
function dirichlet(documents, lexicon, topicnum = 10, numwords = 10, iterations = 10)    
    println("making documents/lexicon corpus...")
    crps = TopicModels.Corpus(documents, lexicon)
    println("making model with $topicnum topics...")
    mdl = TopicModels.Model(fill(0.1, topicnum), fill(0.1, length(lexicon)), crps)
    println("making state...")
    st = TopicModels.State(mdl, crps)
    println("training model with $iterations iterations...")
    TopicModels.trainModel(mdl, st, iterations)
    println("check $numwords most prevalent words for each topic...")
    topwords = TopicModels.topTopicWords(mdl, st, numwords)
    mdl, st, topwords
end