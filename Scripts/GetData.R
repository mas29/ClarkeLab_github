# install.packages("xlsx")
# install.packages("pracma")
# install.packages("stringr")
# install.packages("dplyr")
# install.packages("tidyr")
# install.packages("reshape")
# install.packages("Rmisc")
library(xlsx)
library(stringr)
library(plyr)
require(pracma)
library(dplyr)
library(tidyr)
library(reshape)
library(car)
library(Rmisc)

#set parameters - various files
dir = "/Users/maiasmith/Documents/SFU/ClarkeLab/ClarkeLab_github/"
#dir = "C:/Users/Dave/Documents/SFU job/Lab - muscle signaling/Dixon - myocyte expts/Maia Smith files/ClarkeLab_github/"
# dir = "/Users/mas29/Documents/ClarkeLab_github/"

# Data from Giovanni (C2C12_tunicamycin_output.csv), which is all the data from 1833 compounds, 
# created by the _____ script
#!!!!!!!!!!!!!!!!!!!! replace filename of data frame with the correct filename !!!!!!!!!!!!!!!!!!!
data_file <- paste(dir,"Files/C2C12_tunicamycin_output.csv",sep="")
first_timepoint <- "0"
last_timepoint <- "46"
time_interval <- "2"
phenotypic_markers <- c("SG", "Con") # phenotypic markers as they appear in the input data file
na_value <- 0.2320489

#FUNCTIONS

#function to get the data formatted correctly, replace individual na_values, remove entirely NA rows, and other preliminary processing
preliminary_processing <- function(df) {
  
  confluency_data <- df[,c(1:42)]
  sytoxG_data <- df[,c(1:15,43:ncol(df))]
  df <- rbind(confluency_data,sytoxG_data)
  df <- df[,colSums(is.na(df))<nrow(df)] #remove columns where ALL values are NA
  df$Compound <- as.character(df$Compound) #required for changing Empty compound names to include plate & position
  df[which(df$Compound == "Empty"),'Compound'] <- #changing Empty compound names to include plate & position
    with(df, paste(Compound, Plate, Position, sep = "_"))[which(df$Compound == "Empty")]
  df[18:41][is.na(df[18:41])] <- na_value #fill in NA values with na value specified (0.23, or 1/4 of a cell)
  
  # Replace "NA" pathways with "NegControl"
  df$Pathway <- as.character(df$Pathway)
  df$Pathway[is.na(df$Pathway)] <- "NegControl"
  df$Pathway <- as.factor(df$Pathway)
  df$Pathway <- relevel(df$Pathway, ref = "NegControl")
  
  # Remove invalid XML characters (ex. "\x95")
  df$Compound <- gsub("[\x01-\x1f\x7f-\xff]", "", df$Compound) 
  df$Information <- gsub("[\x01-\x1f\x7f-\xff]", "", df$Information) 
  df$Pathway <- gsub("[\x01-\x1f\x7f-\xff]", "", df$Pathway) 
  df$Targets <- gsub("[\x01-\x1f\x7f-\xff]", "", df$Targets) 
  
  return(df)
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


#Function to get confidence intervals for each timepoint of negative controls.

#@param df -- the data frame containing time course data
#@param first_timepoint_index -- index in df of first timepoint
#@param last_timepoint_index -- index in df of last timepoint
get_confidence_intervals_neg_controls <- function(df, phenotypic_Marker, first_timepoint_index, last_timepoint_index) {
  negControls <- df[df$Pathway == "NegControl" & df$phenotypic_Marker == phenotypic_Marker,c(first_timepoint_index:last_timepoint_index)]
  confidence_intervals <- apply(negControls, 2, function(x) CI(x, ci=0.999)) # 99.9% confidence intervals
  return(confidence_intervals)
}


#Function to get the time.x.distance metric (compare curves to upper confidence interval of negative controls -- 
#get the phenotypic marker value "distance" for each timepoint, multiply each distance by the common time interval, 
#and sum)

#@param confidence_intervals_SG -- confidence intervals for each time point of negative controls data for SG (from get_confidence_intervals_neg_control() function)
#@param confidence_intervals_confluency -- confidence intervals for each time point of negative controls data for confluency (from get_confidence_intervals_neg_control() function)
#@param df -- the data frame containing time course data
#@param first_timepoint_index -- index in df of first timepoint
#@param last_timepoint_index -- index in df of last timepoint
#@param time_interval -- common time interval between measurements
get_time_x_distance <- function(confidence_intervals_SG, confidence_intervals_confluency, df, first_timepoint_index, last_timepoint_index, time_interval) {
  phenotypic_Marker_index <- which(colnames(df) == "phenotypic_Marker")
  time_x_distance <- apply(confluency_sytoxG_data_prelim_proc,1,function(y) {
    if (y[phenotypic_Marker_index] == "SG") {
      df_w_CIs <- rbind(y[first_timepoint_index:last_timepoint_index],confidence_intervals_SG) # use SG confidence intervals
      time_interval*sum(apply(df_w_CIs,2,function(x) {
        x <- as.numeric(x)
        x[1]-x[2]}))
    } else if (y[phenotypic_Marker_index] == "Con") {
      df_w_CIs <- rbind(y[first_timepoint_index:last_timepoint_index],confidence_intervals_confluency) # use confluency confidence intervals
      time_interval*sum(apply(df_w_CIs,2,function(x) {
        x <- as.numeric(x)
        x[1]-x[2]}))
    }
  })
  return(time_x_distance)
}


# Function to add various initial metrics to the data 
# (each sparkline is assessed as its own entity, for mean, min, max, etc. without regard to the negative control values)

# param df -- data frame of compounds vs raw values for phenotypic marker
# param start -- start of numbers
# param end -- end of numbers
# param time_elapsed -- numeric vector of time elapsed (ex. 0, 2, 4...)
add_initial_metrics <- function(df, start, end, time_elapsed) {
  df$mean <- apply(df[start:end], 1, mean)
  df$min <- apply(df[start:end], 1, min)
  df$max <- apply(df[start:end], 1, max)
  df$AUC_trapezoidal_integration <- apply(df[start:end], 1, function(x) trapz(time_elapsed, x)) #correct AUC? boundary correction for trapezoidal integration? ?trapz
  df$time_to_max <- apply(df[start:end], 1, function(x) time_elapsed[which.max(x)])
  df$time_to_min <- apply(df[start:end], 1, function(x) time_elapsed[which.min(x)])
  df$delta_min_max <- apply(df[start:end], 1, function(x) (max(x)-min(x)))
  df$delta_start_finish <- apply(df[start:end], 1, function(x) (x[24]-x[1]))
  df$most_positive_slope <- apply(df[start:end], 1, function(x) (get_slope_info(time_elapsed,x)[1]))
  df$time_to_most_positive_slope <- apply(df[start:end], 1, function(x) (get_slope_info(time_elapsed,x)[2]))
  df$most_negative_slope <- apply(df[start:end], 1, function(x) (get_slope_info(time_elapsed,x)[3]))
  df$time_to_most_negative_slope <- apply(df[start:end], 1, function(x) (get_slope_info(time_elapsed,x)[4]))
  df$empty <- apply(df, 1, function(x) (grepl("Empty", x[1]))) #negative control (T/F) 
  df$empty <- recode(df$empty, "TRUE='Negative Control'; FALSE='Treatment'", as.factor.result = TRUE)
  return(df)
}

# Function to add metrics to the data, comparing each sparkline to the negative control (NC)

# param df -- data frame of...
add_initial_metrics_diff_to_NC <- function(df) {
  
}

#function to get features only
#@param df -- data frame 
get_features <- function(df) {
  df <- unique(df[, !names(df) %in% c("time_elapsed", "phenotype_value")])
  return(df)
}


#END FUNCTIONS



# load the data from Giovanni (C2C12_tunicamycin_output.csv), which is all the data from 1833 compounds, 
# created by the _____ script
#!!!!!!!!!!!!!!!!!!!! replace filename of data frame with the correct filename !!!!!!!!!!!!!!!!!!!
data_from_reconfigure <- read.csv(file=data_file, header=T, check.names=F, row.names=1)

# preliminary processing on data
confluency_sytoxG_data_prelim_proc <- preliminary_processing(data_from_reconfigure)

# add initial metrics
confluency_sytoxG_data <- add_initial_metrics(confluency_sytoxG_data_prelim_proc, 
                                              which(colnames(confluency_sytoxG_data_prelim_proc)==first_timepoint), 
                                              which(colnames(confluency_sytoxG_data_prelim_proc)==last_timepoint), 
                                              seq(as.numeric(first_timepoint),as.numeric(last_timepoint),as.numeric(time_interval)))

# add drugbank data??


# reshape to tall data frame
confluency_sytoxG_data <- melt(confluency_sytoxG_data, measure.vars=(colnames(confluency_sytoxG_data)[which(colnames(confluency_sytoxG_data)==first_timepoint):which(colnames(confluency_sytoxG_data)==last_timepoint)]))
colnames(confluency_sytoxG_data)[colnames(confluency_sytoxG_data) == "variable"] <- "time_elapsed"
colnames(confluency_sytoxG_data)[colnames(confluency_sytoxG_data) == "value"] <- "phenotype_value"
confluency_sytoxG_data$time_elapsed <- as.numeric(as.character(confluency_sytoxG_data$time_elapsed)) #convert factor to number for time_elapsed column




# add metrics to compare each sparkline to the negative controls




# Get confidence intervals on negative control data for each phenotypic marker
confidence_intervals <- NULL
for (i in 1:length(phenotypic_markers)) {
  new_confidence_intervals <- as.data.frame(t(get_confidence_intervals_neg_controls(confluency_sytoxG_data_prelim_proc, phenotypic_markers[i], 
                                                                                which(colnames(confluency_sytoxG_data_prelim_proc) == first_timepoint), 
                                                                                which(colnames(confluency_sytoxG_data_prelim_proc) == last_timepoint))))
  colnames(new_confidence_intervals) <- paste0("phenotype_value.NC.",colnames(new_confidence_intervals))
  new_confidence_intervals$time_elapsed <- rownames(new_confidence_intervals)
  new_confidence_intervals$phenotypic_Marker <- phenotypic_markers[i]
  confidence_intervals <- rbind(confidence_intervals, new_confidence_intervals)
}

# Add confidence intervals to data 
confluency_sytoxG_data <- merge(confluency_sytoxG_data, confidence_intervals, by = c("time_elapsed", "phenotypic_Marker"), all=T, sort=F)
confluency_sytoxG_data <- tbl_df(confluency_sytoxG_data)
confluency_sytoxG_data <- confluency_sytoxG_data %>% #arrange by compound name, time elapsed
  arrange(Compound, phenotypic_Marker, time_elapsed)

# Make calculations using comparisons to negative controls
confluency_sytoxG_data$phenotypic_value.diff.to.NC.upper <- confluency_sytoxG_data$phenotype_value - confluency_sytoxG_data$phenotype_value.NC.upper
sum_diff.to.NC.upper <- aggregate(confluency_sytoxG_data, by=list(Compound,phenotypic_value.diff.to.NC.upper), FUN=sum)

# Get time_x_distance data for each compound
confluency_sytoxG_data$time_x_distance <- get_time_x_distance(confidence_intervals_SG, confidence_intervals_confluency, confluency_sytoxG_data, which(colnames(confluency_sytoxG_data) == "0"), which(colnames(confluency_sytoxG_data) == "46"), 2)









# get separated data for each phenotypic marker
sytoxG_data <- subset(confluency_sytoxG_data, phenotypic_Marker == "SG")
confluency_data <- subset(confluency_sytoxG_data, phenotypic_Marker == "Con")

# get features
sytoxG_data_features <- get_features(sytoxG_data)
confluency_data_features <- get_features(confluency_data)

# save
save(confluency_sytoxG_data_prelim_proc, file=paste(dir,"DataObjects/confluency_sytoxG_data_prelim_proc.R",sep=""))
save(sytoxG_data, file=paste(dir,"DataObjects/sytoxG_data.R",sep=""))
save(confluency_data, file=paste(dir,"DataObjects/confluency_data.R",sep=""))
save(sytoxG_data_features, file=paste(dir,"DataObjects/sytoxG_data_features.R",sep=""))
save(confluency_data_features, file=paste(dir,"DataObjects/confluency_data_features.R",sep=""))
save(confluency_sytoxG_data, file=paste(dir,"DataObjects/confluency_sytoxG_data.R",sep=""))

# export to tsv
write.table(confluency_sytoxG_data, file = paste(dir,"DataOutput/confluency_sytoxG_data.tsv",sep=""), 
            append = FALSE, quote = FALSE, sep = "\t", eol = "\n", na = "NA", dec = ".", row.names = TRUE, col.names = NA)
