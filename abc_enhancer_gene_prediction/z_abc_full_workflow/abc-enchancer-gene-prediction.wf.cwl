cwlVersion: v1.2
class: Workflow
label: abc-enhancer-gene-prediction
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: InlineJavascriptRequirement
- class: StepInputExpressionRequirement
- class: LoadListingRequirement

inputs:
- id: bam
  type: File
  secondaryFiles:
  - pattern: .bai
    required: true
  sbg:fileTypes: BAM
  sbg:x: -560.25
  sbg:y: 394.5
- id: regions_includelist
  type: File
  sbg:fileTypes: BED
  sbg:x: 294
  sbg:y: -454.75
- id: regions_blocklist
  type: File
  sbg:fileTypes: BED
  sbg:x: 143
  sbg:y: -354.75
- id: chr_sizes
  type: File
  sbg:x: 168.6666717529297
  sbg:y: -16.916664123535156
- id: sort_order
  type: File
  sbg:x: -514.25
  sbg:y: -200
- id: ubiquitously_expressed_genes
  doc: UbiquitouslyExpressedGenesHG19.txt
  type: File
  sbg:fileTypes: TXT
  sbg:x: 1223.5
  sbg:y: -386.5
- id: H3K27ac
  doc: ENCFF384ZZM.chr22.bam
  type: File
  secondaryFiles:
  - pattern: .bai
    required: true
  sbg:fileTypes: BAM
  sbg:x: 1108
  sbg:y: -267.25
- id: genes
  type: File
  sbg:fileTypes: BED
  sbg:x: 949.5099487304688
  sbg:y: -183.6873016357422
- id: expression_table
  doc: K562.ENCFF934YBO.TPM.txt
  type: File
  sbg:x: 896.25
  sbg:y: -81.5
- id: dhs
  doc: wgEncodeUwDnaseK562AlnRep1.chr22.bam
  type: File
  secondaryFiles:
  - pattern: .bai
    required: true
  sbg:fileTypes: BAM
  sbg:x: 865.25
  sbg:y: 420.5
- id: cell_type
  type: string
  sbg:exposed: true
- id: hi_c_directory
  doc: example_chr22/input_data/HiC/raw/
  type: Directory
  loadListing: deep_listing
  sbg:x: 1376.2249755859375
  sbg:y: 340.2388610839844

outputs:
- id: counts
  type: File
  outputSource:
  - makecandidateregions/counts
  - makecandidateregions/candidate_regions
  sbg:x: 863.25
  sbg:y: -366.25
- id: call_peaks_wf_outputs
  label: Call Peaks Output
  type: File[]
  outputSource:
  - macs2_call_peaks/peaks_xls
  - macs2_call_peaks/model_r_script
  - macs2_call_peaks/summits
  - macs2_call_peaks/sorted_peaks
  sbg:x: -12.083335876464844
  sbg:y: -14.083332061767578
- id: run_neighborhood_output
  label: Run Neighborhoods Output
  doc: Candidate enhancer regions with Dnase-seq and H3K27ac ChIP-seq read counts
  type: File[]
  outputSource:
  - run_neighborhoods_1/enchancer_list
  - run_neighborhoods_1/counts
  sbg:x: 1768.5
  sbg:y: -91
- id: enchancer_list
  type: File
  outputSource:
  - compute_abc_score/enchancer_list
  sbg:x: 2021.8143310546875
  sbg:y: 261.68206787109375

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
  run:
    cwlVersion: v1.2
    class: CommandLineTool
    label: MACS2 Call Candidate Regions
    doc: "\nThe call candidate regions tool does this..."
    $namespaces:
      sbg: https://sevenbridges.com

    requirements:
    - class: DockerRequirement
      dockerPull: |-
        images.sb.biodatacatalyst.nhlbi.nih.gov/andrewblair/cardiac-compendium:2023042401
    - class: InitialWorkDirRequirement
      listing:
      - entryname: call_candidate_regions.sh
        writable: false
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
    - class: InlineJavascriptRequirement

    inputs:
    - id: narrow_peak
      type: File
    - id: bam
      type: File
      secondaryFiles:
      - pattern: .bai
        required: true
      sbg:fileTypes: BAM
    - id: chr_sizes
      type: File
    - id: regions_blocklist
      type: File
      sbg:fileTypes: BED
    - id: regions_includelist
      type: File
      sbg:fileTypes: BED

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
    - call_candidate_regions.sh

    hints:
    - class: sbg:SaveLogs
      value: '*.sh'
  out:
  - id: candidate_regions
  - id: counts
  sbg:x: 538.4545288085938
  sbg:y: -58
- id: run_neighborhoods_1
  label: Run Neighborhood
  in:
  - id: candidate_enchancer_regions
    source: makecandidateregions/candidate_regions
  - id: genes
    source: genes
  - id: H3K27ac
    source: H3K27ac
  - id: dhs
    source: dhs
  - id: expression_table
    source: expression_table
  - id: chrom_sizes
    source: sort_order
  - id: ubiquitously_expressed_genes
    source: ubiquitously_expressed_genes
  - id: cell_type
    source: cell_type
  run:
    cwlVersion: v1.2
    class: CommandLineTool
    label: Run Neighborhood
    doc: |2-

      Quantifying Enhancer Activity: 

      ```run.neighborhoods.py``` will count DNase-seq (or ATAC-seq) and H3K27ac ChIP-seq reads in candidate enhancer regions. It also makes GeneList.txt, which counts reads in gene bodies and promoter regions.

      Replicate epigenetic experiments should be included as comma delimited list of files. Read counts in replicate experiments will be averaged when computing enhancer Activity.  

      Main output files:

        * **EnhancerList.txt**: Candidate enhancer regions with Dnase-seq and H3K27ac ChIP-seq read counts
        * **GeneList.txt**: Dnase-seq and H3K27ac ChIP-seq read counts on gene bodies and gene promoter regions
    $namespaces:
      sbg: https://sevenbridges.com

    requirements:
    - class: DockerRequirement
      dockerPull: |-
        images.sb.biodatacatalyst.nhlbi.nih.gov/andrewblair/cardiac-compendium:2023042901
    - class: InitialWorkDirRequirement
      listing:
      - entryname: run.neighborhoods.sh
        writable: false
        entry: |2-

          python /usr/src/app/src/run.neighborhoods.py \
          --candidate_enhancer_regions $(inputs.candidate_enchancer_regions.path) \
          --genes $(inputs.genes.path) \
          --H3K27ac $(inputs.H3K27ac.path) \
          --DHS $(inputs.dhs.path) \
          --expression_table $(inputs.expression_table.path) \
          --chrom_sizes $(inputs.chrom_sizes.path) \
          --ubiquitously_expressed_genes $(inputs.ubiquitously_expressed_genes.path) \
          --cellType $(inputs.cell_type) \
          --outdir ./
    - class: InlineJavascriptRequirement

    inputs:
    - id: candidate_enchancer_regions
      type: File
      sbg:fileTypes: BED
    - id: genes
      type: File
      sbg:fileTypes: BED
    - id: H3K27ac
      doc: ENCFF384ZZM.chr22.bam
      type: File
      secondaryFiles:
      - pattern: .bai
        required: true
      sbg:fileTypes: BAM
    - id: dhs
      doc: wgEncodeUwDnaseK562AlnRep1.chr22.bam
      type: File
      secondaryFiles:
      - pattern: .bai
        required: true
      sbg:fileTypes: BAM
    - id: expression_table
      doc: K562.ENCFF934YBO.TPM.txt
      type: File
    - id: chrom_sizes
      type: File
      secondaryFiles:
      - pattern: .bed
        required: true
    - id: ubiquitously_expressed_genes
      doc: UbiquitouslyExpressedGenesHG19.txt
      type: File
      sbg:fileTypes: TXT
    - id: cell_type
      type: string

    outputs:
    - id: enchancer_list
      doc: Candidate enhancer regions with Dnase-seq and H3K27ac ChIP-seq read counts
      type: File
      outputBinding:
        glob: '*EnhancerList.txt'
    - id: counts
      doc: |-
        Dnase-seq and H3K27ac ChIP-seq read counts on gene bodies and gene promoter regions
      type: File
      outputBinding:
        glob: '*GeneList.txt'

    baseCommand:
    - bash
    - run.neighborhoods.sh

    hints:
    - class: sbg:SaveLogs
      value: '*.sh'
    id: dave/abc-development-scratch-project/run-neighborhoods/5
    sbg:appVersion:
    - v1.2
    sbg:content_hash: a67e55ef9b197784ea11c4b22a355604594d937ce1fafc18292a6d9bf74ecd880
    sbg:contributors:
    - dave
    sbg:createdBy: dave
    sbg:createdOn: 1682694903
    sbg:id: dave/abc-development-scratch-project/run-neighborhoods/5
    sbg:image_url:
    sbg:latestRevision: 5
    sbg:modifiedBy: dave
    sbg:modifiedOn: 1682775113
    sbg:project: dave/abc-development-scratch-project
    sbg:projectName: ABC - Development Scratch Project
    sbg:publisher: sbg
    sbg:revision: 5
    sbg:revisionNotes: |-
      Uploaded using sbpack v2022.03.16. 
      Source: 
      repo: https://github.com/davidroberson/cwl-notebooks
      file: abc_enchancer_gene_prediction/cwl/step02_run_neighborhoods.tool.cwl
      commit: (uncommitted file)
    sbg:revisionsInfo:
    - sbg:modifiedBy: dave
      sbg:modifiedOn: 1682694903
      sbg:revision: 0
      sbg:revisionNotes: |-
        Uploaded using sbpack v2022.03.16. 
        Source: 
        repo: https://github.com/davidroberson/cwl-notebooks
        file: 
        commit: (uncommitted file)
    - sbg:modifiedBy: dave
      sbg:modifiedOn: 1682695045
      sbg:revision: 1
      sbg:revisionNotes: |-
        Uploaded using sbpack v2022.03.16. 
        Source: 
        repo: https://github.com/davidroberson/cwl-notebooks
        file: abc_enchancer_gene_prediction/cwl/step02_run_neighborhoods.tool.cwl
        commit: 56bca4c
    - sbg:modifiedBy: dave
      sbg:modifiedOn: 1682697804
      sbg:revision: 2
      sbg:revisionNotes: |-
        Uploaded using sbpack v2022.03.16. 
        Source: 
        repo: https://github.com/davidroberson/cwl-notebooks
        file: abc_enchancer_gene_prediction/cwl/step02_run_neighborhoods.tool.cwl
        commit: (uncommitted file)
    - sbg:modifiedBy: dave
      sbg:modifiedOn: 1682718418
      sbg:revision: 3
      sbg:revisionNotes: |-
        Uploaded using sbpack v2022.03.16. 
        Source: 
        repo: https://github.com/davidroberson/cwl-notebooks
        file: abc_enchancer_gene_prediction/cwl/step02_run_neighborhoods.tool.cwl
        commit: (uncommitted file)
    - sbg:modifiedBy: dave
      sbg:modifiedOn: 1682721057
      sbg:revision: 4
      sbg:revisionNotes: |-
        Uploaded using sbpack v2022.03.16. 
        Source: 
        repo: https://github.com/davidroberson/cwl-notebooks
        file: abc_enchancer_gene_prediction/cwl/step02_run_neighborhoods.tool.cwl
        commit: (uncommitted file)
    - sbg:modifiedBy: dave
      sbg:modifiedOn: 1682775113
      sbg:revision: 5
      sbg:revisionNotes: |-
        Uploaded using sbpack v2022.03.16. 
        Source: 
        repo: https://github.com/davidroberson/cwl-notebooks
        file: abc_enchancer_gene_prediction/cwl/step02_run_neighborhoods.tool.cwl
        commit: (uncommitted file)
    sbg:sbgMaintained: false
    sbg:validationErrors: []
    sbg:workflowLanguage: CWL
  out:
  - id: enchancer_list
  - id: counts
  sbg:x: 1356.2369384765625
  sbg:y: 116.5
- id: macs2_call_peaks
  label: MACS2 Call Peaks
  in:
  - id: bam
    source: bam
  - id: sort_order
    source: sort_order
  run:
    cwlVersion: v1.2
    class: CommandLineTool
    label: MACS2 Call Peaks
    $namespaces:
      sbg: https://sevenbridges.com

    requirements:
    - class: ShellCommandRequirement
    - class: DockerRequirement
      dockerPull: |-
        images.sb.biodatacatalyst.nhlbi.nih.gov/andrewblair/cardiac-compendium:2023042401
    - class: InitialWorkDirRequirement
      listing:
      - entryname: call_peaks.sh
        writable: false
        entry: |-
          source /opt/conda/etc/profile.d/conda.sh
          conda activate macs-py2.7
          macs2 callpeak -t $(inputs.bam.path) -n $(inputs.bam.nameroot).macs2 -f BAM -g hs -p .1 --call-summits --outdir ./

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
      sbg:fileTypes: BAM
    - id: sort_order
      type: File
      inputBinding:
        position: 0
        shellQuote: false

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

    baseCommand:
    - bash
    - call_peaks.sh

    hints:
    - class: sbg:SaveLogs
      value: '*.sh'
    id: dave/abc-development-scratch-project/macs2-call-peaks/22
    sbg:appVersion:
    - v1.2
    sbg:content_hash: aa06b1fa93bf53e25f6b45997e9f7e79ba021c14bafef508d48af20c06f2ac9bc
    sbg:contributors:
    - dave
    sbg:createdBy: dave
    sbg:createdOn: 1682016367
    sbg:id: dave/abc-development-scratch-project/macs2-call-peaks/22
    sbg:image_url:
    sbg:latestRevision: 22
    sbg:modifiedBy: dave
    sbg:modifiedOn: 1682396259
    sbg:project: dave/abc-development-scratch-project
    sbg:projectName: ABC - Development Scratch Project
    sbg:publisher: sbg
    sbg:revision: 22
    sbg:revisionNotes:
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
    sbg:sbgMaintained: false
    sbg:validationErrors: []
    sbg:workflowLanguage: CWL
  out:
  - id: model_r_script
  - id: sorted_peaks
  - id: peaks_xls
  - id: summits
  sbg:x: -253.5
  sbg:y: -65
- id: compute_abc_score
  label: Compute ABC Score
  in:
  - id: enhancers
    source: run_neighborhoods_1/enchancer_list
  - id: genes
    source: genes
  - id: hi_c_directory
    loadListing: deep_listing
    source: hi_c_directory
  - id: chrom_sizes
    source: chr_sizes
  run:
    cwlVersion: v1.2
    class: CommandLineTool
    label: Compute ABC Score
    doc: |2-

      Compute ABC scores by combining Activity (as calculated by run.neighborhoods.py) and Hi-C.  
    $namespaces:
      sbg: https://sevenbridges.com

    requirements:
    - class: LoadListingRequirement
    - class: DockerRequirement
      dockerPull: |-
        images.sb.biodatacatalyst.nhlbi.nih.gov/andrewblair/cardiac-compendium:2023042901
    - class: InitialWorkDirRequirement
      listing:
      - entryname: predict.sh
        writable: false
        entry: |2-

          python src/predict.py \
          --enhancers $(inputs.enchancers.path) \
          --genes $(inputs.genes.path) \
          --HiCdir $(inputs.hi_c_directory) \
          --chrom_sizes $(inputs.chrom_sizes) \
          --hic_resolution 5000 \
          --scale_hic_using_powerlaw \
          --threshold .02 \
          --cellType $(inputs.cel_type) \
          --outdir ./ \
          --make_all_putative
    - class: InlineJavascriptRequirement

    inputs:
    - id: enhancers
      doc: EnhancerList.txt
      type: File
      sbg:fileTypes: TXT
    - id: genes
      doc: GeneList.txt
      type: File
      sbg:fileTypes: TXT
    - id: hi_c_directory
      doc: example_chr22/input_data/HiC/raw/
      type: Directory
      loadListing: deep_listing
    - id: chrom_sizes
      doc: example_chr22/reference/chr22
      type: File
      secondaryFiles:
      - pattern: .bed
        required: true
    - id: hi_c_resolution
      type: int
    - id: cell_type
      type: string

    outputs:
    - id: enchancer_list
      type: File
      outputBinding:
        glob: '*EnhancerList.txt'

    baseCommand:
    - bash
    - predict.py.sh

    hints:
    - class: sbg:SaveLogs
      value: '*.sh'
    id: dave/abc-development-scratch-project/compute-abc-score/1
    sbg:appVersion:
    - v1.2
    sbg:content_hash: a81822f099617bdace5d6d925df4657efe5a84d115c8651393b0ffdc33b7bbc04
    sbg:contributors:
    - dave
    sbg:createdBy: dave
    sbg:createdOn: 1682905179
    sbg:id: dave/abc-development-scratch-project/compute-abc-score/1
    sbg:image_url:
    sbg:latestRevision: 1
    sbg:modifiedBy: dave
    sbg:modifiedOn: 1682905357
    sbg:project: dave/abc-development-scratch-project
    sbg:projectName: ABC - Development Scratch Project
    sbg:publisher: sbg
    sbg:revision: 1
    sbg:revisionNotes: |-
      Uploaded using sbpack v2022.03.16. 
      Source: 
      repo: https://github.com/workflow-development-interest-group/workflow-notebooks
      file: 
      commit: (uncommitted file)
    sbg:revisionsInfo:
    - sbg:modifiedBy: dave
      sbg:modifiedOn: 1682905179
      sbg:revision: 0
      sbg:revisionNotes: |-
        Uploaded using sbpack v2022.03.16. 
        Source: 
        repo: https://github.com/workflow-development-interest-group/workflow-notebooks
        file: 
        commit: (uncommitted file)
    - sbg:modifiedBy: dave
      sbg:modifiedOn: 1682905357
      sbg:revision: 1
      sbg:revisionNotes: |-
        Uploaded using sbpack v2022.03.16. 
        Source: 
        repo: https://github.com/workflow-development-interest-group/workflow-notebooks
        file: 
        commit: (uncommitted file)
    sbg:sbgMaintained: false
    sbg:validationErrors: []
    sbg:workflowLanguage: CWL
  out:
  - id: enchancer_list
  sbg:x: 1699.5419921875
  sbg:y: 252.91171264648438
id: |-
  https://api.sb.biodatacatalyst.nhlbi.nih.gov/v2/apps/dave/abc-development-scratch-project/abc-enchancer-gene-prediction/12/raw/
sbg:appVersion:
- v1.2
sbg:content_hash: af9fa59f5534bc4200e779efbed0933f9263275b431884b3b450a1d945f040f48
sbg:contributors:
- dave
sbg:createdBy: dave
sbg:createdOn: 1682359121
sbg:id: dave/abc-development-scratch-project/abc-enchancer-gene-prediction/12
sbg:image_url: |-
  https://platform.sb.biodatacatalyst.nhlbi.nih.gov/ns/brood/images/dave/abc-development-scratch-project/abc-enchancer-gene-prediction/12.png
sbg:latestRevision: 12
sbg:modifiedBy: dave
sbg:modifiedOn: 1682905684
sbg:project: dave/abc-development-scratch-project
sbg:projectName: ABC - Development Scratch Project
sbg:publisher: sbg
sbg:revision: 12
sbg:revisionNotes: ''
sbg:revisionsInfo:
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682359121
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682359189
  sbg:revision: 1
  sbg:revisionNotes: ''
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682393988
  sbg:revision: 2
  sbg:revisionNotes: ''
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682395780
  sbg:revision: 3
  sbg:revisionNotes: ''
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682396526
  sbg:revision: 4
  sbg:revisionNotes: ''
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682653830
  sbg:revision: 5
  sbg:revisionNotes: |-
    Uploaded using sbpack v2022.03.16. 
    Source: 
    repo: https://github.com/davidroberson/cwl-notebooks
    file: 
    commit: (uncommitted file)
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682654499
  sbg:revision: 6
  sbg:revisionNotes: |-
    Uploaded using sbpack v2022.03.16. 
    Source: 
    repo: https://github.com/davidroberson/cwl-notebooks
    file: 
    commit: (uncommitted file)
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682654875
  sbg:revision: 7
  sbg:revisionNotes: |-
    Uploaded using sbpack v2022.03.16. 
    Source: 
    repo: https://github.com/davidroberson/cwl-notebooks
    file: abc_enchancer_gene_prediction/cwl/abc-enchancer-gene-prediction.cwl
    commit: (uncommitted file)
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682684138
  sbg:revision: 8
  sbg:revisionNotes: |-
    Uploaded using sbpack v2022.03.16. 
    Source: 
    repo: https://github.com/davidroberson/cwl-notebooks
    file: abc_enchancer_gene_prediction/cwl/abc-enchancer-gene-prediction.wf.cwl
    commit: c784f37
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682779821
  sbg:revision: 9
  sbg:revisionNotes: |-
    Uploaded using sbpack v2022.03.16. 
    Source: 
    repo: https://github.com/davidroberson/cwl-notebooks
    file: abc_enchancer_gene_prediction/cwl/abc-enchancer-gene-prediction.wf.cwl
    commit: (uncommitted file)
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682780384
  sbg:revision: 10
  sbg:revisionNotes: ''
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682780468
  sbg:revision: 11
  sbg:revisionNotes: ''
- sbg:modifiedBy: dave
  sbg:modifiedOn: 1682905684
  sbg:revision: 12
  sbg:revisionNotes: ''
sbg:sbgMaintained: false
sbg:validationErrors:
- |-
  Missing one or more mandatory run inputs in step inputs: ['#compute_abc_score.hi_c_resolution', '#compute_abc_score.cell_type']
sbg:workflowLanguage: CWL
