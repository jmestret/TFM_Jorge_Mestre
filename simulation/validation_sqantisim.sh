#!/bin/bash
# This script contains the executed code to simulate the data
# for the validation of SQANTISIM
# author: Jorge Mestre

#######################################
#                                     #
#  Validate SQANTISIM classification  #
#                                     #
#######################################

# Classify transcripts from reference annotation
python sqantisim.py classif \
        --gtf ~/TFM_pipelines/ref/gencode/gencode.v39.annotation.gtf \
        -d ~/TFM_pipelines/selfeval/sc_eval \
	-k 4

# Generate reduced GTF file
python sqantisim.py design equal\
	--gtf ~/TFM_pipelines/ref/gencode/gencode.v39.annotation.gtf \
	-i ~/TFM_pipelines/selfeval/sc_eval/sqantisim_index.tsv \
	-d ~/TFM_pipelines/selfeval/sc_eval \
	--ISM 1000 --NIC 1000 --NNC 1000 --Fusion 1000 --Antisense 1000 --GG 1000 --GI 1000 --Intergenic 1000 \
	--seed 1234

# Validate classification with SQANTI3
python sqanti3_qc.py \
	~/TFM_pipelines/ref/gencode/gencode.v39.annotation.gtf \
	~/TFM_pipelines/selfeval/sc_eval/sqantisim_modified.gtf \
	~/TFM_pipelines/ref/gencode/GRCh38.primary_assembly.genome.fa \
	-o selfeval \
	-d ~/TFM_pipelines/selfeval/sc_eval/sqanti3 \
	--cpus 4 --force_id_ignore --min_ref_len 0 --skipORF


#######################################
#                                     #
#        Simulate transcripts         #
#                                     #
#######################################

# SQANTISIM classif
python sqantisim.py classif \
        --gtf ~/TFM_pipelines/ref/gencode/gencode.v39.annotation.gtf \
        -d ~/TFM_pipelines/selfeval/expr_equal \
	-k 2


# SQANTISIM desing equal - simulate 5000 ISM, 5000 NIC, 5000 NNC, 20000 known transcripts
python sqantisim.py design equal\
	--gtf ~/TFM_pipelines/ref/gencode/gencode.v39.annotation.gtf \
	-i ~/TFM_pipelines/selfeval/expr_diff/sqantisim_index.tsv \
	-d ~/TFM_pipelines/selfeval/expr_diff \
	--ISM 5000 --NIC 5000 --NNC 5000 -nt 35000 \
        --seed 1234


# SQANTISIM desing sample - novel and known equal expression
python sqantisim.py design sample\
	--gtf ~/TFM_pipelines/ref/gencode/gencode.v39.annotation.gtf \
	-i ~/TFM_pipelines/selfeval/expr_diff/sqantisim_index.tsv \
	-d ~/TFM_pipelines/selfeval/expr_diff \
	--ISM 5000 --NIC 5000 --NNC 5000 -nt 35000\
	--mapped_reads ~/TFM_pipelines/ref/seq_data/pb/hs_WTC11_pb_catenate_sqantisim_align.sam \
	--genome ~/TFM_pipelines/ref/gencode/GRCh38.primary_assembly.genome.fa \
        --seed 1234

# SQANTISIM desing sample - novel and known different expression
python sqantisim.py design sample\
        --gtf ~/TFM_pipelines/ref/gencode/gencode.v39.annotation.gtf \
        -i ~/TFM_pipelines/selfeval/expr_diff/sqantisim_index.tsv \
        -d ~/TFM_pipelines/selfeval/expr_diff \
        --ISM 5000 --NIC 5000 --NNC 5000 -nt 35000\
        --mapped_reads ~/TFM_pipelines/ref/seq_data/pb/hs_WTC11_pb_catenate_sqantisim_align.sam \
        --genome ~/TFM_pipelines/ref/gencode/GRCh38.primary_assembly.genome.fa \
        --seed 1234 \
	--iso_complex --diff_exp --low_prob 0.01 --high_prob 0.99


# SQANTISIM compare simulation

# PacBio
python sqantisim.py sim \
	--genome ~/TFM_pipelines/ref/gencode/GRCh38.primary_assembly.genome.fa \
	--gtf ~/TFM_pipelines/ref/gencode/gencode.v39.annotation.gtf \
	-i ~/TFM_pipelines/selfeval/expr_diff/sqantisim_index.tsv \
	-d ~/TFM_pipelines/selfeval/expr_diff \
	--pb --seed 1234 --long_count 1000000 -k 4

# ONT
python sqantisim.py sim \
	--genome ~/TFM_pipelines/ref/gencode/GRCh38.primary_assembly.genome.fa \
	--gtf ~/TFM_pipelines/ref/gencode/gencode.v39.annotation.gtf \
	-i ~/TFM_pipelines/selfeval/expr_diff/sqantisim_index.tsv \
	-d ~/TFM_pipelines/selfeval/expr_diff \
	--ont --seed 1234 --long_count 1000000 --read_type cDNA -k 4

# Illumina
python sqantisim.py sim \
	--genome ~/TFM_pipelines/ref/gencode/GRCh38.primary_assembly.genome.fa \
	--gtf ~/TFM_pipelines/ref/gencode/gencode.v39.annotation.gtf \
	-i ~/TFM_pipelines/selfeval/expr_diff/sqantisim_index.tsv \
	-d ~/TFM_pipelines/selfeval/expr_diff \
	--illumina --seed 1234 --short_count 10000000

