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
