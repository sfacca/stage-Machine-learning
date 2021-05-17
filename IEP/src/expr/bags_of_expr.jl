struct doc_fun_block_bag
    doc::Union{Array{String,1}, Array{Int,1}}
    fun::String
    block::Union{Array{String,1}, Array{Int,1}}  
end

function make_bags(dfbs::Array{doc_fun_block,1}, stemmer=Stemmer("english"), tokenizer=punctuation_space_tokenize; indexed=false)
    bags = Array{doc_fun_block_bag,1}(undef, length(dfbs))
    for i in 1:length(dfbs)
        bags[i] = make_bag(dfbs[i], stemmer, tokenizer)
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
        doc = string.(stem_tokenize_doc(TextAnalysis.StringDocument(dfb.doc); stemmer = stemmer, tokenizer = tokenizer))
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
    for i in 1:length(bags)
        code_vocab = vcat(code_vocab, bags[i].block)
        doc_vocab = vcat(doc_vocab, bags[i].doc)
        println("bag $i added to vocabs")
        println("code: $(length(code_vocab)) , doc: $(length(doc_vocab))")
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

    (code_mat = blocks_mat, code_vocab = code_vocab, docs_mat = docs_mat, docs_vocab = doc_vocab)
end
function add_dfbs_to_dictionary(dfb::Array{doc_fun_block,1}; doc_vocab=nothing, expr_vocab=nothing, stemmer=Stemmer("english"), tokenizer=punctuation_space_tokenize)
    for dfb in dfbs
        if !isnothing(doc_vocab)

        end
        if !isnothing(expr_vocab)
            
        end
    end
    doc_vocab, expr_vocab
end

function make_dictionary(dfbs::Array{doc_fun_block,1}, docs=true, expr=true)
    for dfb in dfbs
    end
end

function make_bags_from_dir(dir)
    stemmer=Stemmer("english")
    tokenizer=punctuation_space_tokenize
    res = Array{doc_fun_block_bag,1}(undef, 0)
    for (root, dirs, files) in walkdir(dir)
        for file in files
            if endswith(file, ".jld2")
                tmp = load(joinpath(root, file))[splitext(file)[1]]
                push!(res, make_bags(tmp, stemmer, tokenizer))
                println("added bag $(splitext(file)[1])")
            end
        end
    end
    res
end

function file_to_bags(root, file, stemmer=Stemmer("english"), tokenizer=punctuation_space_tokenize)
    tmp = load(joinpath(root, file))[splitext(file)[1]]# these are dfbs
    res = make_bags(tmp, stemmer, tokenizer)
    println("finished $(splitext(file)[1])")
    res
end
