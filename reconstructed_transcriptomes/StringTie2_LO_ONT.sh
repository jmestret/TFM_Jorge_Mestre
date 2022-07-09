#!/bin/bash
# Execution of StringTie2 LO to generate the long-read transcriptome reconstructed with ONT
# and the evaluation with SQANTISIM

#######################################
#                                     #
#       StringTie2 LO pipeline        #
#                                     #
#######################################

lr="~/TFM_pipelines/sim_data/wtc11_ont_sample_diff_complex/ONT_simulated.aln.sam" 
genome_fasta="~/TFM_pipelines/ref/gencode/GRCh38.primary_assembly.genome.fa"
ref_annotation="~/TFM_pipelines/sim_data/wtc11_ont_sample_diff_complex/sqantisim_modified.gtf"

# Sort SAM
samtools sort -O bam -o ~/TFM_pipelines/stringtie_pipeline/stringtie_wtc11_ont/ONT_simulated.aln.sorted.bam $lr
lr="~/TFM_pipelines/stringtie_pipeline/stringtie_wtc11_ont/ONT_simulated.aln.sorted.bam"



# Run stringtie2
~/TFM_pipelines/stringtie_pipeline/stringtie/stringtie \
	-L -G $ref_annotation \
	-o ~/TFM_pipelines/stringtie_pipeline/stringtie_wtc11_ont/wtc11_ont_stringtie_transcriptome.gtf \
	$lr


# Delete transcript models unstranded (this is weird)
awk '$7 != "."' ~/TFM_pipelines/stringtie_pipeline/stringtie_wtc11_ont/wtc11_ont_stringtie_transcriptome.gtf > ~/TFM_pipelines/stringtie_pipeline/stringtie_wtc11_ont/stranded_wtc11_ont_stringtie_transcriptome.gtf

#######################################
#                                     #
#        SQANTISIM evaluation         #
#                                     #
#######################################

python sqantisim.py eval \
	--isoforms ~/TFM_pipelines/stringtie_pipeline/stringtie_wtc11_ont/stranded_wtc11_ont_stringtie_transcriptome.gtf \
	--gtf ~/TFM_pipelines/sim_data/wtc11_ont_sample_diff_complex/sqantisim_modified.gtf \
	--genome ~/TFM_pipelines/ref/gencode/GRCh38.primary_assembly.genome.fa \
	-o stringtie2_wtc11_ont -d ~/TFM_pipelines/stringtie_pipeline/stringtie_wtc11_ont/sqanti3 \
	-i ~/TFM_pipelines/sim_data/wtc11_ont_sample_diff_complex/sqantisim_index.tsv

