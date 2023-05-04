Step 01A Call Peaks
================

## Intro

This notebook is a walkthrough of describing 1 of the steps in the ABC
Enhancer Gene Prediction model

[broadinstitute/ABC-Enhancer-Gene-Prediction: Cell type specific
enhancer-gene predictions using ABC model (Fulco, Nasser et al, Nature
Genetics
2019)](https://github.com/broadinstitute/ABC-Enhancer-Gene-Prediction)

We wrap the macs call peaks step. The example code in the github repo is
this

    macs2 callpeak \
    -t example_chr22/input_data/Chromatin/wgEncodeUwDnaseK562AlnRep1.chr22.bam \
    -n wgEncodeUwDnaseK562AlnRep1.chr22.macs2 \
    -f BAM \
    -g hs \
    -p .1 \
    --call-summits \
    --outdir example_chr22/ABC_output/Peaks/ 

    #Sort narrowPeak file
    bedtools sort -faidx example_chr22/reference/chr22 -i example_chr22/ABC_output/Peaks/wgEncodeUwDnaseK562AlnRep1.chr22.macs2_peaks.narrowPeak > example_chr22/ABC_output/Peaks/wgEncodeUwDnaseK562AlnRep1.chr22.macs2_peaks.narrowPeak.sorted

## Rcwl code

``` r
library(Rcwl)
library(tidyverse)

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
system("mv ../cwl/call_peaks_tool.cwl ../cwl/call_peaks_tool.cwl.yml")
#system("~/.local/bin/sbpack bdc dave/abc-development-scratch-project/macs2-call-peaks ../cwl/call_peaks_tool.cwl.yml")
```
