# Transcriptome-Assembly-Statistics
Some scripts providing assembly statistics

# i) DescriptionAssemblage.R
requirement: R and "optparse" R library (see : https://cran.r-project.org/web/packages/optparse/index.html)

from a tabular with names and contig's length, it produces a tab-separated tabular with some statistics :
exemples:
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
