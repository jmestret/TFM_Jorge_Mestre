#!/bin/bash
# This script contains the executed code to simulate the ONT reads
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
        -d ~/TFM_pipelines/sim_data/wtc11_ont_sample_diff_complex \
	-k 8

# Simulation design
python sqantisim.py design sample\
	--gtf ~/TFM_pipelines/ref/gencode/gencode.v39.annotation.gtf \
	-i ~/TFM_pipelines/sim_data/wtc11_ont_sample_diff_complex/sqantisim_index.tsv \
	-d ~/TFM_pipelines/sim_data/wtc11_ont_sample_diff_complex \
	--ISM 5000 --NIC 5000 --NNC 5000 --trans_number 15000 \
	--ont_reads ~/TFM_pipelines/ref/seq_data/ont/ENCSR539ZXJ_cdna.fastq \
	--genome ~/TFM_pipelines/ref/gencode/GRCh38.primary_assembly.genome.fa \
	--seed 1234 -k 8\
	--diff_exp --low_prob 0.01 --high_prob 0.99 --iso_complex

# Simulate reads
python sqantisim.py sim \
	--genome ~/TFM_pipelines/ref/gencode/GRCh38.primary_assembly.genome.fa \
	--gtf ~/TFM_pipelines/ref/gencode/gencode.v39.annotation.gtf \
	-i ~/TFM_pipelines/sim_data/wtc11_ont_sample_diff_complex/sqantisim_index.tsv \
	-d ~/TFM_pipelines/sim_data/wtc11_ont_sample_diff_complex \
	--ont --illumina --seed 1234 --long_count 20000000 --short_count 60000000 \
	-k 12 --read_type cDNA

