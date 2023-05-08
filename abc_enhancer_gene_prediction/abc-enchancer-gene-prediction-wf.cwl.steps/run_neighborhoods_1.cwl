cwlVersion: v1.2
class: CommandLineTool
label: Run Neighborhood
doc: |2-

  Quantifying Enhancer Activity: 

  ```run.neighborhoods.py``` will count DNase-seq (or ATAC-seq) and H3K27ac ChIP-seq reads in candidate enhancer regions. It also makes GeneList.txt, which counts reads in gene bodies and promoter regions.

  Replicate epigenetic experiments should be included as comma delimited list of files. Read counts in replicate experiments will be averaged when computing enhancer Activity.  

  Main output files:

    * **EnhancerList.txt**: Candidate enhancer regions with Dnase-seq and H3K27ac ChIP-seq read counts
    * **GeneList.txt**: Dnase-seq and H3K27ac ChIP-seq read counts on gene bodies and gene promoter regions
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: DockerRequirement
  dockerPull: |-
    images.sb.biodatacatalyst.nhlbi.nih.gov/andrewblair/cardiac-compendium:2023042401
- class: InitialWorkDirRequirement
  listing:
  - entryname: run.neighborhoods.sh
    writable: false
    entry: |2-

      python python3 /usr/src/app/src/run.neighborhoods.py \
      --candidate_enhancer_regions $(inputs.candidate_enchancer_regions.path) \
      --genes $(inputs.genes.path) \
      --H3K27ac $(inputs.H3K27ac.path) \
      --DHS $(inputs.dhs.path) \
      --expression_table $(inputs.expression_table.path) \
      --chrom_sizes $(inputs.chrom_sizes.path) \
      --ubiquitously_expressed_genes $(inputs.ubiquitously_expressed_genes.path) \
      --cellType $(inputs.cell_type) \
      --outdir ./
- class: InlineJavascriptRequirement

inputs:
- id: candidate_enchancer_regions
  type: File
  sbg:fileTypes: BED
- id: genes
  type: File
  sbg:fileTypes: BED
- id: H3K27ac
  doc: ENCFF384ZZM.chr22.bam
  type: File
  secondaryFiles:
  - pattern: .bai
    required: true
  sbg:fileTypes: BAM
- id: dhs
  doc: wgEncodeUwDnaseK562AlnRep1.chr22.bam
  type: File
  secondaryFiles:
  - pattern: .bai
    required: true
  sbg:fileTypes: BAM
- id: expression_table
  doc: K562.ENCFF934YBO.TPM.txt
  type: File
- id: chrom_sizes
  type: File
- id: ubiquitously_expressed_genes
  doc: UbiquitouslyExpressedGenesHG19.txt
  type: File
  sbg:fileTypes: TXT
- id: cell_type
  type: string

outputs:
- id: enchancer_list
  doc: Candidate enhancer regions with Dnase-seq and H3K27ac ChIP-seq read counts
  type: File
  outputBinding:
    glob: '*EnhancerList.txt'
- id: counts
  doc: |-
    Dnase-seq and H3K27ac ChIP-seq read counts on gene bodies and gene promoter regions
  type: File
  outputBinding:
    glob: '*GeneList.txt'

baseCommand:
- bash
- run.neighborhoods.sh

hints:
- class: sbg:SaveLogs
  value: '*.sh'
id: dave/abc-development-scratch-project/run-neighborhoods/9
sbg:appVersion:
- v1.2
sbg:content_hash: af9c21a353ca015388bc07ca362a66a5a675c69a9f3a022f113dad3a92f9114cb
sbg:contributors:
- dave
sbg:createdBy: dave
sbg:createdOn: 1682694903
sbg:id: dave/abc-development-scratch-project/run-neighborhoods/9
sbg:image_url:
sbg:latestRevision: 9
sbg:modifiedBy: dave
sbg:modifiedOn: 1683559314
sbg:project: dave/abc-development-scratch-project
sbg:projectName: ABC - Development Scratch Project
sbg:publisher: sbg
sbg:revision: 9
sbg:revisionNotes: correcting python command
sbg:revisionsInfo:
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682694903
  sbg:revision: 0
  sbg:revisionNotes: |-
    Uploaded using sbpack v2022.03.16. 
    Source: 
    repo: https://github.com/davidroberson/cwl-notebooks
    file: 
    commit: (uncommitted file)
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682695045
  sbg:revision: 1
  sbg:revisionNotes: |-
    Uploaded using sbpack v2022.03.16. 
    Source: 
    repo: https://github.com/davidroberson/cwl-notebooks
    file: abc_enchancer_gene_prediction/cwl/step02_run_neighborhoods.tool.cwl
    commit: 56bca4c
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682697804
  sbg:revision: 2
  sbg:revisionNotes: |-
    Uploaded using sbpack v2022.03.16. 
    Source: 
    repo: https://github.com/davidroberson/cwl-notebooks
    file: abc_enchancer_gene_prediction/cwl/step02_run_neighborhoods.tool.cwl
    commit: (uncommitted file)
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682718418
  sbg:revision: 3
  sbg:revisionNotes: |-
    Uploaded using sbpack v2022.03.16. 
    Source: 
    repo: https://github.com/davidroberson/cwl-notebooks
    file: abc_enchancer_gene_prediction/cwl/step02_run_neighborhoods.tool.cwl
    commit: (uncommitted file)
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682721057
  sbg:revision: 4
  sbg:revisionNotes: |-
    Uploaded using sbpack v2022.03.16. 
    Source: 
    repo: https://github.com/davidroberson/cwl-notebooks
    file: abc_enchancer_gene_prediction/cwl/step02_run_neighborhoods.tool.cwl
    commit: (uncommitted file)
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682775113
  sbg:revision: 5
  sbg:revisionNotes: |-
    Uploaded using sbpack v2022.03.16. 
    Source: 
    repo: https://github.com/davidroberson/cwl-notebooks
    file: abc_enchancer_gene_prediction/cwl/step02_run_neighborhoods.tool.cwl
    commit: (uncommitted file)
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1683552191
  sbg:revision: 6
  sbg:revisionNotes: ''
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1683552461
  sbg:revision: 7
  sbg:revisionNotes: ''
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1683552521
  sbg:revision: 8
  sbg:revisionNotes: ''
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1683559314
  sbg:revision: 9
  sbg:revisionNotes: correcting python command
sbg:sbgMaintained: false
sbg:validationErrors: []
sbg:workflowLanguage: CWL
