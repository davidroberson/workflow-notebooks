cwlVersion: v1.2
class: CommandLineTool
label: macs2-call-peaks
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: DockerRequirement
  dockerPull: |-
    images.sb.biodatacatalyst.nhlbi.nih.gov/andrewblair/cardiac-compendium:2023042401
- class: InitialWorkDirRequirement
  listing:
  - entryname: call_peaks.sh
    writable: false
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
- class: InlineJavascriptRequirement

inputs:
- id: bam
  type: File
  secondaryFiles:
  - pattern: .bai
    required: true
  inputBinding:
    position: 0
    shellQuote: true
- id: sort_order
  type: File
  inputBinding:
    position: 0
    shellQuote: true

outputs:
- id: sorted_peaks
  type: File
  outputBinding:
    glob: '*narrowPeak.sorted'
- id: model_r_scripts
  type: File
  outputBinding:
    glob: '*model.r'
- id: peak_xls
  type: File
  outputBinding:
    glob: '*peak.xls'
- id: summits
  type: File
  outputBinding:
    glob: '*summits.bed'

baseCommand:
- bash
- call_peaks.sh

hints:
- class: sbg:SaveLogs
  value: '*.sh'
id: dave/abc-development-scratch-project/macs2-call-peaks/31
sbg:appVersion:
- v1.2
sbg:content_hash: a317e5d9858f0d44f4fa3f6066e172a8e62924b19e1d3b2ba14304a267599854f
sbg:contributors:
- dave
sbg:createdBy: dave
sbg:createdOn: 1682016367
sbg:id: dave/abc-development-scratch-project/macs2-call-peaks/31
sbg:image_url:
sbg:latestRevision: 31
sbg:modifiedBy: dave
sbg:modifiedOn: 1683550535
sbg:project: dave/abc-development-scratch-project
sbg:projectName: ABC - Development Scratch Project
sbg:publisher: sbg
sbg:revision: 31
sbg:revisionNotes: secondary file
sbg:revisionsInfo:
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682016367
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682016702
  sbg:revision: 1
  sbg:revisionNotes: ''
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682018484
  sbg:revision: 2
  sbg:revisionNotes: ''
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682019385
  sbg:revision: 3
  sbg:revisionNotes: ''
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682023627
  sbg:revision: 4
  sbg:revisionNotes: remove \ from the shell script
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682024281
  sbg:revision: 5
  sbg:revisionNotes: ''
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682024515
  sbg:revision: 6
  sbg:revisionNotes: glob
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682024752
  sbg:revision: 7
  sbg:revisionNotes: glob
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682024949
  sbg:revision: 8
  sbg:revisionNotes: glob
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682025308
  sbg:revision: 9
  sbg:revisionNotes: ''
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682025342
  sbg:revision: 10
  sbg:revisionNotes: ''
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682025744
  sbg:revision: 11
  sbg:revisionNotes: faidx
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682083997
  sbg:revision: 12
  sbg:revisionNotes: ''
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682085904
  sbg:revision: 13
  sbg:revisionNotes:
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682086434
  sbg:revision: 14
  sbg:revisionNotes:
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682086539
  sbg:revision: 15
  sbg:revisionNotes:
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682086851
  sbg:revision: 16
  sbg:revisionNotes:
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682393667
  sbg:revision: 17
  sbg:revisionNotes:
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682393803
  sbg:revision: 18
  sbg:revisionNotes:
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682394324
  sbg:revision: 19
  sbg:revisionNotes:
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682394870
  sbg:revision: 20
  sbg:revisionNotes:
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682395619
  sbg:revision: 21
  sbg:revisionNotes:
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682396259
  sbg:revision: 22
  sbg:revisionNotes:
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1683164916
  sbg:revision: 23
  sbg:revisionNotes: |-
    Uploaded using sbpack v2022.03.16. 
    Source: 
    repo: https://github.com/workflow-development-interest-group/workflow-notebooks
    file: 
    commit: (uncommitted file)
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1683166527
  sbg:revision: 24
  sbg:revisionNotes: |-
    Uploaded using sbpack v2022.03.16. 
    Source: 
    repo: https://github.com/workflow-development-interest-group/workflow-notebooks
    file: 
    commit: (uncommitted file)
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1683166782
  sbg:revision: 25
  sbg:revisionNotes: ''
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1683166868
  sbg:revision: 26
  sbg:revisionNotes: |-
    Uploaded using sbpack v2022.03.16. 
    Source: 
    repo: https://github.com/workflow-development-interest-group/workflow-notebooks
    file: 
    commit: (uncommitted file)
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1683166968
  sbg:revision: 27
  sbg:revisionNotes: ''
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1683167273
  sbg:revision: 28
  sbg:revisionNotes: |-
    Uploaded using sbpack v2022.03.16. 
    Source: 
    repo: https://github.com/workflow-development-interest-group/workflow-notebooks
    file: 
    commit: (uncommitted file)
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1683210582
  sbg:revision: 29
  sbg:revisionNotes: |-
    Uploaded using sbpack v2022.03.16. 
    Source: 
    repo: https://github.com/workflow-development-interest-group/workflow-notebooks
    file: 
    commit: (uncommitted file)
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1683213161
  sbg:revision: 30
  sbg:revisionNotes: |-
    Uploaded using sbpack v2022.03.16. 
    Source: 
    repo: https://github.com/workflow-development-interest-group/workflow-notebooks
    file: abc_enchancer_gene_prediction/step01A_call_peaks/files/call_peaks_tool.cwl
    commit: (uncommitted file)
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1683550535
  sbg:revision: 31
  sbg:revisionNotes: secondary file
sbg:sbgMaintained: false
sbg:validationErrors: []
sbg:workflowLanguage: CWL
