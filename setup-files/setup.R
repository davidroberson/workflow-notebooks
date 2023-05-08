if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
#BiocManager::install("Rcwl")

system("pip3 install sbpack")

BiocManager::install("rworkflow/Rcwl")

install.packages("tidycwl")
