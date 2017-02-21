#https://beta.rstudioconnect.com/content/1813/babynames-dplyr.nb.html

#install.packages("sparklyr")
#install.packages("babynames")
#install.packages("ggplot2")
install.packages("dygraphs")

#.libPaths( c( .libPaths(), "/home/akhil/R/x86_64-pc-linux-gnu-library/3.2/") )

#library(dplyr)
library(sparklyr)
library(dplyr)
library(babynames)
library(ggplot2)
library(dygraphs)
#mtcars

#ss <- select(mtcars, c(disp, drat))

sc <- spark_connect(master = "spark://10.95.1.24:7077", spark_home="/usr", version = "1.6.0")
