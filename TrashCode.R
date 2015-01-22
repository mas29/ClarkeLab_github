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

#confluency_sytoxG_all_plates_for_data_vis_w_selleck_info <- merge(confluency_sytoxG_all_plates_for_data_vis, selleck_bioactive_compound_lib, all.x=TRUE, by.x="compound", by.y="Product.Name")


#function to read in and format data
#param plate_file_names -- names of excel files with plate data
#param plate_sheet_names -- names of sheets of excel files with plate data
#param raw_data_start_row -- the excel sheet starts the raw data at which row
#param raw_data_start_col -- the excel sheet starts the raw data at which column
#param compounds_key_file_name -- name of file with compound key for each plate
#param compounds_key_sheet_names -- names of sheets of excel file with compound key for each plate
#param index -- plate we're considering
read_data <- function(plate_file_names, plate_sheet_names, raw_data_start_row, raw_data_start_col, compounds_key_file_name, compounds_key_sheet_names, index) {
  #read in raw data for plate
  raw_data <- read.xlsx(plate_file_names[index], sheetName=plate_sheet_names[index], stringsAsFactors = FALSE)
  #get data only, no excess 
  trimmed_data <- raw_data[raw_data_start_row:nrow(raw_data),raw_data_start_col:ncol(raw_data)]
  #get compound list for each plate
  compounds <- as.vector(t(read.xlsx(compounds_key_file_name, sheetName=compounds_key_sheet_names[index])))
  #format raw data such that colnames: compounds for that plate
  colnames(trimmed_data) <- compounds
  #change names of empties to reflect plate they came from
  names(trimmed_data) <- ifelse(names(trimmed_data) %in% "Empty", str_c(names(trimmed_data), '.', index), names(trimmed_data))
  return(trimmed_data)
}

#read in raw data for each plate and format it
confluency_plate_1 <- read_data(plates_raw_data_file_names, confluency_plates_raw_data_sheet_names, raw_data_start_row, raw_data_start_col, compound_key_file_name, compound_key_sheet_names, 1)
confluency_plate_2 <- read_data(plates_raw_data_file_names, confluency_plates_raw_data_sheet_names, raw_data_start_row, raw_data_start_col, compound_key_file_name, compound_key_sheet_names, 2)
confluency_plate_3 <- read_data(plates_raw_data_file_names, confluency_plates_raw_data_sheet_names, raw_data_start_row, raw_data_start_col, compound_key_file_name, compound_key_sheet_names, 3)
confluency_plate_4 <- read_data(plates_raw_data_file_names, confluency_plates_raw_data_sheet_names, raw_data_start_row, raw_data_start_col, compound_key_file_name, compound_key_sheet_names, 4)
confluency_plate_5 <- read_data(plates_raw_data_file_names, confluency_plates_raw_data_sheet_names, raw_data_start_row, raw_data_start_col, compound_key_file_name, compound_key_sheet_names, 5)

sytoxG_plate_1 <- read_data(plates_raw_data_file_names, sytoxG_plates_raw_data_sheet_names, raw_data_start_row, raw_data_start_col, compound_key_file_name, compound_key_sheet_names, 1)
sytoxG_plate_2 <- read_data(plates_raw_data_file_names, sytoxG_plates_raw_data_sheet_names, raw_data_start_row, raw_data_start_col, compound_key_file_name, compound_key_sheet_names, 2)
sytoxG_plate_3 <- read_data(plates_raw_data_file_names, sytoxG_plates_raw_data_sheet_names, raw_data_start_row, raw_data_start_col, compound_key_file_name, compound_key_sheet_names, 3)
sytoxG_plate_4 <- read_data(plates_raw_data_file_names, sytoxG_plates_raw_data_sheet_names, raw_data_start_row, raw_data_start_col, compound_key_file_name, compound_key_sheet_names, 4)
sytoxG_plate_5 <- read_data(plates_raw_data_file_names, sytoxG_plates_raw_data_sheet_names, raw_data_start_row, raw_data_start_col, compound_key_file_name, compound_key_sheet_names, 5)

#merge all plates (subset because it puts extensions on repeated columns (ex. Empty.1.1, Empty.1.2)) 
confluency_all_plates_merged <- cbind(confluency_plate_1[1:nrow(confluency_plate_1), 1:ncol(confluency_plate_1)],
                                      confluency_plate_2[1:nrow(confluency_plate_2), 1:ncol(confluency_plate_2)],
                                      confluency_plate_3[1:nrow(confluency_plate_3), 1:ncol(confluency_plate_3)],
                                      confluency_plate_4[1:nrow(confluency_plate_4), 1:ncol(confluency_plate_4)],
                                      confluency_plate_5[1:nrow(confluency_plate_5), 1:ncol(confluency_plate_5)])
sytoxG_all_plates_merged <- cbind(sytoxG_plate_1[1:nrow(sytoxG_plate_1), 1:ncol(sytoxG_plate_1)],
                                  sytoxG_plate_2[1:nrow(sytoxG_plate_2), 1:ncol(sytoxG_plate_2)],
                                  sytoxG_plate_3[1:nrow(sytoxG_plate_3), 1:ncol(sytoxG_plate_3)],
                                  sytoxG_plate_4[1:nrow(sytoxG_plate_4), 1:ncol(sytoxG_plate_4)],
                                  sytoxG_plate_5[1:nrow(sytoxG_plate_5), 1:ncol(sytoxG_plate_5)])

#get compound list for each plate
compoundFile_plate1 <- read.xlsx(compound_key_filename, sheetIndex=1)
compoundFile_plate2 <- read.xlsx(compound_key_filename, sheetIndex=2)
compoundFile_plate3 <- read.xlsx(compound_key_filename, sheetIndex=3)
compoundFile_plate4 <- read.xlsx(compound_key_filename, sheetIndex=4)
compoundFile_plate5 <- read.xlsx(compound_key_filename, sheetIndex=5)

#compounds in vector format
compounds_plate1 <- as.vector(t(compoundFile_plate1))
compounds_plate2 <- as.vector(t(compoundFile_plate2))
compounds_plate3 <- as.vector(t(compoundFile_plate3))
compounds_plate4 <- as.vector(t(compoundFile_plate4))
compounds_plate5 <- as.vector(t(compoundFile_plate5))

confluency_sytoxG_all_plates_compounds_vs_features_save_location <- paste(dir,"DataObjects/confluency_sytoxG_all_plates_compounds_vs_features.R",sep="")
confluency_sytoxG_all_plates_compounds_vs_features_w_selleck_info_save_location <- paste(dir,"DataObjects/confluency_sytoxG_all_plates_compounds_vs_features_w_selleck_info.R",sep="")
confluency_sytoxG_all_plates_for_data_vis_save_location <- paste(dir,"DataObjects/confluency_sytoxG_all_plates_for_data_vis.R",sep="")
confluency_sytoxG_all_plates_for_data_vis_w_selleck_info_save_location <- paste(dir,"DataObjects/confluency_sytoxG_all_plates_for_data_vis_w_selleck_info.R",sep="")


temp1 <- apply(confluency_all_plates_compounds_vs_features, 2, function(x) as.numeric(x))
temp2 <- apply(temp1, 1, mean)
temp <- apply(confluency_all_plates_compounds_vs_features, 1, function(x) mean(as.numeric(x)))
temp_data <- as.numeric(confluency_all_plates_compounds_vs_features[1:2,1:2])

#compute area under the curve
temp <- as.numeric(confluency_all_plates_compounds_vs_features[1,1:24])
AUC_trapezoidal_integration = trapz(time_elapsed,temp)

#find row containing value in specified column (column sytoxG_t0)
which(grepl(1.8563910, sytoxG_all_plates_compounds_vs_features$sytoxG_t0))
