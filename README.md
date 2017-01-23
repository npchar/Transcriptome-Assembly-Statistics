# Transcriptome-Assembly-Statistics
Some scripts providing assembly statistics

## i) DescriptionAssemblage.R
######requirement: 
This R script requires obviously R, but also the "optparse" library (see : https://cran.r-project.org/web/packages/optparse/index.html). Ask for two arguments, an input file with contig's names and contig's length, and an output filename. It produces a tab-separated tabular.
###### exemples:
```
head -n 3 exemple.fasta.statsize
    TRINITY_DN21478_c0_g1_i1        294
    TRINITY_DN21454_c0_g1_i1        208
    TRINITY_DN21435_c0_g1_i1        221
./DescriptionAssemblage.R exemple.fasta.size exemple.fasta.stat
cat exemple.fasta.stat
    RowNames	res
    Number of contigs	31732
    total size of contigs	17478906
    Shortest contigs	297
    Longest contigs	14652
    Number of contigs > 500	11144
    Number of contigs > 1k	2812
    Number of contig > 10k	3
    mean contig size	551
    median contig size	417
    N50 contig length	558
    ```
