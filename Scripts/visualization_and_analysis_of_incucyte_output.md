# Visualization and Analysis of IncuCyte Output
Maia Smith  
February 9, 2015  




```
## Warning: package 'knitr' was built under R version 3.1.2
```

```
## Warning: package 'devtools' was built under R version 3.1.2
```

```
## Warning: package 'car' was built under R version 3.1.2
```

```
## Loading required package: RCurl
```

```
## Warning: package 'RCurl' was built under R version 3.1.2
```

```
## Loading required package: bitops
## Loading required package: RJSONIO
```

```
## Warning: package 'reshape2' was built under R version 3.1.2
```

```
## Warning: package 'gplots' was built under R version 3.1.2
```

```
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



Quality Control
=============

Compare controls and treatments
-----------------------------------------------



<center><iframe scrolling='no' seamless='seamless' style='border:none' src='https://plot.ly/~mas29/225/sytox-green-over-time-control-vs-treatment.embed?width=550&height=550/800/1200' width='800' height='800'></iframe><center>




<center><iframe scrolling='no' seamless='seamless' style='border:none' src='https://plot.ly/~mas29/223/confluency-over-time-control-vs-treatment.embed?width=550&height=550/800/1200' width='800' height='800'></iframe><center>

Compare plates for controls and treatments
-----------------------------------------------

<img src="visualization_and_analysis_of_incucyte_output_files/figure-html/unnamed-chunk-6-1.png" title="" alt="" width="1200px" /><img src="visualization_and_analysis_of_incucyte_output_files/figure-html/unnamed-chunk-6-2.png" title="" alt="" width="1200px" />

Compare sparklines for each plate, controls vs treatments, with mean and sd for each plate and control/treatment
-----------------------------------------------

<img src="visualization_and_analysis_of_incucyte_output_files/figure-html/unnamed-chunk-7-1.png" title="" alt="" width="1200px" /><img src="visualization_and_analysis_of_incucyte_output_files/figure-html/unnamed-chunk-7-2.png" title="" alt="" width="1200px" />



Pathway analysis 
================

Sparklines by Pathway
------------------------

Compared to negative controls:

<img src="visualization_and_analysis_of_incucyte_output_files/figure-html/unnamed-chunk-9-1.png" title="" alt="" width="1200px" /><img src="visualization_and_analysis_of_incucyte_output_files/figure-html/unnamed-chunk-9-2.png" title="" alt="" width="1200px" />

In Plotly:




<center><iframe scrolling='no' seamless='seamless' style='border:none' src='https://plot.ly/~mas29/227/sytox-green-facets-pathway.embed?width=550&height=550/800/1200' width='800' height='800'></iframe><center>




<center><iframe scrolling='no' seamless='seamless' style='border:none' src='https://plot.ly/~mas29/230/confluency-facets-pathway.embed?width=550&height=550/800/1200' width='800' height='800'></iframe><center>

Delta (max-min) values by Pathway
----------------------------------




<center><iframe scrolling='no' seamless='seamless' style='border:none' src='https://plot.ly/~mas29/233.embed?width=550&height=550/800/1200' width='800' height='800'></iframe><center>




<center><iframe scrolling='no' seamless='seamless' style='border:none' src='https://plot.ly/~mas29/235.embed?width=550&height=550/800/1200' width='800' height='800'></iframe><center>

Heatmap of metrics for all compounds (not negative controls) 
=========

<img src="visualization_and_analysis_of_incucyte_output_files/figure-html/unnamed-chunk-18-1.png" title="" alt="" width="1200px" /><img src="visualization_and_analysis_of_incucyte_output_files/figure-html/unnamed-chunk-18-2.png" title="" alt="" width="1200px" /><img src="visualization_and_analysis_of_incucyte_output_files/figure-html/unnamed-chunk-18-3.png" title="" alt="" width="1200px" /><img src="visualization_and_analysis_of_incucyte_output_files/figure-html/unnamed-chunk-18-4.png" title="" alt="" width="1200px" /><img src="visualization_and_analysis_of_incucyte_output_files/figure-html/unnamed-chunk-18-5.png" title="" alt="" width="1200px" /><img src="visualization_and_analysis_of_incucyte_output_files/figure-html/unnamed-chunk-18-6.png" title="" alt="" width="1200px" /><img src="visualization_and_analysis_of_incucyte_output_files/figure-html/unnamed-chunk-18-7.png" title="" alt="" width="1200px" /><img src="visualization_and_analysis_of_incucyte_output_files/figure-html/unnamed-chunk-18-8.png" title="" alt="" width="1200px" /><img src="visualization_and_analysis_of_incucyte_output_files/figure-html/unnamed-chunk-18-9.png" title="" alt="" width="1200px" /><img src="visualization_and_analysis_of_incucyte_output_files/figure-html/unnamed-chunk-18-10.png" title="" alt="" width="1200px" /><img src="visualization_and_analysis_of_incucyte_output_files/figure-html/unnamed-chunk-18-11.png" title="" alt="" width="1200px" /><img src="visualization_and_analysis_of_incucyte_output_files/figure-html/unnamed-chunk-18-12.png" title="" alt="" width="1200px" /><img src="visualization_and_analysis_of_incucyte_output_files/figure-html/unnamed-chunk-18-13.png" title="" alt="" width="1200px" /><img src="visualization_and_analysis_of_incucyte_output_files/figure-html/unnamed-chunk-18-14.png" title="" alt="" width="1200px" /><img src="visualization_and_analysis_of_incucyte_output_files/figure-html/unnamed-chunk-18-15.png" title="" alt="" width="1200px" /><img src="visualization_and_analysis_of_incucyte_output_files/figure-html/unnamed-chunk-18-16.png" title="" alt="" width="1200px" /><img src="visualization_and_analysis_of_incucyte_output_files/figure-html/unnamed-chunk-18-17.png" title="" alt="" width="1200px" /><img src="visualization_and_analysis_of_incucyte_output_files/figure-html/unnamed-chunk-18-18.png" title="" alt="" width="1200px" /><img src="visualization_and_analysis_of_incucyte_output_files/figure-html/unnamed-chunk-18-19.png" title="" alt="" width="1200px" /><img src="visualization_and_analysis_of_incucyte_output_files/figure-html/unnamed-chunk-18-20.png" title="" alt="" width="1200px" /><img src="visualization_and_analysis_of_incucyte_output_files/figure-html/unnamed-chunk-18-21.png" title="" alt="" width="1200px" /><img src="visualization_and_analysis_of_incucyte_output_files/figure-html/unnamed-chunk-18-22.png" title="" alt="" width="1200px" />

Comparison to Negative Controls
================

<img src="visualization_and_analysis_of_incucyte_output_files/figure-html/unnamed-chunk-19-1.png" title="" alt="" width="1200px" /><img src="visualization_and_analysis_of_incucyte_output_files/figure-html/unnamed-chunk-19-2.png" title="" alt="" width="1200px" />

Statistical Analyses
===================

Q-Q Plots
--------------

<img src="visualization_and_analysis_of_incucyte_output_files/figure-html/unnamed-chunk-20-1.png" title="" alt="" width="1200px" /><img src="visualization_and_analysis_of_incucyte_output_files/figure-html/unnamed-chunk-20-2.png" title="" alt="" width="1200px" /><img src="visualization_and_analysis_of_incucyte_output_files/figure-html/unnamed-chunk-20-3.png" title="" alt="" width="1200px" /><img src="visualization_and_analysis_of_incucyte_output_files/figure-html/unnamed-chunk-20-4.png" title="" alt="" width="1200px" /><img src="visualization_and_analysis_of_incucyte_output_files/figure-html/unnamed-chunk-20-5.png" title="" alt="" width="1200px" /><img src="visualization_and_analysis_of_incucyte_output_files/figure-html/unnamed-chunk-20-6.png" title="" alt="" width="1200px" />

```
## Warning: Removed 87 rows containing missing values (stat_qq).
```

```
## Warning: Removed 87 rows containing missing values (stat_qq).
```

```
## Warning: Removed 87 rows containing missing values (stat_qq).
```

```
## Warning: Removed 87 rows containing missing values (stat_qq).
```

```
## Warning: Removed 87 rows containing missing values (stat_qq).
```

```
## Warning: Removed 87 rows containing missing values (stat_qq).
```

<img src="visualization_and_analysis_of_incucyte_output_files/figure-html/unnamed-chunk-20-7.png" title="" alt="" width="1200px" />

```
## Warning: Removed 87 rows containing missing values (stat_qq).
```

```
## Warning: Removed 87 rows containing missing values (stat_qq).
```

```
## Warning: Removed 87 rows containing missing values (stat_qq).
```

```
## Warning: Removed 87 rows containing missing values (stat_qq).
```

```
## Warning: Removed 87 rows containing missing values (stat_qq).
```

```
## Warning: Removed 87 rows containing missing values (stat_qq).
```

<img src="visualization_and_analysis_of_incucyte_output_files/figure-html/unnamed-chunk-20-8.png" title="" alt="" width="1200px" />

```
## Warning: Removed 87 rows containing missing values (stat_qq).
```

```
## Warning: Removed 87 rows containing missing values (stat_qq).
```

```
## Warning: Removed 87 rows containing missing values (stat_qq).
```

```
## Warning: Removed 87 rows containing missing values (stat_qq).
```

```
## Warning: Removed 87 rows containing missing values (stat_qq).
```

```
## Warning: Removed 87 rows containing missing values (stat_qq).
```

<img src="visualization_and_analysis_of_incucyte_output_files/figure-html/unnamed-chunk-20-9.png" title="" alt="" width="1200px" />

```
## Warning: Removed 87 rows containing missing values (stat_qq).
```

```
## Warning: Removed 87 rows containing missing values (stat_qq).
```

```
## Warning: Removed 87 rows containing missing values (stat_qq).
```

```
## Warning: Removed 87 rows containing missing values (stat_qq).
```

```
## Warning: Removed 87 rows containing missing values (stat_qq).
```

```
## Warning: Removed 87 rows containing missing values (stat_qq).
```

<img src="visualization_and_analysis_of_incucyte_output_files/figure-html/unnamed-chunk-20-10.png" title="" alt="" width="1200px" />

At what time point do we see the first significant differences in phenotypic marker values? 
------------------
In Sytox Green?


```
## 
## Call:
## lm(formula = phenotype_value ~ as.factor(time_elapsed), data = data_for_stats, 
##     subset = phenotypic_Marker == "SG")
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -314.46  -38.23  -14.59    8.44 2669.95 
## 
## Coefficients:
##                           Estimate Std. Error t value Pr(>|t|)    
## (Intercept)                 74.528      2.483  30.016  < 2e-16 ***
## as.factor(time_elapsed)2     4.108      3.511   1.170  0.24207    
## as.factor(time_elapsed)4     2.834      3.511   0.807  0.41970    
## as.factor(time_elapsed)6     1.119      3.511   0.319  0.74997    
## as.factor(time_elapsed)8     9.289      3.511   2.645  0.00816 ** 
## as.factor(time_elapsed)10   30.571      3.511   8.706  < 2e-16 ***
## as.factor(time_elapsed)12   52.287      3.511  14.891  < 2e-16 ***
## as.factor(time_elapsed)14   66.403      3.511  18.911  < 2e-16 ***
## as.factor(time_elapsed)16   75.650      3.511  21.544  < 2e-16 ***
## as.factor(time_elapsed)18   87.923      3.511  25.039  < 2e-16 ***
## as.factor(time_elapsed)20  109.096      3.511  31.069  < 2e-16 ***
## as.factor(time_elapsed)22  138.903      3.511  39.557  < 2e-16 ***
## as.factor(time_elapsed)24  170.426      3.511  48.535  < 2e-16 ***
## as.factor(time_elapsed)26  196.007      3.511  55.820  < 2e-16 ***
## as.factor(time_elapsed)28  214.572      3.511  61.107  < 2e-16 ***
## as.factor(time_elapsed)30  227.747      3.511  64.859  < 2e-16 ***
## as.factor(time_elapsed)32  236.130      3.511  67.246  < 2e-16 ***
## as.factor(time_elapsed)34  240.114      3.511  68.380  < 2e-16 ***
## as.factor(time_elapsed)36  240.164      3.511  68.395  < 2e-16 ***
## as.factor(time_elapsed)38  237.577      3.511  67.658  < 2e-16 ***
## as.factor(time_elapsed)40  233.288      3.511  66.436  < 2e-16 ***
## as.factor(time_elapsed)42  229.036      3.511  65.226  < 2e-16 ***
## as.factor(time_elapsed)44  225.055      3.511  64.092  < 2e-16 ***
## as.factor(time_elapsed)46  221.107      3.511  62.968  < 2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 108.8 on 46056 degrees of freedom
## Multiple R-squared:  0.4277,	Adjusted R-squared:  0.4274 
## F-statistic:  1497 on 23 and 46056 DF,  p-value: < 2.2e-16
```

```
## [1] "The first significant time point for Sytox Green after the hour 0 is hour 8."
```

In Confluency?


```
## 
## Call:
## lm(formula = phenotype_value ~ as.factor(time_elapsed), data = data_for_stats, 
##     subset = phenotypic_Marker == "Con")
## 
## Residuals:
##      Min       1Q   Median       3Q      Max 
## -27.9372  -0.2166   0.6207   1.2699   2.3732 
## 
## Coefficients:
##                           Estimate Std. Error  t value Pr(>|t|)    
## (Intercept)               99.20075    0.05590 1774.520  < 2e-16 ***
## as.factor(time_elapsed)2   0.08931    0.07906    1.130 0.258628    
## as.factor(time_elapsed)4   0.02492    0.07906    0.315 0.752606    
## as.factor(time_elapsed)6  -0.10445    0.07906   -1.321 0.186459    
## as.factor(time_elapsed)8  -0.27530    0.07906   -3.482 0.000498 ***
## as.factor(time_elapsed)10 -0.43711    0.07906   -5.529 3.24e-08 ***
## as.factor(time_elapsed)12 -0.59151    0.07906   -7.482 7.46e-14 ***
## as.factor(time_elapsed)14 -0.67342    0.07906   -8.518  < 2e-16 ***
## as.factor(time_elapsed)16 -0.73024    0.07906   -9.237  < 2e-16 ***
## as.factor(time_elapsed)18 -0.70453    0.07906   -8.911  < 2e-16 ***
## as.factor(time_elapsed)20 -0.68427    0.07906   -8.655  < 2e-16 ***
## as.factor(time_elapsed)22 -0.65260    0.07906   -8.255  < 2e-16 ***
## as.factor(time_elapsed)24 -0.63643    0.07906   -8.050 8.47e-16 ***
## as.factor(time_elapsed)26 -0.60346    0.07906   -7.633 2.34e-14 ***
## as.factor(time_elapsed)28 -0.61336    0.07906   -7.758 8.78e-15 ***
## as.factor(time_elapsed)30 -0.63689    0.07906   -8.056 8.08e-16 ***
## as.factor(time_elapsed)32 -0.68883    0.07906   -8.713  < 2e-16 ***
## as.factor(time_elapsed)34 -0.76726    0.07906   -9.705  < 2e-16 ***
## as.factor(time_elapsed)36 -0.83190    0.07906  -10.523  < 2e-16 ***
## as.factor(time_elapsed)38 -0.97516    0.07906  -12.335  < 2e-16 ***
## as.factor(time_elapsed)40 -1.11853    0.07906  -14.148  < 2e-16 ***
## as.factor(time_elapsed)42 -1.27866    0.07906  -16.174  < 2e-16 ***
## as.factor(time_elapsed)44 -1.42124    0.07906  -17.977  < 2e-16 ***
## as.factor(time_elapsed)46 -1.57391    0.07906  -19.908  < 2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 2.45 on 46056 degrees of freedom
## Multiple R-squared:  0.02796,	Adjusted R-squared:  0.02748 
## F-statistic:  57.6 on 23 and 46056 DF,  p-value: < 2.2e-16
```

```
## [1] "The first significant time point for Confluency after the hour 0 is hour 8."
```

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
##  [9] "Microbiology"                 "NegControl"                  
## [11] "Neuronal Signaling"           "NF-B"                        
## [13] "Others"                       "PI3K/Akt/mTOR"               
## [15] "Proteases"                    "Protein Tyrosine Kinase"     
## [17] "Stem Cells &amp;  Wnt"        "TGF-beta/Smad"               
## [19] "Transmembrane Transporters"   "Ubiquitin"
```

For Confluency:


```
## [1] "The following pathways have an AUC for Confluency significantly different (p < 0.01) from the negative controls' AUC?"
```

```
##  [1] "Apoptosis"                    "Cell Cycle"                  
##  [3] "Endocrinology &amp; Hormones" "Epigenetics"                 
##  [5] "GPCR &amp; G Protein"         "JAK/STAT"                    
##  [7] "MAPK"                         "NegControl"                  
##  [9] "NF-B"                         "Others"                      
## [11] "PI3K/Akt/mTOR"                "Proteases"                   
## [13] "Stem Cells &amp;  Wnt"        "Ubiquitin"
```

Which targets are significantly different from the negative controls (measured by AUC)?
------------------------

For Sytox Green:


```
## [1] "The following targets have an AUC for Sytox Green significantly different (p < 1e-20) from the negative controls' AUC?"
```

```
##  [1] "Akt,mTOR,PI3K"                    "ATM/ATR,mTOR"                    
##  [3] "Autophagy,Bcl-2"                  "Bcl-2,Autophagy"                 
##  [5] "Bcr-Abl,c-Kit,Src"                "c-Met"                           
##  [7] "c-RET,FGFR,Bcr-Abl,Aurora Kinase" "CDK"                             
##  [9] "Chk"                              "DNA-PK,PDGFR,mTOR"               
## [11] "DUB,Bcr-Abl"                      "EGFR"                            
## [13] "Epigenetic Reader Domain"         "HDAC"                            
## [15] "HDAC,HER2,EGFR"                   "HER2,VEGFR,EGFR"                 
## [17] "HSP (e.g. HSP90),Autophagy"       "IB/IKK"                          
## [19] "IB/IKK,E2 conjugating"            "JAK,FLT3,c-RET"                  
## [21] "JNK"                              "mTOR,PI3K"                       
## [23] "PDGFR,FGFR,VEGFR,Bcr-Abl"         "PI3K,Autophagy,DNA-PK,mTOR"      
## [25] "PI3K,DNA-PK"                      "PI3K,HDAC"                       
## [27] "PI3K,mTOR"                        "PKA,CDK,Akt"                     
## [29] "PKC"                              "PLK"                             
## [31] "Proton Pump"                      "STAT"                            
## [33] "Survivin"                         "Syk"                             
## [35] "Topoisomerase"                    "VEGFR,PDGFR,c-Kit"
```

Sytox Green sparklines for the significant targets:

<img src="visualization_and_analysis_of_incucyte_output_files/figure-html/unnamed-chunk-26-1.png" title="" alt="" width="1200px" />

For Confluency:


```
## [1] "The following targets have an AUC for Confluency significantly different (p < 1e-20) from the negative controls' AUC?"
```

```
##  [1] "ATPase,Autophagy"                     
##  [2] "Aurora Kinase,FLT3,VEGFR"             
##  [3] "Autophagy,Bcl-2"                      
##  [4] "c-Kit,VEGFR,PDGFR"                    
##  [5] "CaSR"                                 
##  [6] "CRM1"                                 
##  [7] "DNA-PK,PI3K"                          
##  [8] "DUB"                                  
##  [9] "FLT3,Tie-2,c-Kit,c-Met,VEGFR,Axl"     
## [10] "GSK-3"                                
## [11] "IB/IKK"                               
## [12] "IB/IKK,E2 conjugating"                
## [13] "IDO"                                  
## [14] "p53"                                  
## [15] "p97"                                  
## [16] "PAK"                                  
## [17] "Proteasome"                           
## [18] "Proton Pump"                          
## [19] "Raf,Src,Bcr-Abl,VEGFR,Ephrin receptor"
## [20] "S1P Receptor"                         
## [21] "STAT"                                 
## [22] "TNF-alpha,NF-B"                       
## [23] "Topoisomerase"
```

Confluency sparklines for the significant targets:

<img src="visualization_and_analysis_of_incucyte_output_files/figure-html/unnamed-chunk-28-1.png" title="" alt="" width="1200px" />
