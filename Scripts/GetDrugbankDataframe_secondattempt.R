load(paste(dir,"Databases/drugbank_xml_data.R",sep=""))
temp1 <- unlist(drugbank_xml_data)
temp1_substring <- substr(temp1, 0, 5000)
# temp1_list <- as.list(temp1_substring)
temp1_split <- strsplit(temp1_substring, "\n\"")

df <- data.frame(matrix(unlist(temp1_split), nrow=61, byrow=T))
