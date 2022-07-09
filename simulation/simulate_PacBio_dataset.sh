#!/bin/bash
# This script contains the executed code to simulate the PacBio reads
# that the evaluated transcriptomes reconstructed pipelines used
# author: Jorge Mestre

#######################################
#                                     #
#            Run SQANTISIM            #
#                                     #
#######################################

# Classify reference transcripts

python sqantisim.py classif \
        --gtf ~/TFM_pipelines/ref/gencode/gencode.v39.annotation.gtf \
        -d ~/TFM_pipelines/sim_data/wtc11_pb_sample_diff_complex \
	-k 4

# Simulation design
python sqantisim.py design sample\
	--gtf ~/TFM_pipelines/ref/gencode/gencode.v39.annotation.gtf \
	-i ~/TFM_pipelines/sim_data/wtc11_pb_sample_diff_complex/sqantisim_index.tsv \
	-d ~/TFM_pipelines/sim_data/wtc11_pb_sample_diff_complex \
	--ISM 5000 --NIC 5000 --NNC 5000 --trans_number 15000\
	--pb_reads ~/TFM_pipelines/ref/seq_data/pb/hs_WTC11_pb_catenate.fastq \
	--genome ~/TFM_pipelines/ref/gencode/GRCh38.primary_assembly.genome.fa \
        --seed 1234 \
	--iso_complex --diff_exp --low_prob 0.01 --high_prob 0.99

# Simulate reads
python sqantisim.py sim \
	--genome ~/TFM_pipelines/ref/gencode/GRCh38.primary_assembly.genome.fa \
	--gtf ~/TFM_pipelines/ref/gencode/gencode.v39.annotation.gtf \
	-i ~/TFM_pipelines/sim_data/wtc11_pb_sample_diff_complex/sqantisim_index.tsv \
	-d ~/TFM_pipelines/sim_data/wtc11_pb_sample_diff_complex \
	--pb --illumina --seed 1234 --long_count 4000000 --short_count 60000000 \
	-k 4

