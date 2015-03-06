# Performing stats with LIMMA.
library(reshape2)
library(limma)
library(ggplot2)

# Find out if any plates are outliers.

dir = "/Users/maiasmith/Documents/SFU/ClarkeLab/ClarkeLab_github/"
#dir = "C:/Users/Dave/Documents/SFU job/Lab - muscle signaling/Dixon - myocyte expts/Maia Smith files/ClarkeLab_github/"
#dir = "/Users/mas29/Documents/ClarkeLab_github/"

load(file=paste(dir,"DataObjects/confluency_sytoxG_data.R",sep=""))
data_for_stats <- confluency_sytoxG_data

##### Is there a significant difference between time points? ####
sig_level <- 0.05
#  --> For SG? 
fit_SG <- lm(phenotype_value ~ as.factor(time_elapsed), data_for_stats, subset = phenotypic_Marker == "SG")
print(summary(fit_SG))
summary <- as.data.frame(summary(fit_SG)$coef)
first_sig_timepoint <- rownames(summary[summary[,"Pr(>|t|)"] < sig_level,])[2]
print(paste("The first significant time point for Sytox Green after the hour 0 is hour ",gsub("as.factor\\(time_elapsed\\)","",first_sig_timepoint),".",sep=""))
#  --> For Confluency?
fit_con <- lm(phenotype_value ~ as.factor(time_elapsed), data_for_stats, subset = phenotypic_Marker == "Con")
print(summary(fit_con))
summary <- as.data.frame(summary(fit_con)$coef)
first_sig_timepoint <- rownames(summary[summary[,"Pr(>|t|)"] < sig_level,])[2]
print(paste("The first significant time point for Confluency after the hour 0 is hour ",gsub("as.factor\\(time_elapsed\\)","",first_sig_timepoint),".",sep=""))



##### is there a significant difference between plates? Use negative controls to figure out. ####
# Get only negative controls
data_no_NC <- sytoxG_data[sytoxG_data$empty == "Negative Control", c("Compound","Plate","time_elapsed", "phenotype_value")]
data_no_NC$id <- paste(data_no_NC$Compound, "_t", data_no_NC$time_elapsed, sep="")

# Get data matrix
data_matrix <- as.data.frame(t(data_no_NC$phenotype_value))
colnames(data_matrix) <- data_no_NC$id 

# Get design matrix
design <- data_no_NC

# Get fit
design_matrix <- model.matrix(~Plate + time_elapsed, design)
library(limma)
fit <- lmFit(data_matrix, design_matrix)
fit <- eBayes(fit)
topTable(fit)

# design <- model.matrix(~Plate)
# fit <- lmFit(??, design)
# fit <- eBayes(fit)
# topTable(fit)

##### is there a significant difference between pathways with respect to the control? ####
# --> SG
fit_SG <- lm(AUC_trapezoidal_integration ~ Pathway, data_for_stats, subset = phenotypic_Marker == "SG")
summary <-  as.data.frame(summary(fit_SG)$coef)
sig_level <- 0.01
sig_pathways_SG <- rownames(summary[summary[,"Pr(>|t|)"] < sig_level,])
sig_pathways_SG <- gsub("Pathway","",sig_pathways_SG)
print(paste("The following pathways have an AUC for Sytox Green significantly different (p < ",sig_level,") from the negative controls' AUC?",sep=""))
print(sig_pathways_SG[2:length(sig_pathways_SG)])
# --> Con
fit_Con <- lm(AUC_trapezoidal_integration ~ Pathway, data_for_stats, subset = phenotypic_Marker == "Con")
summary <-  as.data.frame(summary(fit_Con)$coef)
sig_level <- 0.01
sig_pathways_Con <- rownames(summary[summary[,"Pr(>|t|)"] < sig_level,])
sig_pathways_Con <- gsub("Pathway","",sig_pathways_Con)
print(paste("The following pathways have an AUC for Confluency significantly different (p < ",sig_level,") from the negative controls' AUC?",sep=""))
print(sig_pathways_Con[2:length(sig_pathways_Con)])


##### is there a significant difference between targets with respect to the control? ####
# --> SG
fit_SG <- lm(AUC_trapezoidal_integration ~ Targets, data_for_stats, subset = phenotypic_Marker == "SG")
summary <-  as.data.frame(summary(fit_SG)$coef)
sig_level <- 1e-20
sig_targets_SG <- rownames(summary[summary[,"Pr(>|t|)"] < sig_level,])
sig_targets_SG <- gsub("Targets","",sig_targets_SG)
print(paste("The following targets have an AUC for Sytox Green significantly different (p < ",sig_level,") from the negative controls' AUC?",sep=""))
print(sig_targets_SG[2:length(sig_targets_SG)])
# --> Con
fit_Con <- lm(AUC_trapezoidal_integration ~ Targets, data_for_stats, subset = phenotypic_Marker == "Con")
summary <-  as.data.frame(summary(fit_Con)$coef)
sig_level <- 1e-20
sig_targets_Con <- rownames(summary[summary[,"Pr(>|t|)"] < sig_level,])
sig_targets_Con <- gsub("Targets","",sig_targets_Con)
print(paste("The following targets have an AUC for Confluency significantly different (p < ",sig_level,") from the negative controls' AUC?",sep=""))
print(sig_targets_Con[2:length(sig_targets_Con)])






######################## WORKING OUT KINKS ############################

# # is there a significant difference between confluency and SG?
# fit <- lm(phenotype_value ~ phenotypic_Marker, data_for_stats)
# summary(fit)
# # Check
# (sampMeans <- aggregate(phenotype_value ~ phenotypic_Marker, data_for_stats, FUN = mean))
# with(sampMeans, phenotype_value[phenotypic_Marker == "SG"] - phenotype_value[phenotypic_Marker == "Con"])
# 
# # is there a significant difference between plates for SG? For each timepoint?
# data_for_stats$Plate <- as.factor(data_for_stats$Plate)
# fit <- lm(phenotype_value ~ Plate, data_for_stats, subset = phenotypic_Marker == "SG")
# summary(fit)
# # Check
# (sampMeans <- aggregate(phenotype_value ~ Plate, data_for_stats, FUN = mean, subset = phenotypic_Marker == "SG"))
# with(sampMeans, phenotype_value[Plate == "2"] - phenotype_value[Plate == "1"])
# # Find observed difference bewteen Plate 3 and 2
# contMat <- c()
# (obsDiff <- contMat %*% coef(fit))
# 
# # is the curve significantly different from the normal?
# 
# # don't need this df right?
# load(file=paste(dir,"DataObjects/confluency_sytoxG_data_prelim_proc.R",sep=""))
# data_for_stats <- melt(confluency_sytoxG_data_prelim_proc, id=colnames(confluency_sytoxG_data_prelim_proc)[1:17], variable.name="time_elapsed", value.name="phenotype_value")
# 
# 
# 
# ##### is there a significant difference between plates? ####
# # !!!! we want the differences AMONG plates, not with respect to a reference
# data_for_stats$time_elapsed <- as.numeric(as.character(data_for_stats$time_elapsed))
# 
# # --> SG
# # Which fit to use? Polynomial order 5, or 4? (I'm hesitant to go any higher.)
# fit_SG_4 <- lm(phenotype_value ~ 0 + Plate + (time_elapsed + I(time_elapsed^2) + I(time_elapsed^3) + I(time_elapsed^4)), 
#                data_for_stats, subset = phenotypic_Marker == "SG")
# fit_SG_5 <- lm(phenotype_value ~ 0 + Plate + (time_elapsed + I(time_elapsed^2) + I(time_elapsed^3) + I(time_elapsed^4) + I(time_elapsed^5)), 
#                data_for_stats, subset = phenotypic_Marker == "SG")
# 
# anova(fit_SG_5, fit_SG_4)
# # Ok let's use 5.
# 
# fit_SG <- lm(phenotype_value ~ 0 + Plate + (time_elapsed + I(time_elapsed^2) + I(time_elapsed^3) + I(time_elapsed^4) + I(time_elapsed^5)), 
#              data_for_stats, subset = phenotypic_Marker == "SG")
# summary(fit_SG)
# 
# # --> Confluency
# # Which fit to use? Polynomial order 5, or 4? (I'm hesitant to go any higher.)
# fit_Con_4 <- lm(phenotype_value ~ 0 + Plate + (time_elapsed + I(time_elapsed^2) + I(time_elapsed^3) + I(time_elapsed^4)), 
#                 data_for_stats, subset = phenotypic_Marker == "Con")
# fit_Con_5 <- lm(phenotype_value ~ 0 + Plate + (time_elapsed + I(time_elapsed^2) + I(time_elapsed^3) + I(time_elapsed^4) + I(time_elapsed^5)), 
#                 data_for_stats, subset = phenotypic_Marker == "Con")
# 
# anova(fit_Con_5, fit_Con_4)
# # Ok let's use 5.
# 
# fit_Con <- lm(phenotype_value ~ 0 + Plate + (time_elapsed + I(time_elapsed^2) + I(time_elapsed^3) + I(time_elapsed^4) + I(time_elapsed^5)), 
#               data_for_stats, subset = phenotypic_Marker == "Con")
# summary(fit_Con)
# 
# 
# ##### is there a significant difference between plates? ####
# # !!!! we want the differences AMONG plates, not with respect to a reference
# 
# # --> SG
# # Which fit to use? Polynomial order 5, or 4? (I'm hesitant to go any higher.)
# fit_SG_4 <- lm(phenotype_value ~ 0 + Plate + (time_elapsed + I(time_elapsed^2) + I(time_elapsed^3) + I(time_elapsed^4)), 
#                data_for_stats, subset = phenotypic_Marker == "SG")
# fit_SG_5 <- lm(phenotype_value ~ 0 + Plate + (time_elapsed + I(time_elapsed^2) + I(time_elapsed^3) + I(time_elapsed^4) + I(time_elapsed^5)), 
#                data_for_stats, subset = phenotypic_Marker == "SG")
# 
# anova(fit_SG_5, fit_SG_4)
# # Ok let's use 5.
# 
# fit_SG <- lm(phenotype_value ~ 0 + Plate + (time_elapsed + I(time_elapsed^2) + I(time_elapsed^3) + I(time_elapsed^4) + I(time_elapsed^5)), 
#              data_for_stats, subset = phenotypic_Marker == "SG")
# summary(fit_SG)
# 
# # --> Confluency
# # Which fit to use? Polynomial order 5, or 4? (I'm hesitant to go any higher.)
# fit_Con_4 <- lm(phenotype_value ~ 0 + Plate + (time_elapsed + I(time_elapsed^2) + I(time_elapsed^3) + I(time_elapsed^4)), 
#                 data_for_stats, subset = phenotypic_Marker == "Con")
# fit_Con_5 <- lm(phenotype_value ~ 0 + Plate + (time_elapsed + I(time_elapsed^2) + I(time_elapsed^3) + I(time_elapsed^4) + I(time_elapsed^5)), 
#                 data_for_stats, subset = phenotypic_Marker == "Con")
# 
# anova(fit_Con_5, fit_Con_4)
# # Ok let's use 5.
# 
# fit_Con <- lm(phenotype_value ~ 0 + Plate + (time_elapsed + I(time_elapsed^2) + I(time_elapsed^3) + I(time_elapsed^4) + I(time_elapsed^5)), 
#               data_for_stats, subset = phenotypic_Marker == "Con")
# summary(fit_Con)


# Get only negative controls
data_no_NC <- confluency_sytoxG_data_prelim_proc[confluency_sytoxG_data_prelim_proc$Pathway == "NegControl",]

# Get data matrix
start_index <- which(colnames(data_no_NC) == "0")
end_index <- ncol(data_no_NC)
data_matrix <- as.data.frame(t(data_no_NC[,c(start_index:end_index)]))
colnames(data_matrix) <- data_no_NC$Compound

# Get design matrix
compound_index <- which(colnames(data_no_NC) == "Compound")
plate_index <- which(colnames(data_no_NC) == "Plate")
time_elapsed_index <- which(colnames(data_no_NC) == "time_elapsed")
design <- data_no_NC[,c(compound_index, time_elapsed_index, plate_index)]

# Get fit
design_matrix <- model.matrix(~Plate + time_elapsed, design)
library(limma)
fit <- lmFit(data_matrix, design_matrix)
fit <- eBayes(fit)
topTable(fit)