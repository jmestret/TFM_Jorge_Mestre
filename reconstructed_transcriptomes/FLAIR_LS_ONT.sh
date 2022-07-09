#!/bin/bash
# Execution of FLAIR LO to generate the long-read transcriptome reconstructed with ONT
# and Illumina reads, and the evaluation with SQANTISIM

#######################################
#                                     #
#         FLAIR LS pipeline           #
#                                     #
#######################################

awk '{ if ($7 > 2) { print } }' ~/TFM_pipelines/sim_data/wtc11_ont_sample_diff_complex/Illumina_wtc11_ont_diffSJ.out.tab > ~/TFM_pipelines/flair_pipeline/flair_wtc11_ont_LS/wtc11_ont.filtered.SJ.out.tab

python flair.py 123 \
	-r ~/TFM_pipelines/sim_data/wtc11_ont_sample_diff_complex/ONT_simulated.fastq \
	-g ~/TFM_pipelines/ref/gencode/GRCh38.primary_assembly.genome.fa \
	-f ~/TFM_pipelines/sim_data/wtc11_ont_sample_diff_complex/sqantisim_modified.gtf \
	-o ~/TFM_pipelines/flair_pipeline/flair_wtc11_ont_LS/flair_wtc11_ont \
	--temp_dir ~/TFM_pipelines/flair_pipeline/flair_wtc11_ont_LS/temp_flair \
	--shortread ~/TFM_pipelines/flair_pipeline/flair_wtc11_ont_LS/wtc11_ont.filtered.SJ.out.tab \
	--check_splice

#######################################
#                                     #
#        SQANTISIM evaluation         #
#                                     #
#######################################

python sqantisim.py eval \
	--isoforms ~/TFM_pipelines/flair_pipeline/flair_wtc11_ont_LS/flair_wtc11_ont.isoforms.gtf \
	--gtf ~/TFM_pipelines/sim_data/wtc11_ont_sample_diff_complex/sqantisim_modified.gtf \
	--genome ~/TFM_pipelines/ref/gencode/GRCh38.primary_assembly.genome.fa \
	-o flair_wtc11_ont_LS -d ~/TFM_pipelines/flair_pipeline/flair_wtc11_ont_LS/sqanti3 \
	-i ~/TFM_pipelines/sim_data/wtc11_ont_sample_diff_complex/sqantisim_index.tsv \
	-k 2 \
	--short_reads ~/TFM_pipelines/flair_pipeline/flair_wtc11_ont_LS/short_reads.fofn

