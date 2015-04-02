---
title: "Target Analysis"
author: "Maia Smith"
date: "March 24, 2015"
output: html_document
---

Target Analysis
===========

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
## [35] "Topoisomerase"
```

Sytox Green sparklines for the significant targets:

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3-1.png) 

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

![plot of chunk unnamed-chunk-5](figure/unnamed-chunk-5-1.png) 
