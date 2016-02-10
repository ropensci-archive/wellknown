#' Get a centroid from WKT or geojson
#'
#' @export
#' @param x Input, a wkt character string or geojson class object
#' @return A length 2 numeric vector, with longitude first, latitude second
#' @examples
#' # WKT
#' str <- "POINT (-116.4000000000000057 45.2000000000000028)"
#' get_centroid(str)
#' str <- 'MULTIPOINT ((100.000 3.101), (101.000 2.100), (3.140 2.180))'
#' get_centroid(str)
#' str <- "MULTIPOLYGON (((40 40, 20 45, 45 30, 40 40)),
#'    ((20 35, 45 20, 30 5, 10 10, 10 30, 20 35), (30 20, 20 25, 20 15, 30 20)))"
#' get_centroid(str)
#'
#' # Geojson as geojson class
#' str <- "POINT (-116.4000000000000057 45.2000000000000028)"
#' get_centroid(wkt2geojson(str))
#' str <- 'MULTIPOINT ((100.000 3.101), (101.000 2.100), (3.140 2.180))'
#' get_centroid(wkt2geojson(str))
#' str <- "MULTIPOLYGON (((40 40, 20 45, 45 30, 40 40)),
#'    ((20 35, 45 20, 30 5, 10 10, 10 30, 20 35), (30 20, 20 25, 20 15, 30 20)))"
#' get_centroid(wkt2geojson(str))
get_centroid <- function(x) {
  UseMethod("get_centroid")
}

#' @export
get_centroid.character <- function(x) {
  centroid(wkt2geojson(x), center = NULL)
}

#' @export
get_centroid.geojson <- function(x) {
  centroid(x, center = NULL)
}
