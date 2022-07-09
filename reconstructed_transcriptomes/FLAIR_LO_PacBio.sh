#!/bin/bash
# Execution of FLAIR LO to generate the long-read transcriptome reconstructed with PacBio
# and the evaluation with SQANTISIM

#######################################
#                                     #
#         FLAIR LO pipeline           #
#                                     #
#######################################
python flair.py 123 \
	-r ~/TFM_pipelines/sim_data/wtc11_pb_sample_diff_complex/PacBio_simulated.fasta \
	-g ~/TFM_pipelines/ref/gencode/GRCh38.primary_assembly.genome.fa \
	-f ~/TFM_pipelines/sim_data/wtc11_pb_sample_diff_complex/sqantisim_modified.gtf \
	-o ~/TFM_pipelines/flair_pipeline/flair_wtc11_pb/flair_wtc11_pb \
	--temp_dir ~/TFM_pipelines/flair_pipeline/flair_wtc11_pb/temp_flair \
	--check_splice

#######################################
#                                     #
#        SQANTISIM evaluation         #
#                                     #
#######################################

python sqantisim.py eval \
	--isoforms ~/TFM_pipelines/flair_pipeline/flair_wtc11_pb/flair_wtc11_pb.isoforms.gtf \
	--gtf ~/TFM_pipelines/sim_data/wtc11_pb_sample_diff_complex/sqantisim_modified.gtf \
	--genome ~/TFM_pipelines/ref/gencode/GRCh38.primary_assembly.genome.fa \
	-o flair_wtc11_pb -d ~/TFM_pipelines/flair_pipeline/flair_wtc11_pb/sqanti3 \
	-i ~/TFM_pipelines/sim_data/wtc11_pb_sample_diff_complex/sqantisim_index.tsv

