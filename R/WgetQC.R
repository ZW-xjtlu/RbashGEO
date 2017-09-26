#' @title Retrive data from GEO, and run a fastqc
#' 
#' @examples
#' sapply(paste0("SRR",3066062:3066069),function(x) nohup_R(WgetQC(x),x))
#' 
#' @export

WgetQC <-
function (GEO_accession = "SRR1234567", Paired = F) 
{
  URL = paste("ftp://ftp-trace.ncbi.nih.gov/sra/sra-instant/reads/ByRun/sra/SRR", 
              substr(GEO_accession, 1, 6), GEO_accession, paste0(GEO_accession, 
                                                                 ".sra"), sep = "/")
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
