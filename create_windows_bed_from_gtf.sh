#!/bin/bash


# if the whole-genome, all-genes GTF file is not present, then download and decompress it
if [[ ! -f "gencode.v34.annotation.gtf" ]]; then
    echo "Downloading whole-genome GTF..."
    wget ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_34/gencode.v34.annotation.gtf.gz
    echo "Unzipping GTF..."
    gunzip gencode.v34.annotation.gtf.gz
fi

# create bed file of all genes' start and end coordinates
awk -v OFS="\t" '{ if ($3 == "gene") print $1, $4 - 1, $5}' gencode.v34.annotation.gtf > all_genes.bed
# Note: this open command might not work if you run this code on a cluster or not your computer
open all_genes.bed

# filter the whole-gencome, all-genes GTF and keep only the genes that are protein-coding
echo "Filtering for protein-coding genes..."
cat gencode.v34.annotation.gtf | grep "protein_coding" > protein_coding.gtf
# create bed file of all protein-coding genes' start and end coordinates
awk -v OFS="\t" '{ if ($3 == "gene") print $1, $4 - 1, $5}' protein_coding.gtf > protein_coding_genes.bed
open protein_coding_genes.bed

# create bed file of 200bp windows spanning protein-coding genes, 100bp apart
echo "Creating windows file..."
bedtools makewindows -b protein_coding_genes.bed -w 200 -s 100 > protein_coding_gene_windows.bed
echo "Sorting windows file..."
sort -k 1,1 -k2,2n protein_coding_gene_windows.bed > pro_cod_gene_windows_sorted.bed

# check how the all-genes bed file and a merged version of the windows bed file compare
# we expect these to be the same
echo "Output from bedtools merge of pro_cod_gene_windows_sorted.bed:"
bedtools merge -i pro_cod_gene_windows_sorted.bed | head
echo "From protein_coding_genes.bed:"
bedtools merge -i protein_coding_genes.bed | head

echo "Done!"
exit 0  # script ran successfully!
