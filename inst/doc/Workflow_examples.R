## ---- echo=TRUE, eval=FALSE----------------------------------------------
#  #source directory
#  s <- c("C:/")
#  # create a target directory on the file system called "compiled_las"
#  #target directory
#  t <- c("C:/compiled_las")
#  
#  las_compile <-  function (s,t)
#  {
#  
#    list.of.files <- list.files(s, pattern = "\\.las$",recursive = TRUE, full.names = T)
#    file.copy(list.of.files,t)
#  }
#  
#  #compile las takes .las files from the source directory and moves to the target directory
#  las_compile(s,t)
#  
#  

## ---- echo=TRUE, eval=FALSE----------------------------------------------
#  lastools::read_las("filepath")

## ---- echo=TRUE, eval=FALSE----------------------------------------------
#  lastools::read_las("filepath",replace_null =FALSE)

## ---- echo=TRUE, eval=FALSE----------------------------------------------
#  lastools::read_las_data_df("directory")

## ---- echo=FALSE, results='asis',fig.width=4, fig.height=6,fig.align="center"----

library(lastools)
knitr::kable(lastools::example_las_obj$WELL,digits = 3,align = c("c"), caption = "lastools::example_las_obj$WELL")


## ---- echo=FALSE, results='asis',fig.width=4, fig.height=6,fig.align="center"----

library(lastools)
knitr::kable(lastools::example_las_obj$CURVE,digits = 3,align = c("c"), caption = "lastools::example_las_obj$CURVE")


## ---- echo=FALSE, results='asis',fig.width=4, fig.height=6,fig.align="center"----

library(lastools)
knitr::kable(lastools::example_las_obj$PARAM,digits = 3,align = c("c"), caption = "lastools::example_las_obj$PARAM")

#lastools::read_las("L:\\Coal_Quality\\R LIBRARY\\Packages\\lastools\\las_files\\PMI2279.las")


## ---- echo=FALSE, results='asis',fig.width=4, fig.height=6,fig.align="center"----

library(lastools)
knitr::kable(head(lastools::example_las_obj$LOG, n=10),digits = 3,align = c("c"), caption = "lastools::example_las_obj$LOG")



## ------------------------------------------------------------------------
library(lastools)


