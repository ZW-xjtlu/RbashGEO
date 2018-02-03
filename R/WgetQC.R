#' @title Retrive data from GEO, and run a fastqc
#' 
#' @examples
#' library(RbashGEO)
#' library(dplyr)
#' Coldata_new <- read.csv("./Coldata_new.csv") #See attached collumn data example in Coldata_example
#' 
#' mapply(
#'   function(x,y){
#'     Rhisat2(Fastq_file_name = x,
#'             Paired = y,
#'             parallel_num = 1,
#'             Fastq_directory = getwd()) %>% Rnohup(.,paste0(x,"_hisat2"))}, 
#'   Coldata_new$SRR_RUN,
#'   (Coldata_new$Lib == "Paired")
#' )
#' 
#' @seealso \code{\link{Rhisat2}}, \code{\link{Rtrim_galore}} ,and \code{\link{Coldata_example}}
#' 
#' @export

WgetQC <-
function (GEO_accession = "SRR1234567", Paired = F) 
{
  
  URL = paste("ftp://ftp-trace.ncbi.nih.gov/sra/sra-instant/reads/ByRun/sra/SRR", 
                    substr(GEO_accession, 1, 6), 
                           GEO_accession, paste0(GEO_accession,".sra"), sep = "/")
  
  Wget_command = paste("wget -c -t 0", URL)
  
  fastq_dump_command = paste0("fastq-dump ", ifelse(Paired, 
                                                    "--split-3 ", ""), GEO_accession, ".sra")
  
  if (Paired) {
    fastqc_command = paste0("fastqc ", GEO_accession, "_1.fastq", 
                            ";", "fastqc ", GEO_accession, "_2.fastq")
  }
  
  else {
    fastqc_command = paste0("fastqc ", GEO_accession, ".fastq")
  }
  
  rm_command = paste0("rm ", GEO_accession, ".sra")
  
  paste(Wget_command, fastq_dump_command, rm_command, fastqc_command, sep = ";")
  
}
