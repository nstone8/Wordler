module Wordler

using DataFrames
import CSV

"""
Read in the allowed guesses and possible answers from the `data` folder and return them as
Vectors of Strings
"""
function getwordlists()
    srcdir=@__DIR__
    datadir=joinpath(dirname(srcdir),"data")
    guess_path=joinpath(datadir,"wordle-allowed-guesses.txt")
    answer_path=joinpath(datadir,"wordle-answers-alphabetical.txt")
    guess_vec=read(guess_path,String) |> split
    answer_vec=read(answer_path,String) |> split
    return (answers=String.(answer_vec),guesses=String.(guess_vec))
end

"""
Get the number of unique letters that `word1` and `word2` have in common.
For example, `count_common_characters("dodge","drawl")` will return `1`
"""
function count_common_characters(word1::String,word2::String)::Int
    #Convert words to Set objects so I don't need to worry about duplicate characters
    (w1,w2)=(Set(a) for a in (word1,word2))
    #now just count how many letters in w1 appear in w2
    count=sum(w1) do character #for each character in w1
        (character in w2) ? 1 : 0 #add 1 to the tally if character is in w1, else add 0
    end
    return count
end

"""
Get the percentage of answers for which this guess overlaps at least 1,2,3,4 or 5 letters.
returns a Vector, the first index corresponding to the percentage of answers which overlap
with this guess for 1 letter, the second index corresponding to the percentage of answers
which overlap this guess for two letters, etc.
"""
function get_overlap_distribution(guess::String,answers::Vector{String})::Vector{Float64}
    overlap_counts=zeros(Int,(5,))
    for ans in answers
        this_overlap=count_common_characters(guess,ans)
        if this_overlap>0 #we don't care if they don't overlap
            overlap_counts[this_overlap]+=1
        end
    end
    #convert result to a percentage
    return overlap_counts./length(answers)
end

"""
Get the percentage of answers for which this guess has 1,2,3,4 or 5 letters in identical
positions. Returns a vector formatted in the same way as that returned by
`get_overlap_distribution`
"""
function get_identical_distribution(guess::String,answers::Vector{String})::Vector{Float64}
    overlap_counts=zeros(Int,(5,))
    for ans in answers
        this_count=0
        for i in 1:5
            if ans[i]==guess[i]
                this_count+=1
            end
        end
        if this_count>0
            overlap_counts[this_count]+=1
        end
    end
    return overlap_counts./length(answers)
end

"""
Get the overlap distributions for all guesses as a DataFrame
"""
function get_all_overlaps(guesses::Vector{String},answers::Vector{String})::DataFrame
    all_rows=[] #make an empty vector to hold all our rows, represented as NamedTuples (could specify this type but I'm lazy)
    for g in guesses
        this_over_dist=get_overlap_distribution(g,answers)
        this_ident_dist=get_identical_distribution(g,answers)
        push!(all_rows,(guess=g,
                        yellow_one=sum(this_over_dist),
                        yellow_two=sum(this_over_dist[2:end]),
                        yellow_three=sum(this_over_dist[3:end]),
                        yellow_four=sum(this_over_dist[4:end]),
                        yellow_five=this_over_dist[5],
                        green_one=sum(this_ident_dist),
                        green_two=sum(this_ident_dist[2:end]),
                        green_three=sum(this_ident_dist[3:end]),
                        green_four=sum(this_ident_dist[4:end]),
                        green_five=this_ident_dist[5]))
    end
    return DataFrame(all_rows)
end

"""
```julia
wordle([save_path])
```
Write all overlaps to `save_path` or the current working directory if save_path is omitted
"""
function wordle end

function wordle(save_path::String)::Nothing
    #get the word lists
    wl=getwordlists()
    result_table=get_all_overlaps(wl.guesses,wl.answers)
    CSV.write(save_path,result_table)
    return nothing
end

function wordle()::Nothing
    wordle("wordle_analysis.csv")
end

export wordle

end # module
