install.packages("xlsx")
install.packages("stringr")
library(xlsx)
library(stringr)

#set parameters - various files
dir = "/Users/maiasmith/Documents/SFU/ClarkeLab/ClarkeLab_github/"
compound_key_filename <- paste(dir,"Files/1419058433_834__1833Key.xlsx",sep="")
selleck_bioactive_compound_library_filename <- paste(dir,"Files/L1700-Selleck-Bioactive-Compound-Library.xlsx",sep="")
plate1_raw_data_filename <- paste(dir,"Files/1419058541_955__C2C12-diff_Tunicamycin_1833_8Sep14%252B-%252BPlate%252B1.xlsx",sep="")
plate2_raw_data_filename <- paste(dir,"Files/1419058542_400__C2C12-diff_Tunicamycin_1833_8Sep14%252B-%252BPlate%252B2.xlsx",sep="")
plate3_raw_data_filename <- paste(dir,"Files/1419058543_181__C2C12-diff_Tunicamycin_1833_8Sep14%252B-%252BPlate%252B3.xlsx",sep="")
plate4_raw_data_filename <- paste(dir,"Files/1419058544_81__C2C12-diff_Tunicamycin_1833_8Sep14%252B-%252BPlate%252B4.xlsx",sep="")
plate1_raw_data_filename <- paste(dir,"Files/1419058545_600__C2C12-diff_Tunicamycin_1833_8Sep14%252B-%252BPlate%252B5.xlsx",sep="")
plate1_raw_data_file_confluency_sheetName <- "Confluency"
plate2_raw_data_file_confluency_sheetName <- "Confluency"
plate3_raw_data_file_confluency_sheetName <- "Confluency"
plate4_raw_data_file_confluency_sheetName <- "Confluency"
plate5_raw_data_file_confluency_sheetName <- "Confluency"
plate1_raw_data_file_sytoxG_sheetName <- "Sytox G +ve"
plate2_raw_data_file_sytoxG_sheetName <- "Sytox G"
plate3_raw_data_file_sytoxG_sheetName <- "Sheet2"
plate4_raw_data_file_sytoxG_sheetName <- "Sytox G +ve"
plate5_raw_data_file_sytoxG_sheetName <- "Sytox G +ve"

#get compound list for each plate
compoundFile_plate1 <- read.xlsx(compound_key_filename, sheetIndex=1)
compoundFile_plate2 <- read.xlsx(compound_key_filename, sheetIndex=2)
compoundFile_plate3 <- read.xlsx(compound_key_filename, sheetIndex=3)
compoundFile_plate4 <- read.xlsx(compound_key_filename, sheetIndex=4)
compoundFile_plate5 <- read.xlsx(compound_key_filename, sheetIndex=5)

#get Selleck Bioactive Compound Library
selleck_bioactive_compound_lib <- read.xlsx(selleck_bioactive_compound_library_filename, sheetIndex=2)

#compounds in vector format
compounds_plate1 <- as.vector(t(compoundFile_plate1))
compounds_plate2 <- as.vector(t(compoundFile_plate2))
compounds_plate3 <- as.vector(t(compoundFile_plate3))
compounds_plate4 <- as.vector(t(compoundFile_plate4))
compounds_plate5 <- as.vector(t(compoundFile_plate5))

#read in raw data for each plate
rawData_confluency_plate1 <- read.xlsx(plate1_raw_data_filename, sheetName=plate1_raw_data_file_confluency_sheetName, stringsAsFactors = FALSE)
rawData_confluency_plate2 <- read.xlsx(plate2_raw_data_filename, sheetName=plate2_raw_data_file_confluency_sheetName, stringsAsFactors = FALSE)
rawData_confluency_plate3 <- read.xlsx(plate3_raw_data_filename, sheetName=plate3_raw_data_file_confluency_sheetName, stringsAsFactors = FALSE)
rawData_confluency_plate4 <- read.xlsx(plate4_raw_data_filename, sheetName=plate4_raw_data_file_confluency_sheetName, stringsAsFactors = FALSE)
rawData_confluency_plate5 <- read.xlsx(plate5_raw_data_filename, sheetName=plate5_raw_data_file_confluency_sheetName, stringsAsFactors = FALSE)

rawData_sytoxG_plate1 <- read.xlsx(plate1_raw_data_filename, sheetName=plate1_raw_data_file_sytoxG_sheetName, stringsAsFactors = FALSE)
rawData_sytoxG_plate2 <- read.xlsx(plate2_raw_data_filename, sheetName=plate2_raw_data_file_sytoxG_sheetName, stringsAsFactors = FALSE)
rawData_sytoxG_plate3 <- read.xlsx(plate3_raw_data_filename, sheetName=plate3_raw_data_file_sytoxG_sheetName, stringsAsFactors = FALSE)
rawData_sytoxG_plate4 <- read.xlsx(plate4_raw_data_filename, sheetName=plate4_raw_data_file_sytoxG_sheetName, stringsAsFactors = FALSE)
rawData_sytoxG_plate5 <- read.xlsx(plate5_raw_data_filename, sheetName=plate5_raw_data_file_sytoxG_sheetName, stringsAsFactors = FALSE)

#get data only, no excess 
confluency_plate1 <- rawData_confluency_plate1[8:nrow(rawData_confluency_plate1),3:ncol(rawData_confluency_plate1)]
confluency_plate2 <- rawData_confluency_plate2[8:nrow(rawData_confluency_plate2),3:ncol(rawData_confluency_plate2)]
confluency_plate3 <- rawData_confluency_plate3[8:nrow(rawData_confluency_plate3),3:ncol(rawData_confluency_plate3)]
confluency_plate4 <- rawData_confluency_plate4[8:nrow(rawData_confluency_plate4),3:ncol(rawData_confluency_plate4)]
confluency_plate5 <- rawData_confluency_plate5[8:nrow(rawData_confluency_plate5),3:ncol(rawData_confluency_plate5)]

sytoxG_plate1 <- rawData_sytoxG_plate1[8:nrow(rawData_sytoxG_plate1),3:ncol(rawData_sytoxG_plate1)]
sytoxG_plate2 <- rawData_sytoxG_plate2[8:nrow(rawData_sytoxG_plate2),3:ncol(rawData_sytoxG_plate2)]
sytoxG_plate3 <- rawData_sytoxG_plate3[8:nrow(rawData_sytoxG_plate3),3:ncol(rawData_sytoxG_plate3)]
sytoxG_plate4 <- rawData_sytoxG_plate4[8:nrow(rawData_sytoxG_plate4),3:ncol(rawData_sytoxG_plate4)]
sytoxG_plate5 <- rawData_sytoxG_plate5[8:nrow(rawData_sytoxG_plate5),3:ncol(rawData_sytoxG_plate5)]

#format raw data such that colnames: compounds for that plate

colnames(confluency_plate1) <- compounds_plate1
colnames(confluency_plate2) <- compounds_plate2
colnames(confluency_plate3) <- compounds_plate3
colnames(confluency_plate4) <- compounds_plate4
colnames(confluency_plate5) <- compounds_plate5

colnames(sytoxG_plate1) <- compounds_plate1
colnames(sytoxG_plate2) <- compounds_plate2
colnames(sytoxG_plate3) <- compounds_plate3
colnames(sytoxG_plate4) <- compounds_plate4
colnames(sytoxG_plate5) <- compounds_plate5

#time elapsed

time_elapsed <- rawData_confluency_plate1[8:nrow(rawData_confluency_plate1),2]
time_elapsed_df <- as.data.frame(time_elapsed, nrow=length(time_elapsed))

#add time elapsed as first row

confluency_plate1 <- cbind(time_elapsed_df, confluency_plate1)
confluency_plate2 <- cbind(time_elapsed_df, confluency_plate2)
confluency_plate3 <- cbind(time_elapsed_df, confluency_plate3)
confluency_plate4 <- cbind(time_elapsed_df, confluency_plate4)
confluency_plate5 <- cbind(time_elapsed_df, confluency_plate5)

sytoxG_plate1 <- cbind(time_elapsed_df, sytoxG_plate1)
sytoxG_plate2 <- cbind(time_elapsed_df, sytoxG_plate2)
sytoxG_plate3 <- cbind(time_elapsed_df, sytoxG_plate3)
sytoxG_plate4 <- cbind(time_elapsed_df, sytoxG_plate4)
sytoxG_plate5 <- cbind(time_elapsed_df, sytoxG_plate5)

#change names of empties to reflect plate they came from

names(confluency_plate1) <- ifelse(names(confluency_plate1) %in% "Empty", str_c(names(confluency_plate1), '.1'), names(confluency_plate1))
names(confluency_plate2) <- ifelse(names(confluency_plate2) %in% "Empty", str_c(names(confluency_plate2), '.2'), names(confluency_plate2))
names(confluency_plate3) <- ifelse(names(confluency_plate3) %in% "Empty", str_c(names(confluency_plate3), '.3'), names(confluency_plate3))
names(confluency_plate4) <- ifelse(names(confluency_plate4) %in% "Empty", str_c(names(confluency_plate4), '.4'), names(confluency_plate4))
names(confluency_plate5) <- ifelse(names(confluency_plate5) %in% "Empty", str_c(names(confluency_plate5), '.5'), names(confluency_plate5))

names(sytoxG_plate1) <- ifelse(names(sytoxG_plate1) %in% "Empty", str_c(names(sytoxG_plate1), '.1'), names(sytoxG_plate1))
names(sytoxG_plate2) <- ifelse(names(sytoxG_plate2) %in% "Empty", str_c(names(sytoxG_plate2), '.2'), names(sytoxG_plate2))
names(sytoxG_plate3) <- ifelse(names(sytoxG_plate3) %in% "Empty", str_c(names(sytoxG_plate3), '.3'), names(sytoxG_plate3))
names(sytoxG_plate4) <- ifelse(names(sytoxG_plate4) %in% "Empty", str_c(names(sytoxG_plate4), '.4'), names(sytoxG_plate4))
names(sytoxG_plate5) <- ifelse(names(sytoxG_plate5) %in% "Empty", str_c(names(sytoxG_plate5), '.5'), names(sytoxG_plate5))

#merge all plates (no compound is repeated)

sytoxG_allPlates <- cbind(confluency_plate1,confluency_plate2[,2:ncol(confluency_plate2)],confluency_plate3[,2:ncol(confluency_plate3)],
                          confluency_plate4[,2:ncol(confluency_plate4)],confluency_plate5[,2:ncol(confluency_plate5)])


#reformat to one compound per row?

#merge selleck data


#save

save(confluency_plate1, file = paste(dir,"DataObjects/confluency_plate1.R",sep=""))
save(confluency_plate2, file = paste(dir,"DataObjects/confluency_plate2.R",sep=""))
save(confluency_plate3, file = paste(dir,"DataObjects/confluency_plate3.R",sep=""))
save(confluency_plate4, file = paste(dir,"DataObjects/confluency_plate4.R",sep=""))
save(confluency_plate5, file = paste(dir,"DataObjects/confluency_plate5.R",sep=""))

save(sytoxG_plate1, file = paste(dir,"DataObjects/sytoxG_plate1.R",sep=""))
save(sytoxG_plate2, file = paste(dir,"DataObjects/sytoxG_plate2.R",sep=""))
save(sytoxG_plate3, file = paste(dir,"DataObjects/sytoxG_plate3.R",sep=""))
save(sytoxG_plate4, file = paste(dir,"DataObjects/sytoxG_plate4.R",sep=""))
save(sytoxG_plate5, file = paste(dir,"DataObjects/sytoxG_plate5.R",sep=""))

save(selleck_bioactive_compound_lib, file = paste(dir,"DataObjects/selleck_bioactive_compound_lib.R",sep=""))


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
