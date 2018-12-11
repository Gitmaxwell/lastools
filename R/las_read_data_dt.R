#' Read las log data to data table
#'
#' Reads CWLS LAS file/s from a directory location and returns a data.table of the log section data by well
#' @param dir string directory path containing .las file/s
#' @return Returns a long format data.table containing well_name, DEPT (Depth),variable,value and file (location of las file)
#' @export
#' @import data.table

read_las_data_dt <- function (dir) {
  laslist <- list.files(dir, pattern = "\\.las$",recursive = TRUE,full.names = T, ignore.case = T)
  las_data <- lapply(laslist,function(x) try(get_las_data_dt(x)))
  #check list items to see if they are data tables
  isdt <- lapply(seq(1,length(las_data)), function (x) data.table::is.data.table(las_data[[x]]))
  #only bind list items which are data tables
  las_data <- data.table::rbindlist(las_data[unlist(isdt)])
  return(las_data)
}

#function passes info into read_las_data_df

get_las_data_dt <- function(x)
{
  las <- lastools::read_las(x)
  filename <- x

  #cleaning up the file
  #remove trailing and leading white spaces and spaces and convert to upper
  well_name <- subset(las$WELL$VALUE,las$WELL$MNEM =="WELL")
  well_name <- trimws(well_name, which = c("both"))
  well_name <- gsub(" ", "",well_name, fixed = TRUE)
  well_name <- toupper(well_name)

  las$CURVE$MNEM <- trimws(las$CURVE$MNEM, which = c("both"))
  las$CURVE$MNEM <- gsub(" ", "",las$CURVE$MNEM, fixed = TRUE)
  las$CURVE$MNEM <- toupper(las$CURVE$MNEM)
  las$CURVE$UNIT <- trimws(las$CURVE$UNIT, which = c("both"))
  las$CURVE$UNIT <- gsub(" ", "",las$CURVE$UNIT, fixed = TRUE)
  las$CURVE$UNIT <- toupper(las$CURVE$UNIT)
  las$CURVE$MNEM <- trimws(las$CURVE$MNEM, which = c("both"))
  las$CURVE$MNEM <- gsub(" ", "",las$CURVE$MNEM, fixed = TRUE)
  las$CURVE$MNEM <- toupper(las$CURVE$MNEM)
  las$CURVE$DESCRIPTION <- trimws(las$CURVE$DESCRIPTION, which = c("both"))
  #las$CURVE$DESCRIPTION <- gsub(" ", "",las$CURVE$DESCRIPTION, fixed = TRUE)
  las$CURVE$DESCRIPTION <- toupper(las$CURVE$DESCRIPTION)

  #now melt the curve data to join to the log data
  curvemap <- as.data.frame(las$CURVE$MNEM)
  data.table::setDT(curvemap)
  curvemap$Units <- (las$CURVE$UNIT)
  curvemap$Descr <- (las$CURVE$DESCRIPTION)
  #concatonate the varaibale and units name
  curvemap$MNEM.UNIT <- paste(las$CURVE$MNEM, las$CURVE$UNIT , sep=".")
  names(curvemap) <- c("variable","Units","Descr", "MNEM.UNIT")

  #melt the data table to long format
  df <- las$LOG
  data.table::setDT(df)
  dfmelt <- data.table::melt(df, id=1)
  dfmelt$value <- as.numeric(dfmelt$value)
  #remove resultant NA values
  dfmelt$value <- ifelse(dfmelt$value <0,NA,dfmelt$value)
  dfmelt <- subset(dfmelt, !(is.na(dfmelt$value)))
  dfmelt$well_name <- subset(las$WELL$VALUE,las$WELL$MNEM =="WELL")
  dfmelt$well_name <- ifelse(is.na(dfmelt$well_name),filename, dfmelt$well_name)
  dfmelt$file <- filename
  #merge the description and units
  #dfmelt <- merge(dfmelt,curvemap)
  dfmelt <- curvemap[dfmelt, on=.(variable=variable),nomatch=0,allow.cartesian=TRUE]
  names(dfmelt) <- c("variable","Units","Descr","MNEM.UNIT", "DEPT","value","well_name","file")
  dfmelt <- dfmelt[order(well_name,variable,Descr,DEPT)]
  dfmelt$DEPT <- round(as.numeric(dfmelt$DEPT),3)
  return(dfmelt)
}



