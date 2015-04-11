---
title: "Pathway Analysis"
author: "Maia Smith"
date: "March 24, 2015"
output: html_document
---

Pathway analysis 
================

Note: To get the hover information working correctly on Plotly graphs (the interactive graphs), do the following: 
1. Hover anywhere over graph
2. You'll see icons appear at the top right-hand corner of the graph
3. Select the icon for "Show closest data on hover"

Sparklines by Pathway
------------------------

Compared to negative controls:

![plot of chunk unnamed-chunk-1](figure/unnamed-chunk-1-1.png) ![plot of chunk unnamed-chunk-1](figure/unnamed-chunk-1-2.png) 

Sparklines By Pathway, in Plotly:
-------


```
## Estimated Draw Time SlowThe draw time for this plot will be slow for clients without much RAM.
```

<iframe height="600" id="igraph" scrolling="no" seamless="seamless"
				src="https://plot.ly/~mas29/227" width="600" frameBorder="0"></iframe>


```
## Estimated Draw Time SlowThe draw time for this plot will be slow for clients without much RAM.
```

<iframe height="600" id="igraph" scrolling="no" seamless="seamless"
				src="https://plot.ly/~mas29/288" width="600" frameBorder="0"></iframe>

Delta (max-min) values by Pathway
----------------------------------


```
## Error in ggplot(sytoxG_data_features, aes(Pathway, delta_min_max, text = Compound)): object 'sytoxG_data_features' not found
```

```
## Error in inherits(x, "ggplot"): object 'SG_delta_by_pathway' not found
```

<iframe height="600" id="igraph" scrolling="no" seamless="seamless"
				src="https://plot.ly/~mas29/288" width="600" frameBorder="0"></iframe>


```
## Error in ggplot(confluency_data_features, aes(Pathway, delta_min_max, : object 'confluency_data_features' not found
```

```
## Error in inherits(x, "ggplot"): object 'Con_delta_by_pathway' not found
```

<iframe height="600" id="igraph" scrolling="no" seamless="seamless"
				src="https://plot.ly/~mas29/288" width="600" frameBorder="0"></iframe>

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
