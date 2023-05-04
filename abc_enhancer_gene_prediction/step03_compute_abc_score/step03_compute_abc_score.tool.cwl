cwlVersion: v1.2
class: CommandLineTool
$namespaces:
  sbg: https://sevenbridges.com
hints:
- class: sbg:SaveLogs
  value: '*.sh'
label: Compute ABC Score
doc: '

  Compute ABC scores by combining Activity (as calculated by run.neighborhoods.py)
  and Hi-C.  '
inputs:
- id: enhancers
  type: File
  doc: EnhancerList.txt
  sbg:fileTypes: TXT
- id: genes
  type: File
  doc: GeneList.txt
  sbg:fileTypes: TXT
- id: hi_c_directory
  type: Directory
  doc: example_chr22/input_data/HiC/raw/
- id: chrom_sizes
  type: File
  doc: example_chr22/reference/chr22
  secondaryFiles:
  - pattern: .bed
- id: hi_c_resolution
  type: int
- id: cell_type
  type: string
baseCommand:
- bash
- predict.sh
requirements:
- class: ShellCommandRequirement
- class: InlineJavascriptRequirement
- class: DockerRequirement
  dockerPull: images.sb.biodatacatalyst.nhlbi.nih.gov/andrewblair/cardiac-compendium:2023050101
- class: InitialWorkDirRequirement
  listing:
  - entryname: predict.sh
    writable: false
    entry: '

      python /usr/src/app/src/predict.py \

      --enhancers $(inputs.enhancers.path) \

      --genes $(inputs.genes.path) \

      --HiCdir $(inputs.hi_c_directory.path) \

      --chrom_sizes $(inputs.chrom_sizes.path) \

      --hic_resolution 5000 \

      --scale_hic_using_powerlaw \

      --threshold .02 \

      --cellType $(inputs.cel_type) \

      --outdir ./ \

      --make_all_putative'
outputs:
- id: all_putattive_predictions
  type: File
  outputBinding:
    glob: '*EnhancerPredictionsAllPutative.txt.gz'
- id: ForVariantOverlap_shrunk150bp
  type: File
  outputBinding:
    glob: '*ForVariantOverlap.shrunk150bp.txt.gz'
- id: all_putative_nonexpressed
  type: File
  outputBinding:
    glob: '*AllPutativeNonExpressedGenes.txt.gz'
- id: enhancer_predictions
  type: File
  outputBinding:
    glob: '*.bedpe'
- id: other_outputs_enhancer_predictions
  type: File
  outputBinding:
    glob: '*.txt'
