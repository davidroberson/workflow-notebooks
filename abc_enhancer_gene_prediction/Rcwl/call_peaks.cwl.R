library(Rcwl)
library(tidyverse)

#input ports
input_ports = list(
  InputParam(id = "bam", type = "File"),
  InputParam(id = "sort_order", type = "File"))

#output ports
output_ports = list(
  OutputParam(id = "sorted_peaks", type = "File", glob = '*narrowPeak.sorted'),
  OutputParam(id = "model_r_scripts", type = "File", glob = '*model.r'),
  OutputParam(id = "peak_xls", type = "File", glob = '*peak.xls'),
  OutputParam(id = "summits", type = "File", glob = '*summits.bed')
)

docker = "images.sb.biodatacatalyst.nhlbi.nih.gov/andrewblair/cardiac-compendium:2023042401"

call_peaks_script = Dirent(entryname = "call_peaks.sh", 
                           read_file("../scripts/call_peaks.sh"), 
                           writable = FALSE)

hints = list(class = "sbg:SaveLogs", value = "*.sh")

call_peaks_tool <- cwlProcess(
  baseCommand = list("bash", "call_peaks.sh"),
  inputs = do.call(InputParamList, c(input_ports)),
  outputs = do.call(OutputParamList, c(output_ports)),
  hints = list(hints),
  requirements = list(
    requireDocker(docker), 
    requireJS(),
    requireShellCommand(),
    requireInitialWorkDir(list(call_peaks_script))))


