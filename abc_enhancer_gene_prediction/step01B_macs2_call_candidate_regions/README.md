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

## Shell script is used in the tool

Notice the inline javascript such as `$(inputs.bam.nameroot)`

    ## /workspaces/workflow-notebooks
    ## 
    ## 
    ## source /opt/conda/etc/profile.d/conda.sh
    ## conda activate macs-py2.7
    ## macs2 callpeak -t $(inputs.bam.path) \
    ##   -n $(inputs.bam.nameroot).macs2 \
    ##   -f BAM -g hs -p .1 --call-summits --outdir ./
    ## 
    ## #Sort narrowPeak file
    ## 
    ## bedtools sort \
    ##   -faidx $(inputs.sort_order.path) \
    ##   -i $(inputs.bam.nameroot).macs2_peaks.narrowPeak \
    ##   > $(inputs.bam.nameroot).macs2_peaks.narrowPeak.sorted

## Rcwl code

``` r
library(Rcwl)
library(tidyverse)


#input ports
input_ports = list(
InputParam(id = "bam", type = "File"),
InputParam(id = "sort_order", type = "File")
)

#output ports
output_ports = list(
OutputParam(id = "sorted_peaks", type = "File", glob = '*narrowPeak.sorted'),
OutputParam(id = "model_r_scripts", type = "File", glob = '*model.r'),
OutputParam(id = "peak_xls", type = "File", glob = '*peak.xls'),
OutputParam(id = "summits", type = "File", glob = '*summits.bed')
)

docker = "images.sb.biodatacatalyst.nhlbi.nih.gov/andrewblair/cardiac-compendium:2023042401"

call_peaks_script = Dirent(entryname = "call_peaks.sh", read_file("files/step_01A_call_peaks.sh"), writable = FALSE)

hints = list(class = "sbg:SaveLogs", value = "*.sh")

call_peaks_tool <- cwlProcess(baseCommand = list("bash", "call_peaks.sh"),
                    inputs = do.call(InputParamList, c(input_ports)),
                    outputs = do.call(OutputParamList, c(output_ports)),
                    hints = list(hints),
                    requirements = list(requireDocker(docker), 
                                        requireJS(),
                                        requireShellCommand(),
                                        requireInitialWorkDir(list(call_peaks_script))
                                        ))
```

## Write CWL files and push to a Seven Bridges platform

``` r
Rcwl::writeCWL(call_peaks_tool, outdir = "files")

system("~/.local/bin/sbpack bdc dave/abc-development-scratch-project/macs2-call-peaks files/call_peaks_tool.cwl")
system("rm files/call_peaks_tool.yml")
```
