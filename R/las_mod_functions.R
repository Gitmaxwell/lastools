#' Convert the version number of a LAS object
#'
#' \code{las_version<-} Takes a LAS object created with the read_las() function and changes the CWLS LAS version.
#' lastools current supports 1.2 and 2.0 only.
#' @param x LAS object
#' @param value A number, currently needs to be 1.2 or 2.0
#' @return Modifies LAS object in place, changing the LAS version to the nominated number
#' @export
"las_version<-" = function(x, value) {
  if (length(x$VERSION) == 0) {
    warning("Object is not a valid LAS object")
  }
  if (x$VERSION == value) {
    warning("LAS file is already this version")
  } else {
    x$VERSION <- value
  }
  return(x)
}

#' Change the depth order of a LAS object in place
#'
#' \code{las_descending<-} Takes a LAS object and sorts the depth order descending if passed TRUE, or asceding if passed FALSE.
#' Also modifies the STRT, STOP and STEP parameters of the WELL information block to suit
#' @param x LAS object
#' @param value Boolean TRUE or FALSE
#' @return Modifies LAS object in place, changing the depth order and STRT, STOP and STEP parameters to suit
#' @export
"las_descending<-" <- function(x, value) {
  desc = value

  if (length(x$VERSION) == 0) {
    warning("Object is not a valid LAS object")
    return(NULL)
  }

  df <- x$LOG
  well = x$WELL

  step_amount = as.numeric(as.character(well$VALUE[well$MNEM == "STEP"]))
  start_depth = as.numeric(as.character(well$VALUE[well$MNEM == "STRT"]))
  stop_depth = as.numeric(as.character(well$VALUE[well$MNEM == "STOP"]))
  if (step_amount < 0 & desc == T) {
    warning("LAS file already in descending order")
    return(x)
  }

  if (step_amount > 0 & desc == F) {
    warning("LAS file already in ascending order")
    return(x)
  }

  if (step_amount > 0 & desc == T) {
    sort_order = order(df[,1], decreasing = desc)
  }

  if (step_amount < 0 & desc == F) {
    sort_order = order(df[,1], decreasing = desc)
  }

  new_start_depth = stop_depth
  new_stop_depth = start_depth
  well$VALUE[well$MNEM == "STEP"] = step_amount * -1
  well$VALUE[well$MNEM == "STRT"] = new_start_depth
  well$VALUE[well$MNEM == "STOP"] = new_stop_depth
  df <- df[sort_order,]
  x$LOG <- df
  x$WELL <- well
  return(x)
}

#' Change the start depth of a LAS object in place
#'
#' \code{las_set_start_depth<-} Takes a LAS object and changes the STRT depth in the WELL table of the LAS object
#' @param x LAS object
#' @param value Number to insert as the new start depth.
#' @return Modifies LAS object in place, changing the STRT parameter of the WELL information block and removing rows from the log that are lower than this number.
#' This was designed to remove negative starting DEPTHS, so caution should be used if the DEPTHS are not in ascending order.
#' @export
"las_set_start_depth<-" <- function(x, value) {
  df <- x$LOG
  df <- df[df[,1]>=value, ]
  well = x$WELL
  well$VALUE[well$MNEM == "STRT"] = value
  x$WELL <- well
  x$LOG <- df
  return(x)
}

#' Change the version of the LAS object to 2.0
#'
#' \code{las_convert_v2<-} Takes a LAS object and changes the version to V2.0 and modifies the WELL table
#' @param x LAS object
#' @param value Boolean TRUE or FALSE
#' @return Modifies LAS object in place, changing the version to V2.0, with the appropriate switching of the parameters in the WELL table
#' @export
"las_convert_v2<-" <- function(x, value) {
  if (value == T) {
    if (length(x$VERSION) == 0) {
      warning("Object is not a valid LAS object")
      return(NULL)
    }
    if (x$VERSION == 2) {
      warning("LAS object is already in version 2.0 format")
      return(x)
    } else {
      x$VERSION <- 2
      well <- x$WELL
      if (nrow(well) > 4) {
      well$VALUE[5:nrow(well)] <- well$DESCRIPTION[5:nrow(well)]
      }
      #well$VALUE[well$MNEM == "WELL"] <- stringr::str_replace_all(well$VALUE[well$MNEM == "WELL"],pattern =  " ", replacement = "")
      x$WELL <- well
      return(x)
    }
  } else {
    return(x)
  }
}

#' Remove the UWI line in the WELL table
#'
#' \code{las_remove_uwi<-} Takes a LAS object and removes the UWI line in the WELL table
#' @param x LAS object
#' @param value boolean TRUE or FALSE
#' @return Modifies LAS object in place, removing the UWI parameter from the WELL table
#' @export
"las_remove_uwi<-" <- function(x, value) {
  if (value == T) {
    well = x$WELL
    well <- well[!stringr::str_detect(toupper(well$MNEM),"UWI"),]
    x$WELL <- well
    return(x)
  } else {
    return(x)
  }
}

#' Remove the UWI line in the WELL table
#'
#' \code{las_trim_well_id<-} Takes a LAS object and removes spaces from the WELL reference in the WELL table.
#' @param x LAS object
#' @param value Boolean TRUE or FALSE
#' @return Modifies LAS object in place, removing spaces from the WELL reference in the WELL table.
#' @export
"las_trim_well_id<-" <- function(x, value) {
  if (value == T) {
    well = x$WELL
    well$VALUE[well$MNEM == "WELL"] <- stringr::str_replace_all(well$VALUE[well$MNEM == "WELL"],pattern =  " ", replacement = "")
    x$WELL <- well
    return(x)
  } else {
    return(x)
  }
}

