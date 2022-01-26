module Wordler

function getwordlists()
    srcdir=@__DIR__
    println(srcdir)
    datadir=joinpath(dirname(srcdir),"data")
    guess_path=joinpath(datadir,"wordle-allowed-guesses.txt")
    answer_path=joinpath(datadir,"wordle-answers-alphabetical.txt")
    guess_vec=read(guess_path,String) |> split
    answer_vec=read(answer_path,String) |> split
    return (answers=answer_vec,guesses=guess_vec)
end

end # module
