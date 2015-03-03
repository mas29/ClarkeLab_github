---
title: "Visualization and Analysis of IncuCyte Output"
author: "Maia Smith"
date: "February 9, 2015"
output:
  html_document:
    keep_md: yes
---


```
## Warning: package 'devtools' was built under R version 3.1.2
```

```
## Warning: package 'car' was built under R version 3.1.2
```

```
## Error in library(plotly): there is no package called 'plotly'
```

```
## Warning: package 'reshape2' was built under R version 3.1.2
```

```
## Warning: package 'gplots' was built under R version 3.1.2
```

```
## KernSmooth 2.23 loaded
## Copyright M. P. Wand 1997-2009
## 
## Attaching package: 'gplots'
## 
## The following object is masked from 'package:stats':
## 
##     lowess
```

```
## Warning: package 'RColorBrewer' was built under R version 3.1.2
```

```
## Error in eval(expr, envir, enclos): could not find function "plotly"
```

```
## Warning in readChar(con, 5L, useBytes = TRUE): cannot open compressed file
## '/Users/maiasmith/Documents/SFU/ClarkeLab/ClarkeLab_github/DataObjects/sytoxG_data.R',
## probable reason 'No such file or directory'
```

```
## Error in readChar(con, 5L, useBytes = TRUE): cannot open the connection
```

```
## Warning in readChar(con, 5L, useBytes = TRUE): cannot open compressed file
## '/Users/maiasmith/Documents/SFU/ClarkeLab/ClarkeLab_github/DataObjects/confluency_data.R',
## probable reason 'No such file or directory'
```

```
## Error in readChar(con, 5L, useBytes = TRUE): cannot open the connection
```

```
## Warning in readChar(con, 5L, useBytes = TRUE): cannot open compressed file
## '/Users/maiasmith/Documents/SFU/ClarkeLab/ClarkeLab_github/DataObjects/sytoxG_data_features.R',
## probable reason 'No such file or directory'
```

```
## Error in readChar(con, 5L, useBytes = TRUE): cannot open the connection
```

```
## Warning in readChar(con, 5L, useBytes = TRUE): cannot open compressed file
## '/Users/maiasmith/Documents/SFU/ClarkeLab/ClarkeLab_github/DataObjects/confluency_data_features.R',
## probable reason 'No such file or directory'
```

```
## Error in readChar(con, 5L, useBytes = TRUE): cannot open the connection
```

```
## Warning in readChar(con, 5L, useBytes = TRUE): cannot open compressed file
## '/Users/maiasmith/Documents/SFU/ClarkeLab/ClarkeLab_github/DataObjects/confluency_sytoxG_data.R',
## probable reason 'No such file or directory'
```

```
## Error in readChar(con, 5L, useBytes = TRUE): cannot open the connection
```

```
## Error in eval(expr, envir, enclos): object 'sytoxG_data' not found
```
Quality Control
=============

Compare controls and treatments
-----------------------------------------------



<center><iframe scrolling='no' seamless='seamless' style='border:none' src='https://plot.ly/~mas29/225/sytox-green-over-time-control-vs-treatment.embed?width=550&height=550/800/1200' width='800' height='800'></iframe><center>




<center><iframe scrolling='no' seamless='seamless' style='border:none' src='https://plot.ly/~mas29/223/confluency-over-time-control-vs-treatment.embed?width=550&height=550/800/1200' width='800' height='800'></iframe><center>

Compare plates for controls and treatments
-----------------------------------------------


```
## Error in ggplot(sytoxG_data, aes(x = as.numeric(time_elapsed), y = as.numeric(phenotype_value), : object 'sytoxG_data' not found
```

```
## Error in ggplot(confluency_data, aes(x = as.numeric(time_elapsed), y = as.numeric(phenotype_value), : object 'confluency_data' not found
```

Compare sparklines for each plate, controls vs treatments, with mean and sd for each plate and control/treatment
-----------------------------------------------


```
## Error in empty(.data): object 'sytoxG_data' not found
```

```
## Error in ggplot(sytoxG_mean_sd_empty, aes(x = as.numeric(time_elapsed), : object 'sytoxG_mean_sd_empty' not found
```

```
## Error in empty(.data): object 'confluency_data' not found
```

```
## Error in ggplot(con_mean_sd_empty, aes(x = as.numeric(time_elapsed), y = as.numeric(mean), : object 'con_mean_sd_empty' not found
```



Pathway analysis 
================

Sparklines by Pathway
------------------------




<center><iframe scrolling='no' seamless='seamless' style='border:none' src='https://plot.ly/~mas29/227/sytox-green-facets-pathway.embed?width=550&height=550/800/1200' width='800' height='800'></iframe><center>




<center><iframe scrolling='no' seamless='seamless' style='border:none' src='https://plot.ly/~mas29/230/confluency-facets-pathway.embed?width=550&height=550/800/1200' width='800' height='800'></iframe><center>

Delta (max-min) values by Pathway
----------------------------------




<center><iframe scrolling='no' seamless='seamless' style='border:none' src='https://plot.ly/~mas29/233.embed?width=550&height=550/800/1200' width='800' height='800'></iframe><center>




<center><iframe scrolling='no' seamless='seamless' style='border:none' src='https://plot.ly/~mas29/235.embed?width=550&height=550/800/1200' width='800' height='800'></iframe><center>

Heatmap of metrics for all compounds (not negative controls) 
=========


```
## Error in eval(expr, envir, enclos): object 'sytoxG_data_features' not found
```

```
## Error in eval(expr, envir, enclos): object 'sytoxG_data_features' not found
```

```
## Error in scale(data_for_heatmap): object 'data_for_heatmap' not found
```

```
## Error in as.matrix(data_for_heatmap): object 'data_for_heatmap' not found
```

Comparison to Negative Controls
================


```r
# Number of time intervals
num_time_intervals <- length(unique(sytoxG_data$time_elapsed))
```

```
## Error in unique(sytoxG_data$time_elapsed): object 'sytoxG_data' not found
```

```r
# Confidence interval bounds
confidence_intervals_SG <- sytoxG_data[1:num_time_intervals,c("time_elapsed", "phenotype_value.NC.upper", "phenotype_value.NC.mean", "phenotype_value.NC.lower")]
```

```
## Error in eval(expr, envir, enclos): object 'sytoxG_data' not found
```

```r
confidence_intervals_Con <- confluency_data[1:num_time_intervals,c("time_elapsed", "phenotype_value.NC.upper", "phenotype_value.NC.mean", "phenotype_value.NC.lower")]
```

```
## Error in eval(expr, envir, enclos): object 'confluency_data' not found
```

```r
# Get rid of negative control sparklines
sytoxG_data_no_NC <- sytoxG_data[which(sytoxG_data$empty == "Treatment"),]
```

```
## Error in eval(expr, envir, enclos): object 'sytoxG_data' not found
```

```r
confluency_data_no_NC <- confluency_data[which(confluency_data$empty == "Treatment"),]
```

```
## Error in eval(expr, envir, enclos): object 'confluency_data' not found
```

```r
# Plot SG
ggplot(sytoxG_data_no_NC) +
  geom_line(aes(x=as.numeric(time_elapsed), y=as.numeric(phenotype_value), group = Compound), alpha = 0.6) +
  xlab("Time Elapsed") +
  ylab("Sytox Green") +
  ggtitle("Time Point at which Compound Surpasses Negative Control\n(Phenotypic Marker: Sytox Green)") +
  geom_ribbon(data = confidence_intervals_SG, mapping = aes(x = time_elapsed, ymin = phenotype_value.NC.lower, ymax = phenotype_value.NC.upper,
                             fill = "red", colour = NULL), alpha = 0.6) +
  scale_fill_manual(name = "Legend",
                    values = c('red'),
                    labels = c('Negative Control')) +
  facet_wrap(~phenotype_value_exceeds_NC_upperbound.timepoint, scales = "fixed") +
  theme(panel.grid = element_blank(),
        axis.ticks.length = unit(0, "cm"),
        panel.background = element_rect(fill = "white")) 
```

```
## Error in ggplot(sytoxG_data_no_NC): object 'sytoxG_data_no_NC' not found
```

```r
# Plot confluency
ggplot(confluency_data_no_NC) +
  geom_line(aes(x=as.numeric(time_elapsed), y=as.numeric(phenotype_value), group = Compound), alpha = 0.6) +
  xlab("Time Elapsed") +
  ylab("Sytox Green") +
  ggtitle("Time Point at which Compound Drops Below Negative Control\n(Phenotypic Marker: Confluency)") +
  geom_ribbon(data = confidence_intervals_Con, mapping = aes(x = time_elapsed, ymin = phenotype_value.NC.lower, ymax = phenotype_value.NC.upper,
                                                         fill = "red", colour = NULL), alpha = 0.6) +
  scale_fill_manual(name = "Legend",
                    values = c('red'),
                    labels = c('Negative Control')) +
  facet_wrap(~phenotype_value_falls_below_NC_lowerbound.timepoint, scales = "fixed") +
  theme(panel.grid = element_blank(),
        axis.ticks.length = unit(0, "cm"),
        panel.background = element_rect(fill = "white"))
```

```
## Error in ggplot(confluency_data_no_NC): object 'confluency_data_no_NC' not found
```

Statistical Analyses
===================

Normal Q-Q Plots
--------------


```
## Error in scale(sytoxG_data_features$delta_min_max): object 'sytoxG_data_features' not found
```

```
## Error in qqnorm(delta_max_min, main = "Normal Q-Q Plot for Sytox Green Delta (max-min)"): object 'delta_max_min' not found
```

```
## Error in quantile(y, probs, names = FALSE, type = qtype, na.rm = TRUE): object 'delta_max_min' not found
```

```
## Error in scale(confluency_data_features$delta_min_max): object 'confluency_data_features' not found
```

```
## Error in qqnorm(delta_max_min, main = "Normal Q-Q Plot for Confluency Delta (max-min)"): object 'delta_max_min' not found
```

```
## Error in quantile(y, probs, names = FALSE, type = qtype, na.rm = TRUE): object 'delta_max_min' not found
```

At what time point do we see the first significant differences in phenotypic marker values? 
------------------
In Sytox Green?


```
## Error in eval(expr, envir, enclos): object 'confluency_sytoxG_data' not found
```

```
## Error in is.data.frame(data): object 'data_for_stats' not found
```

```
## Error in summary(fit_SG): object 'fit_SG' not found
```

```
## Error in summary(fit_SG): object 'fit_SG' not found
```

```
## Error in summary[, "Pr(>|t|)"]: object of type 'closure' is not subsettable
```

```
## Error in gsub("as.factor\\(time_elapsed\\)", "", first_sig_timepoint): object 'first_sig_timepoint' not found
```

In Confluency?


```
## Error in is.data.frame(data): object 'data_for_stats' not found
```

```
## Error in summary(fit_con): object 'fit_con' not found
```

```
## Error in summary(fit_con): object 'fit_con' not found
```

```
## Error in summary[, "Pr(>|t|)"]: object of type 'closure' is not subsettable
```

```
## Error in gsub("as.factor\\(time_elapsed\\)", "", first_sig_timepoint): object 'first_sig_timepoint' not found
```

Which pathways are significantly different from the negative controls (measured by AUC)? 
------------------

For Sytox Green:


```
## Error in is.data.frame(data): object 'data_for_stats' not found
```

```
## Error in summary(fit_SG): object 'fit_SG' not found
```

```
## Error in summary[, "Pr(>|t|)"]: object of type 'closure' is not subsettable
```

```
## Error in gsub("Pathway", "", sig_pathways_SG): object 'sig_pathways_SG' not found
```

```
## [1] "The following pathways have an AUC for Sytox Green significantly different (p < 0.01) from the negative controls' AUC?"
```

```
## Error in print(sig_pathways_SG[2:length(sig_pathways_SG)]): object 'sig_pathways_SG' not found
```

For Confluency:


```
## Error in is.data.frame(data): object 'data_for_stats' not found
```

```
## Error in summary(fit_Con): object 'fit_Con' not found
```

```
## Error in summary[, "Pr(>|t|)"]: object of type 'closure' is not subsettable
```

```
## Error in gsub("Pathway", "", sig_pathways_Con): object 'sig_pathways_Con' not found
```

```
## [1] "The following pathways have an AUC for Confluency significantly different (p < 0.01) from the negative controls' AUC?"
```

```
## Error in print(sig_pathways_Con[2:length(sig_pathways_Con)]): object 'sig_pathways_Con' not found
```

Which targets are significantly different from the negative controls (measured by AUC)?
------------------------

For Sytox Green:


```
## Error in is.data.frame(data): object 'data_for_stats' not found
```

```
## Error in summary(fit_SG): object 'fit_SG' not found
```

```
## Error in summary[, "Pr(>|t|)"]: object of type 'closure' is not subsettable
```

```
## Error in gsub("Targets", "", sig_targets_SG): object 'sig_targets_SG' not found
```

```
## [1] "The following targets have an AUC for Sytox Green significantly different (p < 1e-20) from the negative controls' AUC?"
```

```
## Error in print(sig_targets_SG[2:length(sig_targets_SG)]): object 'sig_targets_SG' not found
```

Sytox Green sparklines for the significant targets:


```
## Error in eval(expr, envir, enclos): object 'sytoxG_data' not found
```

```
## Error in ggplot(sytoxG_data_significant_targets_only, aes(x = as.numeric(time_elapsed), : object 'sytoxG_data_significant_targets_only' not found
```

For Confluency:


```
## Error in is.data.frame(data): object 'data_for_stats' not found
```

```
## Error in summary(fit_Con): object 'fit_Con' not found
```

```
## Error in summary[, "Pr(>|t|)"]: object of type 'closure' is not subsettable
```

```
## Error in gsub("Targets", "", sig_targets_Con): object 'sig_targets_Con' not found
```

```
## [1] "The following targets have an AUC for Confluency significantly different (p < 1e-20) from the negative controls' AUC?"
```

```
## Error in print(sig_targets_Con[2:length(sig_targets_Con)]): object 'sig_targets_Con' not found
```

Confluency sparklines for the significant targets:


```
## Error in eval(expr, envir, enclos): object 'confluency_data' not found
```

```
## Error in ggplot(confluency_data_significant_targets_only, aes(x = as.numeric(time_elapsed), : object 'confluency_data_significant_targets_only' not found
```
