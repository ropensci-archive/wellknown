#' Convert GeoJSON-like objects to WKT
#'
#' @export
#'
#' @template fmt
#' @param obj A GeoJSON-like object representing a Point, LineString, Polygon,
#' MultiPolygon, etc.
#' @param ... Further args passed on to [jsonlite::fromJSON() only
#' in the event of json passed as a character string.
#' @seealso [geojson2wkt()], [wkt2geojson()]
#' @references <https://tools.ietf.org/html/rfc7946>,
#' <https://en.wikipedia.org/wiki/Well-known_text>
#' @details Similar to [geojson2wkt()], but simpler construction.
#' However, input to this function is not proper GeoJSON. If you want to
#' input GeoJSON format (as either list or JSON) use [geojson2wkt()]
#' @examples
#' # point
#' geojson2wkt_(list(Point = c(116.4, 45.2)))
#'
#' # multipoint
#' mp <- list(MultiPoint = matrix(c(100, 101, 3.14, 3.101, 2.1, 2.18),
#'    ncol = 2))
#' geojson2wkt_(mp)
#'
#'
#' # linestring
#' ## 2D
#' st <- list(LineString = matrix(c(0.0, 2.0, 4.0, 5.0,
#'                                0.0, 1.0, 2.0, 4.0),
#'                                ncol = 2))
#' geojson2wkt_(st)
#' ## 3D
#' st <- list(LineString = matrix(c(0.0, 2.0, 4.0, 5.0,
#'                                0.0, 1.0, 2.0, 4.0,
#'                                10, 20, 30, 40),
#'                                ncol = 3))
#' geojson2wkt_(st, fmt = 2)
#'
#' ## 4D
#' st <- list(LineString = matrix(c(0.0, 2.0, 4.0, 5.0,
#'                                0.0, 1.0, 2.0, 4.0,
#'                                10, 20, 30, 40,
#'                                1, 2, 3, 4),
#'                                ncol = 4))
#' geojson2wkt_(st, fmt = 2)
#'
#'
#' # multilinestring
#' ## 2D
#' multist <- list(MultiLineString = list(
#'    matrix(c(0, -2, -4, -1, -3, -5), ncol = 2),
#'    matrix(c(1.66, 10.9999, 10.9, 0, -31.5, 3.0, 1.1, 0), ncol = 2)
#'  )
#' )
#' geojson2wkt_(multist)
#'
#'
#' # polygon
#' ## 2D
#' poly <- list(Polygon = list(
#'    matrix(c(100.001, 101.1, 101.001, 100.001, 0.001, 0.001, 1.001, 0.001), ncol = 2),
#'    matrix(c(100.201, 100.801, 100.801, 100.201, 0.201, 0.201, 0.801, 0.201), ncol = 2)
#' ))
#' geojson2wkt_(poly)
#' geojson2wkt_(poly, fmt=6)
#'
#'
#' # multipolygon
#' ## 2D
#' mpoly <- list(MultiPolygon = list(
#'   list(
#'     matrix(c(100, 101, 101, 100, 0.001, 0.001, 1.001, 0.001), ncol = 2),
#'     matrix(c(100.2, 100.8, 100.8, 100.2, 0.2, 0.2, 0.8, 0.2), ncol = 2)
#'   ),
#'   list(
#'     matrix(c(1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 1.0), ncol = 2),
#'     matrix(c(9.0, 10.0, 11.0, 12.0, 1.0, 2.0, 3.0, 4.0, 9.0), ncol = 2)
#'   )
#' ))
#' geojson2wkt_(obj = mpoly, fmt=2)
#'
#' mpoly2 <- list(MultiPolygon = list(
#'   list(
#'     matrix(c(30, 45, 10, 30, 20, 40, 40, 20), ncol = 2)
#'   ),
#'   list(
#'     matrix(c(15, 40, 10, 5, 15, 5, 10, 20, 10, 5), ncol = 2)
#'   )
#' ))
#' geojson2wkt_(mpoly2, fmt=1)
#' geojson2wkt_(mpoly2, fmt=3)
#'
#'
#' # geometrycollection
#' gmcoll <- list(GeometryCollection = list(
#'  list(Point = c(0.0, 1.0)),
#'  list(LineString = matrix(c(0.0, 2.0, 4.0, 5.0,
#'                            0.0, 1.0, 2.0, 4.0),
#'                            ncol = 2)),
#'  list(Polygon = list(
#'    matrix(c(100.001, 101.1, 101.001, 100.001, 0.001, 0.001, 1.001, 0.001),
#'      ncol = 2),
#'    matrix(c(100.201, 100.801, 100.801, 100.201, 0.201, 0.201, 0.801, 0.201),
#'      ncol = 2)
#'   ))
#' ))
#' geojson2wkt_(gmcoll, fmt=0)
#'
#' # Convert geojson as character string to WKT
#' str <- '{
#'  "Point": [
#'    -105.01621,
#'    39.57422
#'  ]
#' }'
#' geojson2wkt_(str)
#'
#' str <- '{"LineString":[[0,0,10],[2,1,20],[4,2,30],[5,4,40]]}'
#' geojson2wkt_(str)
#'
#' # From a jsonlite json object
#' library("jsonlite")
#' json <- toJSON(list(Point = c(-105,39)))
#' geojson2wkt_(json)
#'
geojson2wkt_ <- function(obj, fmt = 16, ...) {
  UseMethod("geojson2wkt_")
}

#' @export
geojson2wkt.default <- function(obj, fmt = 16, ...) {
  stop("not 'geojson2wkt_' method for ", class(obj), call. = FALSE)
}

#' @export
geojson2wkt_.character <- function(obj, fmt = 16, ...) {
  geojson2wkt_(jsonlite::fromJSON(obj, ...), fmt)
}

#' @export
geojson2wkt_.json <- function(obj, fmt = 16, ...) {
  geojson2wkt_(jsonlite::fromJSON(obj, ...), fmt)
}

#' @export
geojson2wkt_.list <- function(obj, fmt = 16, ...) {
  switch(
    tolower(names(obj)),
    point = dump_point(list(coordinates = obj[[1]]), fmt),
    multipoint = dump_multipoint(list(coordinates = obj[[1]]), fmt),
    linestring = dump_linestring(list(coordinates = obj[[1]]), fmt),
    multilinestring = dump_multilinestring(list(coordinates = obj[[1]]), fmt),
    polygon = dump_polygon(list(coordinates = obj[[1]]), fmt),
    multipolygon = dump_multipolygon(list(coordinates = obj[[1]]), fmt),
    geometrycollection = dump_geometrycollection_(list(geometries = obj[[1]]), fmt),
    stop("only point, multipoint, linestring, multilinestring, polygon, and multipolygon supported", call. = FALSE)
  )
}

dump_geometrycollection_ <- function(obj, fmt = 16){
  geoms <- obj$geometries
  str <- paste0(lapply(geoms, function(z){
    get_fxn(tolower(names(z)))(list(coordinates = z[[1]]), fmt)
  }), collapse = ", ")
  sprintf('GEOMETRYCOLLECTION (%s)', str)
}
