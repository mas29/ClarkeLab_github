# Performing stats with LIMMA.
library(reshape2)
library(limma)
library(ggplot2)

# Find out if any plates are outliers.

dir = "/Users/maiasmith/Documents/SFU/ClarkeLab/ClarkeLab_github/"
#dir = "C:/Users/Dave/Documents/SFU job/Lab - muscle signaling/Dixon - myocyte expts/Maia Smith files/ClarkeLab_github/"
#dir = "/Users/mas29/Documents/ClarkeLab_github/"

load(file=paste(dir,"DataObjects/confluency_sytoxG_data_prelim_proc.R",sep=""))
data_for_stats <- melt(confluency_sytoxG_data_prelim_proc, id=colnames(confluency_sytoxG_data_prelim_proc)[1:17], variable.name="time_elapsed", value.name="phenotype_value")

##### Is there a significant difference between time points? ####
sig_level <- 0.05
#  --> For SG? 
fit_SG <- lm(phenotype_value ~ time_elapsed, data_for_stats, subset = phenotypic_Marker == "SG")
print(summary(fit_SG))
summary <- as.data.frame(summary(fit_SG)$coef)
first_sig_timepoint <- rownames(summary[summary[,"Pr(>|t|)"] < sig_level,])[2]
print(paste("The first significant time point for Sytox Green after the hour 0 is hour ",gsub("time_elapsed","",first_sig_timepoint),".",sep=""))
#  --> For Confluency?
fit_con <- lm(phenotype_value ~ time_elapsed, data_for_stats, subset = phenotypic_Marker == "Con")
print(summary(fit_con))
summary <- as.data.frame(summary(fit_con)$coef)
first_sig_timepoint <- rownames(summary[summary[,"Pr(>|t|)"] < sig_level,])[2]
print(paste("The first significant time point for Confluency after the hour 0 is hour ",gsub("time_elapsed","",first_sig_timepoint),".",sep=""))



##### is there a significant difference between plates? ####
# !!!! we want the differences AMONG plates, not with respect to a reference
data_for_stats$time_elapsed_numeric <- as.numeric(as.character(data_for_stats$time_elapsed))

# --> SG
# Which fit to use? Polynomial order 5, or 4? (I'm hesitant to go any higher.)
fit_SG_4 <- lm(phenotype_value ~ 0 + Plate + (time_elapsed_numeric + I(time_elapsed_numeric^2) + I(time_elapsed_numeric^3) + I(time_elapsed_numeric^4)), 
             data_for_stats, subset = phenotypic_Marker == "SG")
fit_SG_5 <- lm(phenotype_value ~ 0 + Plate + (time_elapsed_numeric + I(time_elapsed_numeric^2) + I(time_elapsed_numeric^3) + I(time_elapsed_numeric^4) + I(time_elapsed_numeric^5)), 
               data_for_stats, subset = phenotypic_Marker == "SG")

anova(fit_SG_5, fit_SG_4)
# Ok let's use 5.

fit_SG <- lm(phenotype_value ~ 0 + Plate + (time_elapsed_numeric + I(time_elapsed_numeric^2) + I(time_elapsed_numeric^3) + I(time_elapsed_numeric^4) + I(time_elapsed_numeric^5)), 
             data_for_stats, subset = phenotypic_Marker == "SG")
summary(fit_SG)

# --> Confluency
# Which fit to use? Polynomial order 5, or 4? (I'm hesitant to go any higher.)
fit_Con_4 <- lm(phenotype_value ~ 0 + Plate + (time_elapsed_numeric + I(time_elapsed_numeric^2) + I(time_elapsed_numeric^3) + I(time_elapsed_numeric^4)), 
               data_for_stats, subset = phenotypic_Marker == "Con")
fit_Con_5 <- lm(phenotype_value ~ 0 + Plate + (time_elapsed_numeric + I(time_elapsed_numeric^2) + I(time_elapsed_numeric^3) + I(time_elapsed_numeric^4) + I(time_elapsed_numeric^5)), 
               data_for_stats, subset = phenotypic_Marker == "Con")

anova(fit_Con_5, fit_Con_4)
# Ok let's use 5.

fit_Con <- lm(phenotype_value ~ 0 + Plate + (time_elapsed_numeric + I(time_elapsed_numeric^2) + I(time_elapsed_numeric^3) + I(time_elapsed_numeric^4) + I(time_elapsed_numeric^5)), 
             data_for_stats, subset = phenotypic_Marker == "Con")
summary(fit_Con)


##### is there a significant difference between pathways with respect to the control? ####
# Replace "NA" pathways with "NegControl"
data_for_stats$Pathway <- as.character(data_for_stats$Pathway)
data_for_stats$Pathway[is.na(data_for_stats$Pathway)] <- "NegControl"
data_for_stats$Pathway <- as.factor(data_for_stats$Pathway)
data_for_stats$Pathway <- relevel(data_for_stats$Pathway, ref = "NegControl")

# --> SG
# Which fit to use? Polynomial order 5, or 4? (I'm hesitant to go any higher.)
fit_SG_4 <- lm(phenotype_value ~ Pathway + (time_elapsed_numeric + I(time_elapsed_numeric^2) + I(time_elapsed_numeric^3) + I(time_elapsed_numeric^4)), 
               data_for_stats, subset = phenotypic_Marker == "SG")
fit_SG_5 <- lm(phenotype_value ~ Pathway + (time_elapsed_numeric + I(time_elapsed_numeric^2) + I(time_elapsed_numeric^3) + I(time_elapsed_numeric^4) + I(time_elapsed_numeric^5)), 
               data_for_stats, subset = phenotypic_Marker == "SG")

anova(fit_SG_5, fit_SG_4)
# Ok let's use 5.

fit_SG <- lm(phenotype_value ~ Pathway + (time_elapsed_numeric + I(time_elapsed_numeric^2) + I(time_elapsed_numeric^3) + I(time_elapsed_numeric^4) + I(time_elapsed_numeric^5)), 
             data_for_stats, subset = phenotypic_Marker == "SG")
summary(fit_SG)


######################## WORKING OUT KINKS ############################

# is there a significant difference between confluency and SG?
fit <- lm(phenotype_value ~ phenotypic_Marker, data_for_stats)
summary(fit)
# Check
(sampMeans <- aggregate(phenotype_value ~ phenotypic_Marker, data_for_stats, FUN = mean))
with(sampMeans, phenotype_value[phenotypic_Marker == "SG"] - phenotype_value[phenotypic_Marker == "Con"])

# is there a significant difference between plates for SG? For each timepoint?
data_for_stats$Plate <- as.factor(data_for_stats$Plate)
fit <- lm(phenotype_value ~ Plate, data_for_stats, subset = phenotypic_Marker == "SG")
summary(fit)
# Check
(sampMeans <- aggregate(phenotype_value ~ Plate, data_for_stats, FUN = mean, subset = phenotypic_Marker == "SG"))
with(sampMeans, phenotype_value[Plate == "2"] - phenotype_value[Plate == "1"])
# Find observed difference bewteen Plate 3 and 2
contMat <- c()
(obsDiff <- contMat %*% coef(fit))

# is the curve significantly different from the normal?