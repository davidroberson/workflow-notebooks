ABC Pipeline
================

## GitHub Documents

This is an R Markdown format used for publishing markdown documents to
GitHub. When you click the **Knit** button all R code chunks are run and
a markdown file (.md) suitable for publishing to GitHub is generated.

## Including Code

You can include R code in the document as follows:

``` r
library(Rcwl)
```

    ## Loading required package: yaml

    ## Loading required package: S4Vectors

    ## Loading required package: stats4

    ## Loading required package: BiocGenerics

    ## 
    ## Attaching package: 'BiocGenerics'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     IQR, mad, sd, var, xtabs

    ## The following objects are masked from 'package:base':
    ## 
    ##     anyDuplicated, aperm, append, as.data.frame, basename, cbind,
    ##     colnames, dirname, do.call, duplicated, eval, evalq, Filter, Find,
    ##     get, grep, grepl, intersect, is.unsorted, lapply, Map, mapply,
    ##     match, mget, order, paste, pmax, pmax.int, pmin, pmin.int,
    ##     Position, rank, rbind, Reduce, rownames, sapply, setdiff, sort,
    ##     table, tapply, union, unique, unsplit, which.max, which.min

    ## 
    ## Attaching package: 'S4Vectors'

    ## The following object is masked from 'package:utils':
    ## 
    ##     findMatches

    ## The following objects are masked from 'package:base':
    ## 
    ##     expand.grid, I, unname

``` r
library(tidyverse)
```

    ## ── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
    ## ✔ dplyr     1.1.2     ✔ readr     2.1.4
    ## ✔ forcats   1.0.0     ✔ stringr   1.5.0
    ## ✔ ggplot2   3.4.2     ✔ tibble    3.2.1
    ## ✔ lubridate 1.9.2     ✔ tidyr     1.3.0
    ## ✔ purrr     1.0.1

    ## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
    ## ✖ dplyr::combine()      masks BiocGenerics::combine()
    ## ✖ tidyr::expand()       masks S4Vectors::expand()
    ## ✖ dplyr::filter()       masks stats::filter()
    ## ✖ dplyr::first()        masks S4Vectors::first()
    ## ✖ dplyr::lag()          masks stats::lag()
    ## ✖ ggplot2::Position()   masks BiocGenerics::Position(), base::Position()
    ## ✖ dplyr::rename()       masks S4Vectors::rename()
    ## ✖ lubridate::second()   masks S4Vectors::second()
    ## ✖ lubridate::second<-() masks S4Vectors::second<-()
    ## ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors

``` r
input_bam <- InputParam(id = "bam", type = "File")
input_sort_order <- InputParam(id = "sort_order", type = "File")

output_sorted_peaks <- OutputParam(id = "sorted_peaks", type = "File", glob = '*narrowPeak.sorted')

script = read_file("step_01A_call_peaks.sh")

call_peaks_script = Dirent(entryname = "call_peaks.sh", read_file("step_01A_call_peaks.sh"), writable = FALSE)

hints = list(class = "sbg:SaveLogs", 
                value = "*.sh")

call_peaks_tool <- cwlProcess(baseCommand = list("bash", "call_peaks.sh"),
                    inputs = InputParamList(input_bam, input_sort_order),
                    outputs = OutputParamList(output_sorted_peaks),
                    hints = list(hints),
                    requirements = list(requireDocker("images.sb.biodatacatalyst.nhlbi.nih.gov/andrewblair/cardiac-compendium:2023042401"), 
                                        requireJS(),
                                        requireShellCommand(),
                                        requireInitialWorkDir(list(call_peaks_script))
                                        ))

Rcwl::writeCWL(call_peaks_tool, outdir = "../cwl")
```

    ##                       cwlout                       ymlout 
    ## "../cwl/call_peaks_tool.cwl" "../cwl/call_peaks_tool.yml"

``` r
system("mv ../cwl/call_peaks_tool.cwl ../cwl/call_peaks_tool.cwl.yml")
#system("~/.local/bin/sbpack bdc dave/abc-development-scratch-project/macs2-call-peaks ../cwl/call_peaks_tool.cwl.yml")
```

## Including Plots

You can also embed plots, for example:

![](abc_pipeline_files/figure-gfm/pressure-1.png)<!-- -->

Note that the `echo = FALSE` parameter was added to the code chunk to
prevent printing of the R code that generated the plot.
