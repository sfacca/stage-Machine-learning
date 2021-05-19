# double bag with internal lexicons

struct doc_fun_block_voc
    fun::String
    doc::SparseVector{Float64,Int64}
    block::SparseVector{Float64,Int64}
    doc_voc::Array{String,1}
    block_voc::Array{String,1}
end

#=
struct bag_of_words_matrix
    matrix::SparseMatrixCSC{Float64,Int64}
    lexicon::Array{T,1}
end
=#

function make_dfbv(dfb::doc_fun_block_bag, unwanted = nothing)
    tmp_blk = _clean_block(dfb.block)
    doc_voc = unique(dfb.doc)
    block_voc = unique(tmp_blk)
    doc = spzeros(length(doc_voc))
    for word in dfb.doc
        doc[findfirst((x)->(x==word), doc_voc)] +=1
    end
    
    block = spzeros(length(block_voc))
    for word in tmp_blk
        doc[findfirst((x)->(x==word), doc_block)] +=1
    end
    doc_fun_block_voc(dfb.fun, doc, block, doc_voc, block_voc)
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


function make_document_vectors(dfbvs::Array{doc_fun_block_voc,1};type=1)
    doc_voc, block_voc = make_lexicons(dfbvs;type=type)
    fun = []    
    doc_len = length(doc_voc)
    block_len = length(block_voc)
    doc_vecs = Array{SparseMatrixCSC{Float64,Int64},1}(undef, length(dfbvs))
    block_vecs = Array{SparseMatrixCSC{Float64,Int64},1}(undef, length(dfbvs)
    for i in 1:length(dfbvs)
        map = _vocab_map(doc_voc, dfbvs[i].doc_voc)
        doc_vecs[i] = spzeros(doc_len)
        for j in 1:length(dfbvs[i].doc)
            doc_vecs[i][map["$(j)"]] = dfbvs[i].doc[j]
        end
        map = _vocab_map(block_voc, dfbvs[i].block_voc)
        block_vecs[i] = spzeros(block_len)
        for j in 1:length(dfbvs[i].block)
            block_vecs[i][map["$(j)"]] = dfbvs[i].block[j]
        end
        push!(fun, dfbvs[i].fun)
    end
    doc_fun_block_docvecs(doc_vecs, fun, block_vecs, doc_voc, block_voc)
end

struct doc_fun_block_docvecs
    doc::Array{SparseMatrixCSC{Float64,Int64},1}
    fun::Array{String,1}
    block::Array{SparseMatrixCSC{Float64,Int64},1}
    doc_vocab::Array{String,1}
    block_vocab::Array{String,1}
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

function get_bags(bag::doc_fun_block_docvecs)
    docbag = []
    for i in 1:length(bag.doc)
        for _ in 1:bag.doc[i]
            push!(docbag, bag.doc_vocab[i])
        end
    end
    blockbag = []
    for i in 1:length(bag.block)
        for _ in 1:bag.block[i]
            push!(blockbag, bag.doc_vocab[i])
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
            push!(blockbag, bag.doc_voc[i])
        end
    end
    sort(docbag), sort(blockbag)
end

