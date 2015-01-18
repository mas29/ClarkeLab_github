#trash code

# sytoxG_allPlates_temp <- merge(sytoxG_plate1, sytoxG_plate2, by="row.names", suffixes = c(".1", ".2"))
# sytoxG_allPlates_temp1 <- merge(sytoxG_plate3, sytoxG_plate4, by="row.names", suffixes = c(".3", ".4"))
# #add suffix to empties of plate 5 before merge
# names(sytoxG_plate5) <- ifelse(names(sytoxG_plate5) %in% "Empty", str_c(names(sytoxG_plate5), '.5'), names(sytoxG_plate5))
# sytoxG_allPlates_temp2 <- merge(sytoxG_plate5,sytoxG_allPlates_temp1, by="row.names")
# sytoxG_allPlates <- merge(sytoxG_allPlates_temp1, sytoxG_allPlates_temp1, by="row.names")
# 
# 
# sytoxG_allPlates_merge1 <- merge(sytoxG_plate1,sytoxG_plate2,by="row.names")
# sytoxG_allPlates_merge2 <- merge(sytoxG_plate3,sytoxG_plate4,by="row.names")
# sytoxG_allPlates_merge3 <- merge(sytoxG_allPlates_merge1,sytoxG_allPlates_merge2,by="row.names")
# sytoxG_allPlates <- merge(sytoxG_allPlates_merge3,sytoxG_plate5,by="row.names")

# rownames(confluency_plate1) <- time_elapsed
# rownames(confluency_plate2) <- time_elapsed
# rownames(confluency_plate3) <- time_elapsed
# rownames(confluency_plate4) <- time_elapsed
# rownames(confluency_plate5) <- time_elapsed
# 
# rownames(sytoxG_plate1) <- time_elapsed
# rownames(sytoxG_plate2) <- time_elapsed
# rownames(sytoxG_plate3) <- time_elapsed
# rownames(sytoxG_plate4) <- time_elapsed
# rownames(sytoxG_plate5) <- time_elapsed

# save(confluency_plate1, file = paste(dir,"DataObjects/confluency_plate1.R",sep=""))
# save(confluency_plate2, file = paste(dir,"DataObjects/confluency_plate2.R",sep=""))
# save(confluency_plate3, file = paste(dir,"DataObjects/confluency_plate3.R",sep=""))
# save(confluency_plate4, file = paste(dir,"DataObjects/confluency_plate4.R",sep=""))
# save(confluency_plate5, file = paste(dir,"DataObjects/confluency_plate5.R",sep=""))
# 
# save(sytoxG_plate1, file = paste(dir,"DataObjects/sytoxG_plate1.R",sep=""))
# save(sytoxG_plate2, file = paste(dir,"DataObjects/sytoxG_plate2.R",sep=""))
# save(sytoxG_plate3, file = paste(dir,"DataObjects/sytoxG_plate3.R",sep=""))
# save(sytoxG_plate4, file = paste(dir,"DataObjects/sytoxG_plate4.R",sep=""))
# save(sytoxG_plate5, file = paste(dir,"DataObjects/sytoxG_plate5.R",sep=""))