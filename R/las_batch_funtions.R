las_get_las_file_paths <- function(path) {
  las_files <- list.files(path, full.names = T)
  las_files <- las_files[stringr::str_detect(toupper(las_files), "\\.LAS")]
  return(las_files)
}


las_read_all <- function(folder_path) {
  if (length(folder_path) == 1) {
    las_paths <- las_get_las_file_paths(folder_path)
  }
  else {
    las_paths <- folder_path
  }
  las_objects <-lapply(las_paths, read_las)
  return(las_objects)
}






