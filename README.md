# Wordler
Naive frequency analysis for wordle

## Source Data

The data used for this analysis was taken from [this thread](https://www.reddit.com/r/wordle/comments/s4tcw8/a_note_on_wordles_word_list/). Thanks cfreshman!

## How to run the code

This code was tested on Julia 1.7.1, to install Wordler, execute the following statement at a julia prompt:

```julia
using Pkg
Pkg.add("https://github.com/nstone8/Wordler")
```

to load the package, type:

```julia
using Wordler
```

You can then run the analysis by typing:

```julia
wordle([save_path])
```

This statement will save a .csv file to `save_path`. If `save_path is omitted, it will be saved as `wordle_analysis.csv` in the current working directory.

## Interpreting the results

The columns in the generated `DataFrame` consist of a `guess` column as well as `yellow_X` and `green_X` columns, where X ranges from `one` to `five`. `yellow_X` columns give the percentage of possible answers for which this guess shares `X` or more unique characters (i.e. will get at least `X` yellow or green squares in the game). `green_X` columns give the percentage of possible answers for which this guess has `X` or more characters in the exact same position (i.e. will get at least `X` green squares in the game).