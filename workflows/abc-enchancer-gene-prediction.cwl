class: Workflow
cwlVersion: v1.2
id: dave/abc-development-scratch-project/abc-enchancer-gene-prediction/1
label: abc-enhancer-gene-prediction
$namespaces:
  sbg: 'https://sevenbridges.com'
inputs:
  - id: sort_order
    type: File
    'sbg:x': -433.5797119140625
    'sbg:y': -583.9046630859375
  - id: bam
    'sbg:fileTypes': BAM
    type: File
    secondaryFiles:
      - pattern: .bai
        required: true
    'sbg:x': -559
    'sbg:y': -276
  - id: regions_includelist
    'sbg:fileTypes': BED
    type: File
    'sbg:x': 27
    'sbg:y': -661
  - id: regions_blocklist
    'sbg:fileTypes': BED
    type: File
    'sbg:x': -112.57969665527344
    'sbg:y': -612.9046630859375
  - id: chr_sizes
    type: File
    'sbg:x': -260.5796813964844
    'sbg:y': -116.90462493896484
outputs:
  - id: macs2_outputs
    outputSource:
      - makecandidateregions/macs2_outputs
    type: 'File[]?'
    'sbg:x': 453.4203186035156
    'sbg:y': -313.9046325683594
steps:
  - id: makecandidateregions
    in:
      - id: narrow_peak
        source: macs2_call_peaks/macs2
      - id: bam
        source: bam
      - id: chr_sizes
        source: chr_sizes
      - id: regions_blocklist
        source: regions_blocklist
      - id: regions_includelist
        source: regions_includelist
    out:
      - id: macs2_outputs
    run:
      class: CommandLineTool
      cwlVersion: v1.2
      $namespaces:
        sbg: 'https://sevenbridges.com'
      id: dave/abc-development-scratch-project/makecandidateregions/6
      baseCommand:
        - bash
        - call_candidate_regions.sh
      inputs:
        - id: narrow_peak
          type: File
        - id: bam
          type: File
          'sbg:fileTypes': BAM
          secondaryFiles:
            - pattern: .bai
              required: true
        - required: true
          id: chr_sizes
          type: File
        - required: true
          id: regions_blocklist
          type: File
          'sbg:fileTypes': BED
        - required: true
          id: regions_includelist
          type: File
          'sbg:fileTypes': BED
      outputs:
        - id: macs2_outputs
          type: 'File[]?'
          outputBinding:
            glob: '*.macs2*'
      label: MACS2 Call Candidate Regions
      requirements:
        - class: DockerRequirement
          dockerPull: >-
            images.sb.biodatacatalyst.nhlbi.nih.gov/andrewblair/cardiac-compendium:2023042401
        - class: InitialWorkDirRequirement
          listing:
            - entryname: call_candidate_regions.sh
              entry: |-
                #conda env create -f abcenv.yml

                python3 /usr/src/app/src/makeCandidateRegions.py \
                --narrowPeak $(inputs.narrow_peak.path) \
                --bam $(inputs.bam.path) \
                --outDir ./ \
                --chrom_sizes $(inputs.chr_sizes.path) \
                --regions_blocklist $(inputs.regions_blocklist.path) \
                --regions_includelist $(inputs.regions_includelist.path) \
                --peakExtendFromSummit 250 \
                --nStrongestPeaks 3000 
              writable: false
        - class: InlineJavascriptRequirement
      hints:
        - class: 'sbg:SaveLogs'
          value: '*.sh'
      'sbg:appVersion':
        - v1.2
      'sbg:id': dave/abc-development-scratch-project/makecandidateregions/6
      'sbg:revision': 6
      'sbg:revisionNotes': null
      'sbg:modifiedOn': 1682358754
      'sbg:modifiedBy': dave
      'sbg:createdOn': 1682057247
      'sbg:createdBy': andrewblair
      'sbg:project': dave/abc-development-scratch-project
      'sbg:projectName': ABC - Development Scratch Project
      'sbg:sbgMaintained': false
      'sbg:validationErrors': []
      'sbg:contributors':
        - dave
        - andrewblair
      'sbg:latestRevision': 6
      'sbg:revisionsInfo':
        - 'sbg:revision': 0
          'sbg:modifiedBy': andrewblair
          'sbg:modifiedOn': 1682057247
          'sbg:revisionNotes': null
        - 'sbg:revision': 1
          'sbg:modifiedBy': dave
          'sbg:modifiedOn': 1682093761
          'sbg:revisionNotes': null
        - 'sbg:revision': 2
          'sbg:modifiedBy': dave
          'sbg:modifiedOn': 1682094145
          'sbg:revisionNotes': null
        - 'sbg:revision': 3
          'sbg:modifiedBy': dave
          'sbg:modifiedOn': 1682094529
          'sbg:revisionNotes': null
        - 'sbg:revision': 4
          'sbg:modifiedBy': dave
          'sbg:modifiedOn': 1682094764
          'sbg:revisionNotes': null
        - 'sbg:revision': 5
          'sbg:modifiedBy': dave
          'sbg:modifiedOn': 1682098538
          'sbg:revisionNotes': null
        - 'sbg:revision': 6
          'sbg:modifiedBy': dave
          'sbg:modifiedOn': 1682358754
          'sbg:revisionNotes': null
      'sbg:image_url': null
      'sbg:publisher': sbg
      'sbg:content_hash': aed72b04c78a625dde34282e509a49087939cfc8bf2fa8bbc32464de4aa12c1a0
      'sbg:workflowLanguage': CWL
    label: MACS2 Call Candidate Regions
    'sbg:x': 121
    'sbg:y': -352
  - id: macs2_call_peaks
    in:
      - id: bam
        source: bam
      - id: sort_order
        source: sort_order
    out:
      - id: macs2
    run:
      class: CommandLineTool
      cwlVersion: v1.2
      $namespaces:
        sbg: 'https://sevenbridges.com'
      id: dave/abc-development-scratch-project/macs2-call-peaks/16
      baseCommand:
        - bash
        - call_peaks.sh
      inputs:
        - id: bam
          type: File
          'sbg:fileTypes': BAM
          secondaryFiles:
            - pattern: .bai
              required: true
        - id: sort_order
          type: File
          inputBinding:
            shellQuote: false
            position: 0
      outputs:
        - id: macs2
          type: 'File[]?'
          outputBinding:
            glob: '*.macs2*'
      label: MACS2 Call Peaks
      requirements:
        - class: ShellCommandRequirement
        - class: DockerRequirement
          dockerPull: quay.io/jnasser/abc-container
        - class: InitialWorkDirRequirement
          listing:
            - entryname: call_peaks.sh
              entry: >-
                macs2 callpeak -t $(inputs.bam.path) -n
                $(inputs.bam.nameroot).macs2 -f BAM -g hs -p .1 --call-summits
                --outdir ./


                #Sort narrowPeak file


                bedtools sort \

                -faidx $(inputs.sort_order.path) \

                -i $(inputs.bam.nameroot).macs2_peaks.narrowPeak \

                > $(inputs.bam.nameroot).macs2_peaks.narrowPeak.sorted
              writable: false
        - class: InlineJavascriptRequirement
      hints:
        - class: 'sbg:SaveLogs'
          value: '*.sh'