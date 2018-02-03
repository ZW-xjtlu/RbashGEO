#Package meta
Coldata_example <- read.csv("/Users/zhenwei/Documents/GitHub/TREW-cons/Newdatas/N1_2018_2_2_NewM14/Coldata_M14new.csv")
devtools::use_data(Coldata_example,overwrite = T)

Annotation_gr <- readRDS("/Users/zhenwei/Documents/GitHub/TREW-cons/L_Recount_SBsites_2018_2_1/Intersect.rds")

devtools::use_data(Annotation_gr)