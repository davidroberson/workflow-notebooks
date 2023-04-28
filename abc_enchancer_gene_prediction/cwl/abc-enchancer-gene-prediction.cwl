cwlVersion: v1.2
class: Workflow
label: abc-enhancer-gene-prediction
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: InlineJavascriptRequirement
- class: StepInputExpressionRequirement

inputs:
- id: sort_order
  type: File
  sbg:x: -504
  sbg:y: -578
- id: bam
  type: File
  secondaryFiles:
  - pattern: .bai
    required: true
  sbg:fileTypes: BAM
  sbg:x: -562
  sbg:y: -203
- id: regions_includelist
  type: File
  sbg:fileTypes: BED
  sbg:x: 27
  sbg:y: -661
- id: regions_blocklist
  type: File
  sbg:fileTypes: BED
  sbg:x: -112.57969665527344
  sbg:y: -612.9046630859375
- id: chr_sizes
  type: File
  sbg:x: -260.5796813964844
  sbg:y: -116.90462493896484

outputs:
- id: counts
  type: File
  outputSource:
  - makecandidateregions/counts
  sbg:x: 314.9624328613281
  sbg:y: -526.222900390625
- id: candidate_regions
  type: File
  outputSource:
  - makecandidateregions/candidate_regions
  sbg:x: 286.9624328613281
  sbg:y: -184.22291564941406

steps:
- id: makecandidateregions
  label: MACS2 Call Candidate Regions
  in:
  - id: narrow_peak
    source: macs2_call_peaks/sorted_peaks
  - id: bam
    source: bam
  - id: chr_sizes
    source: chr_sizes
  - id: regions_blocklist
    source: regions_blocklist
  - id: regions_includelist
    source: regions_includelist
  run: step01B_macs2_call_candidate_regions.cwl
  out:
  - id: candidate_regions
  - id: counts
  sbg:x: 133
  sbg:y: -369
- id: macs2_call_peaks
  label: MACS2 Call Peaks
  in:
  - id: bam
    source: bam
  - id: sort_order
    source: sort_order
  run: step01A_macs2_call_peaks.cwl
  out:
  - id: model_r_script
  - id: sorted_peaks
  - id: peaks_xls
  - id: summits
  sbg:x: -329
  sbg:y: -441