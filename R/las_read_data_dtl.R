#' Read las log data to data table
#'
#' Reads CWLS LAS file/s from a directory location and returns a data.table of the log section data by well
#' @param dir string directory path containing .las file/s
#' @return Returns list of data tables containing well_name, DEPT (Depth),variable,value and file (location of las file)
#' @export
#' @import data.table
#'

read_las_data_dtl <- function (dir) {
  library(data.table)
  laslist <- list.files(dir, pattern = "\\.las$",recursive = TRUE,full.names = T)
  las_data <- lapply(laslist,function(x) try(.get_las_data_dt(x)))
  return(las_data)
}

#function passes info into read_las_data_df
.get_las_data_dt <- function(x)
{
  library(data.table)
  las <- lastools::read_las(x)
  filename <- x

  #set up mapping table to join descriptions and units
  curvemap <- as.data.frame(las$CURVE$MNEM)
  setDT(curvemap)
  curvemap$Units <- (las$CURVE$UNIT)
  curvemap$Descr <- (las$CURVE$DESCRIPTION)
  names(curvemap) <- c("variable","Units","Descr")

  #melt the data table to long format
  #df <- as.data.table(las$LOG)
  df <- las$LOG
  dfmelt <- melt(df, id="DEPT")
  #add well name
  dfmelt$well_name <- subset(las$WELL$VALUE,las$WELL$MNEM =="WELL")
  dfmelt$well_name <- ifelse (is.na(dfmelt$well_name),filename, dfmelt$well_name)
  dfmelt$file <- filename
  #merge the description and units
  dfmelt <- merge(dfmelt,curvemap)
  setDT(dfmelt)
  return(dfmelt)
}






