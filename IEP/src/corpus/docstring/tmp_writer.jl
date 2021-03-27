function wrtt(lex)
    open("try.lexicon", "w") do file
        write(file, lex)
    end
end

open("tmp.lexicon", "w") do file
    println(typeof(file))
    for i in 1:5
        write(file, string(i, "\n"))
    end
end