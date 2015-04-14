#trash code

# sytoxG_allPlates_temp <- merge(sytoxG_plate1, sytoxG_plate2, by="row.names", suffixes = c(".1", ".2"))
# sytoxG_allPlates_temp1 <- merge(sytoxG_plate3, sytoxG_plate4, by="row.names", suffixes = c(".3", ".4"))
# #add suffix to empties of plate 5 before merge
# names(sytoxG_plate5) <- ifelse(names(sytoxG_plate5) %in% "Empty", str_c(names(sytoxG_plate5), '.5'), names(sytoxG_plate5))
# sytoxG_allPlates_temp2 <- merge(sytoxG_plate5,sytoxG_allPlates_temp1, by="row.names")
# sytoxG_allPlates <- merge(sytoxG_allPlates_temp1, sytoxG_allPlates_temp1, by="row.names")
# 
# 
# sytoxG_allPlates_merge1 <- merge(sytoxG_plate1,sytoxG_plate2,by="row.names")
# sytoxG_allPlates_merge2 <- merge(sytoxG_plate3,sytoxG_plate4,by="row.names")
# sytoxG_allPlates_merge3 <- merge(sytoxG_allPlates_merge1,sytoxG_allPlates_merge2,by="row.names")
# sytoxG_allPlates <- merge(sytoxG_allPlates_merge3,sytoxG_plate5,by="row.names")

# rownames(confluency_plate1) <- time_elapsed
# rownames(confluency_plate2) <- time_elapsed
# rownames(confluency_plate3) <- time_elapsed
# rownames(confluency_plate4) <- time_elapsed
# rownames(confluency_plate5) <- time_elapsed
# 
# rownames(sytoxG_plate1) <- time_elapsed
# rownames(sytoxG_plate2) <- time_elapsed
# rownames(sytoxG_plate3) <- time_elapsed
# rownames(sytoxG_plate4) <- time_elapsed
# rownames(sytoxG_plate5) <- time_elapsed

# save(confluency_plate1, file = paste(dir,"DataObjects/confluency_plate1.R",sep=""))
# save(confluency_plate2, file = paste(dir,"DataObjects/confluency_plate2.R",sep=""))
# save(confluency_plate3, file = paste(dir,"DataObjects/confluency_plate3.R",sep=""))
# save(confluency_plate4, file = paste(dir,"DataObjects/confluency_plate4.R",sep=""))
# save(confluency_plate5, file = paste(dir,"DataObjects/confluency_plate5.R",sep=""))
# 
# save(sytoxG_plate1, file = paste(dir,"DataObjects/sytoxG_plate1.R",sep=""))
# save(sytoxG_plate2, file = paste(dir,"DataObjects/sytoxG_plate2.R",sep=""))
# save(sytoxG_plate3, file = paste(dir,"DataObjects/sytoxG_plate3.R",sep=""))
# save(sytoxG_plate4, file = paste(dir,"DataObjects/sytoxG_plate4.R",sep=""))
# save(sytoxG_plate5, file = paste(dir,"DataObjects/sytoxG_plate5.R",sep=""))

#confluency_sytoxG_all_plates_for_data_vis_w_selleck_info <- merge(confluency_sytoxG_all_plates_for_data_vis, selleck_bioactive_compound_lib, all.x=TRUE, by.x="compound", by.y="Product.Name")


#function to read in and format data
#param plate_file_names -- names of excel files with plate data
#param plate_sheet_names -- names of sheets of excel files with plate data
#param raw_data_start_row -- the excel sheet starts the raw data at which row
#param raw_data_start_col -- the excel sheet starts the raw data at which column
#param compounds_key_file_name -- name of file with compound key for each plate
#param compounds_key_sheet_names -- names of sheets of excel file with compound key for each plate
#param index -- plate we're considering
read_data <- function(plate_file_names, plate_sheet_names, raw_data_start_row, raw_data_start_col, compounds_key_file_name, compounds_key_sheet_names, index) {
  #read in raw data for plate
  raw_data <- read.xlsx(plate_file_names[index], sheetName=plate_sheet_names[index], stringsAsFactors = FALSE)
  #get data only, no excess 
  trimmed_data <- raw_data[raw_data_start_row:nrow(raw_data),raw_data_start_col:ncol(raw_data)]
  #get compound list for each plate
  compounds <- as.vector(t(read.xlsx(compounds_key_file_name, sheetName=compounds_key_sheet_names[index])))
  #format raw data such that colnames: compounds for that plate
  colnames(trimmed_data) <- compounds
  #change names of empties to reflect plate they came from
  names(trimmed_data) <- ifelse(names(trimmed_data) %in% "Empty", str_c(names(trimmed_data), '.', index), names(trimmed_data))
  return(trimmed_data)
}

#read in raw data for each plate and format it
confluency_plate_1 <- read_data(plates_raw_data_file_names, confluency_plates_raw_data_sheet_names, raw_data_start_row, raw_data_start_col, compound_key_file_name, compound_key_sheet_names, 1)
confluency_plate_2 <- read_data(plates_raw_data_file_names, confluency_plates_raw_data_sheet_names, raw_data_start_row, raw_data_start_col, compound_key_file_name, compound_key_sheet_names, 2)
confluency_plate_3 <- read_data(plates_raw_data_file_names, confluency_plates_raw_data_sheet_names, raw_data_start_row, raw_data_start_col, compound_key_file_name, compound_key_sheet_names, 3)
confluency_plate_4 <- read_data(plates_raw_data_file_names, confluency_plates_raw_data_sheet_names, raw_data_start_row, raw_data_start_col, compound_key_file_name, compound_key_sheet_names, 4)
confluency_plate_5 <- read_data(plates_raw_data_file_names, confluency_plates_raw_data_sheet_names, raw_data_start_row, raw_data_start_col, compound_key_file_name, compound_key_sheet_names, 5)

sytoxG_plate_1 <- read_data(plates_raw_data_file_names, sytoxG_plates_raw_data_sheet_names, raw_data_start_row, raw_data_start_col, compound_key_file_name, compound_key_sheet_names, 1)
sytoxG_plate_2 <- read_data(plates_raw_data_file_names, sytoxG_plates_raw_data_sheet_names, raw_data_start_row, raw_data_start_col, compound_key_file_name, compound_key_sheet_names, 2)
sytoxG_plate_3 <- read_data(plates_raw_data_file_names, sytoxG_plates_raw_data_sheet_names, raw_data_start_row, raw_data_start_col, compound_key_file_name, compound_key_sheet_names, 3)
sytoxG_plate_4 <- read_data(plates_raw_data_file_names, sytoxG_plates_raw_data_sheet_names, raw_data_start_row, raw_data_start_col, compound_key_file_name, compound_key_sheet_names, 4)
sytoxG_plate_5 <- read_data(plates_raw_data_file_names, sytoxG_plates_raw_data_sheet_names, raw_data_start_row, raw_data_start_col, compound_key_file_name, compound_key_sheet_names, 5)

#merge all plates (subset because it puts extensions on repeated columns (ex. Empty.1.1, Empty.1.2)) 
confluency_all_plates_merged <- cbind(confluency_plate_1[1:nrow(confluency_plate_1), 1:ncol(confluency_plate_1)],
                                      confluency_plate_2[1:nrow(confluency_plate_2), 1:ncol(confluency_plate_2)],
                                      confluency_plate_3[1:nrow(confluency_plate_3), 1:ncol(confluency_plate_3)],
                                      confluency_plate_4[1:nrow(confluency_plate_4), 1:ncol(confluency_plate_4)],
                                      confluency_plate_5[1:nrow(confluency_plate_5), 1:ncol(confluency_plate_5)])
sytoxG_all_plates_merged <- cbind(sytoxG_plate_1[1:nrow(sytoxG_plate_1), 1:ncol(sytoxG_plate_1)],
                                  sytoxG_plate_2[1:nrow(sytoxG_plate_2), 1:ncol(sytoxG_plate_2)],
                                  sytoxG_plate_3[1:nrow(sytoxG_plate_3), 1:ncol(sytoxG_plate_3)],
                                  sytoxG_plate_4[1:nrow(sytoxG_plate_4), 1:ncol(sytoxG_plate_4)],
                                  sytoxG_plate_5[1:nrow(sytoxG_plate_5), 1:ncol(sytoxG_plate_5)])

#get compound list for each plate
compoundFile_plate1 <- read.xlsx(compound_key_filename, sheetIndex=1)
compoundFile_plate2 <- read.xlsx(compound_key_filename, sheetIndex=2)
compoundFile_plate3 <- read.xlsx(compound_key_filename, sheetIndex=3)
compoundFile_plate4 <- read.xlsx(compound_key_filename, sheetIndex=4)
compoundFile_plate5 <- read.xlsx(compound_key_filename, sheetIndex=5)

#compounds in vector format
compounds_plate1 <- as.vector(t(compoundFile_plate1))
compounds_plate2 <- as.vector(t(compoundFile_plate2))
compounds_plate3 <- as.vector(t(compoundFile_plate3))
compounds_plate4 <- as.vector(t(compoundFile_plate4))
compounds_plate5 <- as.vector(t(compoundFile_plate5))

confluency_sytoxG_all_plates_compounds_vs_features_save_location <- paste(dir,"DataObjects/confluency_sytoxG_all_plates_compounds_vs_features.R",sep="")
confluency_sytoxG_all_plates_compounds_vs_features_w_selleck_info_save_location <- paste(dir,"DataObjects/confluency_sytoxG_all_plates_compounds_vs_features_w_selleck_info.R",sep="")
confluency_sytoxG_all_plates_for_data_vis_save_location <- paste(dir,"DataObjects/confluency_sytoxG_all_plates_for_data_vis.R",sep="")
confluency_sytoxG_all_plates_for_data_vis_w_selleck_info_save_location <- paste(dir,"DataObjects/confluency_sytoxG_all_plates_for_data_vis_w_selleck_info.R",sep="")


temp1 <- apply(confluency_all_plates_compounds_vs_features, 2, function(x) as.numeric(x))
temp2 <- apply(temp1, 1, mean)
temp <- apply(confluency_all_plates_compounds_vs_features, 1, function(x) mean(as.numeric(x)))
temp_data <- as.numeric(confluency_all_plates_compounds_vs_features[1:2,1:2])

#compute area under the curve
temp <- as.numeric(confluency_all_plates_compounds_vs_features[1,1:24])
AUC_trapezoidal_integration = trapz(time_elapsed,temp)

#find row containing value in specified column (column sytoxG_t0)
which(grepl(1.8563910, sytoxG_all_plates_compounds_vs_features$sytoxG_t0))


#function to read in and format data

#param plate_file_names -- names of excel files with plate data
#param plate_sheet_names -- names of sheets of excel files with plate data
#param raw_data_start_row -- the excel sheet starts the raw data at which row
#param raw_data_start_col -- the excel sheet starts the raw data at which column
#param compounds_key_file_name -- name of file with compound key for each plate
#param compounds_key_sheet_names -- names of sheets of excel file with compound key for each plate
#param num_plates -- number of plates

read_data <- function(plate_file_names, plate_sheet_names, raw_data_start_row, raw_data_start_col, compounds_key_file_name, compounds_key_sheet_names, num_plates) {
  merged_data <- data.frame()
  for (i in 1:num_plates) {
    #read in raw data for plate
    raw_data <- read.xlsx(plate_file_names[i], sheetName=plate_sheet_names[i], stringsAsFactors = FALSE)
    #get data only, no excess 
    trimmed_data <- raw_data[raw_data_start_row:nrow(raw_data),raw_data_start_col:ncol(raw_data)]
    #get compound list for each plate
    compounds <- as.vector(t(read.xlsx(compounds_key_file_name, sheetName=compounds_key_sheet_names[i])))
    #format raw data such that colnames: compounds for that plate
    colnames(trimmed_data) <- compounds
    #change names of empties to reflect plate they came from
    names(trimmed_data) <- ifelse(names(trimmed_data) %in% "Empty", str_c(names(trimmed_data), '.', i), names(trimmed_data))
    #merge plate data in with others (subset because it puts extensions on repeated columns (ex. Empty.1.1, Empty.1.2)) 
    merged_data <- c(merged_data, trimmed_data[1:nrow(trimmed_data), 1:ncol(trimmed_data)])
  }
  return(as.data.frame(merged_data, stringsAsFactors=F))
}

#function to reorganize the data frame s.t. compound is one row, time elapsed is one row, fluorescence/confluency 
#value is one row, whether it's "confluency" or "sytoxG" data is one row

#param df: data frame of time elapsed vs compound
#param time_elapsed: vector of time elapsed
#param datatype: "confluency" or "sytoxG"

reorg_df <- function(df, time_elapsed, datatype) {
  reorganized_df <- NULL
  for (i in 1:ncol(df)) {
    compound <- colnames(df)[i]
    compound_col <- rep(compound, nrow(df))
    type <- rep(datatype, nrow(df))
    df_to_add <- cbind(compound_col, time_elapsed, df[,i], type)
    reorganized_df <- rbind(reorganized_df, df_to_add)
  }
  colnames(reorganized_df) <- c("compound", "time_elapsed", "raw_value", "data_type")
  return(as.data.frame(reorganized_df, stringsAsFactors=FALSE))
}

set.seed(1410)
dsmall <- diamonds[sample(nrow(diamonds), 100), ]
qplot(carat, price, data = diamonds)
qplot(log(carat), log(price), data = diamonds)
qplot(carat, x*y*z, data = diamonds)
qplot(carat, price, data = dsmall, colour = color)
qplot(carat, price, data = dsmall, colour = color, geom = c("smooth"), method="loess", se=FALSE)
qplot(carat, price, data = dsmall, shape = cut)
qplot(carat, price, data = diamonds, alpha = I(1/10))
qplot(carat, price, data = diamonds, alpha = I(1/100))
qplot(carat, price, data = diamonds, geom = c("point","smooth")) #grey line is confidence interval - to turn off, se=FALSE
qplot(carat, price, data = diamonds, geom = "boxplot")
qplot(carat, price, data = diamonds, geom = "line")

#single plot
myPlot = qplot(as.numeric(rownames(sytoxG_plate1)), as.numeric(Clofarabine), data = sytoxG_plate1, 
               xlab="Time Elapsed", ylab="Clofarabine", geom="line") 
myPlot + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())

#smaller dataset
sm_dataset <- sytoxG_plate1[,1:2]

sm_dataset <- confluency_sytoxG_allPlates[1,2:25]
temp <- cbind(t(sm_dataset), as.data.frame(time_elapsed))
sm_dataset2 <- confluency_sytoxG_allPlates[2,2:25]
temp2 <- cbind(t(sm_dataset), as.data.frame(time_elapsed))
temp3 <- rbind(temp,temp2)

sm_ds_conf_syt <- confluency_sytoxG_allPlates[1,]

p = ggplot(data=sm_ds_conf_syt, aes(x=time_elapsed, y=sm_ds_conf_syt, group = 1)) + geom_line()

p0  <- 
  ggplot(temp3, aes(x=time_elapsed, y=1, group=)) +
  geom_line() +
  ggtitle("Temp curve")

p1 <- 
  ggplot(ChickWeight, aes(x=Time, y=weight, colour=Diet, group=Chick)) +
  geom_line() +
  ggtitle("Growth curve for individual chicks")

ggplot(sytoxG_plate1, aes(date)) + 
  geom_line(aes(y = var0, colour = "var0")) + 
  geom_line(aes(y = var1, colour = "var1"))

p1 <- 
  ggplot(ChickWeight, aes(x=Time, y=weight, colour=Diet, group=Chick)) +
  geom_line() +
  ggtitle("Growth curve for individual chicks")

p1 <- 
  ggplot(confluency_all_plates_for_data_vis, aes(x=as.numeric(time_elapsed), y=as.numeric(confluency_value), group=compound)) +
  geom_line() +
  xlab("Time Elapsed") +
  ylab("Confluency") +
  ggtitle("Confluency - Muscle Cells Over Time")
p1


p1 <- 
  ggplot(sytoxG_all_plates_for_data_vis, aes(x=as.numeric(time_elapsed), y=as.numeric(sytoxG_value), group=compound)) +
  geom_line() +
  xlab("Time Elapsed") +
  ylab("Sytox Green") +
  ggtitle("Sytox Green - Muscle Cells Over Time")
p1

p1 <- 
  ggplot(sytoxG_all_plates_for_data_vis, 
         aes(x=as.numeric(time_elapsed), y=as.numeric(sytoxG_value), group=compound, colour = as.numeric(max))) +
  geom_line() +
  scale_color_gradient(low="darkkhaki", high="darkgreen") +
  xlab("Time Elapsed") +
  ylab("Sytox Green") +
  ggtitle("Sytox Green - Muscle Cells Over Time") +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
p1

ggsave(p1,file="sytoxG_first_half_scaled.pdf")
ggsave(path = "./Plots", plot = last_plot(),filename = "hi",
       scale = 1, width = 1, height = 1, units = c("in"), dpi = 300, limitsize = TRUE)


strip.text.x = element_text(size=3, angle=75),
strip.text.y = element_text(size=12, face="bold"),
axis.text = element_text(size=3),
axis.ticks.length = unit(.0085, "cm"),

legend.title=element_text("horizontal"),
#get rid of text
+ theme(text = element_blank())


temp <- data.frame(Compound=as.Date(character()),
                   Catalog.No=character(), 
                   Rack.Number=character(), 
                   M.w=double(),
                   CAS.Number=integer(),
                   Form=character(),
                   Targets=character(),
                   Information=character(),
                   Smiles=character(),
                   Max.Solubility.in.DMSO..mM.=double(),
                   URL=character(),
                   Pathway=factor(),
                   Plate=integer(),
                   Position=character(),
                   Screen=character(),
                   phenotypic_Marker=factor(),
                   Elapsed=character(),
                   `0`=double(),
                   `2`=double(),
                   `4`=double(),
                   `6`=double(),
                   `8`=double(),
                   `10`=double(),
                   `12`=double(),
                   `14`=double(),
                   `16`=double(),
                   `18`=double(),
                   `20`=double(),
                   `22`=double(),
                   `24`=double(),
                   `26`=double(),
                   `28`=double(),
                   `30`=double(),
                   `32`=double(),
                   `34`=double(),
                   `36`=double(),
                   `38`=double(),
                   `40`=double(),
                   `42`=double(),
                   `44`=double(),
                   `46`=double(),
                   stringsAsFactors=FALSE) 

temp <- aggregate(phenotype_value ~ Plate * time_elapsed, sytoxG_data, FUN = mean) 
temp <- tbl_df(temp)
temp <- temp %>% 
  arrange(Plate)
# aggregate(phenotype_value ~ Plate, sytoxG_data, FUN = sd)

sm_ds$time_to_most_positive_slope <- factor(sm_ds$time_to_most_positive_slope, levels = seq(1,45,2))
sm_ds$time_to_max <- factor(sm_ds$time_to_max, levels = seq(0,46,2))


#calculate mean and sd sytoxG values for each plate
sytoxG_mean_sd <- ddply(sytoxG_data, ~ Plate * time_elapsed, summarize,
                        mean = mean(phenotype_value), sd = sd(phenotype_value))

#plot mean and sd sytoxG values for each plate
ggplot(sytoxG_mean_sd, 
       aes(x=as.numeric(time_elapsed), y=as.numeric(mean), colour = as.factor(Plate), group = Plate)) +
  geom_line(aes(size=sd)) +
  xlab("Time Elapsed") +
  ylab("Sytox Green Mean") +
  ggtitle("Sytox Green - Mean & SD") +
  theme(panel.grid = element_blank(),
        axis.ticks.length = unit(0, "cm"),
        panel.background = element_rect(fill = "white")) 


sytoxG_data %>% 
  filter(Plate == 1, time_elapsed == 0) %>%
  summarise(sd = sd(phenotype_value, na.rm = TRUE))


#sytoxG - plot mean and sd values for each plate, neg. control vs others - using geom_line()
ggplot(sytoxG_mean_sd_empty, 
       aes(x=as.numeric(time_elapsed), y=as.numeric(mean), colour = as.factor(Plate), group = Plate)) +
  geom_line(aes(size=sd)) +
  facet_grid(~ empty, scales = "fixed") +
  xlab("Time Elapsed") +
  ylab("Sytox Green Mean & SD") +
  ggtitle("Sytox Green - Plate Mean & SD (line size) & Negative Control T/F (facets)") +
  theme(panel.grid = element_blank(),
        axis.ticks.length = unit(0, "cm"),
        panel.background = element_rect(fill = "white")) 


#background continous according
#@param fill_by -- feature of dataset to fill by
#@param fill_legend_title -- name of feature of dataset for fill
plot_sparklines_fill <- function(fill_by, fill_legend_title) {
  localenv <- environment()
  ggplot(sm_ds, 
         aes(x=as.numeric(time_elapsed), y=as.numeric(phenotype_value), 
             group=Compound), environment = localenv ) +
    geom_rect(data = sm_ds, aes(xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = Inf, fill = fill_by), alpha = 0.4) +
    geom_line() +
    scale_fill_gradient2(low = "red", mid = "white", high = "red",
                         midpoint = 0, space = "rgb", na.value = "grey50", guide = "colourbar") + 
    xlab("Time Elapsed") +
    ylab("Sytox Green") +
    ggtitle("Sytox Green - Muscle Cells Over Time") +
    facet_wrap(~ Compound, ncol = 44, scales = "fixed") +
    labs(fill = fill_legend_title) +
    theme(panel.grid = element_blank(),
          strip.text=element_blank(),
          axis.text = element_blank(),
          axis.ticks.length = unit(0, "cm"),
          legend.key.height = unit(.85, "cm"),
          panel.background = element_rect(fill = "white"),
          panel.margin = unit(.085, "cm"),
          strip.background = element_rect(fill = "white"))
}

plot_sparklines_fill(delta_min_max, "Delta (max-min)")
plot_sparklines_fill(sytoxG_data$AUC_trapezoidal_integration, "AUC trapezoidal integration")

#sytoxG sparklines - free scale - lines coloured by delta max-min
ggplot(sytoxG_data, 
       aes(x=as.numeric(time_elapsed), y=as.numeric(phenotype_value), 
           group=Compound, colour = as.numeric(delta_min_max))) +
  geom_line() +
  scale_color_gradient(low="black", high="red") +
  xlab("Time Elapsed") +
  ylab("Sytox Green") +
  ggtitle("Sytox Green - Muscle Cells Over Time") +
  facet_wrap(~ Compound, ncol = 44, scales = "free") +
  labs(color = "Delta (max-min)") +
  theme(panel.grid = element_blank(),
        strip.text=element_blank(),
        axis.text = element_blank(),
        axis.ticks.length = unit(0, "cm"),
        legend.key.height = unit(.85, "cm"),
        panel.background = element_rect(fill = "white"),
        panel.margin = unit(.085, "cm"),
        strip.background = element_rect(fill = "white"))


install.packages("devtools")
install_github("plotly", "ropensci")
```{r}

library(knitr)
library(devtools)
library(plotly)
library(ggplot2)

py <- plotly("mas29", "8s6jru0os3")
url<-"https://plot.ly/~mas29/47/pathway-vs-delta-min-max/" 
plotly_iframe <- paste("<center><iframe scrolling='no' seamless='seamless' src='", url, 
                       "/650/800' width='650' height='800'></iframe></center>", sep = "")
```
`r I(plotly_iframe)`

```{r, plotly=TRUE}
dir = "/Users/maiasmith/Documents/SFU/ClarkeLab/ClarkeLab_github/"
load(paste(dir,"DataObjects/sytoxG_data_features.R",sep=""))
a <- ggplot(sytoxG_data_features, aes(delta_min_max, Pathway, text=Compound)) + 
  geom_point()

py$ggplotly(a, kwargs=list(world_readable=FALSE))
```


url<-"https://plot.ly/~mas29/68/pathway-vs-delta-min-max/" 
plotly_iframe <- paste("<center><iframe scrolling='no' seamless='seamless' style='border:none' src='", url, 
                       "/800/1200' width='800' height='1200'></iframe><center>", sep = "")

#convert factor to double for phenotypic marker value columns
for (i in 18:41) {
  confluency_sytoxG_data[,i] <- as.numeric(as.character(confluency_sytoxG_data[,i]))
}

#fill in NA values with na value specified (0.23, or 1/4 of a cell)
confluency_sytoxG_data[18:41][is.na(confluency_sytoxG_data[18:41])] <- na_value

# load source to GetData.R
source("/Users/maiasmith/Documents/SFU/ClarkeLab/ClarkeLab_github/Scripts/GetData.R")

# load the data from Giovanni (C2C12_tunicamycin_output.csv), which is all the data from 1833 compounds, 
# created by the _____ script
#!!!!!!!!!!!!!!!!!!!! replace filename of toXL data frame with the correct filename !!!!!!!!!!!!!!!!!!!
df <- read.csv(file=paste(dir,"Files/C2C12_tunicamycin_output.csv",sep=""), header=T, 
               check.names=F, row.names=1)

# preliminary processing on data
df <- preliminary_processing(df)


# load sytoxG_data file
load("/Users/maiasmith/Documents/SFU/ClarkeLab/ClarkeLab_github/DataObjects/sytoxG_data.R")

# data for curve metrics calculations
sytoxG_curve_metrics <- sytoxG_data

# work with the first compound
compound1 <- sytoxG_curve_metrics[1:24,]

#fit first degree polynomial equation:
fit1 <- lm(formula = phenotype_value ~ time_elapsed, data = compound1)
#second degree
fit2 <- lm(formula = phenotype_value~poly(time_elapsed,2,raw=TRUE), data = compound1)
#third degree
fit3 <- lm(formula = phenotype_value~poly(time_elapsed,3,raw=TRUE), data = compound1)
#fourth degree
fit4 <- lm(formula = phenotype_value~poly(time_elapsed,4,raw=TRUE), data = compound1)
#fifth degree
fit5 <- lm(formula = phenotype_value~poly(time_elapsed,5,raw=TRUE), data = compound1)

#check the significance of the bigger model
anova(fit4,fit5)

#generate 24 numbers over the range [0,46]
xx <- seq(0,46, length=24)
plot(compound1$time_elapsed, compound1$phenotype_value, pch=19)
lines(xx, predict(fit1, data.frame(x=xx)), col="red")
lines(xx, predict(fit2, data.frame(x=xx)), col="green")
lines(xx, predict(fit3, data.frame(x=xx)), col="blue")
lines(xx, predict(fit4, data.frame(x=xx)), col="purple")
lines(xx, predict(fit5, data.frame(x=xx)), col="pink")


# SG <- SG %>%
#   arrange(Pathway)

# (p <- ggplot(SG, aes(time_elapsed, Targets, color = Pathway)) + 
#    geom_tile(aes(fill = mean_value_for_target)))
#  
#  (p <- ggplot(SG, aes(time_elapsed, Targets, color = Pathway)) + 
#     geom_point(aes(size = mean_value_for_target)) +
#     theme(panel.grid = element_blank(),
#           panel.background = element_rect(fill = "white")))

# SG_for_heatmap <- dcast(SG,Targets + Pathway ~ time_elapsed)
# SG_for_heatmap_values <- as.matrix(SG_for_heatmap[,c(-1,-2)])
#   
# #cluster
# distance = dist(SG_for_heatmap_values, method = "euclidean")
# cluster = hclust(distance, method = "ward.D")
# 
# heatmap(
#   SG_for_heatmap_values, Rowv=as.dendrogram(cluster),
#   Colv=NA
# )

data_for_pca <- SG_features_treatment_only %>%
  select(intercept, coef1, coef2, coef3, coef4,
         M.w., Max.Solubility.in.DMSO, mean, min, max, AUC_trapezoidal_integration, time_to_max, 
         time_to_min, delta_min_max, delta_start_finish, most_positive_slope, time_to_most_positive_slope,
         most_negative_slope, time_to_most_negative_slope) 


# PCA on sytoxG data features 
# with guidance from http://www.r-bloggers.com/computing-and-visualizing-pca-in-r/

# install.packages("ggbiplot")
library(dplyr)
library(devtools)
library(ggbiplot)
install_github("ggbiplot", "vqv")

# load data
load("/Users/maiasmith/Documents/SFU/ClarkeLab/ClarkeLab_github/DataObjects/sytoxG_data_features.R")

data_for_pca <- sytoxG_data_features %>%
  select(mean, min, max, AUC_trapezoidal_integration, time_to_max, 
         time_to_min, delta_min_max, delta_start_finish, most_positive_slope, time_to_most_positive_slope,
         most_negative_slope, time_to_most_negative_slope) 

targets <- sytoxG_data_features$Targets

pathways <- sytoxG_data_features$Pathway

plates <- as.factor(sytoxG_data_features$Plate)

# # # log transform  BUT what to do with negatives...
# log_data_for_pca <- log(data_for_pca)

# PCA
pca <- prcomp(data_for_pca, center = TRUE, scale. = TRUE) 

# Standard deviations for each PC
print(pca)

# A plot of the variances associated with each PC. 
plot(pca, type = "l")

# The importance of each PC
# 1st row -- standard deviation associated with each PC. 
# 2nd row -- proportion of the variance explained by each PC 
# 3rd row -- cumulative proportion of explained variance
summary(pca)

### add curve fits values...?


g <- ggbiplot(pca, obs.scale = 1, var.scale = 1, 
              groups = pathways, ellipse = TRUE, 
              circle = TRUE)
g <- g + scale_color_discrete(name = '')
g <- g + theme(legend.direction = 'horizontal', 
               legend.position = 'top')
print(g)
py$ggplotly(g, kwargs=list(world_readable=FALSE))



# Control vs Treatment
plot <- ggplot(sytoxG_data, 
               aes(x=as.numeric(time_elapsed), y=as.numeric(phenotype_value), text=Compound,
                   group=Compound)) +
  geom_line() +
  xlab("Time Elapsed") +
  ylab("Sytox Green") +
  ggtitle("Sytox Green Over Time - Control vs Treatment") +
  facet_grid(~empty, scales = "fixed") +
  theme(panel.grid = element_blank(),
        axis.ticks.length = unit(0, "cm"),
        panel.background = element_rect(fill = "white"), 
        axis.text = element_blank())
response <- py$ggplotly(plot, kwargs=list(world_readable=FALSE, filename="SG_control_vs_treatment", fileopt="overwrite"))
url <- response$url

mf_labeller <- function(var, value){
  value <- as.character(value)
  if (var=="phenotypic_Marker") { 
    value[value=="Con"] <- "Confluency"
    value[value=="SG"]   <- "Sytox Green"
  }
  return(value)
}


# Test whether two conditions are significantly different
is_significant <- function() {
  # Perform inference for a contrast
  # The “W” shape of the expression profile for “1438786_a_at” means that the expression 
  # values for developmental stages P2 and P10 are quite similar. We could formally test 
  # whether the P2 and P10 effects are equal or, equivalently, whether their difference is 
  # equal to zero.
  
  # First extract the parameter estimates from the linear model you fit above. You did save 
  # the fit, right? If not, edit your code to do so and re-run that bit. Hint: the coef() 
  # function will pull parameter estimates out of a wide array of fitted model objects in R.
  
  fit_1438786_a_at$coef
  contMat <- c(0,1,0,-1,0)
  (obsDiff <- contMat %*% coef(fit_1438786_a_at))
  
  # Let’s check that this really is the observed difference in sample mean for the wild type mice, P2 vs. P10.
  
  (sampMeans <- aggregate(gExp ~ devStage, mDat, FUN = mean,
                          subset = gType == "wt"))
  
  with(sampMeans, gExp[devStage == "P2"] - gExp[devStage == "P10"])
  
  # Yes! Agrees with the observed difference we computed by multiplying our contrast matrix and the 
  # estimated parameters. If you don’t get agreement, you have a problem … probably with your contrast matrix.
  # 
  # Now we need the (estimated) standard error for our contrast. The variance-covariance matrix of the 
  # parameters estimated in the original model can be obtained with vcov() and is equal to [Math Processing Error].
  
  vcov(fit_1438786_a_at)
  
  # Let’s check that this is really true. If we take the diagonal elements and take their square root, 
  # they should be exactly equal to the standard errors reported for out original model. Are they?
  
  summary(fit_1438786_a_at)$coefficients[ , "Std. Error"]
  sqrt(diag(vcov(fit_1438786_a_at)))
  
  # Yes! Note for the future that you can get the typical matrix of inferential results from most 
  # fitted model objects for further computing like so:
  
  summary(fit_1438786_a_at)$coefficients
  
  # Returning to our test of the P2 vs. P10 contrast, recall that the variance-covariance matrix 
  # of a contrast obtained as Cα̂  is C(XTX)−1CTσ̂ 2.
  
  print(estSe <- t(contMat) %*% vcov(fit_1438786_a_at) %*% contMat)
  
  # Test statistic = observed effect divided by its estimated standard error.
  
  print(testStat <- obsDiff/estSe)
  
  # Compute a two-sided p-value.
  
  2 * pt(abs(testStat), df = df.residual(fit_1438786_a_at), lower.tail = FALSE)  
}

print(with(sampMeans, phenotype_value[time_elapsed == "2"] - phenotype_value[time_elapsed == "0"]))


Individual sparklines for each compound
-----------------------------------------------
  
  ![Caption for the picture.](/Users/maiasmith/Documents/SFU/ClarkeLab/ClarkeLab_github/Plots/Sparklines_by_target.jpeg)

```{r setup, include=FALSE}
opts_chunk$set(dev = 'pdf')
opts_chunk$set(out.width='3000px', dpi=800)
```


#   temp <- confluency_sytoxG_data_prelim_proc[3839,18:41]
#   temp <- rbind(temp,confidence_intervals)
#   time_x_distance <- sum(apply(temp,2,function(x) (x[1]-x[2])))

# This works, but not for SG and Con together

get_time_x_distance <- function(confidence_intervals, df, first_timepoint_index, last_timepoint_index, time_interval) {
  
  
  
  time_x_distance <- apply(df[, first_timepoint_index:last_timepoint_index],1,function(y) {
    time_interval*sum(apply(rbind(y,confidence_intervals),2,function(x) (x[1]-x[2])))
  })
  return(time_x_distance)
}

# Get time_x_distance data for each compound
confluency_sytoxG_data$time_x_distance <- get_time_x_distance(confidence_intervals_SG, confidence_intervals_confluency, confluency_sytoxG_data, which(colnames(confluency_sytoxG_data) == "0"), which(colnames(confluency_sytoxG_data) == "46"), 2)



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


# Make calculations using comparisons to negative controls:
# Time X Distance
df$phenotypic_value.diff.to.NC.upper <- df$phenotype_value - df$phenotype_value.NC.upper # Get difference to confidence interval's upper value for each timepoint
sum_diff.to.NC.upper <- aggregate(df$phenotypic_value.diff.to.NC.upper, by=list(df$Compound, df$phenotypic_Marker), FUN=sum) # Sum differences for each compound
colnames(sum_diff.to.NC.upper) <- c("Compound", "phenotypic_Marker", "phenotypic_value.diff.to.NC.upper.sum")
sum_diff.to.NC.upper$time_x_distance <- sum_diff.to.NC.upper$phenotypic_value.diff.to.NC.upper.sum * as.numeric(time_interval) # Multiply this sum by the time interval, to get the time X distance value (essentially, AUC of compound - AUC of neg control)
df <- merge(df, sum_diff.to.NC.upper, by = c("Compound", "phenotypic_Marker"), all.x=T, sort=F) # Add time x distance to data

## UPPER TIMEPOINT
temp_ds <- confluency_sytoxG_data[97:192,]
temp <- by(temp_ds, list(phenotypic_Marker = temp_ds$phenotypic_Marker, Compound = temp_ds$Compound), function(x) {
  # Get the timepoint where:
  # a) phenotype value exceeds upperbound of negative control confidence interval
  phenotype_value_exceeds_NC_upperbound.timepoint <- x$time_elapsed[which(x$phenotypic_value.diff.to.NC.upper > 0)] 
  # b) phenotype value drops below lowerbound of negative control confidence interval
  phenotype_value_falls_below_NC_lowerbound.timepoint <- x$time_elapsed[which(x$phenotypic_value.diff.to.NC.lower < 0)] 
  timepoints <- list(phenotype_value_exceeds_NC_upperbound.timepoint[1], phenotype_value_falls_below_NC_lowerbound.timepoint[1])
  return(timepoints)
})


################ WORKING OUT KINKS ##########


# To zoom into top portion:
# Convert to a dendrogram object
hor.dendro <- as.dendrogram(hr)
# Get values for the first branch
m.1 <- m[unlist(hor.dendro[[1]]),]

# Draw heatmap.
my_palette <- colorRampPalette(c("red", "white", "green"))(n = 299)
heatmap.2(data_matrix, Rowv = TRUE, Colv = TRUE, symm = F, hclustfun = hclust, dendrogram = c("row"), cexCol=0.5, cexRow=0.1, col=my_palette, 
          labCol=c("Time to Maximum", "Timepoint at which Sytox Green Value Exceeds Negative Control Upperbound", "Time X Distance to Negative Control Upperbound" ))

x11(height=6, width=2); 
x11();


# Works:
```{r setup, include=FALSE}
opts_chunk$set(comment=NA, fig.width=26, fig.height=26)
```

```{r, echo=FALSE} 
sm_ds <- sytoxG_data_no_NC[1:3400,]
ggplot(sm_ds, 
       aes(x=as.numeric(time_elapsed), y=as.numeric(phenotype_value), 
           group=Compound)) +
  geom_rect(data = sm_ds, aes(xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = Inf, fill = delta_min_max), alpha = 0.4) +
  geom_line() +
  scale_fill_gradient2(low = "red", mid = "white", high = "red",
                       midpoint = 0, space = "rgb", na.value = "grey50", guide = "colourbar") + 
  xlab("Time Elapsed") +
  ylab("Sytox Green") +
  ggtitle("Sytox Green - Muscle Cells Over Time") +
  facet_wrap(~ Compound, ncol = 43, scales = "fixed") +
  labs(fill = "Delta\n(max-min)") +
  theme(panel.grid = element_blank(),
        strip.text=element_blank(),
        axis.text = element_blank(),
        axis.ticks.length = unit(0, "cm"),
        legend.key.height = unit(.85, "cm"),
        panel.background = element_rect(fill = "white"),
        panel.margin = unit(.085, "cm"),
        axis.title.x = element_text(size = 20.5, angle = 00),
        axis.title.y = element_text(size = 20.5, angle = 90),
        title = element_text(size = 35, angle = 00),
        legend.text = element_text(size = 20.5, angle = 00))
```


#### WORKS! Just maybe not useful? 

# Select sub-cluster number(s) and generate corresponding dendrogram and sparklines.
zoom_plot_sparklines <- function(cluster_num) {
  data_matrix.sub <- data_matrix[names(mycl[mycl%in%cluster_num]),]
  
  # Sub-cluster hierarchical clustering
  distMatrix.sub <- dist(data_matrix.sub, method="euclidean")
  hrsub <- hclust(distMatrix.sub, method="average")
  
  # Create heatmap for chosen sub-cluster(s).
  heatmap <- heatmap.2(data_matrix.sub, 
                       Rowv=as.dendrogram(hrsub), 
                       Colv=NULL, 
                       density.info="none", 
                       trace="none", 
                       col=my_palette, 
                       dendrogram = "row",
                       RowSideColors=mycolhc[mycl%in%cluster_num],
                       cexRow = 0.8, 
                       cexCol = 0.8, 
                       srtCol = 45)
  
  # Create sparklines for chosen sub-cluster(s) compounds
  compounds <- rownames(data_matrix.sub)
  sytoxG_data.sub <- sytoxG_data[sytoxG_data$Compound %in% compounds,]
  ggplot(sytoxG_data.sub) +
    geom_line(aes(x=as.numeric(time_elapsed), y=as.numeric(phenotype_value), group=Compound, text=Compound)) +
    geom_ribbon(data = confidence_intervals_SG, mapping = aes(x = time_elapsed, ymin = phenotype_value.NC.lower, ymax = phenotype_value.NC.upper,
                                                              fill = "red", colour = NULL), alpha = 0.6) +
    scale_fill_manual(name = "Legend",
                      values = c('red'),
                      labels = c('Negative Control')) +
    xlab("Time Elapsed") +
    ylab("Sytox Green") +
    ggtitle(paste("Sytox Green Sparklines for Cluster ",cluster_num," Compounds",sep="")) +
    theme(panel.grid = element_blank(),
          axis.ticks.length = unit(0, "cm"),
          panel.background = element_rect(fill = "white"),
          strip.text.x = element_text(size=4),
          axis.text = element_blank())
}

zoom_plot_sparklines(5)

######

# without negative controls in clusters
# Get Sytox Green raw time series data only, for all compounds (no negative controls)
data_for_heatmap <- confluency_sytoxG_data_prelim_proc[confluency_sytoxG_data_prelim_proc$Pathway != "NegControl" 
                                                       & confluency_sytoxG_data_prelim_proc$phenotypic_Marker == "SG",
                                                       start_index:end_index]
rownames(data_for_heatmap) <- confluency_sytoxG_data_prelim_proc[confluency_sytoxG_data_prelim_proc$Pathway != "NegControl" 
                                                                 & confluency_sytoxG_data_prelim_proc$phenotypic_Marker == "SG",]$Compound
data_matrix <- as.matrix(data_for_heatmap)




# Get Sytox Green raw time series data only, for all compounds
if(neg_controls) { # INCLUDE negative controls
  data_for_heatmap <- confluency_sytoxG_data_prelim_proc[confluency_sytoxG_data_prelim_proc$phenotypic_Marker == "SG",
                                                         start_index:end_index]
  rownames(data_for_heatmap) <- confluency_sytoxG_data_prelim_proc[confluency_sytoxG_data_prelim_proc$phenotypic_Marker == "SG",]$Compound
} else { # DO NOT INCLUDE negative controls
  data_for_heatmap <- confluency_sytoxG_data_prelim_proc[confluency_sytoxG_data_prelim_proc$Pathway != "NegControl" 
                                                         & confluency_sytoxG_data_prelim_proc$phenotypic_Marker == "SG",
                                                         start_index:end_index]
  rownames(data_for_heatmap) <- confluency_sytoxG_data_prelim_proc[confluency_sytoxG_data_prelim_proc$Pathway != "NegControl" 
                                                                   & confluency_sytoxG_data_prelim_proc$phenotypic_Marker == "SG",]$Compound
  
}

get_single_feature_hist <- function(df, feature_name) {
  # Distributions to compare
  feature_NC <- df[df$empty == "Negative Control", colnames(df) == feature_name]
  feature_Treatment <- df[df$empty == "Treatment", colnames(df) == feature_name]
  
  # Plot
  plot <- ggplot() + 
    # As density
    geom_density(data = data.frame(feature_NC), aes(x = feature_NC, fill = 'Negative Control'), alpha = 0.5) + 
    geom_density(data = data.frame(feature_Treatment), aes(x = feature_Treatment, fill = 'Treatment'), alpha = 0.5) + 
    # Or as histogram
    #       geom_histogram(aes(x = feature_NC, y=..count../sum(..count..), fill = 'red'), alpha = 0.5) + 
    #       geom_histogram(aes(x = feature_Treatment, y=..count../sum(..count..), fill = 'black'), alpha = 0.5) + 
    xlab(feature_name) +
    ggtitle(feature_name) + 
    guides(fill=guide_legend(title="Legend", direction="horizontal")) +
    theme(axis.line = element_line(colour = "black"),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.border = element_blank(),
          panel.background = element_blank(),
          legend.key.width = unit(0.5, "cm")) 
  
  return(plot)
}

# Works but hardcoded :(

# Get Q-Q Plot of the negative control sample quantiles for all metrics against non-negative control sample quantiles 

# @param df -- data frame of data with metrics 
get_qqplot_sample_sample <- function(df) {
  
  delta_min_max_qq <- get_single_metric_qqplot(df, "delta_min_max")
  delta_min_max_hist <- get_single_metric_hist(df, "delta_min_max")
  time_to_max_qq <- get_single_metric_qqplot(df, "time_to_max")
  time_to_max_hist <- get_single_metric_hist(df, "time_to_max")
  time_x_distance.upper_qq <- get_single_metric_qqplot(df, "time_x_distance.upper")
  time_x_distance.upper_hist <- get_single_metric_hist(df, "time_x_distance.upper")
  time_to_most_positive_slope_qq <- get_single_metric_qqplot(df, "time_to_most_positive_slope")
  time_to_most_positive_slope_hist <- get_single_metric_hist(df, "time_to_most_positive_slope")
  mean_qq <- get_single_metric_qqplot(df, "mean")
  mean_hist <- get_single_metric_hist(df, "mean")
  min_qq <- get_single_metric_qqplot(df, "min")
  min_hist <- get_single_metric_hist(df, "min")
  AUC_trapezoidal_integration_qq <- get_single_metric_qqplot(df, "AUC_trapezoidal_integration")
  AUC_trapezoidal_integration_hist <- get_single_metric_hist(df, "AUC_trapezoidal_integration")
  
  mylegend<-g_legend(delta_min_max_hist)
  
  pushViewport(viewport(layout = grid.layout(15, 2, widths = unit(c(3,7), "null"), heights = unit(c(1, 1, 4, 1, 4, 1, 4, 1, 4, 1, 4, 1, 4, 1, 4), "null"))))
  grid.text("Sytox Green Metrics - Q-Q Plot & Histogram", vp = viewport(layout.pos.row = 1, layout.pos.col = 1:2))
  grid.text("Delta (max-min)", vp = viewport(layout.pos.row = 2, layout.pos.col = 1:2))
  print(delta_min_max_qq, vp = viewport(layout.pos.row = 3, layout.pos.col = 1))
  print(delta_min_max_hist + theme(legend.position="none"), vp = viewport(layout.pos.row = 3, layout.pos.col = 2))
  grid.text("Time To Max", vp = viewport(layout.pos.row = 4, layout.pos.col = 1:2))
  print(time_to_max_qq, vp = viewport(layout.pos.row = 5, layout.pos.col = 1))
  print(time_to_max_hist + theme(legend.position="none"), vp = viewport(layout.pos.row = 5, layout.pos.col = 2))
  grid.text("Time*Distance", vp = viewport(layout.pos.row = 6, layout.pos.col = 1:2))
  print(time_x_distance.upper_qq, vp = viewport(layout.pos.row = 7, layout.pos.col = 1))
  print(time_x_distance.upper_hist + theme(legend.position="none"), vp = viewport(layout.pos.row = 7, layout.pos.col = 2))
  grid.text("Time To Most Positive Slope", vp = viewport(layout.pos.row = 8, layout.pos.col = 1:2))
  print(time_to_most_positive_slope_qq, vp = viewport(layout.pos.row = 9, layout.pos.col = 1))
  print(time_to_most_positive_slope_hist + theme(legend.position="none"), vp = viewport(layout.pos.row = 9, layout.pos.col = 2))
  grid.text("Mean", vp = viewport(layout.pos.row = 10, layout.pos.col = 1:2))
  print(mean_qq, vp = viewport(layout.pos.row = 11, layout.pos.col = 1))
  print(mean_hist + theme(legend.position="none"), vp = viewport(layout.pos.row = 11, layout.pos.col = 2))
  grid.text("Min", vp = viewport(layout.pos.row = 12, layout.pos.col = 1:2))
  print(min_qq, vp = viewport(layout.pos.row = 13, layout.pos.col = 1))
  print(min_hist + theme(legend.position="none"), vp = viewport(layout.pos.row = 13, layout.pos.col = 2))
  grid.text("AUC (trapezoidal integration)", vp = viewport(layout.pos.row = 14, layout.pos.col = 1:2))
  print(AUC_trapezoidal_integration_qq, vp = viewport(layout.pos.row = 15, layout.pos.col = 1))
  print(AUC_trapezoidal_integration_hist + theme(legend.position="none"), vp = viewport(layout.pos.row = 15, layout.pos.col = 2))
  
}

# Plot Q-Q Plots and Densityplots for various metrics - SAMPLE VS THEORETICAL
get_qqplot_sample_sample(sytoxG_data_features)

# Making function dynamic!!!!

data_from_reconfigure[287:288,]

for FILE in $(ls *.tif); do \
for I in R G B; do \
convert -channel $I -separate -format jpg $FILE $FILE-$I.jpg ; \
done ; \
done ; \ 
rename s/\.tif\-/\-/ *.jpg


#dir = "C:/Users/Dave/Documents/SFU job/Lab - muscle signaling/Dixon - myocyte expts/Maia Smith files/ClarkeLab_github/"
# dir = "/Users/mas29/Documents/ClarkeLab_github/"



# save 
# save(confluency_sytoxG_data_prelim_proc, file=paste(dir,"DataObjects/confluency_sytoxG_data_prelim_proc.R",sep=""))
# save(sytoxG_data, file=paste(dir,"DataObjects/sytoxG_data.R",sep=""))
# save(confluency_data, file=paste(dir,"DataObjects/confluency_data.R",sep=""))
# save(sytoxG_data_features, file=paste(dir,"DataObjects/sytoxG_data_features.R",sep=""))
# save(confluency_data_features, file=paste(dir,"DataObjects/confluency_data_features.R",sep=""))
# save(confluency_sytoxG_data, file=paste(dir,"DataObjects/confluency_sytoxG_data.R",sep=""))


```{r, eval=FALSE, echo=FALSE}
ggplot(sytoxG_data, 
       aes(x=as.numeric(time_elapsed), y=as.numeric(phenotype_value), 
           group=Compound, text=Compound)) +
  geom_rect(data = sytoxG_data, aes(xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = Inf, fill = delta_min_max), alpha = 0.4) +
  geom_line() +
  scale_fill_gradient2(low = "red", mid = "white", high = "red",
                       midpoint = 0, space = "rgb", na.value = "grey50", guide = "colourbar") + 
  xlab("Time Elapsed") +
  ylab("Sytox Green") +
  ggtitle("Sytox Green Over Time") +
  facet_wrap(~ Compound, ncol = 44, scales = "fixed") +
  labs(fill = "Delta (max-min)") +
  theme(panel.grid = element_blank(),
        strip.text=element_blank(),
        axis.text = element_blank(),
        axis.ticks.length = unit(0, "cm"),
        legend.key.height = unit(.85, "cm"),
        panel.background = element_rect(fill = "white"),
        panel.margin = unit(.085, "cm"))
```


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  # Get index of phenotypic marker of interest
  marker_index <- which(phenotypic_marker_names == input$marker)
  
  # Expression that generates a sparkline for the selected compound. 
  
  output$sparklines <- renderPlot({
    
    data_tall.compound_and_marker <- subset(data_tall_no_NC_each_marker[[marker_index]], Compound == input$compound)
    
    #     sytoxG_data_no_NC.sub <- sytoxG_data_no_NC[sytoxG_data_no_NC$Compound == input$compound,] 
    #     confluency_data_no_NC.sub <- confluency_data_no_NC[confluency_data_no_NC$Compound == input$compound,] 
    
    plot(data_tall.compound_and_marker, confidence_intervals_each_marker[[marker_index]], input$marker, y_limits_SG, input$compound)
    
  })
})





#################
serverInfo


source("/Users/maiasmith/Documents/SFU/ClarkeLab/ClarkeLab_github/Scripts/GetData.R")

sytoxG_data <- data_tall_each_marker[[1]]
confluency_data <- data_tall_each_marker[[2]]
sytoxG_data_no_NC <- data_tall_no_NC_each_marker[[1]]
confluency_data_no_NC <- data_tall_no_NC_each_marker[[2]]

# Number of time intervals
num_time_intervals <- length(unique(sytoxG_data$time_elapsed))

# Get axis limits
y_limits_SG <- c(min(sytoxG_data$phenotype_value), max(sytoxG_data$phenotype_value))
y_limits_Con <- c(min(confluency_data$phenotype_value), max(confluency_data$phenotype_value))

# Function to plot 
plot <- function(df, confidence_intervals, phenotypic_marker_name, y_axis_limits, compound) {
  ggplot() +
    geom_line(data = df, aes(x=as.numeric(time_elapsed), y=as.numeric(phenotype_value), group=Compound)) +
    geom_ribbon(data = confidence_intervals, mapping = aes(x = time_elapsed, ymin = phenotype_value.NC.lower, ymax = phenotype_value.NC.upper, fill = "red", colour = NULL), alpha = 0.2) +
    scale_fill_manual(name = "Legend", values = 'red', labels = paste(phenotypic_marker_name,'\nNegative Control\n99.9% C.I.',sep="")) +
    xlab("Time Elapsed (hours)") +
    ylab(phenotypic_marker_name) +
    ggtitle(paste(phenotypic_marker_name," Levels for ",compound," Over Time",sep="")) +
    scale_y_continuous(limits = c(y_axis_limits[1], y_axis_limits[2])) +
    theme(panel.grid = element_blank(),
          strip.text=element_blank(),
          legend.key.height = unit(.85, "cm"),
          panel.background = element_rect(fill = "white"),
          panel.margin = unit(.085, "cm"))
}


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  # Get index of phenotypic marker of interest
  marker_index <- which(phenotypic_marker_names == input$marker)
  
  # Expression that generates a sparkline for the selected compound. 
  
  output$sparklines <- renderPlot({
    
    data_tall.compound_and_marker <- subset(data_tall_no_NC_each_marker[[marker_index]], Compound == input$compound)
    
    #     sytoxG_data_no_NC.sub <- sytoxG_data_no_NC[sytoxG_data_no_NC$Compound == input$compound,] 
    #     confluency_data_no_NC.sub <- confluency_data_no_NC[confluency_data_no_NC$Compound == input$compound,] 
    
    plot(data_tall.compound_and_marker, confidence_intervals_each_marker[[marker_index]], input$marker, y_limits_SG, input$compound)
    
  })
})



# Get y-axis limits
y_limits <- c(min(data_tall_each_marker[[input$marker]]$phenotype_value), max(data_tall_each_marker[[input$marker]]$phenotype_value))




# CLUSTERING THAT WORKS


---
  title: "Cluster Analysis"
author: "Maia Smith"
date: "March 24, 2015"
output: html_document
---
  
  Cluster Analysis
============
  
  Clustering is by Euclidean distance, with the features for each compound being their values at each time point.

Sytox Green
----------
  
  ```{r, echo=FALSE, fig.width=10, fig.height=10}

sytoxG_data <- data_tall_each_marker[[1]]
confluency_data <- data_tall_each_marker[[2]]

# Function to get the clustering of your data
# param prelim_df -- the df as a result of the preliminary_processing() function in the GetData script
# param df -- the df in "tall" format, for only your phenotypic marker of interest
# param phenotypic_Marker_name -- name of your phenotypic marker, as is shown in the input dataset (e.g. "SG", "Con")
# param num_clusters -- how many clusters you want
get_data_w_clusters <- function(prelim_df, df, phenotypic_Marker_name, num_clusters) {
  # Parameters
  start_index <- which(colnames(prelim_df) == "0")
  end_index <- which(colnames(prelim_df) == "46")
  num_time_intervals <- length(unique(df$time_elapsed)) # Number of time intervals
  
  # Get Sytox Green raw time series data only, for all compounds (including negative controls)
  data_for_heatmap <- prelim_df[prelim_df$phenotypic_Marker == phenotypic_Marker_name, start_index:end_index]
  rownames(data_for_heatmap) <- prelim_df[prelim_df$phenotypic_Marker == phenotypic_Marker_name,]$Compound
  data_matrix <- as.matrix(data_for_heatmap)
  
  # Get distances (Euclidean) and clusters
  distMatrix <- dist(data_matrix, method="euclidean")
  hr <- hclust(distMatrix, method="average")
  
  # Cut the tree and create color vector for clusters.
  mycl <- cutree(hr, k = num_clusters) # Clusters assigned to each compound.
  mycolhc <- rainbow(length(unique(mycl)), start=0.1, end=0.9)
  mycolhc <- mycolhc[as.vector(mycl)] 
  
  # Plot all clusters
  compound_clusters <- as.data.frame(mycl)
  colnames(compound_clusters) <- "cluster"
  compound_clusters$cluster <- as.factor(compound_clusters$cluster)
  df_w_clusters <- merge(df, compound_clusters, by.x="Compound", by.y="row.names")
}

# --> SG

# Cluster data
sytoxG_data_w_clusters <- get_data_w_clusters(data_wide, sytoxG_data, "SG", 12)

# Plot data
ggplot(sytoxG_data_w_clusters) +
  geom_line(aes(x=as.numeric(time_elapsed), y=as.numeric(phenotype_value), group=Compound, text=Compound)) +
  geom_ribbon(data = confidence_intervals_each_marker[[1]], mapping = aes(x = time_elapsed, ymin = phenotype_value.NC.lower, ymax = phenotype_value.NC.upper,
                                                                          fill = "red", colour = NULL), alpha = 0.6) +
  scale_fill_manual(name = "Legend",
                    values = c('red'),
                    labels = c('Negative Control\n99.9% C.I.')) +
  xlab("Time Elapsed") +
  ylab("Sytox Green") +
  ggtitle("Sytox Green Sparklines for Each Cluster") +
  facet_grid(empty~cluster) +
  theme(panel.grid = element_blank(),
        axis.ticks.length = unit(0, "cm"),
        panel.background = element_rect(fill = "white"),
        axis.text = element_blank())

# --> Con

# Cluster data
con_data_w_clusters <- get_data_w_clusters(data_wide, confluency_data, "Con", 12)

# Plot data
ggplot(con_data_w_clusters) +
  geom_line(aes(x=as.numeric(time_elapsed), y=as.numeric(phenotype_value), group=Compound, text=Compound)) +
  geom_ribbon(data = confidence_intervals_each_marker[[2]], mapping = aes(x = time_elapsed, ymin = phenotype_value.NC.lower, ymax = phenotype_value.NC.upper,
                                                                          fill = "red", colour = NULL), alpha = 0.6) +
  scale_fill_manual(name = "Legend",
                    values = c('red'),
                    labels = c('Negative Control\n99.9% C.I.')) +
  xlab("Time Elapsed") +
  ylab("Sytox Green") +
  ggtitle("Sytox Green Sparklines for Each Cluster") +
  facet_grid(empty~cluster) +
  theme(panel.grid = element_blank(),
        axis.ticks.length = unit(0, "cm"),
        panel.background = element_rect(fill = "white"),
        axis.text = element_blank())
```

In Plotly:
  --------
  
  ```{r, echo = FALSE, plotly=TRUE}
# --> SG
SG_cluster_analysis <- ggplot(sytoxG_data_w_clusters) +
  geom_line(aes(x=as.numeric(time_elapsed), y=as.numeric(phenotype_value), group=Compound, text=Compound)) +
  xlab("Time Elapsed") +
  ylab("Sytox Green") +
  ggtitle("Sytox Green Sparklines for Each Cluster") +
  facet_grid(empty~cluster) +
  theme(panel.grid = element_blank(),
        axis.ticks.length = unit(0, "cm"),
        panel.background = element_rect(fill = "white"),
        axis.text = element_blank())

py$ggplotly(SG_cluster_analysis, session="knitr", kwargs=list(world_readable=FALSE, filename="SG_cluster_analysis", fileopt="overwrite"))
```

```{r, echo = FALSE, plotly=TRUE}
# --> Con
Con_cluster_analysis <- ggplot(con_data_w_clusters) +
  geom_line(aes(x=as.numeric(time_elapsed), y=as.numeric(phenotype_value), group=Compound, text=Compound)) +
  xlab("Time Elapsed") +
  ylab("Confluency") +
  ggtitle("Confluency Sparklines for Each Cluster") +
  facet_grid(empty~cluster) +
  theme(panel.grid = element_blank(),
        axis.ticks.length = unit(0, "cm"),
        panel.background = element_rect(fill = "white"),
        axis.text = element_blank())

py$ggplotly(Con_cluster_analysis, session="knitr", kwargs=list(world_readable=FALSE, filename="Con_cluster_analysis", fileopt="overwrite"))
```

mainPanel(
  tabsetPanel(
    tabPanel("Sparkline", plotOutput("sparklines")), 
    tabPanel("Target",  plotOutput("target")), 
    tabPanel("Pathway", plotOutput("pathway")),
    tabPanel("Cluster", plotOutput("cluster")),
  )
  #       h6("Live Images:", br(), tags$video(src = "video.mp4", type = "video/mp4", width = "600px", height = "600px", 
  #                                           autoplay = NA, controls = "controls")),
  plotOutput("sparklines"),
  plotOutput("target"),
  plotOutput("pathway"),
  plotOutput("cluster")
)

# # Define UI 
# shinyUI(fluidPage(
#   
#   # Application title
#   titlePanel("Explore Selected Compound"),
#   
#   # Sidebar with a slider input for the number of bins
#   sidebarLayout(
#     sidebarPanel(
#       selectizeInput(
#         "compound", 'Select or Type Compound of Interest', choices = compound_list,
#         multiple = FALSE
#       ),
#       radioButtons("marker", "Phenotypic Marker:", phenotypic_marker_names),
#       sliderInput("clusters",
#                   "Number of Clusters:",
#                   min = 1,
#                   max = 25,
#                   value = 10)
#     ),
#     
#     # Show a plot of the generated distribution
#     mainPanel(
#       #       h6("Live Images:", br(), tags$video(src = "video.mp4", type = "video/mp4", width = "600px", height = "600px", 
#       #                                           autoplay = NA, controls = "controls")),
#       plotOutput("sparklines"),
#       plotOutput("target"),
#       plotOutput("pathway"),
#       plotOutput("cluster")
#     )
#   )
# ))


#     # Get cluster data for each phenotypic marker
#     data_w_clusters_each_marker <- list()
#     for (i in 1:length(phenotypic_markers)) {
#       data_w_clusters_new_marker <- get_data_w_clusters(data_wide, data_tall_each_marker[[i]], phenotypic_markers[[i]], input$clusters)
#       data_w_clusters_each_marker[[i]] <- data_w_clusters_new_marker
#     }
#     data_w_clusters_each_marker <- as.list(setNames(data_w_clusters_each_marker, phenotypic_marker_names))
#     
#     data_w_clusters_new_marker <- get_data_w_clusters(data_wide, data_tall_each_marker[[input$marker]], phenotypic_markers[[input$marker]], input$clusters)


# Generates table of additional information for the compound
output$compound_additional_info <- renderText({
  
  data_tall.compound <- subset(data_tall_no_NC_each_marker[[input$marker]], Compound == input$compound)
  M.w. <- data_tall.compound$M.w.[1]
  Target <- data_tall.compound$Target.class..11Mar15.[1]
  Max.Solubility.in.DMSO <- data_tall.compound$Max.Solubility.in.DMSO[1]
  
  paste("\n\n\nMolecular Weight = ", M.w., 
        "\nTarget = ", Target, 
        "\nMax Solubility in DMSO = ", Max.Solubility.in.DMSO)
  
  
  #     additional_info_for_compound <- data.frame(M.w. = M.w., Target = Target, Max.Solubility.in.DMSO = Max.Solubility.in.DMSO)
  #     additional_info_for_compound
})

#!!!!!!!!!!!!!!!!!!!! MUST CHANGE FROM confluency_data etc. 
confluency_data <- df[ , c(1:which(colnames(df) == last_timepoint)[1])]
sytoxG_data <- df[ , c(1:which(colnames(df) == "Screen"), which(colnames(df) == "phenotypic_Marker")[2]:ncol(df))]
df <- rbind(confluency_data,sytoxG_data)
df <- df[,colSums(is.na(df))<nrow(df)] #remove columns where ALL values are NA


# Filename and path for the output of the 1833Reconfigure2_ms_edits.R script
# ex. "/Users/maiasmith/Documents/SFU/ClarkeLab/ClarkeLab_github/Files/C2C12_tunicamycin_output_maia.csv"
data_filename <- "/Users/maiasmith/Documents/SFU/ClarkeLab/ClarkeLab_github/Files/C2C12_tunicamycin_output_maia.csv"






#Reorganizes the data from the 1833 compound screen into an excel file. 

library(MASS)
library(XLConnect)
library(gdata)
library(dataframes2xls)

# Parameters set in Configure.R script
# source("Scripts/Configure.R")

numPhenotypicMarkers <- length(phenotypic_markers) # number of phenotypic markers you're using

#Creates a column vector that contains the desired screen name.  To customzie the screen name, 
#change the variable named "screen_name" above to whatever name you want, remember to keep the name in quotations.
getScreenName <- function(){
  
  screenNamesVec <- NULL
  count = 1
  
  for(i in 1:5){
    for(j in 1:384){
      screenNamesVec[count] <- screen_name
      count = count + 1
    }
  }
  
  screenNamesVec = t(screenNamesVec)
  screenNamesVec = t(screenNamesVec)
  
  colnames(screenNamesVec) <- "Screen"
  
  return(screenNamesVec)
}

#Using a key I created that has each of the 5 384-well plates on a different tab in an excel file, this function
#lists all of the names of the compounds in an order that goes from plate 1-5 a1-a24, b1-b24...p1-p24.
reconfigureCompoundNames <- function() {
  cmpNameKey <- loadWorkbook(key_filename)
  tempList <- list()
  LIST = readWorksheet(cmpNameKey, sheet = getSheets(cmpNameKey))
  tempList[1] = list(LIST)
  
  keyList <- list()
  
  for (i in 1:length(tempList[[1]])) {
    keyList[[i]] <- data.frame(tempList[[1]][i])
  }
  
  combinedFrames <- NULL
  newColNames <- (1:24)
  
  for (i in 1:length(keyList)) {
    colnames(keyList[[i]]) <- newColNames
    combinedFrames <- rbind(combinedFrames, keyList[[i]])
  }
  
  rowLength <- length(combinedFrames[1,])
  colLength <- length(combinedFrames[,1])
  
  newRowNames <- 1:(rowLength*colLength)
  
  cmpNameVector <- NULL
  
  for(i in 1:colLength){
    vec <- combinedFrames[i,]
    vec <- t(vec)
    cmpNameVector <- rbind(cmpNameVector,vec)
  }
  
  row.names(cmpNameVector) <- newRowNames
  colnames(cmpNameVector) <- "Compound"
  
  return(cmpNameVector)
  
}

#Uses a nested for loop to create a column vector that contains all of the plate positions in the correct order.
getPlatePositions<-function(){
  
  lettersVec <- letters[1:16]
  numVec <- 1:24
  platePositions <- NULL
  count = 1
  
  for(i in 1:length(lettersVec)){
    for(j in 1:length(numVec)){
      
      position = sprintf("%s%d",lettersVec[i],numVec[j])
      platePositions[count] = position
      count = count + 1	
    }
  }
  
  platePositions = t(platePositions)
  platePositions = t(platePositions)	
  colnames(platePositions) = "Position"
  
  finalPositions <- NULL
  
  for(i in 1:5){
    finalPositions <- rbind(finalPositions, platePositions)		
  }
  
  return(finalPositions)	
}

#Uses a nested for loop to create a column vector that contains the correct plate number (1-5)
getPlateNumbers<-function(){
  
  plateNumberVec <- NULL
  count = 1
  
  for(i in 1:5){
    for(j in 1:384){
      plateNumberVec[count] <- i					
      count = count + 1	
    }
  }
  
  plateNumberVec = t(plateNumberVec)
  plateNumberVec = t(plateNumberVec)
  
  colnames(plateNumberVec) <- "Plate"
  
  return(plateNumberVec)
}


#Using the excel file specified, this function gathers all of the data listed from the 
#second tab of the excel file and reorganizes it to fit the new ordering of the compounds in the combined plates.
getDescriptions<- function(){
  
  descriptionVector <- list()
  
  descriptionKey <- read.xls(selleck_info_filename,sheet=1)
  descriptionKey <- data.frame(descriptionKey)
  #	print(descriptionKey)
  
  cmpNames <- descriptionKey[,2]
  
  plateNameVector <- reconfigureCompoundNames()
  
  for(i in 1:length(cmpNames)){
    
    currName = cmpNames[i]
    index = which(plateNameVector == currName)
    vec <- data.frame(descriptionKey[i,])
    descriptionVector[index] <- list(vec)
    
  }
  
  length(descriptionVector) = 1920
  
  for(i in 1:length(descriptionVector)){
    
    if(descriptionVector[i] == "NULL"){
      descriptionVector[i] <- "POSITIVE CONTROL"
    }	
  }
  
  combinedDescriptions <- NULL	
  normalColNames <- colnames(data.frame(descriptionVector[1]))
  replace <- LETTERS[1:13]
  
  # Changed from 13 columns to 17 columns for new updated selleck information excel doc given March 15, 2015 (Selleck_1833_LibraryAnnotation_Mar15.xlsx)
  tempRow <- matrix(c(rep.int(NA,17)), nrow = 1, ncol = 17)
  newRow <- data.frame(tempRow)	
  colnames(newRow) <- colnames <- normalColNames
  
  for(i in 1:length(descriptionVector)){
    
    temporaryVec <- data.frame(descriptionVector[i])
    if(length(temporaryVec) == 1){
      temporaryVec <- newRow
    }
    combinedDescriptions <- rbind(combinedDescriptions, temporaryVec)	
  }			
  
  # Changed from 13 columns to 17 columns for new updated selleck information excel doc given March 15, 2015 (Selleck_1833_LibraryAnnotation_Mar15.xlsx)
  combinedDescriptions <- data.frame(combinedDescriptions)
  combinedDescriptions <- combinedDescriptions[,c(1,4:17)]
  
  return(combinedDescriptions)
}


#This function extracts the raw data from the specified excel file and reformats it. The final product of this function
#will be a data frame that has 3 sections, one for each phenotypic marker.  Time will go across the x axis within each 
#dataframe.
getRawData <- function(){
  
  dataList <- list()
  
  wb <- loadWorkbook(raw_data_filename)
  LIST = readWorksheet(wb, sheet = getSheets(wb), startRow = 8)
  dataList[1] <- list(LIST)
  
  tempFrame <- data.frame(dataList[[1]][1])
  elapsedTime <- tempFrame[,2]
  
  
  rowNames <- 1:1920
  finalList <- NULL
  
  #runs once for each phenotypic marker
  for(h in 1:numPhenotypicMarkers){
    currDataFrame <- NULL
    count = h
    
    #runs once for each plate
    for(i in 1:5){
      
      frame <- data.frame(dataList[[1]][count])
      frame <- frame[,3:length(frame[1,])]
      
      startCol = 1
      #once for each letter
      for(j in 1:16){
        
        #get all columns of same letter
        for(k in 1:24){
          tempCol <- data.frame(frame[,startCol + (k-1)])
          tempCol = t(tempCol)
          colnames(tempCol) <- elapsedTime
          currDataFrame <- rbind(currDataFrame, tempCol)
        }
        startCol = startCol + 24		
      }
      count = count + numPhenotypicMarkers	
    }
    rownames(currDataFrame) <- rowNames
    finalList[h] <- list(currDataFrame)	
  }
  
  for(i in 1:numPhenotypicMarkers){
    
    phenotypic_Marker <- NULL
    phenotypic_Marker[1:1920] <- phenotypic_markers[i]
    phenotypic_Marker <- data.frame(phenotypic_Marker)
    
    if(i == 1){
      finalFrame <- data.frame(phenotypic_Marker) 	
      currFrame <- data.frame(finalList[i])
      colnames(currFrame) <- elapsedTime
      finalFrame <- cbind(finalFrame,currFrame)
    } else {
      currFrame <- phenotypic_Marker
      currFrame <- cbind(currFrame,(finalList[i]))
      colnames(currFrame[2:length(currFrame[1,])]) <- elapsedTime
      finalFrame <- cbind(finalFrame,currFrame)
    }	
  }
  
  return(finalFrame)
}


#Calls all of the other functions written in this script, and combines their outputs in the correct order.
combine<-function(){
  
  names <- reconfigureCompoundNames()
  positions<- getPlatePositions()
  plateNumbers <- getPlateNumbers()
  screenID <- getScreenName()
  cmpDescriptions <- getDescriptions()
  dataReformat <- getRawData()
  totalFrame <- cbind(names,cmpDescriptions, plateNumbers, positions,screenID, dataReformat)
  return(totalFrame)	
  
}

# Create reconfigured data, write to file
data_reconfigured <- combine()
dir.create(file.path(dir, "Output"), showWarnings = FALSE)
write.csv(data_reconfigured,file = paste(dir, "Output/data_reconfigured.csv", sep=""))




time_interval <- "2"


#       fluor_image_dir <- paste(archive_dir,expt_days[i],"/",expt_hrs_mins[[i]][j],"/",plate_name_in_archive,"/",toupper(position),fluor_suffix,sep="")
#       phase_cont_image_dir <- paste(archive_dir,expt_days[i],"/",expt_hrs_mins[[i]][j],"/",plate_name_in_archive,"/",toupper(position),phase_cont_suffix,sep="")
#       
#       fluor_img <- suppressWarnings(readTIFF(fluor_image_dir, native=TRUE))
#       writeJPEG(fluor_img, target = paste(dir,"Scripts/shiny_scripts/explore/www/C1_t_",as.character(time_elapsed[count]),".jpeg",sep=""), quality = 1)
#       phase_cont_img <- suppressWarnings(readTIFF(phase_cont_image_dir, native=TRUE))
#       writeJPEG(phase_cont_img, target = paste(dir,"Scripts/shiny_scripts/explore/www/P_t_",as.character(time_elapsed[count]),".jpeg",sep=""), quality = 1)

#   phase_cont_suffix <- "-1-P.tif" # fluorescence image suffix
#   fluor_suffix <- "-1-C1.tif" # phase-contrast image suffix

#  h6("Live Images:", br(), tags$video(src = "video.mp4", type = "video/mp4", width = "600px", height = "600px", 
#   autoplay = NA, controls = "controls"))),
# img(src = "phase_cont_t_0.jpeg", width = "696px", height = "520px")), #### SOOO FAST, but I don't know how to make it reactive....
