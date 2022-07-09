#!/bin/bash
# Execution of FLAIR LS to generate the long-read transcriptome reconstructed with PacBio
# and Illumina reads, and the evaluation with SQANTISIM

#######################################
#                                     #
#         FLAIR LS pipeline           #
#                                     #
#######################################

awk '{ if ($7 > 2) { print } }' ~/TFM_pipelines/sim_data/wtc11_pb_sample_diff_complex/Illumina_wtc11_pb_diffSJ.out.tab > ~/TFM_pipelines/flair_pipeline/flair_wtc11_pb_LS/wtc11_pb.filtered.SJ.out.tab

python flair.py 123 \
	-r ~/TFM_pipelines/sim_data/wtc11_pb_sample_diff_complex/PacBio_simulated.fasta \
	-g ~/TFM_pipelines/ref/gencode/GRCh38.primary_assembly.genome.fa \
	-f ~/TFM_pipelines/sim_data/wtc11_pb_sample_diff_complex/sqantisim_modified.gtf \
	-o ~/TFM_pipelines/flair_pipeline/flair_wtc11_pb_LS/flair_wtc11_pb \
	--temp_dir ~/TFM_pipelines/flair_pipeline/flair_wtc11_pb_LS/temp_flair \
	--shortread ~/TFM_pipelines/flair_pipeline/flair_wtc11_pb_LS/wtc11_pb.filtered.SJ.out.tab \
	--check_splice

#######################################
#                                     #
#        SQANTISIM evaluation         #
#                                     #
#######################################

python sqantisim.py eval \
	--isoforms ~/TFM_pipelines/flair_pipeline/flair_wtc11_pb_LS/flair_wtc11_pb.isoforms.gtf \
	--gtf ~/TFM_pipelines/sim_data/wtc11_pb_sample_diff_complex/sqantisim_modified.gtf \
	--genome ~/TFM_pipelines/ref/gencode/GRCh38.primary_assembly.genome.fa \
	-o flair_wtc11_pb_LS -d ~/TFM_pipelines/flair_pipeline/flair_wtc11_pb_LS/sqanti3 \
	-i ~/TFM_pipelines/sim_data/wtc11_pb_sample_diff_complex/sqantisim_index.tsv \
	-k 2 \
	--short_reads ~/TFM_pipelines/flair_pipeline/flair_wtc11_pb_LS/short_reads.fofn

