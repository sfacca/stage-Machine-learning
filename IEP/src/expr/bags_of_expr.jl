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

function make_bag(dfb::doc_fun_block, stemmer=Stemmer("english"), tokenizer=punctuation_space_tokenize, block_tokenize = block_to_bag)
    fun = dfb.fun
    block = block_tokenize(dfb.block)
    if dfb.doc != ""
        doc = rm_stopw(lowercase.(rm_nums(string.(stem_tokenize_doc(TextAnalysis.StringDocument(dfb.doc); stemmer = stemmer, tokenizer = tokenizer)))))
    else
        doc = Array{String,1}(undef,0)
    end
    doc_fun_block_bag(doc,fun,block)
end

__STOPWORDS = stopwords(Languages.English())

function rm_stopw(arr)
    filter((x)->!(x in __STOPWORDS),arr)
end

function block_to_bag(block::CSTParser.EXPR)
    #lowercase.(rm_nums(get_all_vals(block))) # this iterates 2n times

    r=get_all_vals(block)
    res = Array{String,1}(undef, length(r))#prealloc oh
    i=0
    for x in r# this iterates n times
        if !_word_is_numeric(x)
            i+=1
            res[i] = lowercase(x)            
        end
    end
    if i==0
        []
    else
        res[1:i]
    end
end

#=
function block_to_bag(block::CSTParser.EXPR)
    rm_nums([lowercase(x.val) for x in find_heads(block, :IDENTIFIER)])
end=#

function _word_is_numeric(word)
    return tryparse(Float64, word) !== nothing
end

function rm_nums(arr::Array{String,1})
    filter(!_word_is_numeric, arr)
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


