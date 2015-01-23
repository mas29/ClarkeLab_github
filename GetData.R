install.packages("xlsx")
install.packages("pracma")
install.packages("stringr")
library(xlsx)
library(stringr)
library(plyr)
require(pracma)

options(stringsAsFactors=F)

#set parameters - various files
# dir = "/Users/maiasmith/Documents/SFU/ClarkeLab/ClarkeLab_github/"
dir = "/Users/mas29/Documents/ClarkeLab_github/"
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
#param phenotypic_marker_name -- name of the phenotypic marker (ex."confluency")
#param time_elapsed -- vector of time elapsed
read_data <- function(plate_file_names, plate_sheet_names, raw_data_start_row, raw_data_start_col, compounds_key_file_name, compounds_key_sheet_names, num_plates, phenotypic_marker_name, time_elapsed) {
  merged_data <- data.frame()
  for (i in 1:num_plates) {
    #read in raw data for plate
    raw_data <- read.xlsx(plate_file_names[i], sheetName=plate_sheet_names[i])
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
  #transpose so that rows are compounds, columns are time elapsed
  merged_data <- as.data.frame(t(as.data.frame(merged_data)))  
  #set column names as "sytoxG_t0", "sytoxG_t2", etc.
  colnames(merged_data) <- paste(phenotypic_marker_name,"_t", time_elapsed, sep = "")
  return(merged_data)
}

#function to reorganize the data frame s.t. compound is one row, time elapsed is one row, fluorescence/confluency 
#value is one row, whether it's "confluency" or "sytoxG" data is one row

#param df: data frame of time elapsed vs compound
#param time_elapsed: vector of time elapsed
#param datatype: "confluency" or "sytoxG"

reorg_df <- function(df, time_elapsed, datatype) {
  reorganized_df <- NULL
  for (i in 1:nrow(df)) { #for each compound
    compound <- rownames(df)[i]
    compound_col <- rep(compound, length(time_elapsed))
    incucyte_vals <- t(df[i,1:24])
    type <- rep(datatype, length(time_elapsed))
    df_to_add <- cbind(compound_col, time_elapsed, incucyte_vals, type)
    for (j in 25:ncol(df)) { #add metrics
      new_col <- rep(df[i,j], length(time_elapsed))
      df_to_add <- cbind(df_to_add, new_col)
    }
    reorganized_df <- rbind(reorganized_df, df_to_add)
  }
  colnames(reorganized_df) <- c("compound", "time_elapsed", paste(datatype,"_value",sep=""), "data_type", colnames(df)[25:ncol(df)])
  rownames(reorganized_df) <- NULL
  return(as.data.frame(reorganized_df))
}

#function to get information (most positive, most negative) about the slopes of the sparklines

#param time_elapsed -- vector of times elapsed in experiment
#param penotypic_marker_values -- confluency or sytox green values corresponding to time elapsed
get_slope_info <- function(time_elapsed, penotypic_marker_values) {
  most_negative_slope <- Inf
  most_negative_slope_timepoint <- -1
  most_positive_slope <- -Inf
  most_positive_slope_timepoint <- -1
  for (i in 2:(length(time_elapsed))) {
    rise <- penotypic_marker_values[i]-penotypic_marker_values[i-1]
    run <- time_elapsed[i]-time_elapsed[i-1]
    slope <- rise/run
    curr_timepoint <- (time_elapsed[i-1]+time_elapsed[i])/2
    if (!is.na(slope)) {
      if (slope > most_positive_slope) {
        most_positive_slope <- slope
        most_positive_slope_timepoint <- curr_timepoint
      }
      if (slope < most_negative_slope) {
        most_negative_slope <- slope
        most_negative_slope_timepoint <- curr_timepoint
      }
    }
  }
  return(c(most_positive_slope, most_positive_slope_timepoint, 
           most_negative_slope, most_negative_slope_timepoint))
}

#function to add various metrics to the data

#param df -- data frame of compounds vs raw values for phenotypic marker
add_metrics <- function(df) {
  df[, c(1:24)] <- sapply(df[, c(1:24)], as.numeric)
  df$mean <- apply(df[1:24], 1, mean)
  df$min <- apply(df[1:24], 1, min)
  df$max <- apply(df[1:24], 1, max)
  #correct area under curve?
  df$AUC_trapezoidal_integration <- apply(df[1:24], 1, function(x) trapz(time_elapsed, x))
  #boundary correction for trapezoidal integration? ?trapz
  df$time_to_max <- apply(df[1:24], 1, function(x) time_elapsed[which.max(x)])
  df$time_to_min <- apply(df[1:24], 1, function(x) time_elapsed[which.min(x)])
  df$delta_min_max <- apply(df[1:24], 1, function(x) (max(x)-min(x)))
  df$delta_start_finish <- apply(df[1:24], 1, function(x) (x[24]-x[1]))
  df$most_positive_slope <- apply(df[1:24], 1, function(x) (get_slope_info(time_elapsed,x)[1]))
  df$time_to_most_positive_slope <- apply(df[1:24], 1, function(x) (get_slope_info(time_elapsed,x)[2]))
  df$most_negative_slope <- apply(df[1:24], 1, function(x) (get_slope_info(time_elapsed,x)[3]))
  df$time_to_most_negative_slope <- apply(df[1:24], 1, function(x) (get_slope_info(time_elapsed,x)[4]))
  return(df)
}

#END FUNCTIONS

#### ARRANGE DATA FOR FEATURE EXTRACTION: COMPOUNDS vs FEATURES - SUCH THAT COMPOUNDS ARE ROWS, TIMES ELAPSED ARE COLUMNS ####

#read data
confluency_all_plates_compounds_vs_features <- read_data(plates_raw_data_file_names, confluency_plates_raw_data_sheet_names, raw_data_start_row, raw_data_start_col, compound_key_file_name, compound_key_sheet_names, 5, "confluency", time_elapsed)
sytoxG_all_plates_compounds_vs_features <- read_data(plates_raw_data_file_names, sytoxG_plates_raw_data_sheet_names, raw_data_start_row, raw_data_start_col, compound_key_file_name, compound_key_sheet_names, 5, "sytoxG", time_elapsed)

#add metrics
confluency_all_plates_compounds_vs_features <- add_metrics(confluency_all_plates_compounds_vs_features)
sytoxG_all_plates_compounds_vs_features <- add_metrics(sytoxG_all_plates_compounds_vs_features)

#### ARRANGE DATA FOR DATA VISUALIZATION: COMPOUND as single column, TIME ELAPSED as single column ####

#reorganize format for data vis
confluency_all_plates_for_data_vis <- reorg_df(confluency_all_plates_compounds_vs_features, time_elapsed, "confluency")
sytoxG_all_plates_for_data_vis <- reorg_df(sytoxG_all_plates_compounds_vs_features, time_elapsed, "sytoxG")

#save
save(confluency_all_plates_compounds_vs_features, file=paste(save_dir,"confluency_all_plates_compounds_vs_features.R",sep=""))
save(sytoxG_all_plates_compounds_vs_features, file=paste(save_dir,"sytoxG_all_plates_compounds_vs_features.R",sep=""))
save(confluency_all_plates_for_data_vis, file=paste(save_dir,"confluency_all_plates_for_data_vis.R",sep=""))
save(sytoxG_all_plates_for_data_vis, file=paste(save_dir,"sytoxG_all_plates_for_data_vis.R",sep=""))

#export to csv
write.table(sytoxG_all_plates_compounds_vs_features, file = paste(save_dir,"sytoxG_all_plates_compounds_vs_features.csv",sep=""), 
            append = FALSE, quote = FALSE, sep = ",", eol = "\n", na = "NA", dec = ".", row.names = TRUE, col.names = NA)
write.table(confluency_all_plates_compounds_vs_features, file = paste(save_dir,"confluency_all_plates_compounds_vs_features.csv",sep=""), 
            append = FALSE, quote = FALSE, sep = ",", eol = "\n", na = "NA", dec = ".", row.names = TRUE, col.names = NA)




#get Selleck Bioactive Compound Library
selleck_bioactive_compound_lib <- read.xlsx(selleck_bioactive_compound_library_filename, sheetIndex=2)
colnames(selleck_bioactive_compound_lib)[2] <- "compound" #change "Product.Name" to "compound"

#merge two datasets, confluency & sytoxG, rename first column to "compound" instead of "row.names"
confluency_sytoxG_all_plates_compounds_vs_features <- merge(confluency_all_plates_compounds_vs_features,sytoxG_all_plates_compounds_vs_features, by="row.names", all.x=TRUE, all.y=TRUE)
colnames(confluency_sytoxG_all_plates_compounds_vs_features) <- c("compound",colnames(confluency_sytoxG_all_plates_compounds_vs_features)[-1])

#merge w/selleck data
confluency_sytoxG_all_plates_compounds_vs_features_w_selleck_info <- merge(confluency_sytoxG_all_plates_compounds_vs_features, selleck_bioactive_compound_lib, all.x=TRUE, by="compound")

#merge confluency & sytoxG
confluency_sytoxG_all_plates_for_data_vis <- rbind(confluency_all_plates_for_data_vis,sytoxG_all_plates_for_data_vis)

#merge w/selleck data
confluency_sytoxG_all_plates_for_data_vis_w_selleck_info <- join(confluency_sytoxG_all_plates_for_data_vis, selleck_bioactive_compound_lib, type = "left", by="compound")

