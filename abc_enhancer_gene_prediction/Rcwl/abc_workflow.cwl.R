# require libraries ----
require(tidyverse)
require(Rcwl)
require(tidycwl)

# source individual tools ----
source("call_peaks.cwl.R")
source("make_candidate_regions.cwl.R")
source("run_neighborhoods.cwl.R")

# deine steps ----
call_peaks_step = cwlStep(
  id = "call_peaks", 
  run = call_peaks_tool,
  In = list(
    bam = "bam",
    sort_order = "sort_order"))

make_candidate_regions_step = cwlStep(
  id = "make_candidate_regions", 
  run = make_candidate_regions,
  In = list(
    regions_blocklist = "regions_blocklist",
    regions_includelist = "regions_includelist",
    bam = "bam",
    narrow_peak = "call_peaks/sorted_peaks",
    chr_sizes = "sort_order"),
  Out = list(
    candidate_regions = "candidate_regions"
  ))

run_neighborhoods_step = cwlStep(
  id = "run_neighborhoods", 
  run = run_neighborhoods,
  In = list(
    candidate_enhancer_regions = "make_candidate_regions/candidate_regions",
    genes = "genes",
    H3K27ac = "H3K27ac",
    dhs = "dhs",
    expression_table = "expression_table",
    chr_sizes = "sort_order",
    ubiquitously_expressed_genes = "ubiquitously_expressed_genes"))

# create abc workflow ----
abc_workflow <- cwlWorkflow(
  inputs = InputParamList(
    call_peaks_tool@inputs$bam, 
    call_peaks_tool@inputs$sort_order,
    make_candidate_regions@inputs$regions_blocklist,
    make_candidate_regions@inputs$regions_includelist,
    run_neighborhoods@inputs$genes,
    run_neighborhoods@inputs$H3K27ac,
    run_neighborhoods@inputs$dhs,
    run_neighborhoods@inputs$expression_table,
    run_neighborhoods@inputs$ubiquitously_expressed_genes),

  outputs = OutputParamList(
    OutputParam(id = "summits", type = "File", 
                outputSource = "call_peaks/summits"),
    OutputParam(id = "candidate_regions", type = "File", 
                outputSource = "make_candidate_regions/candidate_regions"),  
    OutputParam(id = "counts", type = "File", 
                outputSource = "make_candidate_regions/counts"),
    OutputParam(id = "enhancer_list", type = "File", 
                outputSource = "run_neighborhoods/enhancer_list"),
    OutputParam(id = "gene_list", type = "File", 
                outputSource = "run_neighborhoods/gene_list"))) +
  call_peaks_step +
  make_candidate_regions_step +
  run_neighborhoods_step

# write cwl to file ----
writeCWL(abc_workflow, "abc_workflow", outdir = "../cwl")

# plot workflow graph ----
flow = read_cwl_yaml("../cwl/abc_workflow.cwl")


get_graph(
  flow %>% parse_inputs(),
  flow %>% parse_outputs(),
  flow %>% parse_steps()
) %>% str()


plotCWL(abc_workflow)

