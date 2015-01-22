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

dump_point <- function(obj, fmt){
  decimals <- 16
  coords <- point$coordinates
  sprintf('POINT (%s)', paste0(format(coords, nsmall = decimals), collapse = ""))
}
