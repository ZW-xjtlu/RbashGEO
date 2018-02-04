RbashGEO
================

### The purpose of the package RbashGEO

-   Help users to populate the RNA-Seq raw data processing commands in bash with little code, i.e. it can make you life easier if you frequently dowload and align RNA-Seq data from [**GEO**](https://www.ncbi.nlm.nih.gov/geo/).

-   Users only need to provide a **collumn data**, that means a table recording the design and names of the fastq files; The sample ids could directly be the **RUN IDs** from GEO.

### Install it with the command below

``` r
devtools::install_github("ZhenWei10/RbashGEO")
```

-   The functions of this package can help users to:

1.  Download and decompress many raw fastq data from GEO easily.
2.  QC, trim, and align the fastq files with popular RNA-Seq command line tools, but with well organized output in R.
3.  Count the alignment results with a user provided annotation by `GRanges` in R, the count is conducted by `SummarizeOverlap` function in `GenomicAlignment` package, which is transplanted from the [**HTSeq-count**](http://htseq.readthedocs.io/en/release_0.9.1/) in python.
4.  The most significant utility of this package is to reduce the repetitive bash coding and in the mean time generate compact results for downstream analysis.

### A template work flow for RNA-Seq

-   First, we need to prepare a **collumn data**, such as the example below.

``` r
library(RbashGEO)
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

Only 2 collumns: `SRR_RUN` and `Lib` are neccessary to complete the work flow of this package, but addition collumns are valuable for their own good.

The design of the collumn table is summarized from [this page](https://www.ncbi.nlm.nih.gov/Traces/study/?acc=SRP103072) on GEO.

-   Then, we should download them from GEO and run fastqc for quality control:

``` r
library(RbashGEO)
mapply(function(x,y) Rnohup(WgetQC(x,y),x), Coldata_example$SRR_RUN,Coldata_example$Lib == "Paired")
```

-   Next, we should align them with [**hisat2**](https://ccb.jhu.edu/software/hisat2/index.shtml) (you should first check the fastqc reports, if they are not OK, you should use `Rtrim_galore` before alignment.):

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

-   Check the organized alignment reports in R all together with this command.

``` r
hisat2_report <- RbashGEO::Check_hisat2_reports()
knitr::kable(hisat2_report[1:6,-1*c(2,3,4)])
```

| Sample\_ID | Uniquely\_alignment | Multiple\_alignment | Mapping\_efficiency |
|:-----------|:--------------------|:--------------------|:--------------------|
| SRR5417009 | 18096777 (52.81%)   | 14678868 (42.83%)   | 95.64%              |
| SRR5417010 | 11359024 (44.98%)   | 12732204 (50.42%)   | 95.40%              |
| SRR5417011 | 13108383 (58.39%)   | 6646745 (29.61%)    | 87.99%              |
| SRR5417012 | 10650346 (45.12%)   | 5640761 (23.90%)    | 69.02%              |
| SRR5417013 | 7925819 (36.53%)    | 4123070 (19.00%)    | 55.53%              |
| SRR5417014 | 11652714 (47.75%)   | 7618818 (31.22%)    | 78.97%              |

You should see a `data.frame` with summarized outputs of hisat2.

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

-   Finally, count the reads. The reads count are stored with `SummarizedExperiment` object in R.

At this step, we need to provide a `GRanges` object for annotation, in this case we use `Annotation_gr` as an example.

``` r
Count_SRRs(Coldata_example$SRR_RUN,"./",Annotation_gr,"Example_human_SE")
```

At last, the obtained `SummarizedExperiment` object could be conveniently handeled with other QC, inference, and learning work flows.

If you are interested in MeRIP data, you could use [meripQC](https://github.com/ZhenWei10/meripQC);

if you are interested in the analysis of the RNA modification data, you could look [m6ALogisticModel](https://github.com/ZhenWei10/m6ALogisticModel) for more information.

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
    ##  [1] Rcpp_0.12.14               XVector_0.18.0            
    ##  [3] knitr_1.18                 magrittr_1.5              
    ##  [5] zlibbioc_1.24.0            GenomicRanges_1.30.1      
    ##  [7] BiocGenerics_0.24.0        GenomicAlignments_1.14.1  
    ##  [9] IRanges_2.12.0             BiocParallel_1.12.0       
    ## [11] lattice_0.20-35            highr_0.6                 
    ## [13] stringr_1.2.0              GenomeInfoDb_1.14.0       
    ## [15] tools_3.4.2                grid_3.4.2                
    ## [17] SummarizedExperiment_1.8.1 parallel_3.4.2            
    ## [19] Biobase_2.38.0             matrixStats_0.52.2        
    ## [21] htmltools_0.3.6            yaml_2.1.16               
    ## [23] rprojroot_1.3-2            digest_0.6.13             
    ## [25] Matrix_1.2-12              GenomeInfoDbData_1.0.0    
    ## [27] S4Vectors_0.16.0           bitops_1.0-6              
    ## [29] RCurl_1.95-4.10            evaluate_0.10.1           
    ## [31] rmarkdown_1.8              DelayedArray_0.4.1        
    ## [33] stringi_1.1.6              compiler_3.4.2            
    ## [35] Rsamtools_1.30.0           Biostrings_2.46.0         
    ## [37] backports_1.1.2            stats4_3.4.2
