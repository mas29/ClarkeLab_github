# Parameters for 1833Reconfigure2_ms_edits.R script, GetData.R script 

# Filename and path for key 
# ex. "/Users/maiasmith/Documents/SFU/ClarkeLab/ClarkeLab_github/Files/1833Key.xlsx"
key_filename <- "/Users/maiasmith/Documents/SFU/ClarkeLab/ClarkeLab_github/Files/1833Key.xlsx"

# Filename and path for selleck information (March 15 version from Scott) 
# ex. "/Users/maiasmith/Documents/SFU/ClarkeLab/ClarkeLab_github/Files/Selleck_1833_LibraryAnnotation_Mar15.xlsx"
selleck_info_filename <- "/Users/maiasmith/Documents/SFU/ClarkeLab/ClarkeLab_github/Files/Selleck_1833_LibraryAnnotation_Mar15.xlsx"

# Filename and path for data from incucyte (all in one excel document, different plates and markers on different sheets) 
# ex. "/Users/maiasmith/Documents/SFU/ClarkeLab/ClarkeLab_github/Files/C2C12_diff_Tunicamycin_Reconfigure.xlsx"
raw_data_filename <- "/Users/maiasmith/Documents/SFU/ClarkeLab/ClarkeLab_github/Files/C2C12_diff_Tunicamycin_Reconfigure.xlsx"

# Filename and path for the output of the 1833Reconfigure2_ms_edits.R script
# ex. "/Users/maiasmith/Documents/SFU/ClarkeLab/ClarkeLab_github/Files/C2C12_tunicamycin_output_maia.csv"
data_filename <- "/Users/maiasmith/Documents/SFU/ClarkeLab/ClarkeLab_github/Files/C2C12_tunicamycin_output_maia.csv"

# First time point in data (in hours)
# ex. "0"
first_timepoint <- "0"

# Last time point in data (in hours)
# ex. "46"
last_timepoint <- "46"

# Interval (in hours) between time points
# ex. "2"
time_interval <- "2"

# Phenotypic marker names as they appear in the data_filename file
# ex. c("SG", "Con")
phenotypic_markers <- c("SG", "Con") 

# Value for the NA wells (IncuCyte didn't detect a value for a particular phenotypic marker)
# ex. 0.2320489
na_value <- 0.2320489

# Plotly login
# DO NOT CHANGE THIS CONFIGURATION (Use my login)
py <- plotly("mas29", "8s6jru0os3")