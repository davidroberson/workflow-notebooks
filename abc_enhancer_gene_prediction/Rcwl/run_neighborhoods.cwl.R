#libraries ----
library(Rcwl)
library(tidyverse)

#input ports ----
input_ports = list(
  InputParam(id = "candidate_enhancer_regions", type = "File"),
  InputParam(id = "genes", type = "File"),
  InputParam(id = "H3K27ac", type = "File"),
  InputParam(id = "dhs", type = "File"),
  InputParam(id = "expression_table", type = "File"), 
  InputParam(id = "chr_sizes", type = "File"),
  InputParam(id = "ubiquitously_expressed_genes", type = "File"),
  InputParam(id = "cell_type", type = "string"))

#output ports ----
output_ports = list(
  OutputParam(id = "enhancer_list", type = "File", 
              glob = '**EnhancerList.txt'),
  OutputParam(id = "gene_list", type = "File", 
              glob = '*GeneList.txt'))

#requirements ----
docker = "images.sb.biodatacatalyst.nhlbi.nih.gov/andrewblair/cardiac-compendium:2023042401"
shell_script = Dirent(entryname = "run_neighborhoods.sh", 
                      read_file("../scripts/run_neighborhoods.sh"), 
                      writable = FALSE)
#hints ----
hints = list(class = "sbg:SaveLogs", value = "*.sh")

#cwl process object ----
run_neighborhoods <- cwlProcess(
  baseCommand = list("bash", "run_neighborhoods.sh"),
  inputs = do.call(InputParamList, c(input_ports)),
  outputs = do.call(OutputParamList, c(output_ports)),
  requirements = list(
    requireDocker(docker), 
    requireJS(),
    requireShellCommand(),
    requireInitialWorkDir(list(shell_script))),
  hints = list(hints))


#$namespaces:
#sbg: https://sevenbridges.com
