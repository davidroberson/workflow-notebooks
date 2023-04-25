label: MACS2 Call Peaks
inputs:
- id: bam
  type: File
  secondaryFiles:
  - pattern: .bai
    required: true
  sbg:fileTypes: BAM
- id: sort_order
  type: File
  inputBinding:
    position: 0
    shellQuote: false
baseCommand:
- bash
- call_peaks.sh
requirements:
- class: ShellCommandRequirement
- class: DockerRequirement
  dockerPull: images.sb.biodatacatalyst.nhlbi.nih.gov/andrewblair/cardiac-compendium:2023042401
- class: InitialWorkDirRequirement
- class: InitialWorkDirRequirement
  listing:
  - entryname: call_peaks.sh
    writable: false
    entry: 'macs2 callpeak -t $(inputs.bam.path) -n $(inputs.bam.nameroot).macs2 -f
      BAM -g hs -p .1 --call-summits --outdir ./


      #Sort narrowPeak file


      bedtools sort \

      -faidx $(inputs.sort_order.path) \

      -i $(inputs.bam.nameroot).macs2_peaks.narrowPeak \

      > $(inputs.bam.nameroot).macs2_peaks.narrowPeak.sorted'
- class: InlineJavascriptRequirement
outputs:
- id: model_r_script
  type: File
  outputBinding:
    glob: '*model.r'
- id: sorted_peaks
  type: File
  outputBinding:
    glob: '*narrowPeak.sorted'
- id: peaks_xls
  type: File
  outputBinding:
    glob: '*peaks.xls'
- id: summits
  type: File
  outputBinding:
    glob: '*summits.bed'
cwlVersion: v1.2
class: CommandLineTool
$namespaces:
  sbg: https://sevenbridges.com
hints:
- class: sbg:SaveLogs
  value: '*.sh'
