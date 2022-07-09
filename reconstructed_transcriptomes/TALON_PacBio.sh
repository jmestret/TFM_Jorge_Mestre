#!/bin/bash
# Execution of TALON to generate the long-read transcriptome reconstructed with PacBio
# and the evaluation with SQANTISIM

#######################################
#                                     #
#            TALON pipeline           #
#                                     #
#######################################

#Flagging reads for internal priming
talon_label_reads \
	--f ~/TFM_pipelines/sim_data/wtc11_pb_sample_diff_complex/PacBio_simulated.aln.sam \
	--g ~/TFM_pipelines/ref/gencode/GRCh38.primary_assembly.genome.fa \
	--t 4 --o hs_talon_label

# Initializing a TALON database
talon_initialize_database \
	--f ~/TFM_pipelines/sim_data/wtc11_pb_sample_diff_complex/sqantisim_modified.gtf \
	--g hs_talon_genome \
	--a hs_talon_metadata \
	--o hs_talon_db

# Running TALON
talon \
	--f ~/TFM_pipelines/talon_pipeline/talon_wtc11_pb/config_file.csv \
	--db ~/TFM_pipelines/talon_pipeline/talon_wtc11_pb/hs_talon_db.db \
	--build hs_talon_genome --threads 4 --o talon_run

# Filtering transcriptome for isoform-level analysis
talon_filter_transcripts \
	--db ~/TFM_pipelines/talon_pipeline/talon_wtc11_pb/hs_talon_db.db \
	--datasets isoseqsim \
	--annot hs_talon_metadata \
	--minCount 3 --minDatasets 1 \
	--o talon_isofilter.csv

# Obtain custom GTF
talon_create_GTF \
	--db ~/TFM_pipelines/talon_pipeline/talon_wtc11_pb/hs_talon_db.db \
	--whitelist ~/TFM_pipelines/talon_pipeline/talon_wtc11_pb/talon_isofilter.csv \
	--build hs_talon_genome --annot hs_talon_metadata \
	--o talon_transcriptome

#######################################
#                                     #
#        SQANTISIM evaluation         #
#                                     #
#######################################

python sqantisim.py eval \
	--isoforms ~/TFM_pipelines/talon_pipeline/talon_wtc11_pb/talon_transcriptome_talon.gtf \
	--gtf ~/TFM_pipelines/sim_data/wtc11_pb_sample_diff_complex/sqantisim_modified.gtf \
	--genome ~/TFM_pipelines/ref/gencode/GRCh38.primary_assembly.genome.fa \
	-o talon_wtc11_pb -d ~/TFM_pipelines/talon_pipeline/talon_wtc11_pb/sqanti3 \
	-i ~/TFM_pipelines/sim_data/wtc11_pb_sample_diff_complex/sqantisim_index.tsv

