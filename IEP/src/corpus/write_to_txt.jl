function write_to_txt(filename, content)
    open("$(filename).txt", "w") do io
        if isa(content, Array)
            for item in content
                write(io, string(item, "\n"))
            end
        else
            write(io, string(content))
        end
    end
end