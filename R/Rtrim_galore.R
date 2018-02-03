#' @title generate a command for trim_galore in R
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
#'         Fastq_directory = "/home/zhen/TREW_new_data") %>% Rnohup(.,paste0(x$output_name,"_trim") )
#' }
#' 
#' 
#' @export
#' 

Rtrim_galore <-
  function(GEO_accession = "SRR1234567", 
            fastq_end = ".fastq",
            Paired = F, 
            Phred_cut = 20, 
            Phred = 33, 
            fastqc = T, 
            CLIP_5 = c(0,0),
            CLIP_3 = c(0,0)) { 
    
   if (length(CLIP_5) == 1) CLIP_5 = c(CLIP_5,CLIP_5)
   if (length(CLIP_3) == 1) CLIP_3 = c(CLIP_3,CLIP_3)
   
   if(Paired == F){
   Paired_dependent_chunk <- paste0("--clip_R1 ",CLIP_5[1]," --three_prime_clip_R1 ",CLIP_3[1]," ", GEO_accession,fastq_end)
   }else{
   Paired_dependent_chunk <- paste0("--clip_R1 ",CLIP_5[1],
                                    " --clip_R2 ",CLIP_5[2],
                                    " --three_prime_clip_R1 ",CLIP_3[1],
                                    " --three_prime_clip_R2 ",CLIP_3[2],
                                    " ", GEO_accession,"_1",fastq_end,
                                    " ", GEO_accession,"_2",fastq_end)
   }
    
   paste0("trim_galore ","--quality ",Phred_cut," --phred",Phred,ifelse(fastqc," --fastqc "," "),Paired_dependent_chunk)

}