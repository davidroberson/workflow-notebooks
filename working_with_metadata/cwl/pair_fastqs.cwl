cwlVersion: v1.2
class: CommandLineTool
label: SBG Pair FASTQs by Metadata CWL1.2
doc: |-
  **SBG Pair FASTQs by Metadata** accepts a list of FASTQ files and groups them into sub-lists based on the metadata. 

  This grouping is done based on the following metadata hierarchy: **Sample ID** > **Library ID** > **Platform unit ID** > **File segment number**. Not all of these four metadata fields are required, but the information has to unambiguously identify pairs of FASTQ files. Files with no **Paired-end** metadata set are treated as single-end reads. Files with no metadata set in the four above-mentioned fields will be grouped together.

  *A list of **all inputs and parameters** with corresponding descriptions can be found at the bottom of this page.*

  ***Please note that any cloud infrastructure costs resulting from app and pipeline executions, including the use of public apps, are the sole responsibility of you as a user. To avoid excessive costs, please read the app description carefully and set the app parameters and execution settings accordingly.***


  ### Common Use Cases

  **SBG Pair FASTQs by Metadata** is most useful for grouping paired-end reads provided in any of the allowed formats (FASTQ, FQ, FASTQ.GZ, FQ.GZ).


  ###Common Issues and Important Notes

  - For paired-end read files, it is important to properly set the **Paired-end** metadata field.
  - Having more than two files in a group might create errors downstream in some pipelines.


  ### Performance Benchmarking

  The following table contains metrics for four tasks executed with different input files on the same c4.2xlarge on-demand AWS instance. Each task consists of 10 files (5 x 2 paired-end files). The duration and cost of the task depend on the size of the input FASTQ files.

  Total FASTQ files size(.gz) | Duration | Cost | Instance type (AWS) |
  |:-------------:|:---------------:|:---------:|:------:|:---:|
  | 123 GB | 54 min | $0.49 | c4.2xlarge |
  | 253 GB | 1 hour 52 min | $1.01 | c4.2xlarge |
  | 484 GB | 3 hours 34 min |$1.93 | c4.2xlarge |
  | 863 GB | 6 hours 23 min | $3.45 | c4.2xlarge |

  *Cost can be significantly reduced by using **spot instances**. Visit the [knowledge center](https://docs.sevenbridges.com/docs/about-spot-instances) for more details.*


  ### Portability

  **SBG Pair FASTQs by Metadata** was tested with cwltool version 3.1.20220907141119. The `fastq_list` input was provided in the job.yaml/job.json file and used for testing.
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ResourceRequirement
  ramMin: 1024
- class: DockerRequirement
  dockerPull: images.sbgenomics.com/nikola_jovanovic/alpine:1
- class: InlineJavascriptRequirement

inputs:
- id: fastq_list
  label: List of FASTQ files
  doc: A list of FASTQ files with properly set metadata fields.
  type: File[]
  sbg:fileTypes: FASTQ, FQ, FASTQ.GZ, FQ.GZ

outputs:
- id: tuple_list
  label: List of grouped FASTQ files
  doc: A list of FASTQ files grouped by metadata fields.
  type: File[]?
  outputBinding:
    outputEval: |-
      ${
          function get_meta_map(m, file, meta) {
              if (meta in file.metadata) {
                  return m[file.metadata[meta]]
              } else {
                  return m['Undefined']
              }
          }

          function create_new_map(map, file, meta) {
              if (meta in file.metadata) {
                  map[file.metadata[meta]] = {}
                  return map[file.metadata[meta]]
              } else {
                  map['Undefined'] = {}
                  return map['Undefined']
              }
          }

          var arr = [].concat(inputs.fastq_list)
          var map = {}

          for (var i in arr) {

              var sm_map = get_meta_map(map, arr[i], 'sample_id')
              if (!sm_map) sm_map = create_new_map(map, arr[i], 'sample_id')

              var lb_map = get_meta_map(sm_map, arr[i], 'library_id')
              if (!lb_map) lb_map = create_new_map(sm_map, arr[i], 'library_id')

              var pu_map = get_meta_map(lb_map, arr[i], 'platform_unit_id')
              if (!pu_map) pu_map = create_new_map(lb_map, arr[i], 'platform_unit_id')

              if ('file_segment_number' in arr[i].metadata) {
                  if (pu_map[arr[i].metadata['file_segment_number']]) {
                      var a = pu_map[arr[i].metadata['file_segment_number']]
                      var ar = [].concat(a)
                      ar = ar.concat(arr[i])
                      pu_map[arr[i].metadata['file_segment_number']] = ar
                  } else {
                      pu_map[arr[i].metadata['file_segment_number']] = [].concat(arr[i])
                  }
              } else {
                  if (pu_map['Undefined']) {
                      a = pu_map['Undefined']
                      ar = [].concat(a)
                      ar = ar.concat(arr[i])
                      pu_map['Undefined'] = ar
                  } else {
                      pu_map['Undefined'] = [].concat(arr[i])
                  }
              }
          }
          var tuple_list = []
          for (var sm in map)
              for (var lb in map[sm])
                  for (var pu in map[sm][lb]) {
                      for (var fsm in map[sm][lb][pu]) {
                          var list = map[sm][lb][pu][fsm]
                          tuple_list.push(list)
                      }
                  }
          return tuple_list
      }
  sbg:fileTypes: FASTQ, FQ, FASTQ.GZ, FQ.GZ

baseCommand:
- echo 
arguments:
- prefix: '"blar" > test.yes &&'
  position: 0
  valueFrom: $(inputs.fastq_list[0].metadata.library_id)
  shellQuote: false

sbg:appVersion:
- v1.2
sbg:categories:
- FASTQ Processing
- CWLtool Tested
sbg:content_hash: ad8786ee7d445bc9e22ebf9b085bccf8b20d68656be70fe4ce2bc4e745c17aab3
sbg:contributors:
- david.roberson
sbg:copyOf: admin/sbg-public-data/sbg-pair-fastqs-by-metadata-cwl1-2/4
sbg:createdBy: david.roberson
sbg:createdOn: 1683040186
sbg:expand_workflow: false
sbg:id: david.roberson/cwltool-and-metadata-testing/sbg-pair-fastqs-by-metadata-cwl1-2/0
sbg:image_url:
sbg:latestRevision: 0
sbg:license: Apache License 2.0
sbg:modifiedBy: david.roberson
sbg:modifiedOn: 1683040186
sbg:project: david.roberson/cwltool-and-metadata-testing
sbg:projectName: cwltool and metadata testing
sbg:publisher: sbg
sbg:revision: 0
sbg:revisionNotes: Copy of admin/sbg-public-data/sbg-pair-fastqs-by-metadata-cwl1-2/4
sbg:revisionsInfo:
- sbg:modifiedBy: david.roberson
  sbg:modifiedOn: 1683040186
  sbg:revision: 0
  sbg:revisionNotes: Copy of admin/sbg-public-data/sbg-pair-fastqs-by-metadata-cwl1-2/4
sbg:sbgMaintained: false
sbg:toolAuthor: Seven Bridges Genomics
sbg:toolkit: SBGTools
sbg:toolkitVersion: '1.0'
sbg:validationErrors: []
sbg:workflowLanguage: CWL
