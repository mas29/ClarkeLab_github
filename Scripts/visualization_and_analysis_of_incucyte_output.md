# Visualization and Analysis of IncuCyte Output
Maia Smith  
February 9, 2015  


```r
library(devtools)
```

```
## Warning: package 'devtools' was built under R version 3.1.2
```

```r
library(plotly)
```

```
## Loading required package: RCurl
## Loading required package: bitops
## Loading required package: RJSONIO
## Loading required package: ggplot2
```

```r
library(ggplot2)
py <- plotly("mas29", "8s6jru0os3")
url<-"https://plot.ly/~mas29/47/pathway-vs-delta-min-max/" 
plotly_iframe <- paste("<center><iframe scrolling='no' seamless='seamless' src='", url, 
                       "/650/800' width='650' height='800'></iframe></center>", sep = "")
plotly_iframe
```

```
## [1] "<center><iframe scrolling='no' seamless='seamless' src='https://plot.ly/~mas29/47/pathway-vs-delta-min-max//650/800' width='650' height='800'></iframe></center>"
```

