#' An example of a LAS object.
#'
#' An example of a LAS object created from a LAS file (49-005-30258.las) downloaded from the Minnelusa Digital Log Data website  
#' 
#'@usage las_obj = lastools::example_las_obj
#'
#' @format A List of length 8 comprising of
#' \describe{
#'   \item{VERSION}{LAS version number}
#'   \item{WELL}{A data frame describing the well section (~W) information. Comprises of four columns (MNEM (Mnemonic code),UNIT (Unit code),VALUE,DESCRIPTION)}
#'   \item{CURVE}{A data frame describing the curve section (~C) information. Comprises of four columns (MNEM (Mnemonic code), UNIT (Unit code),API.CODE, DESCRIPTION)}
#'   \item{PARAM}{A data frame describing the parameter (~P) information. Comprises of four columns  (MNEM (Mnemonic code),UNIT (Unit code),VALUE,DESCRIPTION)}
#'   \item{OTHER}{Placeholder for 'Other' information}
#'   \item{LOG}{A data frame describing the log (~A) information. Comprises of four columns (DEPT (Depth), DT (Delata travel time), RESD (Resistivity), SP (Spontaneous Potential), GR (Gamma Ray))}
#'   \item{PATH}{Usually stores the file load path. In this case is set to "Example"}
#'   \item{ATTRIBUTES}{A data frame with eight columns describing the primary well attribute information including (well (the well id), null (the LOG data null value), start(the LOG data start depth),start_units (the start depth units (in this case Feet), stop (the LOG data end depth), step (LOG data increment step size), step_units (LOG data step units),path (the original load path location))} 
#'   ...
#' }
#' @source \url{www.Minnelusa.com}
"example_las_obj"

lastools::`las_convert_v2<-`() 

las_convert_v2(x) <- TRUE