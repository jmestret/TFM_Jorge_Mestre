#!/bin/bash
# Execution of FLAIR LO to generate the long-read transcriptome reconstructed with ONT
# and the evaluation with SQANTISIM

#######################################
#                                     #
#         FLAIR LO pipeline           #
#                                     #
#######################################

python flair.py 123 \
	-r ~/TFM_pipelines/sim_data/wtc11_ont_sample_diff_complex/ONT_simulated.fastq \
	-g ~/TFM_pipelines/ref/gencode/GRCh38.primary_assembly.genome.fa \
	-f ~/TFM_pipelines/sim_data/wtc11_ont_sample_diff_complex/sqantisim_modified.gtf \
	-o ~/TFM_pipelines/flair_pipeline/flair_wtc11_ont/flair_wtc11_ont \
	--temp_dir ~/TFM_pipelines/flair_pipeline/flair_wtc11_ont/temp_flair \
	--check_splice

#######################################
#                                     #
#        SQANTISIM evaluation         #
#                                     #
#######################################

python sqantisim.py eval \
	--isoforms ~/TFM_pipelines/flair_pipeline/flair_wtc11_ont/flair_wtc11_ont.isoforms.gtf \
	--gtf ~/TFM_pipelines/sim_data/wtc11_ont_sample_diff_complex/sqantisim_modified.gtf \
	--genome ~/TFM_pipelines/ref/gencode/GRCh38.primary_assembly.genome.fa \
	-o flair_wtc11_ont -d ~/TFM_pipelines/flair_pipeline/flair_wtc11_ont/sqanti3 \
	-i ~/TFM_pipelines/sim_data/wtc11_ont_sample_diff_complex/sqantisim_index.tsv

