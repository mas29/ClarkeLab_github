# Script to convert images for a compound to jpeg 
# Load libraries
library("jpeg")
library("tiff")
img <- readTIFF("/Users/maiasmith/Desktop/ClarkeLab_images/A1-1-P_282.tiff", native=TRUE)
writeJPEG(img, target = "/Users/maiasmith/Desktop/ClarkeLab_images/Converted.jpeg", quality = 1)

# Function to get the images corresponding to the compound of interest
get_images <- function(compound) {
  
}