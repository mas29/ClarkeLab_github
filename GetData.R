install.packages("xlsx")
install.packages("pracma")
library(xlsx)
library(stringr)
library(plyr)
require(pracma)

#set parameters - various files
dir = "/Users/maiasmith/Documents/SFU/ClarkeLab/ClarkeLab_github/"
selleck_bioactive_compound_library_filename <- paste(dir,"Files/L1700-Selleck-Bioactive-Compound-Library.xlsx",sep="")
plates_raw_data_file_names <- c(paste(dir,"Files/1419058541_955__C2C12-diff_Tunicamycin_1833_8Sep14%252B-%252BPlate%252B1.xlsx",sep=""),
                               paste(dir,"Files/1419058542_400__C2C12-diff_Tunicamycin_1833_8Sep14%252B-%252BPlate%252B2.xlsx",sep=""),
                               paste(dir,"Files/1419058543_181__C2C12-diff_Tunicamycin_1833_8Sep14%252B-%252BPlate%252B3.xlsx",sep=""),
                               paste(dir,"Files/1419058544_81__C2C12-diff_Tunicamycin_1833_8Sep14%252B-%252BPlate%252B4.xlsx",sep=""),
                               paste(dir,"Files/1419058545_600__C2C12-diff_Tunicamycin_1833_8Sep14%252B-%252BPlate%252B5.xlsx",sep=""))
confluency_plates_raw_data_sheet_names <- c("Confluency", "Confluency", "Confluency", "Confluency", "Confluency")
sytoxG_plates_raw_data_sheet_names <- c("Sytox G +ve", "Sytox G", "Sheet2", "Sytox G +ve", "Sytox G +ve")
compound_key_file_name <- paste(dir,"Files/1419058433_834__1833Key.xlsx",sep="")
compound_key_sheet_names <- c("Sheet1","Sheet2","Sheet3","Sheet4","Sheet5") #one sheet per plate, gives the index of the sheet for each plate in order
raw_data_start_row <- 8 #the excel sheet starts the raw data at what row
raw_data_start_col <- 3 #the excel sheet starts the raw data at what column
time_elapsed <- seq(0,46,2)
save_dir <- paste(dir,"DataObjects/",sep="")

#FUNCTIONS

#function to read in and format data

#param plate_file_names -- names of excel files with plate data
#param plate_sheet_names -- names of sheets of excel files with plate data
#param raw_data_start_row -- the excel sheet starts the raw data at which row
#param raw_data_start_col -- the excel sheet starts the raw data at which column
#param compounds_key_file_name -- name of file with compound key for each plate
#param compounds_key_sheet_names -- names of sheets of excel file with compound key for each plate
#param num_plates -- number of plates

read_data_MERGED <- function(plate_file_names, plate_sheet_names, raw_data_start_row, raw_data_start_col, compounds_key_file_name, compounds_key_sheet_names, num_plates) {
  merged_data <- data.frame()
  for (i in 1:num_plates) {
    #read in raw data for plate
    raw_data <- read.xlsx(plate_file_names[i], sheetName=plate_sheet_names[i], stringsAsFactors = FALSE)
    #get data only, no excess 
    trimmed_data <- raw_data[raw_data_start_row:nrow(raw_data),raw_data_start_col:ncol(raw_data)]
    #get compound list for each plate
    compounds <- as.vector(t(read.xlsx(compounds_key_file_name, sheetName=compounds_key_sheet_names[i])))
    #format raw data such that colnames: compounds for that plate
    colnames(trimmed_data) <- compounds
    #change names of empties to reflect plate they came from
    names(trimmed_data) <- ifelse(names(trimmed_data) %in% "Empty", str_c(names(trimmed_data), '.', i), names(trimmed_data))
    #merge plate data in with others (subset because it puts extensions on repeated columns (ex. Empty.1.1, Empty.1.2)) 
    merged_data <- c(merged_data, trimmed_data[1:nrow(trimmed_data), 1:ncol(trimmed_data)])
  }
  return(as.data.frame(merged_data, stringsAsFactors=F))
}

#function to reorganize the data frame s.t. compound is one row, time elapsed is one row, fluorescence/confluency 
#value is one row, whether it's "confluency" or "sytoxG" data is one row

#param df: data frame of time elapsed vs compound
#param time_elapsed: vector of time elapsed
#param datatype: "confluency" or "sytoxG"

reorg_df <- function(df, time_elapsed, datatype) {
  reorganized_df <- NULL
  for (i in 1:ncol(df)) {
    compound <- colnames(df)[i]
    compound_col <- rep(compound, nrow(df))
    type <- rep(datatype, nrow(df))
    df_to_add <- cbind(compound_col, time_elapsed, df[,i], type)
    reorganized_df <- rbind(reorganized_df, df_to_add)
  }
  colnames(reorganized_df) <- c("compound", "time_elapsed", "raw_value", "data_type")
  return(as.data.frame(reorganized_df, stringsAsFactors=FALSE))
}

#END FUNCTIONS

#get Selleck Bioactive Compound Library
selleck_bioactive_compound_lib <- read.xlsx(selleck_bioactive_compound_library_filename, sheetIndex=2)
colnames(selleck_bioactive_compound_lib)[2] <- "compound" #change "Product.Name" to "compound"

#read in and format data
confluency_all_plates_merged <- read_data_MERGED(plates_raw_data_file_names, confluency_plates_raw_data_sheet_names, raw_data_start_row, raw_data_start_col, compound_key_file_name, compound_key_sheet_names, 5)
sytoxG_all_plates_merged <- read_data_MERGED(plates_raw_data_file_names, sytoxG_plates_raw_data_sheet_names, raw_data_start_row, raw_data_start_col, compound_key_file_name, compound_key_sheet_names, 5)

#### ARRANGE DATA FOR FEATURE EXTRACTION: COMPOUNDS vs FEATURES - SUCH THAT COMPOUNDS ARE ROWS, TIMES ELAPSED ARE COLUMNS ####

#transpose so that rows are compounds, columns are time elapsed
confluency_all_plates_compounds_vs_features <- as.data.frame(t(confluency_all_plates_merged), stringsAsFactors=F)
sytoxG_all_plates_compounds_vs_features <- as.data.frame(t(sytoxG_all_plates_merged), stringsAsFactors=F)

#set column names as "sytoxG_t0", "sytoxG_t2", etc.
colnames(confluency_all_plates_compounds_vs_features) <- paste("confluency_t", time_elapsed, sep = "")
colnames(sytoxG_all_plates_compounds_vs_features) <- paste("sytoxG_t", time_elapsed, sep = "")

#merge two datasets, confluency & sytoxG, rename first column to "compound" instead of "row.names"
confluency_sytoxG_all_plates_compounds_vs_features <- merge(confluency_all_plates_compounds_vs_features,sytoxG_all_plates_compounds_vs_features, by="row.names", all.x=TRUE, all.y=TRUE)
colnames(confluency_sytoxG_all_plates_compounds_vs_features) <- c("compound",colnames(confluency_sytoxG_all_plates_compounds_vs_features)[-1])

#merge w/selleck data
confluency_sytoxG_all_plates_compounds_vs_features_w_selleck_info <- merge(confluency_sytoxG_all_plates_compounds_vs_features, selleck_bioactive_compound_lib, all.x=TRUE, by="compound")

#### ARRANGE DATA FOR DATA VISUALIZATION: COMPOUND as single column, TIME ELAPSED as single column ####

#reorganize for data vis
confluency_all_plates_for_data_vis <- reorg_df(confluency_all_plates_merged, time_elapsed, "confluency")
sytoxG_all_plates_for_data_vis <- reorg_df(sytoxG_all_plates_merged, time_elapsed, "sytoxG")

#merge confluency & sytoxG
confluency_sytoxG_all_plates_for_data_vis <- rbind(confluency_all_plates_for_data_vis,sytoxG_all_plates_for_data_vis)

#merge w/selleck data
confluency_sytoxG_all_plates_for_data_vis_w_selleck_info <- join(confluency_sytoxG_all_plates_for_data_vis, selleck_bioactive_compound_lib, type = "left", by="compound")

#save
save(confluency_all_plates_compounds_vs_features, file=paste(save_dir,"confluency_all_plates_compounds_vs_features.R",sep=""))
save(sytoxG_all_plates_compounds_vs_features, file=paste(save_dir,"sytoxG_all_plates_compounds_vs_features.R",sep=""))
save(confluency_sytoxG_all_plates_compounds_vs_features, file=paste(save_dir,"confluency_sytoxG_all_plates_compounds_vs_features.R",sep=""))
save(confluency_sytoxG_all_plates_compounds_vs_features_w_selleck_info, file=paste(save_dir,"confluency_sytoxG_all_plates_compounds_vs_features_w_selleck_info.R",sep=""))
save(confluency_all_plates_for_data_vis, file=paste(save_dir,"confluency_all_plates_for_data_vis.R",sep=""))
save(sytoxG_all_plates_for_data_vis, file=paste(save_dir,"sytoxG_all_plates_for_data_vis.R",sep=""))
save(confluency_sytoxG_all_plates_for_data_vis, file=paste(save_dir,"confluency_sytoxG_all_plates_for_data_vis.R",sep=""))
save(confluency_sytoxG_all_plates_for_data_vis_w_selleck_info, file=paste(save_dir,"confluency_sytoxG_all_plates_for_data_vis_w_selleck_info.R",sep="")) 

#add metrics
confluency_all_plates_compounds_vs_features[, c(1:24)] <- sapply(confluency_all_plates_compounds_vs_features[, c(1:24)], as.numeric)
confluency_all_plates_compounds_vs_features$mean <- apply(confluency_all_plates_compounds_vs_features[1:24], 1, mean)
confluency_all_plates_compounds_vs_features$min <- apply(confluency_all_plates_compounds_vs_features[1:24], 1, min)
confluency_all_plates_compounds_vs_features$max <- apply(confluency_all_plates_compounds_vs_features[1:24], 1, max)
#correct area under curve?
confluency_all_plates_compounds_vs_features$AUC_trapezoidal_integration <- apply(confluency_all_plates_compounds_vs_features[1:24], 1, function(x) trapz(time_elapsed, x))
#boundary correction for trapezoidal integration? ?trapz
confluency_all_plates_compounds_vs_features$time_to_max <- apply(confluency_all_plates_compounds_vs_features[1:24], 1, function(x) time_elapsed[which.max(x)])

temp <- as.numeric(confluency_all_plates_compounds_vs_features[1,1:24])
which.max( temp)

#ADD METRICS TO SYTOXG AS WELL

