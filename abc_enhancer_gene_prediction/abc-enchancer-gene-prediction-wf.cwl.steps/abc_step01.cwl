cwlVersion: v1.2
class: Workflow
label: abc_step01
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: InlineJavascriptRequirement
- class: StepInputExpressionRequirement

inputs:
- id: sort_order
  type: File
  sbg:x: -104.66666412353516
  sbg:y: 46
- id: bam
  type: File
  secondaryFiles:
  - pattern: .bai
    required: true
  sbg:x: -176.66665649414062
  sbg:y: 502.7095031738281
- id: regions_includelist
  type: File
  sbg:x: 403.3333435058594
  sbg:y: 263.66668701171875
- id: regions_blocklist
  type: File
  sbg:x: 321.6666564941406
  sbg:y: 357.3333435058594

outputs:
- id: call_peaks_output
  type: File[]
  outputSource:
  - macs2_call_peaks/model_r_scripts
  - macs2_call_peaks/peak_xls
  - macs2_call_peaks/summits
  sbg:x: 784.0730590820312
  sbg:y: 1.500001311302185
- id: sorted_peaks
  type: File
  outputSource:
  - macs2_call_peaks/sorted_peaks
  sbg:x: 758.4063720703125
  sbg:y: -124.49999237060547
- id: counts
  type: File
  outputSource:
  - makecandidateregions/counts
  sbg:x: 1014.0467529296875
  sbg:y: 378.66668701171875
- id: candidate_regions
  type: File
  outputSource:
  - makecandidateregions/candidate_regions
  sbg:x: 1024.0467529296875
  sbg:y: 529

steps:
- id: macs2_call_peaks
  label: macs2-call-peaks
  in:
  - id: bam
    source: bam
  - id: sort_order
    source: sort_order
  run: abc_step01.cwl.steps/macs2_call_peaks.cwl
  out:
  - id: sorted_peaks
  - id: model_r_scripts
  - id: peak_xls
  - id: summits
  sbg:x: 415.4822998046875
  sbg:y: 11.833348274230957
- id: makecandidateregions
  label: ' MACS2 Call Candidate Regions'
  in:
  - id: narrow_peak
    source: macs2_call_peaks/sorted_peaks
  - id: bam
    source: bam
  - id: chr_sizes
    source: sort_order
  - id: regions_blocklist
    source: regions_blocklist
  - id: regions_includelist
    source: regions_includelist
  run: abc_step01.cwl.steps/makecandidateregions.cwl
  out:
  - id: candidate_regions
  - id: counts
  sbg:x: 722.7396850585938
  sbg:y: 413.46484375
sbg:appVersion:
- v1.2
sbg:content_hash: a328cca8371a14be9cdd892295325b1984614136a017292dbd1fb591accd1cb39
sbg:contributors:
- dave
sbg:createdBy: dave
sbg:createdOn: 1683484068
sbg:id: dave/abc-development-scratch-project/abc_step01/7
sbg:image_url: |-
  https://platform.sb.biodatacatalyst.nhlbi.nih.gov/ns/brood/images/dave/abc-development-scratch-project/abc_step01/7.png
sbg:latestRevision: 7
sbg:modifiedBy: dave
sbg:modifiedOn: 1683553423
sbg:original_source: dave/abc-development-scratch-project/abc_step01/7
sbg:project: dave/abc-development-scratch-project
sbg:projectName: ABC - Development Scratch Project
sbg:publisher: sbg
sbg:revision: 7
sbg:revisionNotes: '"python3 now"'
sbg:revisionsInfo:
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1683484068
  sbg:revision: 0
  sbg:revisionNotes: |-
    Uploaded using sbpack v2022.03.16. 
    Source: 
    repo: https://github.com/davidroberson/workflow-notebooks
    file: 
    commit: (uncommitted file)
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1683497577
  sbg:revision: 1
  sbg:revisionNotes: ''
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1683506044
  sbg:revision: 2
  sbg:revisionNotes: ''
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1683507607
  sbg:revision: 3
  sbg:revisionNotes: |-
    Uploaded using sbpack v2022.03.16. 
    Source: 
    repo: https://github.com/davidroberson/workflow-notebooks
    file: 
    commit: (uncommitted file)
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1683551587
  sbg:revision: 4
  sbg:revisionNotes: ''
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1683551673
  sbg:revision: 5
  sbg:revisionNotes: ''
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1683551854
  sbg:revision: 6
  sbg:revisionNotes: ''
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1683553423
  sbg:revision: 7
  sbg:revisionNotes: '"python3 now"'
sbg:sbgMaintained: false
sbg:validationErrors: []
sbg:workflowLanguage: CWL
