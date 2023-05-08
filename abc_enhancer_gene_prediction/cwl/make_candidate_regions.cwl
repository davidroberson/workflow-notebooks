cwlVersion: v1.0
class: CommandLineTool
baseCommand:
- bash
- make_candidate_regions.sh
requirements:
- class: DockerRequirement
  dockerPull: images.sb.biodatacatalyst.nhlbi.nih.gov/andrewblair/cardiac-compendium:2023042401
- class: InlineJavascriptRequirement
- class: ShellCommandRequirement
- class: InitialWorkDirRequirement
  listing:
  - entryname: make_candidate_regions.sh
    entry: "\nconda env create -f abcenv.yml  \n\npython src/makeCandidateRegions.py
      \\\n  --narrowPeak $(inputs.narrow_peak.path)  \\\n  --bam $(inputs.bam.path)
      \\\n  --outDir ./ \\\n  --chrom_sizes $(inputs.chr_sizes.path) \\\n  --regions_blocklist
      $(inputs.regions_blocklist.path) \\\n  --regions_includelist $(inputs.regions_includelist)
      \\\n  --peakExtendFromSummit 250 \\\n  --nStrongestPeaks 3000 "
    writable: false
hints:
- class: sbg:SaveLogs
  value: '*.sh'
inputs:
  narrow_peak:
    type: File
    inputBinding:
      separate: true
  bam:
    type: File
    inputBinding:
      separate: true
  chr_sizes:
    type: File
    inputBinding:
      separate: true
  regions_blocklist:
    type: File
    inputBinding:
      separate: true
  regions_includelist:
    type: File
    inputBinding:
      separate: true
outputs:
  candidate_regions:
    type: File
    outputBinding:
      glob: '*candidateRegions.bed'
  counts:
    type: File
    outputBinding:
      glob: '*Counts.bed'
