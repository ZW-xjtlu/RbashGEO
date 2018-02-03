RbashGEO
================

### The purpose of the package RbashGEO

-   Help users to populate the NGS raw data processing command in bash with little code.

-   Users only need to provide a `collumn data`, that means a table record the design and name of the fastq data, they could be the `SRR RUN` ids on GEO.

-   The functions of this package can help users to:

1.  Download and decompress raw fastq data from NCBI.
2.  QC, trim, and align the fastq files with popular RNA-Seq command line tools.
3.  Count the alignment results with a user provided annotation by `GRanges` in R, the count is conducted by `SummarizeOverlap` function in `GenomicAlignment` package, which is transplanted from the **HTSeq-count** in python.
