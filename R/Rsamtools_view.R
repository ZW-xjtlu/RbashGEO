#'@title Samtools views in R to filter multiple alignments
#'
#'@examples
#'sam_filenames <- gsub(".sam","",grep(".sam$",list.files(),value = T) )
#'sapply(
#'  sam_filenames,
#'  function(x){
#'    Rsamtools_view(x,flag_filter = 2816) %>% Rnohup(.,paste0(x,"_samfilter") )
#'  }
#')
#
#'@export
#'
#'
Rsamtools_view <- function(sam_name,sam_directory = ".",sam_end = ".sam",parallel_num = 8,flag_filter = 2816) {
  sam_directory = gsub("/$","",sam_directory)
  paste0("samtools view -@ ",parallel_num," -F ",flag_filter," -q 30 -Sb ",sam_directory,"/",sam_name,sam_end," -o ",sam_directory,"/",sam_name,".bam")
}