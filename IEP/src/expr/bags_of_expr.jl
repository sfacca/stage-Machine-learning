struct doc_fun_block_bag
    doc::Array{String,1}
    fun::String
    block::Array{String,1}
end

function make_bags(dfbs::Array{doc_fun_block,1}, stemmer=Stemmer("english"), tokenizer=punctuation_space_tokenize)
    bags = Array{doc_fun_block_bag,1}(undef, length(dfbs))
    for i in 1:length(dfbs)
        bags[i] = make_bag(dfbs[i], stemmer, tokenizer)
    end
    bags
end

function make_bag(dfb::doc_fun_block, stemmer=Stemmer("english"), tokenizer=punctuation_space_tokenize, block_tokenize = get_all_vals)
    fun = dfb.fun
    block = block_tokenize(dfb.block)
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
