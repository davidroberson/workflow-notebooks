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
