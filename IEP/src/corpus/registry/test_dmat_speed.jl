function sparse_dense(p=0.002)
    n=100
    sptimes = []
    dntimes = []
    is = []

    for i in 100:100:1000
        println("time for $i x $i matrix")
        spmat = sprand(i,i,p)
        mat = rand(i,i)
        push!(sptimes, @benchmark pairwise(SqEuclidean(), $spmat))
        push!(dntimes, @benchmark pairwise(SqEuclidean(), $mat))
        push!(is, i)
    end

    sptimes, dntimes, is
end

function row_sparse_dense(p=0.002)
    n=100
    sptimes = []
    dntimes = []
    is = []

    for i in 100:100:1000
        println("time for $i x 100 matrix")
        spmat = sprand(i,100,p)
        mat = rand(i,100)
        push!(sptimes, @benchmark pairwise(SqEuclidean(), $spmat))
        push!(dntimes, @benchmark pairwise(SqEuclidean(), $mat))
        push!(is, i)
    end

    sptimes, dntimes, is
end
function col_sparse_dense(p=0.002)
    n=100
    sptimes = []
    dntimes = []
    is = []

    for i in 100:100:1000
        println("time for 100 x $i matrix")
        spmat = sprand(100,i,p)
        mat = rand(100,i)
        push!(sptimes, @benchmark pairwise(SqEuclidean(), $spmat))
        push!(dntimes, @benchmark pairwise(SqEuclidean(), $mat))
        push!(is, i)
    end

    sptimes, dntimes, is
end

using Plots
function plot_result(sptimes, dntimes, is)
    spt = [mean(x.times) for x in sptimes]
    dnt = [mean(x.times) for x in dntimes]

    p=plot(is, spt, label="sparse matrix", title="pairwise time of YxY matrix")
    plot!(is, dnt, label="dense matrix")
    p
end

function plot_result!(sptimes, dntimes, is)
    spt = [mean(x.times) for x in sptimes]
    dnt = [mean(x.times) for x in dntimes]

    plot!(is, spt, label="sparse matrix", title="pairwise time of YxY matrix")
    plot!(is, dnt, label="dense matrix")
end


function test_distance()
    mat = rand(400,400)
    spmat = sprand(400,400, 0.004)
    dtimes = []
    sptimes = []
    is = []
    for i in 1:400
    end
end

function __calc(arr, arr2)
    for _ in 1:100
        evaluate(SqEuclidean(), arr, arr2)
    end
end
