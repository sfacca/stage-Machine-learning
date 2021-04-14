using SparseArrays

"""
function converts bags of words into .documents file using LDA-C format.
the file consists of one document per line. 
* the line is prefixed by a number indicating the number of tuples for that document.
* the tuples are separated by spaces
* each document consists of a collection of tuples
        * the first element of each tuple expresses the word indicated by an index into the lexicon file, starting at zero
        * the second element expresses the number of times that word appears in the document.
"""
function make_documents(bags::SparseMatrixCSC)
    # mat is a SparseMatrixCSC
    # 
    #ids = bags.rowval
    #number = bags.nzval
    str = ""

    # column j starts at colptr[j], ends at colptr[j+1]-1
    # there are bags.n columns
    for i in 1:bags.n
        println("preparing documentline $i of $(bags.n)")
        if bags.colptr[i] != (bags.colptr[i+1]-1)
            range = bags.colptr[i]:(bags.colptr[i+1]-1)            
            str*=_make_doc_line(bags.nzval[range], bags.rowval[range])
            #str*="\n"
        end
        #if i != bags.n
            #str*="\n" # trailing newline breaks readDocs
        #end 
    end

    str[1:end-1]
end

function write_documents(bags::SparseMatrixCSC, name="bags.documents")
    open(name,"w") do file
        write(file, make_documents(bags))
    end
end
function write_documents(str::String, name="bags.documents")
    open(name,"w") do file
        write(file, str)
    end
end


function _make_doc_line(vals, ids)
    if length(vals) != length(ids)
        throw("vals, ids length missmatch in _addDoc(val, ids)")
    elseif length(vals) == 0 #empty lines break readDocs
        str=""
    else
        str = "$(length(vals)) "
        for i in 1:length(vals)
            str*="$(Int(ids[i])):$(Int(vals[i])) "
        end
        str = str[1:end-1]#trailing whitespacesa break readDocs
        str*="\n"
    end
    str
end

#=
struct SparseMatrixCSC{Tv,Ti<:Integer} <: AbstractSparseMatrixCSC{Tv,Ti}
    m::Int                  # Number of rows
    n::Int                  # Number of columns
    colptr::Vector{Ti}      # Column j is in colptr[j]:(colptr[j+1]-1)
    rowval::Vector{Ti}      # Row indices of stored values
    nzval::Vector{Tv}       # Stored values, typically nonzeros
end
=#

