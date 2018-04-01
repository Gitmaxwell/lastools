#' Plot a LAS file
#'
#' Takes a lasplot LAS object and plots the log file with a facet for each variable present. Able to "zoom" to a particular depth section using the from and to variables, and able to subset a particular set of curves using the string input to columns.
#' @param las The LAS object generated with read_las
#' @param from numeric  FROM depth to use in subsetting
#' @param to numeric  TO depth to use in subsetting
#' @param columns string  A string or vector of strings with the variable names to plot eg: c("BRD", "CADE") will only plot these curves.
#' @return Returns a ggplot2 plot object with a facet for each variable with reversed depths as commonly displayed with coal.
#' @export
#'
las_plot <- function(las, from = NA, to = NA, columns = NULL) {
  df <- las$LOG
  colnames(df) <- c("Depth", colnames(df)[2:ncol(df)])
  df <- reshape2::melt(df, id = "Depth")
  if (!is.na(from) & !is.na(to)) df <- df[df$Depth >= from & df$Depth <= to,]
  if (length(columns) > 0) df <- df[df$variable %in% columns,]
  ggplot2::ggplot(df, ggplot2::aes_string(x = "value", y = "Depth")) + ggplot2::geom_path(ggplot2::aes_string(color = "variable")) + ggplot2::scale_y_reverse() + ggplot2::facet_wrap(~variable, scale = "free_x", nrow = 1)
}


