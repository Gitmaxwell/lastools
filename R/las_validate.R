
las_validate_format <- function(path) {


  las_section_codes <- c("~V", "~W", "~C", "~P", "~O", "~A")
  las_required_section_codes <- c("~V", "~W", "~C", "~A")
  las_well_headers <- c("STRT", "STOP", "STEP", "NULL", "COMP", "WELL", "FLD", "LOC", "SRVC", "DATE")
  las_required_well_headers <- c("STRT", "STOP", "STEP", "NULL")


  sections_appear_once <- F
  required_sections_in_file <- F
  required_well_headers_present <- F
  start_depth_matches_well_table <- F
  stop_depth_matches_well_table <- F
  step_distance_matches_log <- F
  lines <- readLines(path)

  #Remove comment lines
  lines <- lines[!stringr::str_detect(stringr::str_sub(lines, 1, 5), "#")]

  #Vectors of validation parameters
  section_appearances <- sapply(las_section_codes, function(x) sum(stringr::str_detect(lines, x)))
  required_section_appearances <- sapply(las_required_section_codes <- c("~V", "~W", "~C", "~A"), function(x) sum(stringr::str_detect(lines, x)))

  if (all(required_section_appearances > 0)) required_sections_in_file <- T
  if (all(section_appearances <= 1)) sections_appear_once <- T

  #Extract the well data for checking

  if (all(required_section_appearances)) {
  well_block_rows <- .las_get_block_dims(lines, "~W")
  well_data <- do.call(rbind, lapply(lines[well_block_rows], function(x) .las_parse_table_line(x, section = "~W")))
  required_well_headers_present <- all(las_required_well_headers %in% well_data$MNEM)
  if (required_well_headers_present) {
  las = read_las(path)
  las_attributes <- las_get_attributes(las)
  expected_length <- abs(las_attributes$stop - las_attributes$start) / las_attributes$step
  log_length <- nrow(las$LOG)
  if (expected_length == log_length) step_distance_matches_log <- T
  if (las$LOG[1,1] == las_attributes$start) start_depth_matches_well_table <- T
  if (las$LOG[nrow(las$LOG),1] == las_attributes$stop) stop_depth_matches_well_table <- T
  }
  }

  checks <- c(sections_appear_once,
    required_sections_in_file,
    required_well_headers_present,
    start_depth_matches_well_table,
    stop_depth_matches_well_table,
    step_distance_matches_log)

  warnings = c( "Duplicate section codes found",
                "Missing required section blocks",
                "Missing WELL information headers",
                "Start depth does not match log",
                "Stop depth does not match log",
                "Log length does not match expected length")

  if (all(checks)) return(T) else {
    print(warnings[checks==F])
    return(F)
  }

}


