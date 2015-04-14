# Parameters for 1833Reconfigure2_ms_edits.R script, GetData.R script 
library(plotly)

########################################################################################################
############# ------------------- Change the following configurations -------------------- #############
########################################################################################################

# Directory of the archive for the IncuCyte images (point to EssenFiles/ScanData/ directory)
# e.g. "/Volumes/G-Drive/dc140908\ c2c12\ diff\ tun\ 1-5/EssenFiles/ScanData/" 
archive_dir <- "/Volumes/G-Drive/dc140908\ c2c12\ diff\ tun\ 1-5/EssenFiles/ScanData/" 

# Filename and path for key 
# e.g. "/Users/maiasmith/Documents/SFU/ClarkeLab/ClarkeLab_github/Files/1833Key.xlsx"
key_filename <- "/Users/maiasmith/Documents/SFU/ClarkeLab/ClarkeLab_github/Files/1833Key.xlsx"

# Filename and path for selleck information (March 15 version from Scott) 
# e.g. "/Users/maiasmith/Documents/SFU/ClarkeLab/ClarkeLab_github/Files/Selleck_1833_LibraryAnnotation_Mar15.xlsx"
selleck_info_filename <- "/Users/maiasmith/Documents/SFU/ClarkeLab/ClarkeLab_github/Files/Selleck_1833_LibraryAnnotation_Mar15.xlsx"

# Filename and path for data from incucyte (all in one excel document, different plates and markers on different sheets) 
# e.g. "/Users/maiasmith/Documents/SFU/ClarkeLab/ClarkeLab_github/Files/C2C12_diff_Tunicamycin_Reconfigure.xlsx"
# e.g. "/Users/maiasmith/Documents/SFU/ClarkeLab/Test_Datasets/forcina_tunicamycin_1833_modulation.xlsx"
raw_data_filename <- "/Users/maiasmith/Documents/SFU/ClarkeLab/Test_Datasets/forcina_tunicamycin_1833_modulation.xlsx"

# Phenotypic marker names as comprehensible by user (IN THE ORDER THAT THEY APPEAR IN THE raw_data_filename TABS)
# e.g. c("Confluency", "Sytox Green")
# e.g. c("Confluency", "Sytox Green", "NLS")
phenotypic_marker_names <- c("Confluency", "Sytox Green", "NLS")

# Phenotypic marker names as they appear in the raw_data_filename tabs (IN THE ORDER THAT THEY APPEAR IN THE raw_data_filename TABS)
# e.g. c("Con", "SG")
# e.g. c("Con", "SG", "NLS") 
phenotypic_markers <- c("Con", "SG", "NLS") 

# Types of images output by the IncuCyte machine
# e.g. c("Phase-Contrast", "Green Fluorescence")
image_type_names <- c("Phase-Contrast", "Green Fluorescence")

# Types of images output by the IncuCyte machine, as they appear in the archive image files (e.g. if filename is "A1-1-C.tif", it's "C")
# e.g. c("P", "C1")
image_types <- c("P", "C1")

# Number of plates in screen (as integer)
num_plates <- 5

# Number of wells per plate (as integer)
num_wells_per_plate <- 384

# Number of "letters" for the screen (e.g. A1, B1, C1 ... if goes up to letter P, would be 16 letters) (as integer)
num_letters <- 16

# Number of "numbers" for the screen (e.g. A1, B1, C1 ... A2, B2, C2 ... if goes up to A24, would be 24 numbers) (as integer)
num_numbers <- 24 

# The name of your IncuCyte screen
# e.g. "C2C12 Diff Tunicamycin"
screen_name <- "C2C12 Diff Tunicamycin"

# Value for the NA wells (IncuCyte didn't detect a value for a particular phenotypic marker)
# e.g. 0.2320489
na_value <- 0.2320489

########################################################################################################
############# ---------------- Do NOT change the following configurations ---------------- #############
########################################################################################################

# Plotly login
# DO NOT CHANGE THIS CONFIGURATION (Use my login)
py <- plotly("mas29", "8s6jru0os3")
