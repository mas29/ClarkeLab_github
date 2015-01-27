# install.packages("xlsx")
# install.packages("pracma")
# install.packages("stringr")
library(xlsx)
library(stringr)
library(plyr)
require(pracma)
library(dplyr)
library(tidyr)
library(reshape)

#set parameters - various files
dir = "/Users/maiasmith/Documents/SFU/ClarkeLab/ClarkeLab_github/"
#dir = "/Users/mas29/Documents/ClarkeLab_github/"
time_elapsed <- seq(0,46,2)
save_dir <- paste(dir,"DataObjects/",sep="")
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
  return(df)
}

#END FUNCTIONS

#load toXL, which is all the data from 1833 compounds, created by the Reconfigure_dc.R script
#!!!!!!!!!!!!!!!!!!!! replace filename of toXL data frame with the correct filename !!!!!!!!!!!!!!!!!!!
load("/Users/maiasmith/Documents/SFU/ClarkeLab/ClarkeLab_github/Files/1421981517_326__incucyte-c2c12%252Bdiff%252Btun.RData")
confluency_sytoxG_data <- toXL
confluency_data <- confluency_sytoxG_data[,c(1:42)]
sytoxG_data <- confluency_sytoxG_data[,c(1:15,43:ncol(confluency_sytoxG_data))]
confluency_sytoxG_data <- rbind(confluency_data,sytoxG_data)
confluency_sytoxG_data <- confluency_sytoxG_data[,colSums(is.na(confluency_sytoxG_data))<nrow(confluency_sytoxG_data)] #remove columns where ALL values are NA

###### THE DATA IS WRONGLY input for toXL? ????????????????? ##############

#convert factor to double for phenotypic marker value columns
for (i in 18:41) {
  confluency_sytoxG_data[,i] <- as.numeric(as.character(confluency_sytoxG_data[,i]))
}

#add metrics
confluency_sytoxG_data <- add_metrics(confluency_sytoxG_data, 18, 41, time_elapsed)

#reshape for data vis 
confluency_sytoxG_data <- melt(confluency_sytoxG_data, id=(colnames(confluency_sytoxG_data)[c(1:17,42:53)]), measure.vars=(colnames(confluency_sytoxG_data)[18:41]))
colnames(confluency_sytoxG_data)[30] <- "time_elapsed"
colnames(confluency_sytoxG_data)[31] <- "phenotype_value"

#save
save(confluency_sytoxG_data, file=paste(save_dir,"confluency_sytoxG_data.R",sep=""))

#export to tsv
write.table(confluency_sytoxG_data, file = paste(save_dir,"confluency_sytoxG_data.tsv",sep=""), 
            append = FALSE, quote = FALSE, sep = "\t", eol = "\n", na = "NA", dec = ".", row.names = TRUE, col.names = NA)
