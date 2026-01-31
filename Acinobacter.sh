#!/bin/bash
# ======================================================
# Whole Genome Sequencing Pipeline (Paired-End)
# Organism: Acinetobacter baumannii
# Accession: SRR25305574 (ENA)
# Author: Annah Ndono
# ======================================================

set -euo pipefail

# -----------------------------
# Define variables
# -----------------------------
WORKDIR="/Users/sam/Documents/HP/Folder_5/G_SBC_G857_Sequencing_&_HPC/A_baumannii_align3"
FASTQ_R1="SRR25305574_1.fastq.gz"
FASTQ_R2="SRR25305574_2.fastq.gz"
REF="A_baumannii_ATCC_17978.fasta"
GFF="A_baumannii_ATCC_17978.gff"
THREADS=2
SAMPLE="SRR25305574"

# -----------------------------
# Move to working directory
# -----------------------------
cd "$WORKDIR"
echo "Working directory: $(pwd)"

# -----------------------------
# Inspect FASTQ files
# -----------------------------
echo "Inspecting paired-end FASTQ files..."
zcat "$FASTQ_R1" | head -20
zcat "$FASTQ_R2" | head -20

# -----------------------------
# Quality Control
# -----------------------------
echo "Running FastQC..."
fastqc "$FASTQ_R1" "$FASTQ_R2"

# -----------------------------
# Alignment (paired-end)
# -----------------------------
echo "Aligning reads to reference genome..."
bwa mem -t "$THREADS" "$REF" \
  "$FASTQ_R1" "$FASTQ_R2" > "${SAMPLE}.sam"

# -----------------------------
# Convert SAM → BAM
# -----------------------------
echo "Converting SAM to BAM..."
samtools view -bS -T "$REF" "${SAMPLE}.sam" > "${SAMPLE}.bam"

# -----------------------------
# Sort and index BAM
# -----------------------------
echo "Sorting BAM..."
samtools sort "${SAMPLE}.bam" -o "${SAMPLE}_sorted.bam"

echo "Indexing BAM..."
samtools index "${SAMPLE}_sorted.bam"

# -----------------------------
# Mapping statistics
# -----------------------------
echo "Generating mapping statistics..."
samtools flagstat "${SAMPLE}_sorted.bam" > "${SAMPLE}_mappingstats.txt"
head -20 "${SAMPLE}_mappingstats.txt"

# -----------------------------
# Alignment quality control
# -----------------------------
echo "Running Qualimap..."
qualimap bamqc \
  -bam "${SAMPLE}_sorted.bam" \
  -gff "$GFF" \
  -outdir bamqc

# -----------------------------
# Variant calling (haploid genome)
# -----------------------------
echo "Calling variants with FreeBayes..."
freebayes \
  -f "$REF" \
  -p 1 \
  "${SAMPLE}_sorted.bam" > "${SAMPLE}.vcf"

# -----------------------------
# Compress and index VCF
# -----------------------------
echo "Compressing and indexing VCF..."
bgzip -c "${SAMPLE}.vcf" > "${SAMPLE}.vcf.gz"
bcftools index -t "${SAMPLE}.vcf.gz"

echo "Pipeline completed successfully ✅"
