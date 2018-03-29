#' As featurecollection
#' 
#' Helper function to make a FeatureCollection list object for use
#' in vizualizing, e.g., with `leaflet`
#'
#' @export
#' @param x (list) GeoJSON as a list
#' @examples
#' str <- 'MULTIPOINT ((100.000 3.101), (101.000 2.100), (3.140 2.180),
#' (31.140 6.180), (31.140 78.180))'
#' x <- wkt2geojson(str, fmt = 2)
#' as_featurecollection(x)
as_featurecollection <- function(x) {
  if (!inherits(x, "geojson")) stop("Must be of class geojson", call. = FALSE)
  x <- unclass(x)
  if (!"properties" %in% names(x)) x$properties <- list()
  list(type = "FeatureCollection", features = list(x))
}
