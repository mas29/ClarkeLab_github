# install.packages("shiny")
library(shiny)
system.file("examples", package="shiny")
runExample("01_hello") # a histogram
runExample("02_text") # tables and data frames
runExample("03_reactivity") # a reactive expression
runExample("04_mpg") # global variables
runExample("05_sliders") # slider bars
runExample("06_tabsets") # tabbed panels
runExample("07_widgets") # help text and submit buttons
runExample("08_html") # Shiny app built from HTML
runExample("09_upload") # file upload wizard
runExample("10_download") # file download wizard
runExample("11_timer") # an automated timer


runApp("/Users/maiasmith/Documents/SFU/ClarkeLab/ClarkeLab_github/Scripts/shiny_scripts/myApp1")
runApp("/Users/maiasmith/Documents/SFU/ClarkeLab/ClarkeLab_github/Scripts/shiny_scripts/temp_sparklines", launch.browser = TRUE)
runApp("/Users/maiasmith/Documents/SFU/ClarkeLab/ClarkeLab_github/Scripts/shiny_scripts/explore_compound", launch.browser = TRUE)

# Check out: http://rmarkdown.rstudio.com/authoring_shiny.html for integration with RMarkdown