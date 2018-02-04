#' @title Check the hisat2 reports under the curent working directory.
#' 
#' @param result_tail define what the tail of the hisat2 output is, default is "_hisat2.out".
#' @param Format whether format the returned output into a \code{data.frame}, default is TRUE.
#' 
#' @examples
#' Check_hisat2_reports()
#' 
#' @export
#' 
Check_hisat2_reports <- function(result_tail="_hisat2.out",Format = T){
  Hisat2_Output_filenames <- grep(paste0(result_tail,"$"),list.files(),value = T)
  lst_result <- lapply(Hisat2_Output_filenames,readLines)
  SRR_names = gsub(paste0(result_tail,"$"),"" ,Hisat2_Output_filenames )
  names(lst_result) = SRR_names
  if(!Format) {
    return( lst_result )
    }else{
      lst_result_df = lapply( lst_result, function(x) data.frame(Total_Reads = gsub(" .*$","",x[1]),
                                                              Unpaired_Reads = paste0( gsub(").*$","",x[2]),")"),
                                                              No_alignment = paste0( gsub(").*$","",x[3]),")"),
                                                              Uniquely_alignment = paste0( gsub(").*$","",x[4]),")"),
                                                              Multiple_alignment = paste0( gsub(").*$","",x[5]),")"),
                                                              Mapping_efficiency =  gsub(" .*$","",x[6])) 
                           )
      df_result = Reduce(rbind,lst_result_df)
      df_result$Sample_ID = names(lst_result)
    return(df_result[,c(7,1:6)])
  }
}