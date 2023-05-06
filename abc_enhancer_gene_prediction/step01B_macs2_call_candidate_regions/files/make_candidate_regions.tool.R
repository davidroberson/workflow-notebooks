library(Rcwl)
library(tidyverse)

#input ports
input_ports = list(
  InputParam(id = "narrow_peak", type = "File"),
  InputParam(id = "bam", type = "File", 
             secondaryFiles = list(pattern = ".bai"), value = list("BAM")),
  InputParam(id = "chr_sizes", type = "File"),
  InputParam(id = "regions_blocklist", type = "File"),
  InputParam(id = "regions_includelist", type = "File")
)

#output ports
output_ports = list(
  OutputParam(id = "candidate_regions", type = "File", 
              glob = '*candidateRegions.bed'),
  OutputParam(id = "counts", type = "File", 
              glob = '*Counts.bed')
)

#requirements
docker = "images.sb.biodatacatalyst.nhlbi.nih.gov/andrewblair/cardiac-compendium:2023042401"
shell_script = Dirent(entryname = "make_candidate_regions.sh", read_file("make_candidate_regions.sh"), writable = FALSE)

#hints
hints = list(class = "sbg:SaveLogs", value = "*.sh")

make_candidate_regions <- cwlProcess(
  baseCommand = list("bash", "make_candidate_regions.sh"),
  inputs = do.call(InputParamList, c(input_ports)),
  outputs = do.call(OutputParamList, c(output_ports)),
  requirements = list(
    requireDocker(docker), 
    requireJS(),
    requireShellCommand(),
    requireInitialWorkDir(list(shell_script))),
  hints = list(hints))

make_candidate_regions <- addMeta(
  cwl = make_candidate_regions,
  label = " MACS2 Call Candidate Regions",
  doc = read_file("doc.md"))

#write cwl to file
writeCWL(make_candidate_regions, outdir = "./")
























