cwlVersion: v1.2
class: Workflow
label: abc-enhancer-gene-prediction
doc: |-
  ## Activity by Contact Model of Enhancer-Gene Specificity in Common Workflow Language
    
  [broadinstitute/ABC-Enhancer-Gene-Prediction: Cell type specific enhancer-gene predictions using ABC model (Fulco, Nasser et al, Nature Genetics 2019)](https://github.com/broadinstitute/ABC-Enhancer-Gene-Prediction)
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: LoadListingRequirement
- class: SubworkflowFeatureRequirement
- class: InlineJavascriptRequirement
- class: StepInputExpressionRequirement

inputs:
- id: ubiquitously_expressed_genes
  doc: UbiquitouslyExpressedGenesHG19.txt
  type: File
  sbg:fileTypes: TXT
  sbg:x: 845.6240844726562
  sbg:y: -379.2631530761719
- id: H3K27ac
  doc: ENCFF384ZZM.chr22.bam
  type: File
  secondaryFiles:
  - pattern: .bai
    required: true
  sbg:fileTypes: BAM
  sbg:x: 692.0714111328125
  sbg:y: -352.1052551269531
- id: genes
  type: File
  sbg:fileTypes: BED
  sbg:x: 566.7105102539062
  sbg:y: -288.2819519042969
- id: dhs
  doc: wgEncodeUwDnaseK562AlnRep1.chr22.bam
  type: File
  secondaryFiles:
  - pattern: .bai
    required: true
  sbg:fileTypes: BAM
  sbg:x: 338.6691589355469
  sbg:y: -108.2255630493164
- id: hi_c_resolution
  type: int
  sbg:exposed: true
- id: chrom_sizes
  doc: example_chr22/reference/chr22
  type: File
  secondaryFiles:
  - pattern: .bed
    required: true
  sbg:x: 170.82330322265625
  sbg:y: 675.706787109375
- id: sort_order
  type: File
  sbg:x: 17
  sbg:y: 97.95912170410156
- id: regions_includelist
  type: File
  sbg:x: -33.17951965332031
  sbg:y: 214.22503662109375
- id: regions_blocklist
  type: File
  sbg:x: -40.453521728515625
  sbg:y: 335.9999694824219
- id: bam
  type: File
  secondaryFiles:
  - pattern: .bai
    required: true
  sbg:x: 65.0225601196289
  sbg:y: 514.8157958984375
- id: hi_c_directory
  doc: example_chr22/input_data/HiC/raw/
  type: Directory
  loadListing: no_listing
  sbg:x: 978.4022827148438
  sbg:y: 337.9774169921875
- id: cell_type
  type: string
  sbg:x: 670.0720825195312
  sbg:y: 463.41351318359375
- id: expression_table
  doc: K562.ENCFF934YBO.TPM.txt
  type: File
  sbg:x: 458.7744445800781
  sbg:y: -200.90977478027344

outputs:
- id: run_neighborhood_output
  label: Run Neighborhoods Output
  doc: Candidate enhancer regions with Dnase-seq and H3K27ac ChIP-seq read counts
  type: File[]
  outputSource:
  - run_neighborhoods_1/enchancer_list
  - run_neighborhoods_1/counts
  sbg:x: 1260.1842041015625
  sbg:y: 89.87593841552734
- id: outputs_compute_abc_score
  type: File[]
  outputSource:
  - compute_abc_score/other_outputs_enhancer_predictions
  - compute_abc_score/all_putative_nonexpressed
  - compute_abc_score/ForVariantOverlap_shrunk150bp
  - compute_abc_score/enhancer_predictions
  - compute_abc_score/all_putattive_predictions
  linkMerge: merge_flattened
  sbg:x: 1520.6090087890625
  sbg:y: 337.36090087890625
- id: abc_step01_outputs
  label: ABC Step01 Outputs
  type: File[]
  outputSource:
  - abc_step01/sorted_peaks
  - abc_step01/counts
  - abc_step01/call_peaks_output
  linkMerge: merge_flattened
  sbg:x: 522.5526123046875
  sbg:y: 123.54887390136719

steps:
- id: run_neighborhoods_1
  label: Run Neighborhood
  in:
  - id: candidate_enchancer_regions
    source: abc_step01/candidate_regions
  - id: genes
    source: genes
  - id: H3K27ac
    source: H3K27ac
  - id: dhs
    source: dhs
  - id: expression_table
    source: expression_table
  - id: chrom_sizes
    source: chrom_sizes
  - id: ubiquitously_expressed_genes
    source: ubiquitously_expressed_genes
  - id: cell_type
    source: cell_type
  run: abc-enchancer-gene-prediction-wf.cwl.steps/run_neighborhoods_1.cwl
  out:
  - id: enchancer_list
  - id: counts
  sbg:x: 1010.2498168945312
  sbg:y: 144.72735595703125
- id: compute_abc_score
  label: Compute ABC Score
  in:
  - id: enhancers
    source: run_neighborhoods_1/enchancer_list
  - id: genes
    source: run_neighborhoods_1/counts
  - id: hi_c_directory
    loadListing: deep_listing
    source: hi_c_directory
  - id: chrom_sizes
    source: chrom_sizes
  - id: hi_c_resolution
    source: hi_c_resolution
  - id: cell_type
    source: cell_type
  run: abc-enchancer-gene-prediction-wf.cwl.steps/compute_abc_score.cwl
  out:
  - id: all_putattive_predictions
  - id: ForVariantOverlap_shrunk150bp
  - id: all_putative_nonexpressed
  - id: enhancer_predictions
  - id: other_outputs_enhancer_predictions
  sbg:x: 1257.8095703125
  sbg:y: 402.5
- id: abc_step01
  label: abc_step01
  in:
  - id: sort_order
    source: sort_order
  - id: bam
    source: bam
  - id: regions_includelist
    source: regions_includelist
  - id: regions_blocklist
    source: regions_blocklist
  run: abc-enchancer-gene-prediction-wf.cwl.steps/abc_step01.cwl
  out:
  - id: call_peaks_output
  - id: sorted_peaks
  - id: counts
  - id: candidate_regions
  sbg:x: 304.6476745605469
  sbg:y: 202.2452850341797
sbg:appVersion:
- v1.2
sbg:content_hash: a5b946e0b6d9c68e8180589776f596586ee9c6b7b9513adbcfc7ab4b55d59ac50
sbg:contributors:
- dave
sbg:createdBy: dave
sbg:createdOn: 1682359121
sbg:id: dave/abc-development-scratch-project/abc-enchancer-gene-prediction/30
sbg:image_url: |-
  https://platform.sb.biodatacatalyst.nhlbi.nih.gov/ns/brood/images/dave/abc-development-scratch-project/abc-enchancer-gene-prediction/30.png
sbg:latestRevision: 30
sbg:modifiedBy: dave
sbg:modifiedOn: 1683553647
sbg:original_source: |-
  https://api.sb.biodatacatalyst.nhlbi.nih.gov/v2/apps/dave/abc-development-scratch-project/abc-enchancer-gene-prediction/30/raw/
sbg:project: dave/abc-development-scratch-project
sbg:projectName: ABC - Development Scratch Project
sbg:publisher: sbg
sbg:revision: 30
sbg:revisionNotes: ''
sbg:revisionsInfo:
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682359121
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682359189
  sbg:revision: 1
  sbg:revisionNotes: ''
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682393988
  sbg:revision: 2
  sbg:revisionNotes: ''
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682395780
  sbg:revision: 3
  sbg:revisionNotes: ''
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682396526
  sbg:revision: 4
  sbg:revisionNotes: ''
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682653830
  sbg:revision: 5
  sbg:revisionNotes: |-
    Uploaded using sbpack v2022.03.16. 
    Source: 
    repo: https://github.com/davidroberson/cwl-notebooks
    file: 
    commit: (uncommitted file)
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682654499
  sbg:revision: 6
  sbg:revisionNotes: |-
    Uploaded using sbpack v2022.03.16. 
    Source: 
    repo: https://github.com/davidroberson/cwl-notebooks
    file: 
    commit: (uncommitted file)
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682654875
  sbg:revision: 7
  sbg:revisionNotes: |-
    Uploaded using sbpack v2022.03.16. 
    Source: 
    repo: https://github.com/davidroberson/cwl-notebooks
    file: abc_enchancer_gene_prediction/cwl/abc-enchancer-gene-prediction.cwl
    commit: (uncommitted file)
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682684138
  sbg:revision: 8
  sbg:revisionNotes: |-
    Uploaded using sbpack v2022.03.16. 
    Source: 
    repo: https://github.com/davidroberson/cwl-notebooks
    file: abc_enchancer_gene_prediction/cwl/abc-enchancer-gene-prediction.wf.cwl
    commit: c784f37
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682779821
  sbg:revision: 9
  sbg:revisionNotes: |-
    Uploaded using sbpack v2022.03.16. 
    Source: 
    repo: https://github.com/davidroberson/cwl-notebooks
    file: abc_enchancer_gene_prediction/cwl/abc-enchancer-gene-prediction.wf.cwl
    commit: (uncommitted file)
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682780384
  sbg:revision: 10
  sbg:revisionNotes: ''
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682780468
  sbg:revision: 11
  sbg:revisionNotes: ''
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682905684
  sbg:revision: 12
  sbg:revisionNotes: ''
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682963245
  sbg:revision: 13
  sbg:revisionNotes: ''
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682963397
  sbg:revision: 14
  sbg:revisionNotes: ''
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682963552
  sbg:revision: 15
  sbg:revisionNotes: ''
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682963803
  sbg:revision: 16
  sbg:revisionNotes: ''
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682964950
  sbg:revision: 17
  sbg:revisionNotes: ''
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682965181
  sbg:revision: 18
  sbg:revisionNotes: ''
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682965418
  sbg:revision: 19
  sbg:revisionNotes: ''
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682965717
  sbg:revision: 20
  sbg:revisionNotes: ''
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1683550630
  sbg:revision: 21
  sbg:revisionNotes: ''
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1683550682
  sbg:revision: 22
  sbg:revisionNotes: ''
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1683550705
  sbg:revision: 23
  sbg:revisionNotes: ''
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1683551113
  sbg:revision: 24
  sbg:revisionNotes: ''
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1683552126
  sbg:revision: 25
  sbg:revisionNotes: ''
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1683552374
  sbg:revision: 26
  sbg:revisionNotes: ''
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1683552410
  sbg:revision: 27
  sbg:revisionNotes: ''
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1683552545
  sbg:revision: 28
  sbg:revisionNotes: ''
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1683553435
  sbg:revision: 29
  sbg:revisionNotes: '""python3 now""'
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1683553647
  sbg:revision: 30
  sbg:revisionNotes: ''
sbg:sbgMaintained: false
sbg:validationErrors: []
sbg:workflowLanguage: CWL
