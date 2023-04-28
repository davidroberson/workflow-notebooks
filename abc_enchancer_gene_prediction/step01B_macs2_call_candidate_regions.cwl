cwlVersion: v1.2
class: CommandLineTool
$namespaces:
  sbg: https://sevenbridges.com
hints:
- class: sbg:SaveLogs
  value: '*.sh'
label: MACS2 Call Candidate Regions
doc: '

  The call candidate regions tool does this...'
inputs:
- id: narrow_peak
  type: File
- id: bam
  type: File
  sbg:fileTypes: BAM
  secondaryFiles:
  - pattern: .bai
- id: chr_sizes
  type: File
- id: regions_blocklist
  type: File
  sbg:fileTypes: BED
- id: regions_includelist
  type: File
  sbg:fileTypes: BED
requirements:
- class: ShellCommandRequirement
- class: InlineJavascriptRequirement
- class: DockerRequirement
  dockerPull: images.sb.biodatacatalyst.nhlbi.nih.gov/andrewblair/cardiac-compendium:2023042401
- class: InitialWorkDirRequirement
  listing:
  - entryname: call_candidate_regions.sh
    writable: false
    entry: '#conda env create -f abcenv.yml


      python3 /usr/src/app/src/makeCandidateRegions.py \

      --narrowPeak $(inputs.narrow_peak.path) \

      --bam $(inputs.bam.path) \

      --outDir ./ \

      --chrom_sizes $(inputs.chr_sizes.path) \

      --regions_blocklist $(inputs.regions_blocklist.path) \

      --regions_includelist $(inputs.regions_includelist.path) \

      --peakExtendFromSummit 250 \

      --nStrongestPeaks 3000 '
outputs:
- id: candidate_regions
  type: File
  outputBinding:
    glob: '*candidateRegions.bed'
- id: counts
  type: File
  outputBinding:
    glob: '*Counts.bed'
