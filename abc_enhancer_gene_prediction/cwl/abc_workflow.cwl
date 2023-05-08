cwlVersion: v1.0
class: Workflow
inputs:
  bam:
    type: File
  sort_order:
    type: File
  regions_blocklist:
    type: File
  regions_includelist:
    type: File
  genes:
    type: File
  H3K27ac:
    type: File
  dhs:
    type: File
  expression_table:
    type: File
  ubiquitously_expressed_genes:
    type: File
outputs:
  summits:
    type: File
    outputSource: call_peaks/summits
  candidate_regions:
    type: File
    outputSource: make_candidate_regions/candidate_regions
  counts:
    type: File
    outputSource: make_candidate_regions/counts
  enhancer_list:
    type: File
    outputSource: run_neighborhoods/enhancer_list
  gene_list:
    type: File
    outputSource: run_neighborhoods/gene_list
steps:
  call_peaks:
    run: call_peaks.cwl
    in:
      bam: bam
      sort_order: sort_order
    out:
    - sorted_peaks
    - model_r_scripts
    - peak_xls
    - summits
  make_candidate_regions:
    run: make_candidate_regions.cwl
    in:
      regions_blocklist: regions_blocklist
      regions_includelist: regions_includelist
      bam: bam
      narrow_peak: call_peaks/sorted_peaks
      chr_sizes: sort_order
    out:
    - candidate_regions
    - counts
  run_neighborhoods:
    run: run_neighborhoods.cwl
    in:
      candidate_enhancer_regions: make_candidate_regions/candidate_regions
      genes: genes
      H3K27ac: H3K27ac
      dhs: dhs
      expression_table: expression_table
      chr_sizes: sort_order
      ubiquitously_expressed_genes: ubiquitously_expressed_genes
    out:
    - enhancer_list
    - gene_list
