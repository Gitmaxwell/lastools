#' @title Read las curve mnemonics data to data frame
#'
#' @description This function extracts las mnemonics from all las files in a directory
#' @param dir The Target Directory containing the .las files (required)
#' @export
#' @examples
#' get_all_las_mnemonics(dir)


read_las_mnemonics_df <- function(dir)

{
  get_mnemonics <- function(x)

  {
    las <- lastools::read_las(x)
    mnem.df <- as.data.frame(las$CURVE$MNEM)
    mnem.df <- as.data.frame(las$CURVE$DESCRIPTION)
    names(mnem.df) <- c("mnem")
    return(mnem.df)
  }
  list.of.files <- list.files(dir, pattern = "\\.las$",recursive = TRUE, full.names = T)
  mnem <- lapply(list.of.files,function(x) get_mnemonics(x))
  mnem <-unique(as.data.frame(do.call(rbind,mnem)))
  return (mnem)
}