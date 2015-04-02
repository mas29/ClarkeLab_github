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

<iframe height="600" id="igraph" scrolling="no" seamless="seamless"
				src="https://plot.ly/~mas29/289" width="600" frameBorder="0"></iframe>

<iframe height="600" id="igraph" scrolling="no" seamless="seamless"
				src="https://plot.ly/~mas29/290" width="600" frameBorder="0"></iframe>

Which pathways are significantly different from the negative controls (measured by AUC)? 
------------------

For Sytox Green:


```
## [1] "The following pathways have an AUC for Sytox Green significantly different (p < 0.01) from the negative controls' AUC?"
```

```
##  [1] "Apoptosis"                    "Cell Cycle"                  
##  [3] "DNA Damage"                   "Endocrinology &amp; Hormones"
##  [5] "GPCR &amp; G Protein"         "JAK/STAT"                    
##  [7] "MAPK"                         "Metabolism"                  
##  [9] "Microbiology"                 "NA"                          
## [11] "NegControl"                   "Neuronal Signaling"          
## [13] "NF-B"                         "Others"                      
## [15] "PI3K/Akt/mTOR"                "Proteases"                   
## [17] "Protein Tyrosine Kinase"      "Stem Cells &amp;  Wnt"       
## [19] "TGF-beta/Smad"                "Transmembrane Transporters"  
## [21] "Ubiquitin"
```

For Confluency:


```
## [1] "The following pathways have an AUC for Confluency significantly different (p < 0.01) from the negative controls' AUC?"
```

```
##  [1] "Apoptosis"                    "Cell Cycle"                  
##  [3] "Endocrinology &amp; Hormones" "Epigenetics"                 
##  [5] "GPCR &amp; G Protein"         "JAK/STAT"                    
##  [7] "MAPK"                         "NA"                          
##  [9] "NegControl"                   "NF-B"                        
## [11] "Others"                       "PI3K/Akt/mTOR"               
## [13] "Proteases"                    "Stem Cells &amp;  Wnt"       
## [15] "Ubiquitin"
```
