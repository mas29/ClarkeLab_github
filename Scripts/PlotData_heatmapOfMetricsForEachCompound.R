# Plot heatmap of scaled metrics for each compound, for SG data only.
library(gplots)
library(RColorBrewer)

# Load data.
dir = "/Users/maiasmith/Documents/SFU/ClarkeLab/ClarkeLab_github/"
load(file=paste(dir,"DataObjects/sytoxG_data_features.R",sep=""))

# Select metrics of interest, for all compounds (no negative controls)
data_for_heatmap <- sytoxG_data_features[sytoxG_data_features$Pathway != "NegControl", 
                                         names(sytoxG_data_features) %in% c("time_x_distance", "delta_min_max", "time_to_max")]
rownames(data_for_heatmap) <- sytoxG_data_features[sytoxG_data_features$Pathway != "NegControl", 
                                                   names(sytoxG_data_features) == "Compound"]

# Scale metrics.
data_for_heatmap <- scale(data_for_heatmap)

# Draw heatmap.
my_palette <- colorRampPalette(c("red", "white", "green"))(n = 299)
heatmap.2(as.matrix(data_for_heatmap), Rowv = TRUE, Colv = TRUE, symm = F, hclustfun = hclust, dendrogram = c("row"), cexCol=0.5, cexRow=0.1, col=my_palette)
 