struct doc_fun_block_bag
    doc::Union{Array{String,1}, Array{Int,1}}
    fun::String
    block::Union{Array{String,1}, Array{Int,1}}  
end

function make_bags(dfbs::Array{doc_fun_block}, stemmer=Stemmer("english"), tokenizer=punctuation_space_tokenize; indexed=false)
    bags = Array{doc_fun_block_bag,1}(undef, length(dfbs))
    for i in 1:length(dfbs)
        bags[i] = make_bag(dfbs[i].block, stemmer, tokenizer)
    end

    if indexed
        indexed_bags = Array{doc_fun_block_bag,1}(undef, length(dfbs))
        code_vocab = Array{String,1}(undef, 0)
        doc_vocab = Array{String,1}(undef, 0)
        for bag in code_bags
            code_vocab = vcat(code_vocab, bag.block)
            doc_vocab = vcat(doc_vocab, bag.docs)
        end
        code_vocab = sort(unique(code_vocab))
        doc_vocab = sort(unique(doc_vocab))
        for i in 1:length(bags)
            indexed_bags[i] = convert_to_index(bags[i], doc_vocab, code_vocab)
        end
    end

    if indexed
        indexed_bags, (code = code_vocab, docs = doc_vocab)
    else
        bags
    end
end

function make_bag(dfb::doc_fun_block, stemmer=Stemmer("english"), tokenizer=punctuation_space_tokenize)
    fun = dfb.fun
    block = get_all_vals(dfb.block)
    if dfb.doc != ""
        doc = stem_tokenize_doc(TextAnalysis.StringDocument(dfb.doc); stemmer = stemmer, tokenizer = tokenizer)
    else
        doc = Array{String,1}(undef,0)
    end
    doc_fun_block_bag(doc,fun,block)
end

function convert_to_index(bag::doc_fun_block_bag, doc_vocab, code_vocab)
    doc = Int.(zeros(length(doc_vocab)))    
    block = Int.(zeros(length(code_vocab)))
    for i in 1:length(bag.doc)
        doc[findfirst((x)->(x==bag.doc[i]), doc_vocab)] +=1
    end
    for i in 1:length(bag.block)
        block[findfirst((x)->(x==bag.block[i]), code_vocab)] +=1
    end
    doc_fun_block_bag(doc,fun,block)
end
"""a column is a bag"""
function convert_to_matrix(bags::Array{doc_fun_block_bag,1})
    code_vocab = Array{String,1}(undef, 0)
    doc_vocab = Array{String,1}(undef, 0)
    for bag in bags
        code_vocab = vcat(code_vocab, bag.block)
        doc_vocab = vcat(doc_vocab, bag.docs)
    end
    len = length(bags)#(rows, cols)
    docs_mat = spzeros(length(doc_vocab),len)
    blocks_mat = spzeros(length(code_vocab),len)
    for j in 1:len
        for i in 1:length(bags[j].doc)
            docs_mat[findfirst((x)->(x==bags[j].doc[i]),doc_vocab),j] +=1
        end        
        for i in 1:length(bags[j].block)
            blocks_mat[findfirst((x)->(x==bags[j].block[i]),code_vocab),j] += 1
        end
        println("bag $j out of $len converted")
    end

    (code_mat = blocks_mat, code_vocab = code_vocab, docs_mat = docs_mat, docs_vocab = docs_vocab)
end
    
