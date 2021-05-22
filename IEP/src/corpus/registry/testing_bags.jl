# 1 create test doc fun blocks 

dfs = Array{IEP.doc_fun_block,1}(undef, 5)
str = ["Lorem Ipsum is simply dummy text of the printing and typesetting industry. 
Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, 
when an unknown printer took a galley of type and scrambled it to make a type 
specimen book. It has survived not only five centuries, but also the leap into 
electronic typesetting, remaining essentially unchanged.","It was popularised in the 1960s with the release of Letraset sheets containing 
Lorem Ipsum passages, and more recently with desktop publishing software like 
Aldus PageMaker including versions of Lorem Ipsum.", "t is a long established fact that a reader will be distracted by the readable 
content of a page when looking at its layout. The point of using Lorem Ipsum 
is that it has a more-or-less normal distribution of letters, as opposed to using","Content here, content here', making it look like readable English. Many desktop 
publishing packages and web page editors now use Lorem Ipsum as their default 
model text, and a search for","Various versions have evolved over the years, sometimes by accident, 
sometimes on purpose (injected humour and the like)."]
dfs[1] = IEP.doc_fun_block(
    str[1],"lorem_ipsum", CSTParser.parse("i=0"))
dfs[2] = IEP.doc_fun_block(
    str[2], "lorem_ipsum2", CSTParser.parse("i=0"))
dfs[3] = IEP.doc_fun_block(
    str[3], "why1", CSTParser.parse("i=0"))
dfs[4] = IEP.doc_fun_block(
    str[4], "why2", CSTParser.parse("i=0"))
dfs[5] = IEP.doc_fun_block(
    str[5], "why3", CSTParser.parse("i=0"))

#2 turn them into dfb bags

dfbbags = IEP.make_bags(dfs)

#3 turn them into dfb vocs

dfbvocs = IEP.make_dfbv(dfbbags)

#4 turn them into docvecs wityh lexicon

doc_lexicon, block_lexicon = IEP.get_lexicons(dfbvocs)
doc_lexicon_dict = IEP.dict_of_lexicon(doc_lexicon)    
block_lexicon_dict = IEP.dict_of_lexicon(block_lexicon)
docvecs = IEP.make_docvec(dfbvocs, doc_lexicon_dict, block_lexicon_dict)

#5 finally make mats 

doc_mat, fun_names, block_mat = IEP.make_mat_from_docvecs(docvecs)

#6 turn them into documents and lexicons
IEP.write_lexicon(doc_lexicon, "test.lexicon")
IEP.write_documents(doc_mat, "test.documents")

#7 load them and get the bags
docs_lexi_bags = IEP.get_bags(readDocs("test.documents"), readLexicon("test.lexicon"))
dfbv_bags = IEP.get_bags(dfbbags[1])

docs_lexi_bags[1] == dfbv_bags








