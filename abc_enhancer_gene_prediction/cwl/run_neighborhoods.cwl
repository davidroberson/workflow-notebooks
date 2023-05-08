cwlVersion: v1.0
class: CommandLineTool
baseCommand:
- bash
- run_neighborhoods.sh
requirements:
- class: DockerRequirement
  dockerPull: images.sb.biodatacatalyst.nhlbi.nih.gov/andrewblair/cardiac-compendium:2023042401
- class: InlineJavascriptRequirement
- class: ShellCommandRequirement
- class: InitialWorkDirRequirement
  listing:
  - entryname: run_neighborhoods.sh
    entry: |2-


      python /usr/src/app/src/run.neighborhoods.py \
            --candidate_enhancer_regions $(inputs.candidate_enchancer_regions.path) \
            --genes $(inputs.genes.path) \
            --H3K27ac $(inputs.H3K27ac.path) \
            --DHS $(inputs.dhs.path) \
            --expression_table $(inputs.expression_table.path) \
            --chrom_sizes $(inputs.chrom_sizes.path) \
            --ubiquitously_expressed_genes $(inputs.ubiquitously_expressed_genes.path) \
            --cellType $(inputs.cell_type) \
            --outdir ./
    writable: false
hints:
- class: sbg:SaveLogs
  value: '*.sh'
inputs:
  candidate_enhancer_regions:
    type: File
    inputBinding:
      separate: true
  genes:
    type: File
    inputBinding:
      separate: true
  H3K27ac:
    type: File
    inputBinding:
      separate: true
  dhs:
    type: File
    inputBinding:
      separate: true
  expression_table:
    type: File
    inputBinding:
      separate: true
  chr_sizes:
    type: File
    inputBinding:
      separate: true
  ubiquitously_expressed_genes:
    type: File
    inputBinding:
      separate: true
  cell_type:
    type: string
    inputBinding:
      separate: true
outputs:
  enhancer_list:
    type: File
    outputBinding:
      glob: '**EnhancerList.txt'
  gene_list:
    type: File
    outputBinding:
      glob: '*GeneList.txt'
