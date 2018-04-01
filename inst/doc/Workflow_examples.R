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



## ---- echo=TRUE, warning=FALSE, message=FALSE,results='hide'-------------

#retrive sample  las files from minnelusa
  #download zip file to a temp directory
tmpdir <- tempdir()
tmploc <- paste(tmpdir,"\\","LAS_Sample_API.zip", sep="")
download.file("http://www.minnelusa.com/sample_data/LAS_Sample_API.zip","LAS_Sample_API.zip")

#unzip file in working directory
unzip("LAS_Sample_API.zip")

#read in one of the sample las files
las1 <- lastools::read_las("49-005-30999.las")



## ---- echo=FALSE, results='asis',fig.width=4, fig.height=6---------------
#inspect the WELL  component of the 
knitr::kable(las1$WELL,digits = 3,align = c("c"), caption = "las1$WELL")


## ---- echo=FALSE, results='asis',fig.width=4, fig.height=6---------------
#inspect the WELL  component of the 
knitr::kable(las1$CURVE,digits = 3,align = c("c"), caption = "las1$CURVE")


## ---- echo=TRUE, warning=FALSE, message=FALSE, results='hide'------------

#read all unzipped las files in working directory to a data.table
las_df <- lastools::read_las_data_df(getwd())

#setcolorder(las_df,c("well_name","DEPT","variable","Units","Descr","value","file"))


## ---- echo=FALSE, warning=FALSE, message=FALSE---------------------------

#obviscate file loaction column 
las_df$file <- c("file location")
#preview the data
knitr::kable(head(las_df, n=10),digits = 3,align = c("c"), caption = "Preview of imported LAS data from lastools::read_las_data_df")


## ---- echo=FALSE, results='asis',fig.width=4, fig.height=6,fig.align="center"----
#inspect the WELL  component of the 
lastools::las_plot(las1)


## ---- echo=TRUE, warning=FALSE, message=FALSE,fig.width=7, fig.height=9,fig.align="center"----

#get the names of the first two wells in the data.table
wells <-  unique(las_df$well_name)[1:2]
#subset the data.table for plotting
lassubs <- subset(las_df, las_df$variable %in% c("GR", "SP") & las_df$well_name %in% wells)
#set up the plot faceted by variable and well
lasplot <- ggplot2::ggplot(lassubs, ggplot2::aes_string(x = "value", y = "DEPT")) 
lasplot <- lasplot + ggplot2::geom_path(ggplot2::aes_string(color = "variable")) 
lasplot <- lasplot + ggplot2::scale_y_reverse() 
lasplot <- lasplot + ggplot2::facet_wrap(~well_name+variable, scale = "free_x", nrow = 1)
#plot the data
plot(lasplot)

## ---- echo=TRUE, warning=FALSE, message=FALSE,fig.width=5, fig.height=5,fig.align="center"----


library(ggtern)
tern <-  ggtern::ggtern(data=las1$LOG, aes(GR,SP,DT)) + geom_point()
plot(tern)


## ---- echo=TRUE, warning=FALSE, message=FALSE,fig.width=10, fig.height=5,fig.align="center"----

  #add noramilsed data
normalise <- function(x) {(x-min(x, na.rm = T))/(max(x,na.rm = T)-min(x,na.rm = T))}
las_df <- as.data.table(las_df)
las_df[,`:=`(normvalue =normalise(value)),by=.(variable)]
las_df_dc <- dcast(las_df, well_name+DEPT~variable, value.var = "normvalue")

#bend in plot at 7-8 clusters

library(cluster)

set.seed(4)
#k - means - efacies
kfit <- pam(las_df_dc[,c("GR","SP","DT","RESD")], 6)
#plot(las_df_dc[,c("GR","SP","DT")],col = kfit$cluster)
#append cluster to data
las_df_dc$clust <- kfit$cluster
#normalise cluster values so we plot nicely
las_df_dc$clust <- normalise(kfit$cluster)


las_df_melt <- melt(las_df_dc, id.vars = c("well_name","DEPT"))
setorderv(las_df_melt, c("well_name", "DEPT", "variable"))


lasplot2 <- ggplot2::ggplot(subset(las_df_melt,las_df_melt$well_name ==c("#13-31 Hoffman Et Al")), ggplot2::aes_string(x = "value", y = "DEPT")) 
lasplot2 <- lasplot2 + ggplot2::geom_path(ggplot2::aes_string(color = "value")) 
lasplot2 <- lasplot2 + ggplot2::scale_y_reverse() 
lasplot2 <- lasplot2 + ggplot2::facet_wrap(~variable, scale = "free_x", nrow = 1)
#lasplot2 <- lasplot2 + ggplot2::facet_wrap(~variable, nrow = 1)
lasplot2 <- lasplot2 + scale_colour_gradientn(colours = terrain.colors(10))
#plot the data
plot(lasplot2)


ggplot(data=subset(las_df_melt,las_df_melt$well_name ==c("#13-31 Hoffman Et Al")), aes(x=DEPT, y=value, colour=variable)) + geom_line() 

library(ggtern)
#tern <-  ggtern::ggtern(data=las_df_dc, aes(GR,SP,DT, colour=clust)) + geom_point() 
tern <-  ggtern::ggtern(data=las_df_dc, aes(GR,SP,DT)) + geom_point() 
#+ scale_colour_gradientn(colours = primary.colors(5))
# + scale_colour_gradientn(colours = terrain.colors(10))
plot(tern)


#library(cluster)
#data(xclara)
#km <- kmeans(xclara[1:100,],3)
#dissE <- daisy(xclara[1:100,])
#sk <- silhouette(km$cl, dissE)
#plot(sk)


## ---- echo=TRUE, warning=FALSE, message=FALSE,fig.width=10, fig.height=5,fig.align="center"----

install.packages("kohonen")

library(kohonen)

#https://www.r-bloggers.com/self-organising-maps-for-customer-segmentation-using-r/
  
#add noramilsed data
normalise <- function(x) {(x-min(x, na.rm = T))/(max(x,na.rm = T)-min(x,na.rm = T))}
las_df <- as.data.table(las_df)
las_df[,`:=`(normvalue =normalise(value)),by=.(variable)]
las_df_dc <- dcast(las_df, well_name+DEPT~variable, value.var = "normvalue")

#bend in plot at 7-8 clusters

library(cluster)

set.seed(4)
#k - means - efacies
kfit <- pam(las_df_dc[,c("GR","SP","DT","RESD")], 6)
#plot(las_df_dc[,c("GR","SP","DT")],col = kfit$cluster)
#append cluster to data
las_df_dc$clust <- kfit$cluster
#normalise cluster values so we plot nicely
las_df_dc$clust <- normalise(kfit$cluster)


las_df_melt <- melt(las_df_dc, id.vars = c("well_name","DEPT"))
setorderv(las_df_melt, c("well_name", "DEPT", "variable"))


lasplot2 <- ggplot2::ggplot(subset(las_df_melt,las_df_melt$well_name ==c("#13-31 Hoffman Et Al")), ggplot2::aes_string(x = "value", y = "DEPT")) 
lasplot2 <- lasplot2 + ggplot2::geom_path(ggplot2::aes_string(color = "value")) 
lasplot2 <- lasplot2 + ggplot2::scale_y_reverse() 
lasplot2 <- lasplot2 + ggplot2::facet_wrap(~variable, scale = "free_x", nrow = 1)
#lasplot2 <- lasplot2 + ggplot2::facet_wrap(~variable, nrow = 1)
lasplot2 <- lasplot2 + scale_colour_gradientn(colours = terrain.colors(10))
#plot the data
plot(lasplot2)


ggplot(data=subset(las_df_melt,las_df_melt$well_name ==c("#13-31 Hoffman Et Al")), aes(x=DEPT, y=value, colour=variable)) + geom_line() 

library(ggtern)
#tern <-  ggtern::ggtern(data=las_df_dc, aes(GR,SP,DT, colour=clust)) + geom_point() 
tern <-  ggtern::ggtern(data=las_df_dc, aes(GR,SP,DT)) + geom_point() 
#+ scale_colour_gradientn(colours = primary.colors(5))
# + scale_colour_gradientn(colours = terrain.colors(10))
plot(tern)


#library(cluster)
#data(xclara)
#km <- kmeans(xclara[1:100,],3)
#dissE <- daisy(xclara[1:100,])
#sk <- silhouette(km$cl, dissE)
#plot(sk)


