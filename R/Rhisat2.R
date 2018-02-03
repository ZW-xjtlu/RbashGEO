#'@title Generate hisat2 command in R
#'
#'@examples
#'library(RbashGEO)
#'library(dplyr)
#'Coldata_new <- read.csv("./Coldata_M14new.csv")
#'
#'mapply(
#'  function(x,y){
#'    Rhisat2(Fastq_file_name = x,
#'            Paired = y,
#'            parallel_num = 1,
#'            Fastq_directory = getwd()) %>% Rnohup(.,paste0(x,"_hisat2"))}, 
#'  Coldata_new$SRR_RUN,
#'  (Coldata_new$Lib == "Paired")
#')
#'
#'@seealso \code{\link{Check_hisat2_reports}}
#'
#'
#'@export
#'

Rhisat2 <- function (Fastq_file_name = "SRR1234567",
                     indx_directory = "/home/zhen/hisat2_idx/hg19/genome",
                     Fastq_directory = ".", 
                     Paired = F, 
                     trim_5 = NULL, 
                     trim_3 = NULL, 
                     parallel_num = 8,
                     Fastq_file_end = ".fastq",
                     output_name = Fastq_file_name,
                     tune_Mismatch_MX = NULL,
                     tune_Mismatch_MN = NULL) 
{
  Fastq_directory = gsub("/$","",Fastq_directory)
  if (Paired) {
    input_argument = paste0( " -1 ",Fastq_directory,"/",Fastq_file_name,"_1",Fastq_file_end," -2 ",Fastq_directory,"/",Fastq_file_name,"_2",Fastq_file_end)
  }
  else {
    input_argument = paste0( " -U ",Fastq_directory,"/",Fastq_file_name,Fastq_file_end)
  }
  
  trim_argument = ifelse(is.null(trim_5),"",paste0(" -5 ",trim_5," -3 ",trim_3))
  
  mismatch_argument = ifelse(is.null(tune_Mismatch_MX),"",paste0(" --mp ",tune_Mismatch_MX,",",tune_Mismatch_MN))
  
  output_argument = paste0(" -S ",output_name,".sam")
  
  paste0("hisat2 -p ",parallel_num, trim_argument, mismatch_argument," --no-unal -x ",indx_directory,input_argument,output_argument)
}
