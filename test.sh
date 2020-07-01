awk -v OFS="\t" '{ if ($3 == "gene") print $1, $4 - 1, $5}' gencode.v34.annotation.gtf > all_genes.bed
open all_genes.bed
cat gencode.v34.annotation.gtf | grep "protein_coding" > protein_coding.gtf
awk -v OFS="\t" '{ if ($3 == "gene") print $1, $4 - 1, $5}' protein_coding.gtf > protein_coding_genes.bed
open protein_coding_genes.bed
bedtools makewindows -b protein_coding_genes.bed -w 200 -s 100 > protein_coding_gene_windows.bed
sort -k 1,1 -k2,2n protein_coding_gene_windows.bed > pro_cod_gene_windows_sorted.bed
bedtools merge -i pro_cod_gene_windows_sorted.bed | head
cat protein_coding_genes.bed | head
