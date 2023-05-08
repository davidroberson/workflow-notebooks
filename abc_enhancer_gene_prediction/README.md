ABC Pipeline
================

## Intro

This notebook is a walk through of describing the steps in the ABC
Enhancer Gene Prediction model.

[broadinstitute/ABC-Enhancer-Gene-Prediction: Cell type specific
enhancer-gene predictions using ABC model (Fulco, Nasser et al, Nature
Genetics
2019)](https://github.com/broadinstitute/ABC-Enhancer-Gene-Prediction)

## Write CWL files and push to a Seven Bridges platform

``` r
system("pwd")
system("~/.local/bin/sbpack bdc dave/abc-development-scratch-project/abc_workflow cwl/abc_workflow.cwl")
```
