cwlVersion: v1.0
class: CommandLineTool
baseCommand:
- bash
- call_peaks.sh
requirements:
- class: DockerRequirement
  dockerPull: images.sb.biodatacatalyst.nhlbi.nih.gov/andrewblair/cardiac-compendium:2023042401
- class: InlineJavascriptRequirement
- class: ShellCommandRequirement
- class: InitialWorkDirRequirement
  listing:
  - entryname: call_peaks.sh
    entry: |2-


      source /opt/conda/etc/profile.d/conda.sh
      conda activate macs-py2.7
      macs2 callpeak -t $(inputs.bam.path) \
        -n $(inputs.bam.nameroot).macs2 \
        -f BAM -g hs -p .1 --call-summits --outdir ./

      #Sort narrowPeak file

      bedtools sort \
        -faidx $(inputs.sort_order.path) \
        -i $(inputs.bam.nameroot).macs2_peaks.narrowPeak \
        > $(inputs.bam.nameroot).macs2_peaks.narrowPeak.sorted
    writable: false
hints:
- class: sbg:SaveLogs
  value: '*.sh'
inputs:
  bam:
    type: File
    inputBinding:
      separate: true
  sort_order:
    type: File
    inputBinding:
      separate: true
outputs:
  sorted_peaks:
    type: File
    outputBinding:
      glob: '*narrowPeak.sorted'
  model_r_scripts:
    type: File
    outputBinding:
      glob: '*model.r'
  peak_xls:
    type: File
    outputBinding:
      glob: '*peak.xls'
  summits:
    type: File
    outputBinding:
      glob: '*summits.bed'
