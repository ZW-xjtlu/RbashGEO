#' @title Count data and save the result
#' 
#' @param SRRs The bam file names (without .bam).
#' @param Mode,Inter.feature,Ignore.strand Default settings are "Union",FALSE, and TRUE resectively; see \code{\link{summarizeOverlaps}} for more information.
#' 
#' Generally, set Ignore.strand = TRUE if you are not using strand specific library (other wise you usually lose half of your data).
#' 
#' Set Inter.feature = T if you want to deal with overlapping features.
#' 
#' @param reference_annotation A \code{\link{Granges}} object.
#' @examples 
#' 
#' Count_SRRs(SRR_RUN_human_SE,"./",Annotation_gr,F,"Example_human_SE")
#' 
#' 
#' ###An example to handel a long list of bam files with either single end or paired end sequencing library
#' 
#' library(RbashGEO)
#'
#' Annot_GR <- GenomicRanges::reduce( readRDS("SVM_RMBase.rds") ,min.gapwidth=0L) 
#' Coldata_df <- read.csv("Coldata_target_human.csv")


#' Count_seperately <- function(SRR_RUN,BAM_dir,Annot_gr,title){
#'  if(sum(!paste0(SRR_RUN,".bam") %in% grep(".bam", list.files(BAM_dir) , value = T)) > 0) {stop("Incomplete bam files, please check again.")}
#'  SRR_RUN_SE <- as.character( SRR_RUN )[Coldata_df$Lib == "Single"]
#'  SRR_RUN_PE <- as.character( SRR_RUN )[Coldata_df$Lib == "Paired"]
#' Count_SRRs(SRR_RUN_SE,BAM_dir,Annot_gr,paste0(title,"_SE"),F)
#'  Count_SRRs(SRR_RUN_PE,BAM_dir,Annot_gr,paste0(title,"_PE"),T)
#'}
#'Count_seperately(Coldata_df$SRR_RUN,"/home/zhen/TREW_cons_bams",Annot_GR,"SVM_RMBase")
#' 
#' 
#' @seealso \code{\link{Rsamtools_view}}
#' 
#' @import GenomicAlignments
#' @import Rsamtools
#' @import BiocParallel
#' @export

Count_SRRs <- function(SRRs,bam_dir = "./",reference_annotation,save_title,paired = F,Mode = "Union",Ignore.strand = T,Inter.feature = F) {
  
  register(SerialParam())
  
  bam.list = BamFileList(file = paste0(gsub("\\/$","",bam_dir),"/",SRRs,".bam"),
                         asMates=paired)
  
  print("Bam files checked.")
  
  print("Counting...")
  
  se <- summarizeOverlaps(reference_annotation,
                          bam.list,
                          mode = Mode,
                          inter.feature = Inter.feature,
                          singleEnd =!paired,
                          ignore.strand = Ignore.strand,
                          fragments = paired)
  
  print(paste0("Count finished for ", save_title, "."))
  
  saveRDS(se,paste0(save_title,".rds"))
}