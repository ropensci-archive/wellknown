#' Make WKT polygon objects
#'
#' @export
#'
#' @param ... A GeoJSON-like object representing a Point, LineString, Polygon, MultiPolygon, etc.
#' @param fmt Format string which indicates the number of digits to display after the
#' decimal point when formatting coordinates. Max: 20
#' @examples
#' # numeric
#' polygon(c(100.001, 0.001), c(101.12345, 0.001), c(101.001, 1.001), c(100.001, 0.001))
#'
#' # data.frame
#' df <- us_cities[1:25,c('long','lat')]
#' polygon(df)
#'
#' # list
#' polygon(list(c(100.001, 0.001), c(101.12345, 0.001), c(101.001, 1.001), c(100.001, 0.001)))
polygon <- function(..., fmt = 16) {
  UseMethod("polygon")
}

#' @export
polygon.numeric <- function(..., fmt = 16){
  pts <- list(...)
  fmtcheck(fmt)
  invisible(lapply(pts, checker, type='POLYGON', len=2))
  str <- paste0(lapply(pts, function(z){
    sprintf("(%s)", paste0(str_trim_(format(z, nsmall = fmt, trim = TRUE)), collapse = " "))
  }), collapse = ", ")
  sprintf('POLYGON (%s)', str)
}

#' @export
polygon.data.frame <- function(..., fmt = 16){
  pts <- list(...)
  fmtcheck(fmt)
  # invisible(lapply(pts, checker, type='MULTIPOINT', len=2))
  str <- paste0(apply(pts[[1]], 1, function(z){
    sprintf("(%s)", paste0(str_trim_(format(z, nsmall = fmt, trim = TRUE)), collapse = " "))
  }), collapse = ", ")
  sprintf('POLYGON (%s)', str)
}

#' @export
polygon.list <- function(..., fmt = 16) {
  pts <- list(...)[[1]]
  fmtcheck(fmt)
  str <- paste0(lapply(pts, function(z) {
    paste0(str_trim_(format(z, nsmall = fmt, trim = TRUE)), collapse = " ")
  }), collapse = ", ")
  sprintf('POLYGON (%s)', str)
}
