#!/bin/bash
# Execution of StringTie2 LO to generate the long-read transcriptome reconstructed with PacBio
# and the evaluation with SQANTISIM

#######################################
#                                     #
#       StringTie2 LO pipeline        #
#                                     #
#######################################

lr="~/TFM_pipelines/sim_data/wtc11_pb_sample_diff_complex/PacBio_simulated.aln.sam" 
genome_fasta="~/TFM_pipelines/ref/gencode/GRCh38.primary_assembly.genome.fa"
ref_annotation="~/TFM_pipelines/sim_data/wtc11_pb_sample_diff_complex/sqantisim_modified.gtf"

# Sort SAM
samtools sort -O bam -o ~/TFM_pipelines/stringtie_pipeline/stringtie_wtc11_pb/PacBio_simulated.aln.sorted.bam $lr
lr="~/TFM_pipelines/stringtie_pipeline/stringtie_wtc11_pb/PacBio_simulated.aln.sorted.bam"



# Run stringtie2
~/TFM_pipelines/stringtie_pipeline/stringtie/stringtie \
	-L -G $ref_annotation \
	-o ~/TFM_pipelines/stringtie_pipeline/stringtie_wtc11_pb/wtc11_pb_stringtie_transcriptome.gtf \
	$lr


# Delete transcript models unstranded (this is weird)
awk '$7 != "."' ~/TFM_pipelines/stringtie_pipeline/stringtie_wtc11_pb/wtc11_pb_stringtie_transcriptome.gtf > ~/TFM_pipelines/stringtie_pipeline/stringtie_wtc11_pb/stranded_wtc11_pb_stringtie_transcriptome.gtf

#######################################
#                                     #
#        SQANTISIM evaluation         #
#                                     #
#######################################

python sqantisim.py eval \
	--isoforms ~/TFM_pipelines/stringtie_pipeline/stringtie_wtc11_pb/stranded_wtc11_pb_stringtie_transcriptome.gtf \
	--gtf ~/TFM_pipelines/sim_data/wtc11_pb_sample_diff_complex/sqantisim_modified.gtf \
	--genome ~/TFM_pipelines/ref/gencode/GRCh38.primary_assembly.genome.fa \
	-o stringtie2_wtc11_pb -d ~/TFM_pipelines/stringtie_pipeline/stringtie_wtc11_pb/sqanti3 \
	-i ~/TFM_pipelines/sim_data/wtc11_pb_sample_diff_complex/sqantisim_index.tsv

