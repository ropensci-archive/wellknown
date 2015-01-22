# point <- list('type' = 'Point', 'coordinates' = c(116.4, 45.2, 11.1))
# point
#
# decimals <- 16
# coords <- point$coordinates
# sprintf('POINT (%s)', paste0(format(coords, nsmall = decimals), collapse = ""))

#' Convert GeoJSON-like POINT object to WKT.
#'
#' @export
#'
#' @param obj A GeoJSON-like `dict` representing a Point.
#' @param fmt Format string which indicates the number of digits to display after the
#' decimal point when formatting coordinates.
#' @return WKT representation of the input GeoJSON Point ``obj``.
#' @examples
#' point <- list('type' = 'Point', 'coordinates' = c(116.4, 45.2, 11.1))
#' dump_point(point)

dump_point <- function(obj, fmt = 16){
  coords <- obj$coordinates
  sprintf('POINT (%s)', paste0(format(coords, nsmall = fmt), collapse = ""))
}

#' Convert GeoJSON-like LineString object to WKT.
#'
#' @export
#'
#' @param obj A GeoJSON-like `dict` representing a LineString
#' @param fmt Format string which indicates the number of digits to display after the
#' decimal point when formatting coordinates.
#' @examples
#' st <- list(type = 'LineString',
#'            coordinates = list(c(0.0, 0.0, 10.0), c(2.0, 1.0, 20.0),
#'                              c(4.0, 2.0, 30.0), c(5.0, 4.0, 40.0)))
#' dump_linestring(st, fmt=0)
dump_linestring <- function(obj, fmt = 16){
  coords <- obj$coordinates
  str <- paste0(lapply(coords, function(z){
    paste0(gsub("\\s", "", format(z, nsmall = fmt)), collapse = " ")
  }), collapse = ", ")
  sprintf('LINESTRING (%s)', str)
}
