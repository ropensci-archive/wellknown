#' Make WKT multipoint objects
#'
#' @export
#'
#' @param ... A GeoJSON-like object representing a Point, LineString, Polygon, MultiPolygon, etc.
#' @param fmt Format string which indicates the number of digits to display after the
#' decimal point when formatting coordinates. Max: 20
#' @examples
#' multipoint(c(100.000, 3.101), c(101.000, 2.100), c(3.140, 2.180))
#' # multipoint(0, 1)
#' # point(-116.4)
#' # point()
#' # point(NA)
#' # point(NA, NULL)
multipoint <- function(..., fmt = 16) {
  UseMethod("multipoint")
}

#' @export
multipoint.numeric <- function(..., fmt = 16){
  pts <- list(...)
  fmtcheck(fmt)
  invisible(lapply(pts, checker, type='MULTIPOINT', len=2))
  str <- paste0(lapply(pts, function(z){
    sprintf("(%s)", paste0(str_trim_(format(z, nsmall = fmt, trim = TRUE)), collapse = " "))
  }), collapse = ", ")
  sprintf('MULTIPOINT (%s)', str)
}
