#!/bin/bash
# Execution of StringTie2 Ls to generate the long-read transcriptome reconstructed with ONT
# and Illumina reads, and the evaluation with SQANTISIM

#######################################
#                                     #
#       StringTie2 LS pipeline        #
#                                     #
#######################################

lr="~/TFM_pipelines/sim_data/wtc11_ont_sample_diff_complex/ONT_simulated.aln.sam"
sr="~/TFM_pipelines/sim_data/wtc11_ont_sample_diff_complex/Illumina_wtc11_ont_diffAligned.sortedByCoord.out.bam"
genome_fasta="~/TFM_pipelines/ref/gencode/GRCh38.primary_assembly.genome.fa"
ref_annotation="~/TFM_pipelines/sim_data/wtc11_ont_sample_diff_complex/sqantisim_modified.gtf"

# Sort SAM
samtools sort -O bam -o ~/TFM_pipelines/stringtie_pipeline/stringtie_wtc11_ont_LS/ONT_simulated.aln.sorted.bam $lr
lr="~/TFM_pipelines/stringtie_pipeline/stringtie_wtc11_ont_LS/ONT_simulated.aln.sorted.bam"

# Run stringtie2
~/TFM_pipelines/stringtie_pipeline/stringtie/stringtie \
	-L --mix -G $ref_annotation \
	-o ~/TFM_pipelines/stringtie_pipeline/stringtie_wtc11_ont_LS/wtc11_ont_stringtie_LS_transcriptome.gtf \
	$sr $lr


awk '$7 != "."' ~/TFM_pipelines/stringtie_pipeline/stringtie_wtc11_ont_LS/wtc11_ont_stringtie_LS_transcriptome.gtf > ~/TFM_pipelines/stringtie_pipeline/stringtie_wtc11_ont_LS/stranded_wtc11_ont_stringtie_LS_transcriptome.gtf

#######################################
#                                     #
#        SQANTISIM evaluation         #
#                                     #
#######################################

python sqantisim.py eval \
	--isoforms ~/TFM_pipelines/stringtie_pipeline/stringtie_wtc11_ont_LS/stranded_wtc11_ont_stringtie_LS_transcriptome.gtf \
	--gtf ~/TFM_pipelines/sim_data/wtc11_ont_sample_diff_complex/sqantisim_modified.gtf \
	--genome ~/TFM_pipelines/ref/gencode/GRCh38.primary_assembly.genome.fa \
	-o stringtie2_wtc11_ont_LS -d ~/TFM_pipelines/stringtie_pipeline/stringtie_wtc11_ont_LS/sqanti3 \
	-i ~/TFM_pipelines/sim_data/wtc11_ont_sample_diff_complex/sqantisim_index.tsv

