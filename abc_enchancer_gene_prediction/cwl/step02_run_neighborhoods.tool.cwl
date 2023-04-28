cwlVersion: v1.2
class: CommandLineTool
$namespaces:
  sbg: https://sevenbridges.com
hints:
- class: sbg:SaveLogs
  value: '*.sh'
label: Run Neighborhood
doc: "\nQuantifying Enhancer Activity: \n\n```run.neighborhoods.py``` will count DNase-seq\
  \ (or ATAC-seq) and H3K27ac ChIP-seq reads in candidate enhancer regions. It also\
  \ makes GeneList.txt, which counts reads in gene bodies and promoter regions.\n\n\
  Replicate epigenetic experiments should be included as comma delimited list of files.\
  \ Read counts in replicate experiments will be averaged when computing enhancer\
  \ Activity.  \n\nMain output files:\n\n  * **EnhancerList.txt**: Candidate enhancer\
  \ regions with Dnase-seq and H3K27ac ChIP-seq read counts\n  * **GeneList.txt**:\
  \ Dnase-seq and H3K27ac ChIP-seq read counts on gene bodies and gene promoter regions"
inputs:
- id: candidate_enchancer_regions
  type: File
  sbg:fileTypes: BED
- id: genes
  type: File
  sbg:fileTypes: BED
- id: H3K27ac
  type: File
  doc: ENCFF384ZZM.chr22.bam
  sbg:fileTypes: BAM
  secondaryFiles:
  - pattern: .bai
- id: dhs
  type: File
  doc: wgEncodeUwDnaseK562AlnRep1.chr22.bam
  sbg:fileTypes: BAM
  secondaryFiles:
  - pattern: .bai
- id: expression_table
  type: File
  doc: K562.ENCFF934YBO.TPM.txt
  sbg:fileTypes: BAM
  secondaryFiles:
  - pattern: .bai
- id: chrom_sizes
  type: File
- id: ubiquitously_expressed_genes
  type: File
  doc: UbiquitouslyExpressedGenesHG19.txt
  sbg:fileTypes: TXT
- id: cell_type
  type: string
baseCommand:
- bash
- run.neighborhoods.sh
requirements:
- class: ShellCommandRequirement
- class: InlineJavascriptRequirement
- class: DockerRequirement
  dockerPull: images.sb.biodatacatalyst.nhlbi.nih.gov/andrewblair/cardiac-compendium:2023042401
- class: InitialWorkDirRequirement
  listing:
  - entryname: run.neighborhoods.sh
    writable: false
    entry: '

      python /usr/src/app/src/run.neighborhoods.py \

      --candidate_enhancer_regions $(inputs.candidate_enchancer_regions.path) \

      --genes $(inputs.genes.path) \

      --H3K27ac $(inputs.H3K27ac.path) \

      --DHS $(inputs.dhs.path) \

      --expression_table $(inputs.expression_table.path) \

      --chrom_sizes $(inputs.chrom_sizes.path) \

      --ubiquitously_expressed_genes $(inputs.ubiquitously_expressed_genes.path) \

      --cellType $(inputs.cell_type) \

      --outdir ./'
outputs:
- id: enchancer_list
  type: File
  doc: Candidate enhancer regions with Dnase-seq and H3K27ac ChIP-seq read counts
  outputBinding:
    glob: '*EnhancerList.txt'
- id: counts
  type: File
  doc: Dnase-seq and H3K27ac ChIP-seq read counts on gene bodies and gene promoter
    regions
  outputBinding:
    glob: '*GeneList.txt'
