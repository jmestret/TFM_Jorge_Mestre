#!/bin/bash
# Execution of IsoSeq3 to generate the long-read transcriptome reconstructed with PacBio
# and the evaluation with SQANTISIM

#######################################
#                                     #
#          IsoSeq3 pipeline           #
#                                     #
#######################################

# Convert simulated reads to PacBio BAM format
python ~/Convert2PacBioBAM/convert_to_pacbio_bam.py \
	~/TFM_pipelines/sim_data/wtc11_pb_sample_diff_complex/PacBio_simulated.fasta \
	~/TFM_pipelines/ref/seq_data/pb/ENCFF992WSK.flnc.bam \
	~/TFM_pipelines/isoseq_pipeline/PacBio_simulated

# Run IsoSeq3 clustering
echo "~/TFM_pipelines/isoseq_pipeline/PacBio_simulated.converted.bam" > ~/TFM_pipelines/isoseq_pipeline/flnc.fofn

isoseq3 cluster \
	~/TFM_pipelines/isoseq_pipeline/flnc.fofn \
	~/TFM_pipelines/isoseq_pipeline/pb_simulated_clustered.bam \
	--verbose

# Collapse redundant isoforms with reference genome
gunzip ~/TFM_pipelines/isoseq_pipeline/pb_simulated_clustered.hq.fasta.gz

minimap2 -ax splice -t8 -uf --secondary=no -C5 \
	~/TFM_pipelines/ref/gencode/GRCh38.primary_assembly.genome.fa \
	~/TFM_pipelines/isoseq_pipeline/pb_simulated_clustered.hq.fasta > ~/TFM_pipelines/isoseq_pipeline/pb_simulated_clustered.hq.fasta.sam

samtools sort -O sam -o ~/TFM_pipelines/isoseq_pipeline/pb_simulated_clustered.hq.fasta.sorted.sam ~/TFM_pipelines/isoseq_pipeline/pb_simulated_clustered.hq.fasta.sam

python ~/cDNA_Cupcake/cupcake/tofu/collapse_isoforms_by_sam.py \
 	--input ~/TFM_pipelines/isoseq_pipeline/pb_simulated_clustered.hq.fasta \
	-s ~/TFM_pipelines/isoseq_pipeline/pb_simulated_clustered.hq.fasta.sorted.sam \
	--dun-merge-5-shorter -o ~/TFM_pipelines/isoseq_pipeline/wtc11_pb_cupcake \
	--cpus 8


#######################################
#                                     #
#        SQANTISIM evaluation         #
#                                     #
#######################################

python sqantisim.py eval \
	--isoforms ~/TFM_pipelines/isoseq_pipeline/wtc11_pb_cupcake.collapsed.gff \
	--gtf ~/TFM_pipelines/sim_data/wtc11_pb_sample_diff_complex/sqantisim_modified.gtf \
	--genome ~/TFM_pipelines/ref/gencode/GRCh38.primary_assembly.genome.fa \
	-o isoseq_wtc11_pb -d ~/TFM_pipelines/isoseq_pipeline/sqanti3 \
	-i ~/TFM_pipelines/sim_data/wtc11_pb_sample_diff_complex/sqantisim_index.tsv

