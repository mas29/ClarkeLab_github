#install.packages("xlsx")
library(xlsx)

dir = "/Users/maiasmith/Documents/SFU/ClarkeLab/"
setwd(dir)

#get compound list for each plate???
compoundFile_plate1 <- read.xlsx(paste(dir,"Files/1419058433_834__1833Key.xlsx",sep=""), sheetIndex=1)
compoundFile_plate2 <- read.xlsx(paste(dir,"Files/1419058433_834__1833Key.xlsx",sep=""), sheetIndex=2)
compoundFile_plate3 <- read.xlsx(paste(dir,"Files/1419058433_834__1833Key.xlsx",sep=""), sheetIndex=3)
compoundFile_plate4 <- read.xlsx(paste(dir,"Files/1419058433_834__1833Key.xlsx",sep=""), sheetIndex=4)
compoundFile_plate5 <- read.xlsx(paste(dir,"Files/1419058433_834__1833Key.xlsx",sep=""), sheetIndex=5)

#compounds in vector format
compounds_plate1 <- as.vector(t(compoundFile_plate1))
compounds_plate2 <- as.vector(t(compoundFile_plate2))
compounds_plate3 <- as.vector(t(compoundFile_plate3))
compounds_plate4 <- as.vector(t(compoundFile_plate4))
compounds_plate5 <- as.vector(t(compoundFile_plate5))

#read in raw data for each plate
rawData_confluency_plate1 <- read.xlsx(paste(dir,"Files/1419058541_955__C2C12-diff_Tunicamycin_1833_8Sep14%252B-%252BPlate%252B1.xlsx",sep=""), sheetName="Confluency", stringsAsFactors = FALSE)
rawData_confluency_plate2 <- read.xlsx(paste(dir,"Files/1419058542_400__C2C12-diff_Tunicamycin_1833_8Sep14%252B-%252BPlate%252B2.xlsx",sep=""), sheetName="Confluency", stringsAsFactors = FALSE)
rawData_confluency_plate3 <- read.xlsx(paste(dir,"Files/1419058543_181__C2C12-diff_Tunicamycin_1833_8Sep14%252B-%252BPlate%252B3.xlsx",sep=""), sheetName="Confluency", stringsAsFactors = FALSE)
rawData_confluency_plate4 <- read.xlsx(paste(dir,"Files/1419058544_81__C2C12-diff_Tunicamycin_1833_8Sep14%252B-%252BPlate%252B4.xlsx",sep=""), sheetName="Confluency", stringsAsFactors = FALSE)
rawData_confluency_plate5 <- read.xlsx(paste(dir,"Files/1419058545_600__C2C12-diff_Tunicamycin_1833_8Sep14%252B-%252BPlate%252B5.xlsx",sep=""), sheetName="Confluency", stringsAsFactors = FALSE)

rawData_sytoxG_plate1 <- read.xlsx(paste(dir,"Files/1419058541_955__C2C12-diff_Tunicamycin_1833_8Sep14%252B-%252BPlate%252B1.xlsx",sep=""), sheetName="Sytox G +ve", stringsAsFactors = FALSE)
rawData_sytoxG_plate2 <- read.xlsx(paste(dir,"Files/1419058542_400__C2C12-diff_Tunicamycin_1833_8Sep14%252B-%252BPlate%252B2.xlsx",sep=""), sheetName="Sytox G", stringsAsFactors = FALSE)
rawData_sytoxG_plate3 <- read.xlsx(paste(dir,"Files/1419058543_181__C2C12-diff_Tunicamycin_1833_8Sep14%252B-%252BPlate%252B3.xlsx",sep=""), sheetName="Sheet2", stringsAsFactors = FALSE)
rawData_sytoxG_plate4 <- read.xlsx(paste(dir,"Files/1419058544_81__C2C12-diff_Tunicamycin_1833_8Sep14%252B-%252BPlate%252B4.xlsx",sep=""), sheetName="Sytox G +ve", stringsAsFactors = FALSE)
rawData_sytoxG_plate5 <- read.xlsx(paste(dir,"Files/1419058545_600__C2C12-diff_Tunicamycin_1833_8Sep14%252B-%252BPlate%252B5.xlsx",sep=""), sheetName="Sytox G +ve", stringsAsFactors = FALSE)

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

#format raw data such that rownames: time elapsed, colnames: compounds
rownames(confluency_plate1) <- rawData_confluency_plate1[8:nrow(rawData_confluency_plate1),2]
rownames(confluency_plate2) <- rawData_confluency_plate2[8:nrow(rawData_confluency_plate2),2]
rownames(confluency_plate3) <- rawData_confluency_plate3[8:nrow(rawData_confluency_plate3),2]
rownames(confluency_plate4) <- rawData_confluency_plate4[8:nrow(rawData_confluency_plate4),2]
rownames(confluency_plate5) <- rawData_confluency_plate5[8:nrow(rawData_confluency_plate5),2]

rownames(sytoxG_plate1) <- rawData_sytoxG_plate1[8:nrow(rawData_sytoxG_plate1),2]
rownames(sytoxG_plate2) <- rawData_sytoxG_plate2[8:nrow(rawData_sytoxG_plate2),2]
rownames(sytoxG_plate3) <- rawData_sytoxG_plate3[8:nrow(rawData_sytoxG_plate3),2]
rownames(sytoxG_plate4) <- rawData_sytoxG_plate4[8:nrow(rawData_sytoxG_plate4),2]
rownames(sytoxG_plate5) <- rawData_sytoxG_plate5[8:nrow(rawData_sytoxG_plate5),2]

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

