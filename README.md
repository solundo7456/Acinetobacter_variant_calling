# Whole Genome Sequencing Analysis of *Acinetobacter baumannii*

This repository contains a complete **paired-end whole genome sequencing (WGS) analysis pipeline** for *Acinetobacter baumannii* using Illumina sequencing data downloaded from the **European Nucleotide Archive (ENA)**.

---

## 📌 Project Overview

- **Organism:** *Acinetobacter baumannii* ATCC 17978  
- **Sequencing platform:** Illumina  
- **Read type:** Paired-end  
- **ENA accession:** SRR25305574  
- **Genome type:** Haploid bacterial genome  

The pipeline processes raw FASTQ files through:
1. Quality control  
2. Genome alignment  
3. BAM processing and statistics  
4. Alignment quality assessment  
5. Variant calling  

---

## 🧬 Data Source

Sequencing data were downloaded from **ENA**:

- `SRR25305574_1.fastq.gz` (forward reads)
- `SRR25305574_2.fastq.gz` (reverse reads)

Reference genome:
- *A. baumannii* ATCC 17978 (chromosome)
- FASTA and GFF annotation files

---

## 🛠️ Tools Used

| Tool        | Purpose |
|------------|--------|
| FastQC     | Read quality control |
| BWA-MEM   | Paired-end read alignment |
| SAMtools  | SAM/BAM processing |
| Qualimap  | Alignment quality assessment |
| FreeBayes | Variant calling (haploid) |
| bcftools  | VCF indexing |
| IGV       | Genome visualization |

---

## 📁 Project Structure

```text
A_baumannii_WGS/
├── data/
│   ├── SRR25305574_1.fastq.gz
│   └── SRR25305574_2.fastq.gz
├── reference/
│   ├── A_baumannii_ATCC_17978.fasta
│   └── A_baumannii_ATCC_17978.gff
├── scripts/
│   └── wgs_pipeline.sh
├── results/
│   ├── bamqc/
│   ├── *.bam
│   ├── *.vcf.gz
├── README.md

