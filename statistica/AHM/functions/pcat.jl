# da due array a un array di coppie

function pcat(a::Array{T,1},b::Array{T,1}) where {T}
    if length(a)<length(b)
        vcat(
            [(a[i],b[i]) for i in 1:length(a)], 
            [(nothing,b[i]) for i in length(a)+1:length(b)]
            )
    elseif length(a)>length(b)
        vcat(
            [(a[i],b[i]) for i in 1:length(b)], 
            [(a[i],nothing) for i in length(b)+1:length(a)]
            )
    else
        [(a[i],b[i]) for i in 1:length(a)]
    end
end

#eg 
#   pcat([1,2,3],[6,5,4])  ->  [(1,6),(2,5),(3,4)]
#   pcat([1,2,3],[8,9])    ->  [(1,8),(2,9),(3,nothing)]