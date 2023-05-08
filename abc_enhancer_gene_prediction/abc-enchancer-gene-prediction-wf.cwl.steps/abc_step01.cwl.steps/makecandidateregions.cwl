cwlVersion: v1.2
class: CommandLineTool
label: ' MACS2 Call Candidate Regions'
doc: |
  # Step 01B MACS2 Make Candidate Regions

  ## Intro

  The second part of step 1 of the ABC Enhancer Gene Prediction model

  [broadinstitute/ABC-Enhancer-Gene-Prediction: Cell type specific enhancer-gene predictions using ABC model (Fulco, Nasser et al, Nature Genetics 2019)](https://github.com/broadinstitute/ABC-Enhancer-Gene-Prediction)

  The example code in the github repo is as follows

  ```         
  python src/makeCandidateRegions.py \
  --narrowPeak example_chr22/ABC_output/Peaks/wgEncodeUwDnaseK562AlnRep1.chr22.macs2_peaks.narrowPeak.sorted \
  --bam example_chr22/input_data/Chromatin/wgEncodeUwDnaseK562AlnRep1.chr22.bam \
  --outDir example_chr22/ABC_output/Peaks/ \
  --chrom_sizes example_chr22/reference/chr22 \
  --regions_blocklist reference/wgEncodeHg19ConsensusSignalArtifactRegions.bed \
  --regions_includelist example_chr22/reference/RefSeqCurated.170308.bed.CollapsedGeneBounds.TSS500bp.chr22.bed \
  --peakExtendFromSummit 250 \
  --nStrongestPeaks 3000 
  ```

  ## Shell script is used in the tool

  Notice the inline javascript such as `$(inputs.bam.nameroot)`

  ```         
  ## conda env create -f abcenv.yml
  ## 
  ## python src/makeCandidateRegions.py \
  ## --narrowPeak $(inputs.narrow_peak.path)  \
  ## --bam $(inputs.bam.path) \
  ## --outDir ./ \
  ## --chrom_sizes $(inputs.chr_sizes.path) \
  ## --regions_blocklist $(inputs.regions_blocklist.path) \
  ## --regions_includelist $(inputs.regions_includelist) \
  ## --peakExtendFromSummit 250 \
  ## --nStrongestPeaks 3000
  ```
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: DockerRequirement
  dockerPull: |-
    images.sb.biodatacatalyst.nhlbi.nih.gov/andrewblair/cardiac-compendium:2023042401
- class: InitialWorkDirRequirement
  listing:
  - entryname: make_candidate_regions.sh
    writable: false
    entry: |-
      #conda env create -f abcenv.yml

      python3 /usr/src/app/src/makeCandidateRegions.py \
      --narrowPeak $(inputs.narrow_peak.path)  \
      --bam $(inputs.bam.path) \
      --outDir ./ \
      --chrom_sizes $(inputs.chr_sizes.path) \
      --regions_blocklist $(inputs.regions_blocklist.path) \
      --regions_includelist $(inputs.regions_includelist.path) \
      --peakExtendFromSummit 250 \
      --nStrongestPeaks 3000 
- class: InlineJavascriptRequirement

inputs:
- id: narrow_peak
  type: File
  inputBinding:
    position: 0
    shellQuote: true
- id: bam
  type: File
  secondaryFiles:
  - pattern: .bai
    required: true
  inputBinding:
    position: 0
    shellQuote: true
- id: chr_sizes
  type: File
  inputBinding:
    position: 0
    shellQuote: true
- id: regions_blocklist
  type: File
  inputBinding:
    position: 0
    shellQuote: true
- id: regions_includelist
  type: File
  inputBinding:
    position: 0
    shellQuote: true

outputs:
- id: candidate_regions
  type: File
  outputBinding:
    glob: '*candidateRegions.bed'
- id: counts
  type: File
  outputBinding:
    glob: '*Counts.bed'

baseCommand:
- bash
- make_candidate_regions.sh

hints:
- class: sbg:SaveLogs
  value: '*.sh'
id: dave/abc-development-scratch-project/makecandidateregions/17
sbg:appVersion:
- v1.2
sbg:content_hash: afd7e9900a2e141b3cb49fcbca72c2105cdab60ca6266a077e3ddfd37d2c175fd
sbg:contributors:
- dave
- andrewblair
sbg:createdBy: andrewblair
sbg:createdOn: 1682057247
sbg:id: dave/abc-development-scratch-project/makecandidateregions/17
sbg:image_url:
sbg:latestRevision: 17
sbg:modifiedBy: dave
sbg:modifiedOn: 1683554119
sbg:project: dave/abc-development-scratch-project
sbg:projectName: ABC - Development Scratch Project
sbg:publisher: sbg
sbg:revision: 17
sbg:revisionNotes: fix include list path
sbg:revisionsInfo:
- sbg:modifiedBy: andrewblair
  sbg:modifiedOn: 1682057247
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682093761
  sbg:revision: 1
  sbg:revisionNotes:
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682094145
  sbg:revision: 2
  sbg:revisionNotes:
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682094529
  sbg:revision: 3
  sbg:revisionNotes:
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682094764
  sbg:revision: 4
  sbg:revisionNotes:
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682098538
  sbg:revision: 5
  sbg:revisionNotes:
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682358754
  sbg:revision: 6
  sbg:revisionNotes:
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682392348
  sbg:revision: 7
  sbg:revisionNotes:
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682392943
  sbg:revision: 8
  sbg:revisionNotes:
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682646024
  sbg:revision: 9
  sbg:revisionNotes: |-
    Uploaded using sbpack v2022.03.16. 
    Source: 
    repo: https://github.com/davidroberson/cwl-notebooks
    file: 
    commit: (uncommitted file)
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682646253
  sbg:revision: 10
  sbg:revisionNotes: |-
    Uploaded using sbpack v2022.03.16. 
    Source: 
    repo: https://github.com/davidroberson/cwl-notebooks
    file: abc_enchancer_gene_prediction/step01B_macs2_call_candidate_regions.cwl
    commit: b6df87a
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682650365
  sbg:revision: 11
  sbg:revisionNotes: |-
    Uploaded using sbpack v2022.03.16. 
    Source: 
    repo: https://github.com/davidroberson/cwl-notebooks
    file: abc_enchancer_gene_prediction/step01B_macs2_call_candidate_regions.cwl
    commit: (uncommitted file)
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682650472
  sbg:revision: 12
  sbg:revisionNotes: |-
    Uploaded using sbpack v2022.03.16. 
    Source: 
    repo: https://github.com/davidroberson/cwl-notebooks
    file: abc_enchancer_gene_prediction/step01B_macs2_call_candidate_regions.cwl
    commit: b135b8f
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1683414860
  sbg:revision: 13
  sbg:revisionNotes: |-
    Uploaded using sbpack v2022.03.16. 
    Source: 
    repo: https://github.com/workflow-development-interest-group/workflow-notebooks
    file: abc_enhancer_gene_prediction/step01B_macs2_call_candidate_regions/files/make_candidate_regions.cwl
    commit: (uncommitted file)
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1683551667
  sbg:revision: 14
  sbg:revisionNotes: ''
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1683553273
  sbg:revision: 15
  sbg:revisionNotes: corrected python argument and commented out conda line
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1683553291
  sbg:revision: 16
  sbg:revisionNotes: python3 now
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1683554119
  sbg:revision: 17
  sbg:revisionNotes: fix include list path
sbg:sbgMaintained: false
sbg:validationErrors: []
sbg:workflowLanguage: CWL
