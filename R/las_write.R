#' Write LAS object to LAS file
#'
#' Reads CWLS LAS file/s from a directory location and returns a data.table of the log section data by well
#' @param las In memory las object
#' @param path Directory path to write las file
#' @return Writes a las object as a LAS file to disk
#' @export
#'

write_las <- function(las, path) {
  las_string <- .las_to_vector(las)
  writeLines(las_string, path)
}

.las_section_to_string <- function(df, section) {
  # Convert a section block of LAS files to a string vector to ready to write back out as a .LAS file
  #
  # Takes a data.frame object from a LAS object (WELL, PARAM, CURVE) and converts it to a formatted table as #a string
  # vector.
  # @param df A valid data.frame from a LAS object, needs to be one of the WELL, PARAM or CURVE tables
  # @param section The associated section code for the data.frame (~W, ~P, ~C) as a string
  # @return returns a formatted table as a string vector with line breaks - ready to pass to writeLines
  # @export
  #
  if (is.null(df)) return("#")
  df[,1] <- stringr::str_c(df[,1], ".", df[,2])
  df[,1] <- stringr::str_pad(df[,1], width = 10, side = "right")
  space_width = max(nchar(df[,2])) + max(nchar(df[,1])) + 15
  df[,3] <- stringr::str_pad(df[,3], width = space_width, side = "left")
  df[,3] <- stringr::str_c(df[,3], ":")
  df[,4] <- stringr::str_pad(df[,4], width = space_width, side = "left")
  df_out <- stringr::str_c(df[,1], df[,3], df[,4])
  first_line <- section
  second_line <- "#MNEM.UNIT          VALUE/NAME          DESCRIPTION"
  third_line <-  "#------------       ---------------     --------------------"
  lines = c(first_line, second_line, third_line, df_out, "#", "#")
  lines_out <- paste(lines, sep = "\n")
  return(lines_out)
}

.las_version_to_string <- function(version = c(1.2, 2.0)) {

  # Get appropriate Version and Wrapping lines for a valid CWLS LAS file
  #
  # Returns a string containing the version and wrap lines for the desired version code (1.2 and 2.0 #supported)
  # @param version numeric one of 1.2 or 2.0
  # @return returns a vector with the VERSION and WRAP lines - ready to pass to writeLines
  # @export
  #
  if (version == 1.2) return(c("~Version Information", " VERS. 1.2                          : CWLS LOG ASCII STANDARD - VERSION 1.2", " WRAP.                NO            : One line per depth step", "#", "#"))
  if (version == 2.0) return(c("~Version Information", " VERS. 2.0                          : CWLS LOG ASCII STANDARD - VERSION 2.0", " WRAP.                NO            : One line per depth step", "#", "#"))
}



.las_data_to_string <- function(las) {
  # Convert the LOG section of a LAS object to a string for writing
  #
  # Returns a string vector version of the LOG data from the LAS file, ready to passed to writeLines
  # @param las The log file to be converted to a string vector
  # @return returns a table formatted as a string vector ready to be passed to writeLines
  # @export
  #
  df = las$LOG
  null_char = las$WELL$VALUE[las$WELL$MNEM == "NULL"]
  df[is.na(df)] <- null_char
  header = paste(c("~A", colnames(df)), collapse = "       ")
  df1 = apply(df, MARGIN = 2, function(x) stringr::str_pad(x,width = 11, side = "left"))
  df2 = apply(df1, MARGIN = 1, function(x) paste(x, collapse = ""))
  df_out = c(header, df2)
  return(df_out)
}



.las_to_vector <- function(las) {
  # Converts an entire LAS object to a string object ready to be written to a file
  #
  # Convenience function to convert each piece of a LAS object back into formatted strings to write with writeLines
  # @param las The the LAS object (as created with read_las)
  # @return returns a string vector with all the appropriate formatting to write the LAS object back out to a .LAS file using writeLines
  # @export
  #


  version_info = .las_version_to_string(las$VERSION)
  well_info = .las_section_to_string(las$WELL, "~W")
  curve_info = .las_section_to_string(las$CURVE, "~C")
  param_info = .las_section_to_string(las$PARAM, "~P")
  other_info = c("~O", las$OTHER)
  data_out <- .las_data_to_string(las)
  lines_out <- c(version_info, well_info, curve_info, param_info, other_info,"#", "#", data_out)
  return(lines_out)
}


