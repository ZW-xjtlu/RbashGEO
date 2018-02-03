#' @title submit a bash commands into the qsub...
#' @examples
#' arg_df <- data.frame(
#' Fastq_file_name = rep("SRR1744126",3), 
#' trim_5 = c(16,16,0),
#' trim_3 = c(12,0,12),
#' output_name = paste0("SRR1744126_",1:3)
#' )
#' 
#' for(i in 1:nrow(arg_df)) {
#' x = arg_df[i,]
#' Rhisat2(Fastq_file_name = x$Fastq_file_name,
#'         trim_5 = x$trim_5,
#'         trim_3 = x$trim_3,
#'         output_name = x$output_name,
#'         Fastq_directory = "/home/zhen/TREW_new_data") %>% Rnohup(.,paste0(x$output_name,"_hisat2") )
#' }
#' 
#' 
#' @export
Rnohup <-
function(command,output = "X") {
  write(command,paste0(output,".sh"))
  system(paste0("chmod +x ./", paste0(output,".sh")))
  system(paste0("nohup ./",paste0(output,".sh"), ifelse(is.null(output),"",paste0(" > ",output,".out"))," &"))
}
