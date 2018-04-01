#' Read a LAS file
#'
#' Reads a CWLS LAS file and returns a list object with the VERSION, WELL, CURVE, PARAMETER, OTHER and LOG sections, as well as storing the original path of the file.
#' @param filepath string       path to the LAS file
#' @param replace_null boolean  replace the NULLS in the LOG section (as given by the WELL table) to the R NA value
#' @return Returns a list object with VERSION, WELL, CURVE, PARAMETER, OTHER and LOG sections. WELL, CURVE, PARAMETER and LOG are data.frames. OTHER is a string with line breaks. VERSION is a numeric (1.2 or 2.0)
#' @export
#'
read_las <- function(filepath, replace_null = T) {
  out <- tryCatch({
  if (is.null(filepath)) return(NULL)
  filepath = as.character(filepath)
  lasfile <- file(filepath,open="r")
  lines <- readLines(lasfile)
  print(filepath)
  if (!any(stringr::str_detect(lines[1:5], "~V"))) {
    close(lasfile)
    print(paste(filepath, "doesn't appear to be a LAS file"))
    return(NULL)
  }

  lines <- lines[!stringr::str_detect(stringr::str_sub(lines, 1, 5), "#")]
  lines <- lines[!is.na(lines)]
  #print(lines[1:30])
  version <- .las_get_version(lines)
  well_block_rows <- .las_get_block_dims(lines, "~W")
  curve_block_rows <- .las_get_block_dims(lines, "~C")
  param_block_rows <- .las_get_block_dims(lines, "~P")
  data_block_rows <- .las_get_block_dims(lines, "~A")
  other_block_rows <- .las_get_block_dims(lines, "~O")
  #Other data block is line is joined with new line characters
  other_data <- paste(lines[other_block_rows], collapse = '\n')
  #Call parsing of table lines over each table section, and paste together with DO CALL
  well_data <- do.call(rbind, lapply(lines[well_block_rows], function(x) .las_parse_table_line(x, section = "~W")))
  print(curve_block_rows)
  curve_data <- do.call(rbind, lapply(lines[curve_block_rows], function(x) .las_parse_table_line(x, section = "~C")))
  param_data <- do.call(rbind, lapply(lines[param_block_rows], function(x) .las_parse_table_line(x, section = "~P")))
  #Convert to a data.frame
  log_data <- data.frame(.las_get_log_data(lines[data_block_rows]))
  #Replace null characters if required
  if (replace_null == T) {
    log_data[log_data == as.numeric(as.character(well_data$VALUE[stringr::str_detect(well_data$MNEM, "NULL")]))] <- NA
  }
  colnames(log_data) <- stringr::str_trim(curve_data$MNEM)
  close(lasfile)
  lasobj = list("VERSION" = version, "WELL" = well_data,"CURVE" = curve_data, "PARAM" = param_data,"OTHER" = other_data, "LOG" = log_data)
  attributes = las_get_attributes(lasobj)
  attributes$path = filepath
  lasobj = list("VERSION" = version, "WELL" = well_data,"CURVE" = curve_data, "PARAM" = param_data,"OTHER" = other_data, "LOG" = log_data, "PATH" = filepath, "ATTRIBUTES" = attributes)
  return(lasobj)
  },
    error = function(cond) {
      message(paste("Problem with file:", filepath))
      message("Here's the original error message:")
      message(cond)
      # Choose a return value in case of error
      return(filepath)
    })
  return(out)
}


.las_get_version <- function(lines) {
  version_row <- which(stringr::str_detect(lines, "~V"))
  version = lines[version_row+1]
  if (stringr::str_detect(version, "1.2")) return(1.2) else return(2.0)
}

.las_get_block_dims <- function(lines, section) {
  #Finds the block row indices for the sections ~A, ~O, ~C, ~P,
  if (!section %in% c("~A", "~O", "~C", "~P", "~W")) {
    warning("Invalid section header")
    return(c(0))
  }

  start_row <- which(stringr::str_detect(lines, section))
  if (length(start_row)==0) return(c(0,0))
  block_vector <- numeric()
  if (section %in%  c("~W", "~C", "~P")) {
    for (i in (start_row:length(lines))) {
      if (!stringr::str_detect(stringr::str_sub(lines[i], 1, 5), "#") & !stringr::str_detect(lines[i], "~") & stringr::str_detect(stringr::str_sub(lines[i], 1, 20), "\\.")) block_vector <- c(block_vector, i)
      if (stringr::str_detect(lines[i], "~") & (i > start_row)) break
        }
  }

  if (section ==  "~O") {
    for (i in (start_row:length(lines))) {
      if (!stringr::str_detect(lines[i], "#") & !stringr::str_detect(lines[i], "~")) block_vector <- c(block_vector, i)
      if (stringr::str_detect(lines[i], "~") & (i > start_row)) break
    }
  }

  #Log section starts at the detection of the A character and ends with the last row of data
  if (section == "~A") {
    end_row <- length(lines)
    block_vector <- seq(start_row, end_row)
  }
  #Returns a sequence from start to end to use as an indexing vector
  return(block_vector)
}


.las_parse_table_line <- function(line, section) {
  first_dot <- stringr::str_locate(line, "\\.")[[1]]
  last_colon <- stringr::str_locate(line, ":")[[1]]
  spaces <- data.frame(stringr::str_locate_all(line, " ")[[1]])
  space_after_dot <- spaces[spaces[,1] > first_dot,][1,1]
  substr(line, first_dot, first_dot) <- ";"
  substr(line, last_colon, last_colon) <- ";"
  substr(line, space_after_dot, space_after_dot) <- ";"
  if (section %in% c("~W", "~P")) table_names <- c("MNEM", "UNIT", "VALUE", "DESCRIPTION")
  if (section == "~C") table_names <- c("MNEM", "UNIT", "API CODE", "DESCRIPTION")
  line = stringr::str_split(line, ";")
  names(line[[1]]) <- table_names
  df = data.frame(t(line[[1]]), stringsAsFactors = F)
  colnames(df) <- stringr::str_trim(colnames(df))
  df[,1] <- stringr::str_trim(df[,1])
  df[,2] <- stringr::str_trim(df[,2])
  df[,3] <- stringr::str_trim(df[,3])
  return(df)
}

.las_get_log_data <- function(lines) {
  lines[1] <- substr(lines[1], 3, nchar(lines[1]))
  lines <- paste(lines, collapse = "\n")
  lines <- stringr::str_replace_all(lines, "-", " -")

  return(data.table::fread(lines, header = T,showProgress = FALSE))
  #added showProgress = FALSE to supress warnings - KM 14-Nov-2017
}


