library(xlsx)
library(stringr)
library(plyr)
require(pracma)
library(dplyr)
library(tidyr)
library(reshape)
library(car)
library(Rmisc)
library(reshape2)

# Parameters in Configure.R script
# source("Scripts/Configure.R")

#FUNCTIONS

#function to get the data formatted correctly, replace individual na_values, remove entirely NA rows, and other preliminary processing
preliminary_processing <- function(df) {
  
  colnames(df)[1] <- "Compound"
  
  # Indeces of phenotypic markers in data frame
  pheno_marker_indeces <- which(colnames(df) == "phenotypic_Marker")
  
  # For each phenotypic marker, get a new data frame
  df_each_marker <- list()
  for (i in 1:length(pheno_marker_indeces)) {
    if (i == length(pheno_marker_indeces)) { # if we're at the last phenotypic marker 
      df_new_marker <- df[ , c(1:which(colnames(df) == "Screen"), pheno_marker_indeces[i]:ncol(df))]
    } else { # if not
      df_new_marker <- df[ , c(1:which(colnames(df) == "Screen"), pheno_marker_indeces[i]:(pheno_marker_indeces[i+1]-1))]
    }
    df_each_marker[[i]] <- df_new_marker
  }
  
  # Bind all marker data frames together
  df <- do.call("rbind", df_each_marker)
  df <- df[,colSums(is.na(df))<nrow(df)] #remove columns where ALL values are NA
  
  ### Turn factors to characters before string edits, and turn al NA's to "NA" as a string, otherwise errors occur ###
  for (i in 1:(which(colnames(df) == "phenotypic_Marker")[1]-1)) {
    if (class(df[[i]]) == "factor") {
      df[[i]] <- as.character(df[[i]])
      df[[i]][which(is.na(df[[i]]))] <- "NA" # Turn all NA's to "NA" as string, otherwise, errors occur.
    }
  }
  
  # Add a "NegControl" pathway label
  df$Pathway[which(df$Compound == "Empty")] <- "NegControl"
  
  ### Turn characters to factors after string edits ###
  for (i in 1:(which(colnames(df) == "phenotypic_Marker")[1]-1)) {
    if (class(df[[i]]) == "character") {
      df[[i]] <- as.factor(df[[i]])
    }
  }
  
  # Level Negative Control as reference for pathways
  df$Pathway <- relevel(df$Pathway, ref = "NegControl")
  
  # Rename "empty" wells by appending their plate and position
  df$Compound <- as.character(df$Compound) #required for changing Empty compound names to include plate & position
  df[which(df$Compound == "Empty"),'Compound'] <- #changing Empty compound names to include plate & position
    with(df, paste(Compound, Plate, Position, sep = "_"))[which(df$Compound == "Empty")]
  df[which(colnames(df) == first_timepoint):which(colnames(df) == last_timepoint)][is.na(df[which(colnames(df) == first_timepoint):which(colnames(df) == last_timepoint)])] <- na_value #fill in NA values with na value specified (0.23, or 1/4 of a cell)
  
  # Remove invalid XML characters (ex. "\x95")
  df$Compound <- gsub("[\x01-\x1f\x7f-\xff]", "", df$Compound) 
  df$Information <- gsub("[\x01-\x1f\x7f-\xff]", "", df$Information) 
  df$Pathway <- gsub("[\x01-\x1f\x7f-\xff]", "", df$Pathway) 
  df$Targets..as.supplied. <- gsub("[\x01-\x1f\x7f-\xff]", "", df$Targets..as.supplied.) 
  
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

# Function to add various initial metrics to the data 
# (each sparkline is assessed as its own entity, for mean, min, max, etc. without regard to the negative control values)

# param df -- data frame of compounds vs raw values for phenotypic marker
# param start -- start of numbers
# param end -- end of numbers
# param time_elapsed -- numeric vector of time elapsed (ex. 0, 2, 4...)
add_initial_metrics <- function(df, start, end, time_elapsed) {
  # Add metrics
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

add_metrics_compare_to_NC <- function(prelim_df, df, phenotypic_markers, first_timepoint, last_timepoint) {
  # Get confidence intervals on negative control data for each phenotypic marker
  confidence_intervals <- NULL
  for (i in 1:length(phenotypic_markers)) {
    new_confidence_intervals <- as.data.frame(t(get_confidence_intervals_neg_controls(prelim_df, phenotypic_markers[i], 
                                                                                      which(colnames(prelim_df) == first_timepoint), 
                                                                                      which(colnames(prelim_df) == last_timepoint))))
    colnames(new_confidence_intervals) <- paste0("phenotype_value.NC.",colnames(new_confidence_intervals))
    new_confidence_intervals$time_elapsed <- rownames(new_confidence_intervals)
    new_confidence_intervals$phenotypic_Marker <- phenotypic_markers[i]
    confidence_intervals <- rbind(confidence_intervals, new_confidence_intervals)
  }
  
  # Add confidence intervals to data 
  df <- merge(df, confidence_intervals, by = c("time_elapsed", "phenotypic_Marker"), all.x=T, sort=F)
  
  # Make calculations using comparisons to negative controls:
  # Time X Distance
  get_time_x_distance <- function(phenotype_value.NC.col, upper_lower_or_mean) {
    df[,paste("phenotypic_value.diff.to.NC.",upper_lower_or_mean,sep="")] <- df$phenotype_value - df[,phenotype_value.NC.col] # Get difference to confidence interval's upper value for each timepoint
    sum_diff.to.NC <- aggregate(df[,paste("phenotypic_value.diff.to.NC.",upper_lower_or_mean,sep="")], by=list(df$Compound, df$phenotypic_Marker), FUN=sum) # Sum differences for each compound for each phenotypic marker
    colnames(sum_diff.to.NC) <- c("Compound", "phenotypic_Marker", paste("phenotypic_value.diff.to.NC.",upper_lower_or_mean,".sum",sep=""))
    # WARNING: this assumes a constant time interval between data capture times in incucyte output
    sum_diff.to.NC$time_x_distance <- sum_diff.to.NC[,paste("phenotypic_value.diff.to.NC.",upper_lower_or_mean,".sum",sep="")] * (time_elapsed[2]-time_elapsed[1]) # Multiply this sum by the time interval, to get the time X distance value (essentially, AUC of compound - AUC of neg control)
    df <- merge(df, sum_diff.to.NC, by = c("Compound", "phenotypic_Marker"), all.x=T, sort=F) # Add time x distance to data
    colnames(df)[which(colnames(df) == "time_x_distance")] <- paste("time_x_distance.",upper_lower_or_mean,sep="")
    df[,paste("phenotypic_value.diff.to.NC.",upper_lower_or_mean,".sum",sep="")] <- NULL # No point in keeping the sum of differences if we have the time X distance
    return(df)
  }
  
  df <- get_time_x_distance("phenotype_value.NC.upper", "upper")
  df <- get_time_x_distance("phenotype_value.NC.mean", "mean")
  df <- get_time_x_distance("phenotype_value.NC.lower", "lower")
  
  df <- tbl_df(df) %>% #arrange by compound name, time elapsed
    arrange(Compound, phenotypic_Marker, time_elapsed)
  
  return(df)
}

# Function to find the first time point at which the curve overtakes the upperbound and lowerbound of the negative controls confidence intervals

# @param df -- data frame after metrics are added, and compared to negative controls
get_timepoints_of_phenotype_value_overtaking_NC <- function(df) {
  upper <- by(df, list(phenotypic_Marker = df$phenotypic_Marker, Compound = df$Compound), function(x) {
    # Get the timepoint where:
    # a) phenotype value exceeds upperbound of negative control confidence interval
    phenotype_value_exceeds_NC_upperbound.timepoint <- x$time_elapsed[which(x$phenotypic_value.diff.to.NC.upper > 0)] 
    return(phenotype_value_exceeds_NC_upperbound.timepoint[1])
  })
  lower <- by(df, list(phenotypic_Marker = df$phenotypic_Marker, Compound = df$Compound), function(x) {
    # Get the timepoint where:
    # b) phenotype value drops below lowerbound of negative control confidence interval
    phenotype_value_falls_below_NC_lowerbound.timepoint <- x$time_elapsed[which(x$phenotypic_value.diff.to.NC.lower < 0)] 
    return(phenotype_value_falls_below_NC_lowerbound.timepoint[1])
  })
  upper <- melt(rbind(upper))
  colnames(upper) <- c("phenotypic_Marker", "Compound", "phenotype_value_exceeds_NC_upperbound.timepoint")
  df <- merge(df, upper, by=c("phenotypic_Marker", "Compound"))
  lower <- melt(rbind(lower))
  colnames(lower) <- c("phenotypic_Marker", "Compound", "phenotype_value_falls_below_NC_lowerbound.timepoint")
  df <- merge(df, lower, by=c("phenotypic_Marker", "Compound"))
  return(df)
}

#function to get features only
#@param df -- data frame 
get_features <- function(df) {
  df <- unique(df[, !names(df) %in% c("time_elapsed", "phenotype_value", "phenotype_value.NC.upper", "phenotype_value.NC.mean", "phenotype_value.NC.lower", 
                                      "phenotypic_value.diff.to.NC.upper", "phenotypic_value.diff.to.NC.mean", "phenotypic_value.diff.to.NC.lower")])
  return(df)
}


#END FUNCTIONS

#############################################################################################
####### --------------------------- Reformat the data ------------------------------- #######
#############################################################################################

# Get time elapsed information
last_pheno_marker_index <- tail(which(colnames(data_reconfigured) == "phenotypic_Marker"), n=1)
time_elapsed <- colnames(data_reconfigured[(last_pheno_marker_index + 1):ncol(data_reconfigured)])
first_timepoint <- head(time_elapsed, n=1)
last_timepoint <- tail(time_elapsed, n=1)
time_elapsed <- as.numeric(time_elapsed)

# preliminary processing on data (data is in wide format, hence the variable name)
data_wide <- preliminary_processing(data_reconfigured)

# Change to numeric  type
for (i in which(colnames(data_wide)==first_timepoint):which(colnames(data_wide)==last_timepoint)) {
  data_wide[,i] <- as.numeric(data_wide[,i])
}

# add initial metrics
data_tall <- add_initial_metrics(data_wide, 
                                 which(colnames(data_wide)==first_timepoint), 
                                 which(colnames(data_wide)==last_timepoint), 
                                 time_elapsed)

# reshape to tall data frame
data_tall <- melt(data_tall, measure.vars=(colnames(data_tall)[which(colnames(data_tall)==first_timepoint):which(colnames(data_tall)==last_timepoint)]))
colnames(data_tall)[colnames(data_tall) == "variable"] <- "time_elapsed"
colnames(data_tall)[colnames(data_tall) == "value"] <- "phenotype_value"
data_tall$time_elapsed <- as.numeric(as.character(data_tall$time_elapsed)) #convert factor to number for time_elapsed column

# add metrics to compare each sparkline to the negative controls
data_tall <- add_metrics_compare_to_NC(data_wide, data_tall, phenotypic_markers, first_timepoint, last_timepoint)

# find first time points at which the curve overtakes the upperbound and lowerbound on the confidence intervals for negative controls
data_tall <- get_timepoints_of_phenotype_value_overtaking_NC(data_tall)

# get separated data for each phenotypic marker
data_tall_each_marker <- list()
for (i in 1:length(phenotypic_markers)) {
  data_tall_new_marker <- subset(data_tall, phenotypic_Marker == phenotypic_markers[i])
  data_tall_each_marker[[i]] <- data_tall_new_marker
}
data_tall_each_marker <- as.list(setNames(data_tall_each_marker, phenotypic_marker_names))

# Get number of time intervals
num_time_intervals <- length(unique(data_tall$time_elapsed))

# Get confidence interval bounds for each phenotypic marker
confidence_intervals_each_marker <- list()
for (i in 1:length(phenotypic_markers)) {
  confidence_intervals_new_marker <- data_tall_each_marker[[i]][1:num_time_intervals,
                                                                c("time_elapsed", "phenotype_value.NC.upper", "phenotype_value.NC.mean", "phenotype_value.NC.lower")]
  confidence_intervals_each_marker[[i]] <- confidence_intervals_new_marker
}
confidence_intervals_each_marker <- as.list(setNames(confidence_intervals_each_marker, phenotypic_marker_names))

# Get rid of negative control data for each phenotypic marker
data_tall_no_NC_each_marker <- list()
for (i in 1:length(phenotypic_markers)) {
  data_tall_no_NC_new_marker <- data_tall_each_marker[[i]][which(data_tall_each_marker[[i]]$empty == "Treatment"),]
  data_tall_no_NC_each_marker[[i]] <- data_tall_no_NC_new_marker
}
data_tall_no_NC_each_marker <- as.list(setNames(data_tall_no_NC_each_marker, phenotypic_marker_names))

# Get features-only dataframes for each phenotypic marker
data_tall_features_each_marker <- list()
for (i in 1:length(phenotypic_markers)) {
  data_tall_features_new_marker <- get_features(data_tall_each_marker[[i]])
  data_tall_features_each_marker[[i]] <- data_tall_features_new_marker
}
data_tall_features_each_marker <- as.list(setNames(data_tall_features_each_marker, phenotypic_marker_names))

# Set phenotypic marker name correlations (ex. "Sytox Green" --> "SG")
phenotypic_markers <- setNames(phenotypic_markers, phenotypic_marker_names)
# Set image type name correlations (ex. "Phase-Contrast" --> "P")
image_types <- setNames(image_types, image_type_names)

