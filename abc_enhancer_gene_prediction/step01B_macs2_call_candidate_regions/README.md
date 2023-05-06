Step 01B MACS2 Make Candidate Regions
================

## Intro

The second part of step 1 of the ABC Enhancer Gene Prediction model

[broadinstitute/ABC-Enhancer-Gene-Prediction: Cell type specific
enhancer-gene predictions using ABC model (Fulco, Nasser et al, Nature
Genetics
2019)](https://github.com/broadinstitute/ABC-Enhancer-Gene-Prediction)

The example code in the github repo is as follows

    python src/makeCandidateRegions.py \
    --narrowPeak example_chr22/ABC_output/Peaks/wgEncodeUwDnaseK562AlnRep1.chr22.macs2_peaks.narrowPeak.sorted \
    --bam example_chr22/input_data/Chromatin/wgEncodeUwDnaseK562AlnRep1.chr22.bam \
    --outDir example_chr22/ABC_output/Peaks/ \
    --chrom_sizes example_chr22/reference/chr22 \
    --regions_blocklist reference/wgEncodeHg19ConsensusSignalArtifactRegions.bed \
    --regions_includelist example_chr22/reference/RefSeqCurated.170308.bed.CollapsedGeneBounds.TSS500bp.chr22.bed \
    --peakExtendFromSummit 250 \
    --nStrongestPeaks 3000 

## Shell script is used in the tool

Notice the inline javascript such as `$(inputs.bam.nameroot)`

    ## conda env create -f abcenv.yml
    ## 
    ## python src/makeCandidateRegions.py \
    ## --narrowPeak $(inputs.narrow_peak.path)  \
    ## --bam $(inputs.bam.path) \
    ## --outDir ./ \
    ## --chrom_sizes $(inputs.chr_sizes.path) \
    ## --regions_blocklist $(inputs.regions_blocklist.path) \
    ## --regions_includelist $(inputs.regions_includelist) \
    ## --peakExtendFromSummit 250 \
    ## --nStrongestPeaks 3000

## Shell script is used in the tool

Notice the inline javascript such as `$(inputs.bam.nameroot)`

    ## conda env create -f abcenv.yml
    ## 
    ## python src/makeCandidateRegions.py \
    ## --narrowPeak $(inputs.narrow_peak.path)  \
    ## --bam $(inputs.bam.path) \
    ## --outDir ./ \
    ## --chrom_sizes $(inputs.chr_sizes.path) \
    ## --regions_blocklist $(inputs.regions_blocklist.path) \
    ## --regions_includelist $(inputs.regions_includelist) \
    ## --peakExtendFromSummit 250 \
    ## --nStrongestPeaks 3000

## Rcwl code

``` r
library(Rcwl)
library(tidyverse)

#input ports
input_ports = list(
InputParam(id = "narrow_peak", type = "File"),
InputParam(id = "bam", type = "File", 
           secondaryFiles = list(pattern = ".bai"), value = list("BAM")),
InputParam(id = "chr_sizes", type = "File"),
InputParam(id = "regions_blocklist", type = "File"),
InputParam(id = "regions_includelist", type = "File")
)

#output ports
output_ports = list(
OutputParam(id = "candidate_regions", type = "File", 
            glob = '*candidateRegions.bed'),
OutputParam(id = "counts", type = "File", 
            glob = '*Counts.bed')
)

#requirements
docker = "images.sb.biodatacatalyst.nhlbi.nih.gov/andrewblair/cardiac-compendium:2023042401"
shell_script = Dirent(entryname = "make_candidate_regions.sh", read_file("make_candidate_regions.sh"), writable = FALSE)

#hints
hints = list(class = "sbg:SaveLogs", value = "*.sh")

make_candidate_regions <- cwlProcess(
  baseCommand = list("bash", "make_candidate_regions.sh"),
  inputs = do.call(InputParamList, c(input_ports)),
  outputs = do.call(OutputParamList, c(output_ports)),
  requirements = list(
    requireDocker(docker), 
    requireJS(),
    requireShellCommand(),
    requireInitialWorkDir(list(shell_script))),
  hints = list(hints))


make_candidate_regions <- addMeta(
  cwl = make_candidate_regions,
  label = " MACS2 Call Candidate Regions")

#write cwl to file
writeCWL(make_candidate_regions, outdir = "./")
```

## Push to a Seven Bridges platform

Note: this could be a good spot to inject some additional SB specific
yaml tags.

``` r
system("~/.local/bin/sbpack bdc dave/abc-development-scratch-project/makecandidateregions make_candidate_regions.cwl")
system("rm make_candidate_regions.yml")
```

``` r
rmarkdown::render("call_regions.Rmd", output_dir = "../", output_file = "README.md")
```
