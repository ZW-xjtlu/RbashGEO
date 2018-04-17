#' @title submit bash commands by user defined number of chunks 
#' @param Commands the vector of commands we want to submit (do not need to include nohup portion).
#' @param Chunk  number of parallel processes.
#' @param Name the names of the script and output files.
#' 
#' @examples
#' 
#' file_names <- grep(".fq$", list.files("/home/zhen/PAR-CLIP/Trim"), value = T)
#' commands <- paste0("fastq_to_fasta -i ",file_names," -o ", gsub("fq","fa",file_names),"{\}n",
#'                   "fastx_collapser -i ",gsub("fq","fa",file_names)," -o ", gsub("trimmed.fq","collapsed.fa",file_names))
#' Chunk_submit(commands,6,"collapse")
#' 
#' @export
Chunk_submit <- function(Commands,Chunk = 6,Name) {
  
  mapply(function(x,y)write(x,y),
         split(Commands,
               cut(1:length(Commands),Chunk)),
         paste0(Name,"_",1:Chunk,".sh"))
  
  system("chmod +x *.sh")
  
  commands_submit <- paste0("nohup ./",paste0(Name, "_",1:Chunk,".sh")," > ",paste0(Name, "_",1:Chunk,".out")," &")
  
  sapply(commands_submit,system)
  
}