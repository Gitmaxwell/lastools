las_get_curve_names <- function(las) {
    return(las$CURVE$MNEM)
}

las_get_attributes <- function(las) {
  out <- tryCatch({
  well = las$WELL$VALUE[las$WELL$MNEM == "WELL"]
  if (length(well) == 0) well = "NULL"
  if (well == "WELL") well = stringr::str_trim(las$WELL$DESCRIPTION[las$WELL$MNEM == "WELL"])
  null= as.numeric(las$WELL$VALUE[las$WELL$MNEM == "NULL"])
  start= as.numeric(las$WELL$VALUE[las$WELL$MNEM == "STRT"])
  start_units = las$WELL$UNIT[las$WELL$MNEM == "STRT"]
  stop= as.numeric(las$WELL$VALUE[las$WELL$MNEM == "STOP"])
  step = as.numeric(las$WELL$VALUE[las$WELL$MNEM == "STEP"])
  step_units = las$WELL$UNIT[las$WELL$MNEM == "STEP"]
  return(data.frame("well" = well, "null" = null, "start" = start, "start_units" = start_units, "stop" = stop, "step" = step, "step_units" = step_units))
  }, error = function(cond) return(data.frame("well" = NA, "null" = NA, "start" = NA, "start_units" = NA, "stop" = NA, "step" = NA, "step_units" = NA, stringsAsFactors = F)))
}


