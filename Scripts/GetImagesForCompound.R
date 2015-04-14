# Script to convert images for a compound to jpeg 
# Load libraries
library("jpeg")
library("tiff")
library("animation")
img <- readTIFF("/Users/maiasmith/Desktop/ClarkeLab_images/A1-1-P_282.tiff", native=TRUE)
writeJPEG(img, target = "/Users/maiasmith/Desktop/ClarkeLab_images/Converted.jpeg", quality = 1)

#!!!!! INCLUDE YEARS/MONTHS?
# Function to get the folder structure of the archive directory
archive_dir_orientation <- function() {
  expt_days <- list.files(path = archive_dir) # Experiment days
  expt_hrs_mins <- list()
  for (i in 1:length(expt_days)) {
    expt_new_hrs_mins <- list.files(path = paste(archive_dir,expt_days[i],sep=""))
    expt_hrs_mins[[i]] <- expt_new_hrs_mins
  }
  expt_hrs_mins <- as.list(setNames(expt_hrs_mins, expt_days))
  return(expt_hrs_mins)
}

# Function to get plate numbers as they appear in the archive (e.g. folders 282, 283, 284, 285, 286  correspond to plates 1, 2, 3, 4, 5)
get_plate_nums_in_archive_dir <- function() {
  plate_nums_etc <- list.files(path = paste(archive_dir,expt_days[1],"/",expt_hrs_mins[[1]][1],sep=""))
  plate_nums <- plate_nums_etc[grep("^[[:digit:]]*$", plate_nums_etc)]
  return(plate_nums)
}

# Function to get the images corresponding to the compound of interest
get_images <- function(compound) {
  # Get info for this compound
  expt_hrs_mins <- archive_dir_orientation() # Get archive directory folder structure
  plate_nums <- get_plate_nums_in_archive_dir() # Get names of plates as they exist in the archive
  position <- data_wide[data_wide$Compound == compound,]$Position[1] # Position of compound in plate
  plate <- data_wide[data_wide$Compound == compound,]$Plate[1] # Plate of compound
  
  # Set suffix for the different image types
  suffixes <- list()
  for (i in 1:length(image_types)) {
    new_suffix <- paste("-1-",image_types[i],".tif",sep="")
    suffixes[[i]] <- new_suffix
  }
  suffixes <- as.list(setNames(suffixes, image_type_names))
  
  # Remove all files in www directory of shiny "explore" app
  do.call(file.remove,list(list.files(paste(dir,"Scripts/shiny_scripts/explore/www/",sep=""), full.names=TRUE)))
  
  # Now convert and add the images to the www directory of shiny "explore" app
  count <- 1 # To keep track of which timepoint we're at
  for (i in 1:length(expt_days)) { # For each experiment day
    for (j in 1:length(expt_hrs_mins[[i]])) { # For each hour/minute of image capture in that experiment day
      plate_name_in_archive <- plate_nums[plate]
      
      for (x in 1:length(image_types)) {
        image_dir <- paste(archive_dir,expt_days[i],"/",expt_hrs_mins[[i]][j],"/",plate_name_in_archive,"/",toupper(position),suffixes[[x]],sep="")
        img <- suppressWarnings(readTIFF(image_dir, native=TRUE))
        writeJPEG(img, target = paste(dir,"Scripts/shiny_scripts/explore/www/",image_types[x],"_t_",as.character(time_elapsed[count]),".jpeg",sep=""), quality = 1)
      }
      
      count <- count + 1
    }
  }

}