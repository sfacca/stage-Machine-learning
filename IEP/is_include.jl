"""
this function returns included file if the given expr is an include, nothing otherwise"""
function is_include(e::CSTParser.EXPR)::Union{Nothing, String}
    res = nothing
    if e.head == :call
        # it's a call, let's check called function
        if !isnothing(e.args) && length(e.args)>1
            if e.args[1].head == :IDENTIFIER && e.args[1].val == "include"
                res = e.args[2].val
            end
        end
    end
    res
end


function scrape_includes(e::CSTParser.EXPR)::Array{String}
	res = Array{String,1}(undef, 0)
	tmp = is_include(e)
	if !isnothing(tmp)
		res = [tmp]
	else
        if _checkArgs(e)
            for sube in e.args
                res = vcat(res, scrape_includes(sube))
            end
        end
	end
    #println(typeof(res))
	res
end


function scrape_includes(arr::Array{CSTParser.EXPR,1})::Array{String}
	res = Array{String,1}(undef, 0)
	for e in arr
        res = vcat(res,scrape_includes(e))
	end
	res
end


function scrape_includes(tuple::Tuple{CSTParser.EXPR,String})
	[(tuple[2], x) for x in scrape_includes(tuple[1])]
end


function aux_stuff(arr)
	res = []
	for tuple in arr
		res = vcat(res, scrape_includes(tuple))
	end
	res
end

function get_links(arr::Array{Any,1})
    res = Array{Tuple{String,String},1}(undef, length(arr))
    for i in 1:length(arr)
        res[i] = get_links(arr[i])
    end
    res
end

function get_links(tuple)::Tuple{String,String}
    # get base path
    origin = split(tuple[1],"\\")[1:(end-1)]# this removes the filename
    path = split(tuple[2],"\\")
    for name in path
        if name == ".."
            if length(origin)>0
                origin = origin[1:(end-1)]# "../" means go back one folder
            else
                origin = [".."]
            end
        else
            push!(origin, name)
        end
    end
    (tuple[1],string(origin.*"\\"...)[1:(end-2)])
end

function make_tree(tuple)
    lnks = get_links(tuple)
    lnks = lnks[sortperm([x[1] for x in lnks])]
    res = []
    tmp = nothing
    me = lnks[1][1]
    for link in lnks
        if link[1] == me
            # add link
            if !isnothing(tmp)
                push!(tmp, link[2])
            else
                tmp = [link[2]]
            end
        else
            # add file_node
            push!(res, file_node(me, tmp))
            # new me
            me = link[1]
            tmp = [link[2]]
        end
    end
    # do the last one
    push!(res, file_node(me, tmp))
    
    res
end

    # make the leaf nodes
    #= just add them when they're missing
    all_filepaths = []
    for x in res
        append!(all_filepaths, x.points)
        push!(all_filepaths, x.path)
    end
    all_filepaths = sort(unique(all_filepaths))
    all_nodes = sort([x.path for x in res])

    to_add = []
    for i in 1:length(all_filepaths)
        if all_filepaths in all_nodes
        else
            push!(to_add, i)
        end
    end

    to_add = all_filepaths[to_add]
    tmp = Array{file_node,1}(undef, length(to_add))
    for i in 1:length(to_add)
        tmp[i] = file_node(to_add[i])
    end
    vcat(res, tmp)=#



struct file_node
    path::String
    points::Union{Array{String,1},Nothing}
    file_node(p)=new(p,nothing)
    file_node(p,a)=new(p,a)
end

# delete this (redundancy)
function _checkArgs(e)
	!isnothing(e.args) && !isempty(e.args)
end


