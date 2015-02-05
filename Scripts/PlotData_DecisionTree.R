# install.packages("ggplot2")
# install.packages("grid")
# install.packages("plyr")
# install.packages("rpart.plot")
# install.packages("rattle")
library(ggplot2)
library("grid")
library(plyr)
library(rpart)
library(rpart.plot)  
library(rattle)

#set paths
dir = "/Users/maiasmith/Documents/SFU/ClarkeLab/ClarkeLab_github/"
# dir = "/Users/mas29/Documents/ClarkeLab_github/"

## load datasets

sm_ds_for_dt <- sytoxG_data_features[sample(1:nrow(sytoxG_data_features), 50),]

# grow tree 
fit <- rpart(delta_min_max ~ Form + Targets + Pathway + empty + M.w.+ Max.Solubility.in.DMSO..mM., 
             method="anova", data=sm_ds_for_dt)

fit <- rpart(Targets ~ delta_min_max + min + max + time_to_min + time_to_max + most_positive_slope + time_to_most_positive_slope +
               most_negative_slope + time_to_most_negative_slope, method = "class", data=sytoxG_data_features)



printcp(fit) # display the results 
print(fit)
prp(fit)
plotcp(fit) # visualize cross-validation results 
summary(fit) # detailed summary of splits

# create additional plots 
par(mfrow=c(1,2)) # two plots on one page 
rsq.rpart(fit) # visualize cross-validation results    

# plot of tree 
prp(fit)
fancyRpartPlot(fit)

# prune the tree 
pfit<- prune(fit, cp=0.01160389) # from cptable   

# plot the pruned tree 
plot(pfit, uniform=TRUE, 
     main="Pruned Regression Tree for Mileage")
text(pfit, use.n=TRUE, all=TRUE, cex=.8)
post(pfit, file = "c:/ptree2.ps", 
     title = "Pruned Regression Tree for Mileage")