#' @title Count data and save the result
#' 
#' @param SRRs The bam file names (without .bam).
#' @param Mode,Inter.feature,Ignore.strand Default settings are "Union",FALSE, and FALSE resectively; see \code{\link{summarizeOverlaps}} for more information.
#' @param reference_annotation A \code{\link{Granges}} object.
#' @examples 
#' 
#' Count_SRRs(SRR_RUN_human_SE,"./",Annotation_gr,F,"Example_human_SE")
#' 
#' @seealso \code{\link{Rsamtools_view}}
#' 
#' @import GenomicAlignments
#' @import Rsamtools
#' @import BiocParallel
#' @export


Count_SRRs <- function(SRRs,bam_dir = "./",reference_annotation,save_title,paired = F,Mode = "Union",Ignore.strand = F,Inter.feature = F) {
  
  register(SerialParam())
  
  bam.list = BamFileList(file = paste0(gsub("\\/$","",bam_dir),"/",SRRs,".bam"),
                         asMates=paired)
  
  print("Bam files checked.")
  
  print("Counting...")
  
  se <- summarizeOverlaps(reference_annotation,
                          bam.list,
                          mode = Mode,
                          Inter.feature = FALSE,
                          singleEnd =!paired,
                          ignore.strand = Ignore.strand,
                          fragments = paired)
  
  print(paste0("Count finished for ", save_title, "."))
  
  saveRDS(se,paste0(save_title,".rds"))
}