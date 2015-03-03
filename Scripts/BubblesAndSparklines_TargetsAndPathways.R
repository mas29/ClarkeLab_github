library(dplyr)
library(ggplot2)
library(reshape)
library(reshape2)

# set directory
dir = "/Users/maiasmith/Documents/SFU/ClarkeLab/ClarkeLab_github/"
#dir = "C:/Users/Dave/Documents/SFU job/Lab - muscle signaling/Dixon - myocyte expts/Maia Smith files/ClarkeLab_github/"
#dir = "/Users/mas29/Documents/ClarkeLab_github/"

# load the preliminarily processed data 
load(paste(dir,"DataObjects/confluency_sytoxG_data_prelim_proc.R",sep=""))

# sytoxG data only
SG <- confluency_sytoxG_data_prelim_proc %>%
  filter(phenotypic_Marker == "SG") 

# change column names so don't start with a number
colnames(SG)[which(colnames(SG)=="0"):which(colnames(SG)=="46")] <- 
  paste0("t",colnames(SG)[which(colnames(SG)=="0"):which(colnames(SG)=="46")], sep="")

# group by target and pathway, summarize mean for each time point
SG <- SG %>%
  group_by(Targets, Pathway) %>%
  summarise_each(funs(mean), t0, t2, t4, t6, t8, t10, t12, t14, t16, t18, t20, t22, t24, t26, t28, t30, 
                 t32, t34, t36, t38, t40, t42, t44, t46)

#reshape for data vis 
SG <- as.data.frame(SG)
SG <- melt(SG, id=c("Targets","Pathway"))
colnames(SG)[colnames(SG) == "variable"] <- "time_elapsed"
colnames(SG)[colnames(SG) == "value"] <- "mean_value_for_target"



SG <- tbl_df(SG)
temp <- SG %>%
  filter(Pathway == c("Cell Cycle", "Epigenetics")) %>%
  arrange(Targets)

### SOMETHING WRONG HERE -- look at data, timepoints are missing ####

scalerange <- range(temp$mean_value_for_target)
gradientends <- scalerange + rep(c(0,100,200), each=2)
colorends <- c("white", "red", "white", "green")

 (p <- ggplot(temp, aes(time_elapsed, Targets)) + 
    geom_tile(aes(fill = mean_value_for_target), colour = "white") + 
    scale_fill_gradientn(colours = colorends) + 
    scale_x_discrete("", expand = c(0, 0)) + 
    scale_y_discrete("", expand = c(0, 0)) + 
    theme_grey(base_size = 9) + 
    theme(legend.position = "none",
          axis.ticks = element_blank(), 
          axis.text.x = element_text(angle = 330, hjust = 0)))

