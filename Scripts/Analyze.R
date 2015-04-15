# Script that will fully visualize and analyze your data 
# (although you must make sure the parameters in config.yml are set according to your filesystem and needs)

# -------------------------------------------------

# Configure

library(yaml)
library(dbConnect)
config = yaml.load_file("config.yml")

archive_dir=config$db$archive_dir
key_filename=config$db$key_filename
selleck_info_filename=config$db$selleck_info_filename
raw_data_filename=config$db$raw_data_filename
phenotypic_marker_names=config$db$phenotypic_marker_names
phenotypic_markers=config$db$phenotypic_markers
image_type_names=config$db$image_type_names
image_types=config$db$image_types
num_plates=config$db$num_plates
num_wells_per_plate=config$db$num_wells_per_plate
num_letters=config$db$num_letters
num_numbers=config$db$num_numbers
screen_name=config$db$screen_name
na_value=config$db$na_value

# Unlist
phenotypic_marker_names <- unlist(strsplit(phenotypic_marker_names, ", "))
phenotypic_markers <- unlist(strsplit(phenotypic_markers, ", "))
image_type_names <- unlist(strsplit(image_type_names, ", "))
image_types <- unlist(strsplit(image_types, ", "))

# To numeric
num_plates <- as.numeric(num_plates)
num_wells_per_plate <- as.numeric(num_wells_per_plate)
num_letters <- as.numeric(num_letters)
num_numbers <- as.numeric(num_numbers)
na_value <- as.numeric(na_value)

# -------------------------------------------------

# Reconfigure the data 
source("Scripts/Reconfigure_ms_edits.R")

# Reformat the data
source("Scripts/GetData.R")

# -------------------------------------------------

# Libraries for RMardowns
library(ggplot2)
library(grid)
library(gridExtra)
library(plyr)
library(knitr)
library(devtools)
library(car)
library(plotly)
library(reshape2)
library(gplots)
library(RColorBrewer)
library(shiny)


# # "Bricks" plot of all sparklines 
# knitr::knit2html("RMarkdowns/AllSparklines.Rmd")
# browseURL("RMarkdowns/AllSparklines.html")

# Explore individual compounds
runApp("Scripts/shiny_scripts/explore", launch.browser = TRUE)





