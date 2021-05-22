# double bag with internal lexicons

struct doc_fun_block_voc
    doc::SparseVector{Float64,Int64}
    fun::String
    block::SparseVector{Float64,Int64}
    doc_voc::Array{String,1}
    block_voc::Array{String,1}
end



function file_to_dfbv(root, file)
    tmp = load(joinpath(root, file))[splitext(file)[1]]# these are dfb_bags
    res = make_dfbv(tmp)
    println("finished $(splitext(file)[1])")
    res
end

#=
struct bag_of_words_matrix
    matrix::SparseMatrixCSC{Float64,Int64}
    lexicon::Array{T,1}
end
=#
#=
## dfb bag to bag of words vectors
1. make full lexicon
2. make dict word => lexicon index
2. for every bag
    2.1 make map bag vocab index => lexicon index
    2.2 convert bag's vector into lexicon indexes

=#
function make_dfbv(dfb::doc_fun_block_bag, unwanted = nothing)
    if isnothing(unwanted)
        tmp_blk = _clean_block(dfb.block)
    else
        tmp_blk = _clean_block(dfb.block, unwanted)
    end
    doc_voc = unique(dfb.doc)
    block_voc = unique(tmp_blk)
    doc = spzeros(length(doc_voc))
    for word in dfb.doc
        doc[findfirst((x)->(x==word), doc_voc)] +=1
    end
    
    block = spzeros(length(block_voc))
    for word in tmp_blk
        block[findfirst((x)->(x==word), block_voc)] +=1
    end
    doc_fun_block_voc(doc, dfb.fun, block, doc_voc, block_voc)
end
function make_dfbv(dfbs::Array{doc_fun_block_bag}, unwanted = nothing)
    res = Array{doc_fun_block_voc,1}(undef, length(dfbs))
    for i in 1:length(res)
        res[i] = make_dfbv(dfbs[i], unwanted)
    end
    res
end


function make_lexicons(dfbvs::Array{doc_fun_block_voc,1};type=1)
    if type == 1
        doc_voc = []
        block_voc = []
        for bag in dfbvs
            doc_voc = vcat(doc_voc, bag.doc_voc)
            block_voc = vcat(block_voc, bag.block_voc)
        end
    else
        #minimizes reallocations
        doc_len = 0
        block_len = 0
        for bag in dfbs
            doc_len = doc_len + length(bag.doc_voc)
            block_len = block_len + length(bag.block_voc)
        end
        doc_voc = Array{String,1}(undef, doc_len)
        block_voc = Array{String,1}(undef, block_len)
        bi = 1
        di = 1
        for bag in dfbs
            if length(bag.doc_voc) > 0
                doc_voc[di:(di+length(bag.doc_voc))] = bag.doc_voc
                di = di + length(bag.doc_voc) + 1
            end
            if length(bag.block_voc) > 0
                block_voc[bi:(bi+length(bag.block_voc))] = bag.block_voc
                bi = bi + length(bag.block_voc) + 1
            end
        end
    end
    unique!(doc_voc)
    unique!(block_voc) 
    doc_voc, block_voc
end

function add_file_to_lexicons(root, file, doc_lexicon, block_lexicon)
    (root, file)
    tmp = load(joinpath(root, file))[splitext(file)[1]]
    res = get_doc_fun_block(tmp)                
    map = get_file_module_map(tmp)
    apply_map!(res, map)
    println("finished $(splitext(file)[1])")
    res
end

function get_lexicons(dfbvs::Array{doc_fun_block_voc,1})
    doc = []
    block = []
    for dfbv in dfbvs
        doc = vcat(doc, dfbv.doc_voc)
        block = vcat(block, dfbv.block_voc)
    end
    unique(doc), unique(block)
end

function get_lexicons_from_file(root, file)
    get_lexicons(load(joinpath(root, file))[splitext(file)[1]])
end

function dict_of_lexicon(lexicon::Array{T,1}) where {T}
    tmp = Array{Pair{T,Int64},1}(undef, length(lexicon))
    for i in 1:length(lexicon)
        tmp[i] = (lexicon[i]=>i)
    end
    Dict(tmp)
end

function file_to_docvecs(root, file, doc_lexicon::Array{Any,1}, block_lexicon::Array{Any,1})
    doc_dict = dict_of_lexicon(doc_lexicon)
    block_dict = dict_of_lexicon(block_lexicon)
    file_to_docvecs(root,file,doc_dict,block_dict)
end

function file_to_docvecs(root, file, doc_dict::Dict{T,Int64}, block_dict::Dict{S,Int64}) where {T, S}
    tmp = load(joinpath(root, file))[splitext(file)[1]]# this is an array of dfbvs
    res = Array{doc_fun_block_docvecs,1}(undef, length(tmp))
    for i in 1:length(tmp)
        res[i] = make_docvec(tmp[i], doc_dict, block_dict)
    end
    res
end

function get_bags(docu::Array{TopicModels.Document,1}, lexi::Array{String,1})
	bags = Array{Array{String,1},1}(undef, length(docu))
	for i in 1:length(docu)
		bags[i] = Array{String,1}(undef, 0)
		for term in docu[i].terms
			push!(bags[i], lexi[term])
		end
		bags[i] = sort(bags[i])
	end
	bags
end


function make_docvec(tmp::doc_fun_block_voc, doc_dict::Dict{T,Int64}, block_dict::Dict{S,Int64}) where {T, S}
    doc_docvec = spzeros(length(doc_dict))
    block_docvec = spzeros(length(block_dict))
    for i in 1:length(tmp.doc)
        doc_docvec[doc_dict[tmp.doc_voc[i]]] = tmp.doc[i]
    end
    for i in 1:length(tmp.block)
        block_docvec[block_dict[tmp.block_voc[i]]] = tmp.block[i]
    end
    doc_fun_block_docvecs(doc_docvec, tmp.fun, block_docvec)
end


function make_docvec(tmp::Array{doc_fun_block_voc,1}, doc_dict::Dict{T,Int64}, block_dict::Dict{S,Int64})::Array{doc_fun_block_docvecs,1} where {T, S}
    res = []
    for tm in tmp
        push!(res, make_docvec(tm, doc_dict, block_dict))
    end
    res
end

struct doc_fun_block_docvecs
    doc::SparseVector{Float64,Int64}
    fun::String
    block::SparseVector{Float64,Int64}
end

function make_mat_from_docvecs(tmp::Array{doc_fun_block_docvecs,1})
    doc_docvecs = [x.doc for x in tmp]
    fun_names = [x.fun for x in tmp]
    block_docvecs = [x.block for x in tmp]	
	# one column is a docvec
	doc_mat = spzeros(length(doc_docvecs[1]),length(doc_docvecs))#row, cols
	for i in 1:length(doc_docvecs)
		doc_mat[:,i] = doc_docvecs[i]
		#println("built document vector column $i out of $(length(doc_docvecs))")
	end
	block_mat = spzeros(length(block_docvecs[1]),length(block_docvecs))#row, cols
	for i in 1:length(block_docvecs)
		block_mat[:,i] = block_docvecs[i]
		#println("built document vector column $i out of $(length(block_docvecs))")
	end
	doc_mat, fun_names, block_mat
end



function _clean_block(block::Array{String}, unwanted = ["(",")",".",",","::","=","/", "", "!","!=","==","...",".."])
    filter((x)->(!(x in unwanted)),block)
end

function _vocab_map(total::Array{String,1}, bag::Array{String,1})
    dic = Dict()
    for i in 1:length(bag)#bag[i] => total[dict[i]]
        j = findfirst((x)->(x==bag[i]), total)
        push!(dic, ("$i"=>j))
    end
    dic    
end

function get_bags(doc_docvec, block_docvec,doc_lexicon,block_lexicon)
    if length(doc_docvec) != length(doc_lexicon) || length(block_docvec) != length(block_lexicon)
        throw("lexicons and docvecs length missmatch")
    else
        doc = []
        block = []
        for i in 1:length(doc_docvec)
            for _ in 1:doc_docvec[i]
                push!(doc, doc_lexicon[i])
            end
        end
        for i in 1:length(block_docvec)
            for _ in 1:block_docvec[i]
                push!(block, block_lexicon[i])
            end
        end
        sort(doc), sort(block)
    end    
end

function get_bags(bag::doc_fun_block_docvecs, doc_lexicon, block_lexicon)
    docbag = []
    for i in 1:length(bag.doc)
        for _ in 1:bag.doc[i]
            push!(docbag, doc_lexicon[i])
        end
    end
    blockbag = []
    for i in 1:length(bag.block)
        for _ in 1:bag.block[i]
            push!(blockbag, block_lexicon[i])
        end
    end
    sort(docbag), sort(blockbag)
end

function get_bags(bag::doc_fun_block_voc)
    docbag = []
    for i in 1:length(bag.doc)
        for _ in 1:bag.doc[i]
            push!(docbag, bag.doc_voc[i])
        end
    end
    blockbag = []
    for i in 1:length(bag.block)
        for _ in 1:bag.block[i]
            push!(blockbag, bag.block_voc[i])
        end
    end
    sort(docbag), sort(blockbag)
end

function get_bags(bag::doc_fun_block_bag, clean=true)
    if clean
        sort(bag.doc), sort(_clean_block(bag.block))
    else
        sort(bag.doc), sort(bag.block)
    end
end

