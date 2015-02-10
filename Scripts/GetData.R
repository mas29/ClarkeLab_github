# install.packages("xlsx")
# install.packages("pracma")
# install.packages("stringr")
# install.packages("dplyr")
# install.packages("tidyr")
# install.packages("reshape")
library(xlsx)
library(stringr)
library(plyr)
require(pracma)
library(dplyr)
library(tidyr)
library(reshape)
library(car)

#set parameters - various files
dir = "/Users/maiasmith/Documents/SFU/ClarkeLab/ClarkeLab_github/"
#dir = "C:/Users/Dave/Documents/SFU job/Lab - muscle signaling/Dixon - myocyte expts/Maia Smith files/ClarkeLab_github/"
# dir = "/Users/mas29/Documents/ClarkeLab_github/"
time_elapsed <- seq(0,46,2)
na_value <- 0.2320489

#FUNCTIONS

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
#param start -- start of numbers
#param end -- end of numbers
#param time_elapsed -- numeric vector of time elapsed (ex. 0, 2, 4...)
add_metrics <- function(df, start, end, time_elapsed) {
  df$mean <- apply(df[start:end], 1, mean)
  df$min <- apply(df[start:end], 1, min)
  df$max <- apply(df[start:end], 1, max)
  #correct area under curve?
  df$AUC_trapezoidal_integration <- apply(df[start:end], 1, function(x) trapz(time_elapsed, x))
  #boundary correction for trapezoidal integration? ?trapz
  df$time_to_max <- apply(df[start:end], 1, function(x) time_elapsed[which.max(x)])
  df$time_to_min <- apply(df[start:end], 1, function(x) time_elapsed[which.min(x)])
  df$delta_min_max <- apply(df[start:end], 1, function(x) (max(x)-min(x)))
  df$delta_start_finish <- apply(df[start:end], 1, function(x) (x[24]-x[1]))
  df$most_positive_slope <- apply(df[start:end], 1, function(x) (get_slope_info(time_elapsed,x)[1]))
  df$time_to_most_positive_slope <- apply(df[start:end], 1, function(x) (get_slope_info(time_elapsed,x)[2]))
  df$most_negative_slope <- apply(df[start:end], 1, function(x) (get_slope_info(time_elapsed,x)[3]))
  df$time_to_most_negative_slope <- apply(df[start:end], 1, function(x) (get_slope_info(time_elapsed,x)[4]))
  df$empty <- apply(df, 1, function(x) (grepl("Empty", x[1])))#negative control (T/F) 
  df$empty <- recode(df$empty, "TRUE='Negative Control'; FALSE='Treatment'", as.factor.result = TRUE)
  return(df)
}

#### potentially want to change to ddply?????

#function to get features only
#@param df -- data frame as tbl_df
get_features <- function(df) {
  df <- df %>%
    select(Compound, Catalog.No., Rack.Number, M.w., CAS.Number, Form, Targets, Information, Smiles, Max.Solubility.in.DMSO,
           URL, Pathway, Plate, Position, Screen, phenotypic_Marker, Elapsed, mean, min, max, AUC_trapezoidal_integration, time_to_max,
           time_to_min, delta_min_max, delta_start_finish, most_positive_slope, time_to_most_positive_slope, most_negative_slope, 
           time_to_most_negative_slope, empty) %>%
    distinct()
  return(df)
}


#END FUNCTIONS

# load the data from Giovanni (C2C12_tunicamycin_output.csv), which is all the data from 1833 compounds, 
# created by the _____ script
#!!!!!!!!!!!!!!!!!!!! replace filename of toXL data frame with the correct filename !!!!!!!!!!!!!!!!!!!
confluency_sytoxG_data <- read.csv(file=paste(dir,"Files/C2C12_tunicamycin_output.csv",sep=""), header=T, 
                                   check.names=F, row.names=1)

confluency_data <- confluency_sytoxG_data[,c(1:42)]
sytoxG_data <- confluency_sytoxG_data[,c(1:15,43:ncol(confluency_sytoxG_data))]
confluency_sytoxG_data <- rbind(confluency_data,sytoxG_data)
confluency_sytoxG_data <- confluency_sytoxG_data[,colSums(is.na(confluency_sytoxG_data))<nrow(confluency_sytoxG_data)] #remove columns where ALL values are NA
confluency_sytoxG_data$Compound <- as.character(confluency_sytoxG_data$Compound) #required for changing Empty compound names to include plate & position
confluency_sytoxG_data[which(confluency_sytoxG_data$Compound == "Empty"),'Compound'] <- #changing Empty compound names to include plate & position
  with(confluency_sytoxG_data, paste(Compound, Plate, Position, sep = "_"))[which(confluency_sytoxG_data$Compound == "Empty")]

#fill in NA values with na value specified (0.23, or 1/4 of a cell)
confluency_sytoxG_data[18:41][is.na(confluency_sytoxG_data[18:41])] <- na_value

### There are some strange characters in the Compound names, explaining error for add_metrics ###
#add metrics
confluency_sytoxG_data <- add_metrics(confluency_sytoxG_data, 18, 41, time_elapsed)

#reshape for data vis 
confluency_sytoxG_data <- melt(confluency_sytoxG_data, id=(colnames(confluency_sytoxG_data)[c(1:17,42:ncol(confluency_sytoxG_data))]), measure.vars=(colnames(confluency_sytoxG_data)[18:41]))
colnames(confluency_sytoxG_data)[colnames(confluency_sytoxG_data) == "variable"] <- "time_elapsed"
colnames(confluency_sytoxG_data)[colnames(confluency_sytoxG_data) == "value"] <- "phenotype_value"

#convert factor to number for time_elapsed column
confluency_sytoxG_data$time_elapsed <- as.numeric(as.character(confluency_sytoxG_data$time_elapsed))

#add drugbank data??

#convert to tbl_df
confluency_sytoxG_data <- tbl_df(confluency_sytoxG_data)

#arrange by compound name, time elapsed
confluency_sytoxG_data <- confluency_sytoxG_data %>%
  arrange(Compound, phenotypic_Marker, time_elapsed)

#get separated data into sytoxG and confluency
sytoxG_data <- subset(confluency_sytoxG_data, phenotypic_Marker == "SG")
confluency_data <- subset(confluency_sytoxG_data, phenotypic_Marker == "Con")

#get features
sytoxG_data_features <- get_features(sytoxG_data)
confluency_data_features <- get_features(confluency_data)



save(sytoxG_data, file=paste(dir,"DataObjects/sytoxG_data.R",sep=""))
save(confluency_data, file=paste(dir,"DataObjects/confluency_data.R",sep=""))
# CAUSES FATAL ERROR... ### save(sytoxG_data_features, file=paste(dir,"DataObjects/sytoxG_data_features.R",sep=""))
save(confluency_data_features, file=paste(dir,"DataObjects/confluency_data_features.R",sep=""))
save(confluency_sytoxG_data, file=paste(dir,"DataObjects/confluency_sytoxG_data.R",sep=""))


#export to tsv
write.table(confluency_sytoxG_data, file = paste(dir,"DataOutput/confluency_sytoxG_data.tsv",sep=""), 
            append = FALSE, quote = FALSE, sep = "\t", eol = "\n", na = "NA", dec = ".", row.names = TRUE, col.names = NA)
