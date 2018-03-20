#' @title A highly compact but easy to use function to count based on the single based RNA modification GRanges
#' 
#' @param Coldata a data.frame with 2 collumns neccessarily well defined:
#' 
#' 1. a collumn named "SRR_RUN". The entries should be character sting consistant with the name of the bam files (before ".bam").
#' 
#' 2. a collumn named "Lib". The entries should be either "Single" or "Paired"
#' 
#' @return a \code{\link{SummarizedExperiment}} object saved under current working directory with well defined colData and rowRanges.
#' 
#' @details Under this version, the function is designed to support the count over many (>100) fastq files with both single and paired end data.
#' If you have only single or paired end data, please use \code{\link{Count_SRRs}}.
#' 
#' @param BAM_dir the directory of your bam files, the function expect all bam files named by "SRR_RUN.bam".
#' @param Annot_gr the single based resolution row GRanges used for count.
#' @param title the title of the file saved.
#' @param bin_zize the width of the bin used for count, default is 100.
#' @examples 
#' 
#' library(RbashGEO)
#' Annot_GR <- GenomicRanges::reduce( readRDS("hg19_union_gr.rds") ,min.gapwidth=0L)
#' Coldata_df <- read.csv("ColDesign_Meth.csv")
#' Count_from_coldata(Coldata_df,Annot_GR,"/home/zhen/bam_Metdb","hg19_union_metdb")
#' 
#' @seealso \code{\link{Count_SRRs}} is good for count under other contexts.
#' 
#' @import GenomicRanges
#' @import SummarizedExperiment
#' @export

Count_from_coldata <- function(Coldata,
                               Annot_gr,
                               BAM_dir,
                               title = "test",
                               bin_size = 100){
  Annot_gr <- resize( Annot_gr, bin_size, fix = "center")
  SRR_RUN <- Coldata$SRR_RUN
  if(sum(!paste0(SRR_RUN,".bam") %in% grep(".bam", list.files(BAM_dir) , value = T)) > 0) {stop("Incomplete bam files, please check again.")}
  SRR_RUN_SE <- as.character( SRR_RUN )[Coldata_df$Lib == "Single"]
  SRR_RUN_PE <- as.character( SRR_RUN )[Coldata_df$Lib == "Paired"]
  Count_SRRs(SRR_RUN_SE,BAM_dir,Annot_gr,paste0(title,"_SE"),F)
  Count_SRRs(SRR_RUN_PE,BAM_dir,Annot_gr,paste0(title,"_PE"),T)
  sumexp_PE <- readRDS(paste0(title,"_PE.rds"))
  sumexp_SE <- readRDS(paste0(title,"_SE.rds"))
  sumexp_combined <- cbind(sumexp_PE,sumexp_SE)
  rowRanges(sumexp_combined) = resize( rowRanges(sumexp_combined), 1, fix = "center" )
  sumexp_combined  = sumexp_combined[,paste0( ColData$SRR_RUN, ".bam")]
  colData(sumexp_combined) <- DataFrame( ColData )
  saveRDS(sumexp_combined,paste0(title,".rds"))
}