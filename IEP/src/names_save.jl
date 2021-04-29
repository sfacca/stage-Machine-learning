open("names.txt", "w") do io
    for name in names
        write(io, name)
        write(io, "\n")
    end
end