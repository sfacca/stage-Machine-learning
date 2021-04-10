using FileIO

filename = "raw.txt"
#1 load text from file
lines = unique(readlines(filename))
task_status_lines = filter((x)->(occursin(r"^[0-9]", x)) , lines)

#2 get finished
function get_finished(arr::Array{String,1})        
    filter((x)->(!occursin(r"NON FATTO$",x)),filter((x)->(occursin(r"FATTO$",x)),arr))
end
finished_tasks = get_finished(lines)
function remove_STATE!(arr::Array{String,1})
    states = ["FATTO", "INIZIATO", "NON FATTO"]
    for i in 1:length(arr)        
        arr[i] = replace(arr[i], r"[ \t]+$"=>"")
        arr[i] = replace(arr[i], r" NON FATTO$"=>"")        
        arr[i] = replace(arr[i], r" INIZIATO$"=>"")               
        arr[i] = replace(arr[i], r" FATTO$"=>"")                       
        arr[i] = replace(arr[i], r" NON$"=>"")
        arr[i] = replace(arr[i], r"[ \t]+$"=>"")
        arr[i] = replace(arr[i], r"^[0-9]. "=>"")
    end
    arr = unique(arr)
end
function _invert!(arr::Array{T,1}) where {T} # n/2 arr in place inverter
    len = length(arr)
    for i in 1:Int(round(len/2))
        tmp = arr[i]
        arr[i] = arr[len-i+1]
        arr[len-i+1] = tmp
    end
    arr
end
#3 write
remove_STATE!(finished_tasks)
remove_STATE!(task_status_lines)
task_status_lines = unique(task_status_lines)
finished_tasks = unique(finished_tasks)
_invert!(finished_tasks)
_invert!(task_status_lines)
open("curated.txt", "w") do outp
    for task in finished_tasks        
        write(outp, "* ")
        write(outp, task)
        write(outp, "\n")
    end
end
open("status_lines.txt", "w") do outp
    for task in task_status_lines              
        write(outp, "* ")
        write(outp, task)
        write(outp, "\n")
    end
end
println("finished has $(length(finished_tasks)) lines")
println("task status has $(length(task_status_lines)) lines")