

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