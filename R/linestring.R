#' Make WKT linestring objects
#'
#' @export
#'
#' @param ... A GeoJSON-like object representing a Point, LineString, Polygon, MultiPolygon, etc.
#' @param fmt Format string which indicates the number of digits to display after the
#' decimal point when formatting coordinates. Max: 20
#' @examples
#' linestring(c(100.000, 0.000), c(101.000, 1.000), fmt=2)
#' linestring(c(100.0, 0.0), c(101.0, 1.0), c(120.0, 5.00), fmt=2)
#' linestring(c(0.0, 0.0, 10.0), c(2.0, 1.0, 20.0),
#'            c(4.0, 2.0, 30.0), c(5.0, 4.0, 40.0), fmt=2)
linestring <- function(..., fmt = 16) {
  UseMethod("linestring")
}

#' @export
linestring.numeric <- function(..., fmt = 16){
  pts <- list(...)
  fmtcheck(fmt)
  # invisible(lapply(pts, checker, type='LINESTRING', len=2))
  str <- paste0(lapply(pts, function(z){
    paste0(gsub("\\s", "", format(z, nsmall = fmt, trim = TRUE)), collapse = " ")
  }), collapse = ", ")
  sprintf('LINESTRING (%s)', str)
}
