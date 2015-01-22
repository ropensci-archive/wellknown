#' Convert GeoJSON-like objects to WKT.
#'
#' @export
#'
#' @param obj A GeoJSON-like object representing a Point, LineString, Polygon, MultiPolygon, etc.
#' @param fmt Format string which indicates the number of digits to display after the
#' decimal point when formatting coordinates.
#' @seealso \code{\link{wkt2geojson}}
#' @examples
#' # point
#' point <- list('type' = 'Point', 'coordinates' = c(116.4, 45.2))
#' geojson2wkt(point)
#'
#' # linestring
#' st <- list(type = 'LineString',
#'            coordinates = list(c(0.0, 0.0, 10.0), c(2.0, 1.0, 20.0),
#'                              c(4.0, 2.0, 30.0), c(5.0, 4.0, 40.0)))
#' geojson2wkt(st)
#'
#' # polygon
#' poly <- list(type = 'Polygon',
#'      coordinates=list(
#'        list(c(100.001, 0.001), c(101.12345, 0.001), c(101.001, 1.001), c(100.001, 0.001)),
#'        list(c(100.201, 0.201), c(100.801, 0.201), c(100.801, 0.801), c(100.201, 0.201))
#' ))
#' geojson2wkt(poly)
#' geojson2wkt(poly, fmt=6)

geojson2wkt <- function(obj, fmt = 16){
  switch(tolower(obj$type),
         point = dump_point(obj, fmt),
         linestring = dump_linestring(obj, fmt),
         polygon = dump_polygon(obj, fmt)
  )
}

#' Convert GeoJSON-like POINT object to WKT.
#'
#' @inheritParams geojson2wkt
#' @keywords internal
dump_point <- function(obj, fmt = 16){
  coords <- obj$coordinates
  sprintf('POINT (%s)', paste0(format(coords, nsmall = fmt), collapse = ""))
}

#' Convert GeoJSON-like LineString object to WKT.
#'
#' @inheritParams geojson2wkt
#' @keywords internal
dump_linestring <- function(obj, fmt = 16){
  coords <- obj$coordinates
  str <- paste0(lapply(coords, function(z){
    paste0(gsub("\\s", "", format(z, nsmall = fmt)), collapse = " ")
  }), collapse = ", ")
  sprintf('LINESTRING (%s)', str)
}

#' Convert GeoJSON-like Polygon object to WKT.
#'
#' @inheritParams geojson2wkt
#' @keywords internal
dump_polygon <- function(obj, fmt = 16){
  coords <- obj$coordinates
  str <- paste0(lapply(coords, function(z){
    sprintf("(%s)", paste0(lapply(z, function(w){
      paste0(gsub("\\s", "", format(w, nsmall = fmt)), collapse = " ")
    }), collapse = ", "))
  }), collapse = ", ")
  sprintf('POLYGON (%s)', str)
}
