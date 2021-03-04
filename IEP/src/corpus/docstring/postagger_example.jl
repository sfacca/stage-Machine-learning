using TextModels
using TextAnalysis

str = "Andrew finds the house very beautiful" 
sd = StringDocument(str)
pos = PoSTagger()
pos(sd)