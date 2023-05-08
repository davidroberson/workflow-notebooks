ABC Pipeline
================

## Intro

This notebook is a walk through of describing the steps in the ABC
Enhancer Gene Prediction model.

[broadinstitute/ABC-Enhancer-Gene-Prediction: Cell type specific
enhancer-gene predictions using ABC model (Fulco, Nasser et al, Nature
Genetics
2019)](https://github.com/broadinstitute/ABC-Enhancer-Gene-Prediction)

## Pull CWL files from BioData Catalyst Powered by Seven Bridges

``` r
system("pwd")
system("~/.local/bin/sbpull bdc --unpack dave/abc-development-scratch-project/abc-enchancer-gene-prediction abc-enchancer-gene-prediction-wf.cwl")
```

## Review workflow with tidycwl

``` r
require(tidycwl)
require(tidyverse)
require(knitr)

flow = read_cwl_yaml("abc-enchancer-gene-prediction-wf.cwl")

flow %>%
  parse_inputs() %>% 
  select(id, doc, `sbg:fileTypes`) %>% 
  kable()
```

| id                           | doc                                  | sbg:fileTypes |
|:-----------------------------|:-------------------------------------|:--------------|
| ubiquitously_expressed_genes | UbiquitouslyExpressedGenesHG19.txt   | TXT           |
| H3K27ac                      | ENCFF384ZZM.chr22.bam                | BAM           |
| genes                        | NA                                   | BED           |
| dhs                          | wgEncodeUwDnaseK562AlnRep1.chr22.bam | BAM           |
| hi_c\_resolution             | NA                                   | NA            |
| chrom_sizes                  | example_chr22/reference/chr22        | NA            |
| sort_order                   | NA                                   | NA            |
| regions_includelist          | NA                                   | NA            |
| regions_blocklist            | NA                                   | NA            |
| bam                          | NA                                   | NA            |
| hi_c\_directory              | example_chr22/input_data/HiC/raw/    | NA            |
| cell_type                    | NA                                   | NA            |
| expression_table             | K562.ENCFF934YBO.TPM.txt             | NA            |

``` r
flow %>% 
  parse_outputs() %>% 
  select(id, doc)%>% 
  kable()
```

| id                        | doc                                                                        |
|:--------------------------|:---------------------------------------------------------------------------|
| run_neighborhood_output   | Candidate enhancer regions with Dnase-seq and H3K27ac ChIP-seq read counts |
| run_neighborhood_output   | Candidate enhancer regions with Dnase-seq and H3K27ac ChIP-seq read counts |
| outputs_compute_abc_score | NA                                                                         |
| outputs_compute_abc_score | NA                                                                         |
| outputs_compute_abc_score | NA                                                                         |
| outputs_compute_abc_score | NA                                                                         |
| outputs_compute_abc_score | NA                                                                         |
| abc_step01_outputs        | NA                                                                         |
| abc_step01_outputs        | NA                                                                         |
| abc_step01_outputs        | NA                                                                         |
