#' @title Check the hisat2 reports under the curent working directory.
#' 
#' @examples
#' Check_hisat2_reports()
#' 
#' @export
#' 
Check_hisat2_reports <- function(result_tail="_hisat2.out"){
  Hisat2_Output_filenames <- grep(paste0(result_tail,"$"),list.files(),value = T)
  lst_result <- lapply(Hisat2_Output_filenames,readLines)
  SRR_names = gsub(paste0(result_tail,"$"),"" ,Hisat2_Output_filenames )
  names(lst_result) = SRR_names
  lst_result
}