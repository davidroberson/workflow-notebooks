conda env create -f abcenv.yml

python src/makeCandidateRegions.py \
--narrowPeak $(inputs.narrow_peak.path)  \
--bam $(inputs.bam.path) \
--outDir ./ \
--chrom_sizes $(inputs.chr_sizes.path) \
--regions_blocklist $(inputs.regions_blocklist.path) \
--regions_includelist $(inputs.regions_includelist) \
--peakExtendFromSummit 250 \
--nStrongestPeaks 3000 