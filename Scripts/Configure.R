# Parameters for 1833Reconfigure2_ms_edits.R script, GetData.R script 
library(plotly)

########################################################################################################
############# ------------------- Change the following configurations -------------------- #############
########################################################################################################

# Filename and path for key 
# ex. "/Users/maiasmith/Documents/SFU/ClarkeLab/ClarkeLab_github/Files/1833Key.xlsx"
key_filename <- "/Users/maiasmith/Documents/SFU/ClarkeLab/ClarkeLab_github/Files/1833Key.xlsx"

# Filename and path for selleck information (March 15 version from Scott) 
# ex. "/Users/maiasmith/Documents/SFU/ClarkeLab/ClarkeLab_github/Files/Selleck_1833_LibraryAnnotation_Mar15.xlsx"
selleck_info_filename <- "/Users/maiasmith/Documents/SFU/ClarkeLab/ClarkeLab_github/Files/Selleck_1833_LibraryAnnotation_Mar15.xlsx"

# Filename and path for data from incucyte (all in one excel document, different plates and markers on different sheets) 
# ex. "/Users/maiasmith/Documents/SFU/ClarkeLab/ClarkeLab_github/Files/C2C12_diff_Tunicamycin_Reconfigure.xlsx"
raw_data_filename <- "/Users/maiasmith/Documents/SFU/ClarkeLab/ClarkeLab_github/Files/C2C12_diff_Tunicamycin_Reconfigure.xlsx"

# Phenotypic marker names as comprehensible by user (IN THE ORDER THAT THEY APPEAR IN THE raw_data_filename TABS)
# ex. c("Sytox Green", "Confluency")
phenotypic_marker_names <- c("Sytox Green", "Confluency")

# Phenotypic marker names as they appear in the raw_data_filename tabs (IN THE ORDER THAT THEY APPEAR IN THE raw_data_filename TABS)
# ex. c("SG", "Con")
phenotypic_markers <- c("SG", "Con") 

# The name of your IncuCyte screen
# e.g. "C2C12 Diff Tunicamycin"
screen_name <- "C2C12 Diff Tunicamycin"

# Value for the NA wells (IncuCyte didn't detect a value for a particular phenotypic marker)
# ex. 0.2320489
na_value <- 0.2320489

########################################################################################################
############# ---------------- Do NOT change the following configurations ---------------- #############
########################################################################################################

# Plotly login
# DO NOT CHANGE THIS CONFIGURATION (Use my login)
py <- plotly("mas29", "8s6jru0os3")
