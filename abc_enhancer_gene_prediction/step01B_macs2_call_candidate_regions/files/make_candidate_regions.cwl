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
    entry: "conda env create -f abcenv.yml\n\npython src/makeCandidateRegions.py \\\n--narrowPeak
      $(inputs.narrow_peak.path)  \\\n--bam $(inputs.bam.path) \\\n--outDir ./ \\\n--chrom_sizes
      $(inputs.chr_sizes.path) \\\n--regions_blocklist $(inputs.regions_blocklist.path)
      \\\n--regions_includelist $(inputs.regions_includelist) \\\n--peakExtendFromSummit
      250 \\\n--nStrongestPeaks 3000 "
    writable: false
hints:
- class: sbg:SaveLogs
  value: '*.sh'
label: ' MACS2 Call Candidate Regions'
doc: "# Step 01B MACS2 Make Candidate Regions\n\n## Intro\n\nThe second part of step
  1 of the ABC Enhancer Gene Prediction model\n\n[broadinstitute/ABC-Enhancer-Gene-Prediction:
  Cell type specific enhancer-gene predictions using ABC model (Fulco, Nasser et al,
  Nature Genetics 2019)](https://github.com/broadinstitute/ABC-Enhancer-Gene-Prediction)\n\nThe
  example code in the github repo is as follows\n\n```         \npython src/makeCandidateRegions.py
  \\\n--narrowPeak example_chr22/ABC_output/Peaks/wgEncodeUwDnaseK562AlnRep1.chr22.macs2_peaks.narrowPeak.sorted
  \\\n--bam example_chr22/input_data/Chromatin/wgEncodeUwDnaseK562AlnRep1.chr22.bam
  \\\n--outDir example_chr22/ABC_output/Peaks/ \\\n--chrom_sizes example_chr22/reference/chr22
  \\\n--regions_blocklist reference/wgEncodeHg19ConsensusSignalArtifactRegions.bed
  \\\n--regions_includelist example_chr22/reference/RefSeqCurated.170308.bed.CollapsedGeneBounds.TSS500bp.chr22.bed
  \\\n--peakExtendFromSummit 250 \\\n--nStrongestPeaks 3000 \n```\n\n## Shell script
  is used in the tool\n\nNotice the inline javascript such as `$(inputs.bam.nameroot)`\n\n```
  \        \n## conda env create -f abcenv.yml\n## \n## python src/makeCandidateRegions.py
  \\\n## --narrowPeak $(inputs.narrow_peak.path)  \\\n## --bam $(inputs.bam.path)
  \\\n## --outDir ./ \\\n## --chrom_sizes $(inputs.chr_sizes.path) \\\n## --regions_blocklist
  $(inputs.regions_blocklist.path) \\\n## --regions_includelist $(inputs.regions_includelist)
  \\\n## --peakExtendFromSummit 250 \\\n## --nStrongestPeaks 3000\n```\n"
inputs:
  narrow_peak:
    type: File
    inputBinding:
      separate: true
  bam:
    type: File
    secondaryFiles:
      pattern: .bai
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
