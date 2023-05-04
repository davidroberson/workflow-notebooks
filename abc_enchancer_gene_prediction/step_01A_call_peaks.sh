

source /opt/conda/etc/profile.d/conda.sh
conda activate macs-py2.7
macs2 callpeak -t $(inputs.bam.path) \
  -n $(inputs.bam.nameroot).macs2 \
  -f BAM -g hs -p .1 --call-summits --outdir ./

#Sort narrowPeak file

bedtools sort \
  -faidx $(inputs.sort_order.path) \
  -i $(inputs.bam.nameroot).macs2_peaks.narrowPeak \
  > $(inputs.bam.nameroot).macs2_peaks.narrowPeak.sorted