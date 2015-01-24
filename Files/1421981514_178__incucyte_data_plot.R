incucyte_data_plot <- function(reorg_data, n_plates, duration, intervals) {

# David C. Clarke
# Copyright 2014

# ===============================
# This function plots the phenotypes from an Incucyte time course experiment in minimal "sparklines"-style line plots organized in the 384-well format.
# "reorg_data" = reorganized data frame ("toXL") from the reorganization R-scripts.

# To use the function, copy and paste this entire script and paste into the command line in R. The function should then appear in the workspace. 
# Then enter the following into the command line, substituting your own values for each variable:
# <output_variable_name> <- incucyte_data_plot(toXL, 5, 46, 2)
# ===============================

# v1: October 3, 2014
# Future changes: add more phenotypes, write figures directly to pdf files, add text labeling in margins, color plot box for ez id of off-scale plots, automate the time variable determination,

# ===============================

# Create the time variable:
time = seq(0, duration, by=intervals);

# Create bases for y-axis scales for each phenotype:

# For confluency, set y-axis scale with the low scale value = minimum rounded down to nearest 5 and a max value of 100:
yaxis_scale_conf <- c(5*(floor(min(apply(as.matrix(reorg_data[, 19:42]), 2, as.numeric, na.rm=T), na.rm=T)/5)), 100);

# To create a common y-axis scale for the phenotype plots, find the minimum and 90th-percentile maximum value for the entire dataset (across all plates):
phenotype_range <- c(min(apply(as.matrix(reorg_data[, 46:69]), 2, as.numeric, na.rm=T), na.rm=T), quantile(apply(apply(as.matrix(reorg_data[, 46:69]), 2, as.numeric), 1, max, na.rm=T), 0.9, na.rm=T)); 

# Set y-axis scale with the low scale value = minimum and the high value to either the 90th percentile or the max value, rounded down or up to the nearest 10:
yaxis_scale9 <- c(10*(floor(phenotype_range[1]/10)), 10*(ceiling(phenotype_range[2]/10)));


# For each plate, plot the phenotypes:
for (p in 1:n_plates) {


	# Confluency phenotype:
	# --------------------
	dev.new(width = 12, height = 8); # create a new plot window

	# Set the graphics parameters (multiple plot figure, square shape, no ticks, no box, inner & outer margins)
	par(mfrow = c(16,24), pty="s", tck=0, bty="n", mai = c(0,0,0,0)+0.05, oma = c(0,0,0,0)+1);

	for (i in 1:384) {
		# the 'mfrow' parameter above ensures that the plots fill each row
		# the plot parameters specify no x or y axes, no annotation, and that lines are plotted without markers
		plot(time, t(reorg_data[((p-1)*384)+i,19:42]), ylim = yaxis_scale_conf, xaxt='n', yaxt='n', ann=F, type="l");
		axis(2, labels=FALSE, col = "grey");
	}
	# ---------------------

	# Fluorescence phenotype 1:
	# ------------------------
	dev.new(width = 12, height = 8); 
	
	# Set the graphics parameters (multiple plot figure, square shape, no ticks, no box, inner & outer margins)
	par(mfrow = c(16,24), pty="s", tck=0, bty="n", mai = c(0,0,0,0)+0.05, oma = c(0,0,0,0)+1);

	# Create 384 plots:
	for (i in 1:384) { 
	
		# Determine y-axis scale (if it will be adjusted to accommodate a large maximum value):
		ymax = max(as.numeric(as.matrix(reorg_data[((p-1)*384)+i, 46:69])), na.rm=T);
		
		# If ymax is larger than the 90th percentile maximum value, then use the adjusted axis and color the line differently:
		if (ymax > phenotype_range[2])  {
			yaxis_scale = c(phenotype_range[1], ymax);
			col_line = 'blue';
			line_width = 2;
			} else { yaxis_scale = yaxis_scale9; col_line = 'black'; line_width = 1;
		}

		# the 'mfrow' parameter above ensures that the plots fill each row
		# the plot parameters specify no x or y axes, no annotation, and that lines are plotted without markers
		plot(time, t(reorg_data[((p-1)*384)+i,46:69]), ylim=yaxis_scale, xaxt='n', yaxt='n', ann=F, type="l", col=col_line, lwd = line_width);
		axis(2, labels=FALSE, col = "grey");
	}
}
}
