# Plot heatmap of time series data for each compound, for SG data only.
library(gplots)
library(ggplot2)
library(RColorBrewer)
library(grid)
library(gridExtra)

# Load data.
# dir = "/Users/mas29/Documents/ClarkeLab_github/"
dir = "/Users/maiasmith/Documents/SFU/ClarkeLab/ClarkeLab_github/"
load(file=paste(dir,"DataObjects/confluency_sytoxG_data_prelim_proc.R",sep=""))

# Parameters
start_index <- which(colnames(confluency_sytoxG_data_prelim_proc) == "0")
end_index <- which(colnames(confluency_sytoxG_data_prelim_proc) == "46")
num_time_intervals <- length(unique(sytoxG_data$time_elapsed)) # Number of time intervals
num_clusters <- 12

# Confidence interval bounds
confidence_intervals_SG <- sytoxG_data[1:num_time_intervals,c("time_elapsed", "phenotype_value.NC.upper", "phenotype_value.NC.mean", "phenotype_value.NC.lower")]

# Get Sytox Green raw time series data only, for all compounds (including negative controls)
data_for_heatmap <- confluency_sytoxG_data_prelim_proc[confluency_sytoxG_data_prelim_proc$phenotypic_Marker == "SG", start_index:end_index]
rownames(data_for_heatmap) <- confluency_sytoxG_data_prelim_proc[confluency_sytoxG_data_prelim_proc$phenotypic_Marker == "SG",]$Compound
data_matrix <- as.matrix(data_for_heatmap)

# Get distances (Euclidean) and clusters
distMatrix <- dist(data_matrix, method="euclidean")
hr <- hclust(distMatrix, method="average")

# Cut the tree and create color vector for clusters.
mycl <- cutree(hr, k = num_clusters) # Clusters assigned to each compound.
mycolhc <- rainbow(length(unique(mycl)), start=0.1, end=0.9)
mycolhc <- mycolhc[as.vector(mycl)] 
# 
# # Creates heatmap for entire data set -- obtained clusters are indicated in the color bar.
# 
# my_palette <- colorRampPalette(c("red", "white", "green"))(n = 299)
# heatmap.2(data_matrix, 
#           Rowv=as.dendrogram(hr), 
#           Colv=NULL, 
#           density.info="none", 
#           trace="none", 
#           col=my_palette, 
#           dendrogram = "row",
#           RowSideColors=mycolhc,
#           cexRow = 0.8, 
#           cexCol = 0.8, 
#           srtCol = 45,
#           main = "Heatmap of Sytox Green Data for All Compounds")
# 
# # Print color key for cluster assignments. (Numbers beside color boxes correspond to the cluster numbers in 'mycl').
# names(mycolhc) <- names(mycl); 
# barplot(rep(10, max(mycl)), col=unique(mycolhc[hr$labels[hr$order]]), horiz=T, names=unique(mycl[hr$order])) 

# Plot all clusters
compound_clusters <- as.data.frame(mycl)
colnames(compound_clusters) <- "cluster"
compound_clusters$cluster <- as.factor(compound_clusters$cluster)
sytoxG_data_w_clusters <- merge(sytoxG_data, compound_clusters, by.x="Compound", by.y="row.names")

ggplot(sytoxG_data_w_clusters) +
  geom_line(aes(x=as.numeric(time_elapsed), y=as.numeric(phenotype_value), group=Compound, text=Compound)) +
  geom_ribbon(data = confidence_intervals_SG, mapping = aes(x = time_elapsed, ymin = phenotype_value.NC.lower, ymax = phenotype_value.NC.upper,
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
        strip.text.x = element_text(size=4),
        axis.text = element_blank())