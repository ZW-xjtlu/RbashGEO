RbashGEO
================

### The purpose of the package RbashGEO

-   Help users to populate the RNA-Seq raw data processing commands in bash with little code.

-   Users only need to provide a **collumn data**, that means a table recording the design and names of the fastq files; The sample ids could be the **RUN IDs** from [**GEO**](https://www.ncbi.nlm.nih.gov/geo/).

### Install it with the command below

``` r
devtools::install_github("ZhenWei10/RbashGEO")
```

-   The functions of this package can help users to:

1.  Download and decompress raw fastq data automatically from NCBI.
2.  QC, trim, and align the fastq files with popular RNA-Seq command line tools.
3.  Count the alignment results with a user provided annotation by `GRanges` in R, the count is conducted by `SummarizeOverlap` function in `GenomicAlignment` package, which is transplanted from the [**HTSeq-count**](http://htseq.readthedocs.io/en/release_0.9.1/) in python.

### A standardized work flow

-   First, we need to prepare a **collumn data** like the example below.

``` r
library(RbashGEO)
```

    ## Warning: replacing previous import 'GenomicAlignments::first' by
    ## 'dplyr::first' when loading 'RbashGEO'

    ## Warning: replacing previous import 'GenomicAlignments::last' by
    ## 'dplyr::last' when loading 'RbashGEO'

``` r
knitr::kable( Coldata_example[1:6,1:6] )
```

| SRR\_RUN   | IP\_input | Experiment     | Perturbation | Interest | Lib    |
|:-----------|:----------|:---------------|:-------------|:---------|:-------|
| SRR5417009 | IP        | human-NB4      | C            | METTL14  | Single |
| SRR5417010 | IP        | human-MonoMac6 | C            | METTL14  | Single |
| SRR5417011 | IP        | human-NB4      | C            | METTL14  | Single |
| SRR5417012 | IP        | human-NB4      | METTL14-     | METTL14  | Single |
| SRR5417013 | IP        | human-NB4      | METTL14-     | METTL14  | Single |
| SRR5417014 | IP        | human-MonoMac6 | C            | METTL14  | Single |

Only 2 collumns: `SRR_RUN` and `Lib` are essential for the complete application of this package, other information is valuable for their own good.

The design of this table is summarized from [this page](https://www.ncbi.nlm.nih.gov/Traces/study/?acc=SRP103072) on GEO.

-   Then, we should download them from GEO and run fastqc for quality control:

``` r
library(RbashGEO)
mapply(function(x,y) Rnohup(WgetQC(x,y),x), Coldata_example$SRR_RUN,Coldata_example$Lib == "Paired")
```

<hr/>
-   Next, we should align them with hisat2 (you should first check the fastqc reports, if they are not OK, you should use `Rtrim_galore` before alignment):

``` r
library(RbashGEO)
library(dplyr)

mapply(
 function(x,y){
   Rhisat2(Fastq_file_name = x,
           Paired = y,
           parallel_num = 1,
           Fastq_directory = getwd()) %>% Rnohup(.,paste0(x,"_hisat2"))}, 
 Coldata_example$SRR_RUN,
 (Coldata_example$Lib == "Paired")
)
```

<hr/>
-   Check the alignment result in R all together with this command.

``` r
RbashGEO::Check_hisat2_reports()
```

You should see something like below.

> RbashGEO::Check\_hisat2\_reports()
> $SRR5417009
> \[1\] "34270423 reads; of these:" 
> \[2\] " 34270423 (100.00%) were unpaired; of these:"
> \[3\] " 1494778 (4.36%) aligned 0 times" 
> \[4\] " 18096777 (52.81%) aligned exactly 1 time"
> \[5\] " 14678868 (42.83%) aligned &gt;1 times" 
> \[6\] "95.64% overall alignment rate" 
> ...

<hr/>
-   Then, convert the sam into bam with some desired filters on [SAM flags](https://broadinstitute.github.io/picard/explain-flags.html).

``` r
library(RbashGEO)

sapply(
  Coldata_example$SRR_RUN,
  function(x) Rnohup(
  Rsamtools_view(x,sam_end = ".sam",parallel_num = 1,flag_filter = 2820),
  x)
)
```

<hr/>
-   Finally, count them and obtain the resulting `SummarizedExperiment` object.

At this step, we need to provide a `GRanges` object for annotation, in this case we use `Annotation_gr` as an example.

``` r
Count_SRRs(Coldata_example$SRR_RUN,"./",Annotation_gr,"Example_human_SE")
```

<hr/>
At last, the obtained `SummarizedExperiment` object could be easily analyzed with other QC, inference, and learning work flows. If you are interested in MeRIP data, you could use [meripQC](https://github.com/ZhenWei10/meripQC); if you are interested in the analysis of the RNA modification data, you could look [m6ALogisticModel](https://github.com/ZhenWei10/m6ALogisticModel) for more information.

``` r
sessionInfo()
```

    ## R version 3.4.2 (2017-09-28)
    ## Platform: x86_64-apple-darwin15.6.0 (64-bit)
    ## Running under: macOS Sierra 10.12.6
    ## 
    ## Matrix products: default
    ## BLAS: /Library/Frameworks/R.framework/Versions/3.4/Resources/lib/libRblas.0.dylib
    ## LAPACK: /Library/Frameworks/R.framework/Versions/3.4/Resources/lib/libRlapack.dylib
    ## 
    ## locale:
    ## [1] zh_CN.UTF-8/zh_CN.UTF-8/zh_CN.UTF-8/C/zh_CN.UTF-8/zh_CN.UTF-8
    ## 
    ## attached base packages:
    ## [1] stats     graphics  grDevices utils     datasets  methods   base     
    ## 
    ## other attached packages:
    ## [1] RbashGEO_1.0
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] Rcpp_0.12.14               highr_0.6                 
    ##  [3] pillar_1.0.1               bindr_0.1                 
    ##  [5] compiler_3.4.2             GenomeInfoDb_1.14.0       
    ##  [7] XVector_0.18.0             bitops_1.0-6              
    ##  [9] tools_3.4.2                zlibbioc_1.24.0           
    ## [11] digest_0.6.13              tibble_1.4.1              
    ## [13] evaluate_0.10.1            lattice_0.20-35           
    ## [15] pkgconfig_2.0.1            rlang_0.1.6               
    ## [17] Matrix_1.2-12              DelayedArray_0.4.1        
    ## [19] yaml_2.1.16                parallel_3.4.2            
    ## [21] bindrcpp_0.2               GenomeInfoDbData_1.0.0    
    ## [23] stringr_1.2.0              dplyr_0.7.4               
    ## [25] knitr_1.18                 Biostrings_2.46.0         
    ## [27] S4Vectors_0.16.0           IRanges_2.12.0            
    ## [29] stats4_3.4.2               rprojroot_1.3-2           
    ## [31] grid_3.4.2                 glue_1.2.0                
    ## [33] Biobase_2.38.0             R6_2.2.2                  
    ## [35] BiocParallel_1.12.0        rmarkdown_1.8             
    ## [37] magrittr_1.5               backports_1.1.2           
    ## [39] Rsamtools_1.30.0           htmltools_0.3.6           
    ## [41] matrixStats_0.52.2         GenomicAlignments_1.14.1  
    ## [43] BiocGenerics_0.24.0        GenomicRanges_1.30.1      
    ## [45] assertthat_0.2.0           SummarizedExperiment_1.8.1
    ## [47] stringi_1.1.6              RCurl_1.95-4.10
