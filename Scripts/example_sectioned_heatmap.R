nba <- read.csv("http://datasets.flowingdata.com/ppg2008.csv")
nba$Name <- with(nba, reorder(Name, PTS))

library("ggplot2")
library("plyr")
library("reshape2")
library("scales")

nba.m <- melt(nba)
nba.s <- ddply(nba.m, .(variable), transform,
               rescale = scale(value))

ggplot(nba.s, aes(variable, Name)) + 
  geom_tile(aes(fill = rescale), colour = "white") + 
  scale_fill_gradient(low = "white", high = "steelblue") + 
  scale_x_discrete("", expand = c(0, 0)) + 
  scale_y_discrete("", expand = c(0, 0)) + 
  theme_grey(base_size = 9) + 
  theme(legend.position = "none",
        axis.ticks = element_blank(), 
        axis.text.x = element_text(angle = 330, hjust = 0))
nba.s$Category <- nba.s$variable
levels(nba.s$Category) <- 
  list("Offensive" = c("PTS", "FGM", "FGA", "X3PM", "X3PA", "AST"),
       "Defensive" = c("DRB", "ORB", "STL"),
       "Other" = c("G", "MIN", "FGP", "FTM", "FTA", "FTP", "X3PP", 
                   "TRB", "BLK", "TO", "PF"))

nba.s$rescaleoffset <- nba.s$rescale + 100*(as.numeric(nba.s$Category)-1)
scalerange <- range(nba.s$rescale)
gradientends <- scalerange + rep(c(0,100,200), each=2)
colorends <- c("white", "red", "white", "green", "white", "blue")

ggplot(nba.s, aes(variable, Name)) + 
  geom_tile(aes(fill = rescaleoffset), colour = "white") + 
  scale_fill_gradientn(colours = colorends, values = rescale(gradientends)) + 
  scale_x_discrete("", expand = c(0, 0)) + 
  scale_y_discrete("", expand = c(0, 0)) + 
  theme_grey(base_size = 9) + 
  theme(legend.position = "none",
        axis.ticks = element_blank(), 
        axis.text.x = element_text(angle = 330, hjust = 0))