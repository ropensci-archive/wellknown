#' Convert GeoJSON-like objects to WKT.
#'
#' @export
#'
#' @template fmt
#' @param obj A GeoJSON-like object representing a Point, LineString, Polygon,
#' MultiPolygon, etc.
#' @param ... Further args passed on to [jsonlite::fromJSON()] only
#' in the event of json passed as a character string.
#' @seealso [geojson2wkt_()], [wkt2geojson()]
#' @references <https://tools.ietf.org/html/rfc7946>,
#' <https://en.wikipedia.org/wiki/Well-known_text>
#' @examples
#' # point
#' point <- list(type = 'Point', coordinates = c(116.4, 45.2))
#' geojson2wkt(point)
#'
#' # multipoint
#' mp <- list(
#'   type = 'MultiPoint',
#'   coordinates = matrix(c(100, 101, 3.14, 3.101, 2.1, 2.18), ncol = 2)
#' )
#' geojson2wkt(mp)
#'
#' # linestring
#' st <- list(
#'   type = 'LineString',
#'   coordinates = matrix(c(0.0, 2.0, 4.0, 5.0,
#'                          0.0, 1.0, 2.0, 4.0), ncol = 2)
#' )
#' geojson2wkt(st)
#'
#' # multilinestring
#' multist <- list(
#'   type = 'MultiLineString',
#'   coordinates = list(
#'    matrix(c(0, -2, -4, -1, -3, -5), ncol = 2),
#'    matrix(c(1.66, 10.9999, 10.9, 0, -31.5, 3.0, 1.1, 0), ncol = 2)
#'  )
#' )
#' geojson2wkt(multist)
#'
#' # polygon
#' poly <- list(
#'   type = 'Polygon',
#'   coordinates = list(
#'     matrix(c(100.001, 101.1, 101.001, 100.001, 0.001, 0.001, 1.001, 0.001),
#'       ncol = 2),
#'     matrix(c(100.201, 100.801, 100.801, 100.201, 0.201, 0.201, 0.801, 0.201),
#'       ncol = 2)
#'   )
#' )
#' geojson2wkt(poly)
#' geojson2wkt(poly, fmt=6)
#'
#' # multipolygon
#' mpoly <- list(
#'   type = 'MultiPolygon',
#'   coordinates = list(
#'     list(
#'       matrix(c(100, 101, 101, 100, 0.001, 0.001, 1.001, 0.001), ncol = 2),
#'       matrix(c(100.2, 100.8, 100.8, 100.2, 0.2, 0.2, 0.8, 0.2), ncol = 2)
#'     ),
#'     list(
#'       matrix(c(1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 1.0), ncol = 3),
#'       matrix(c(9.0, 10.0, 11.0, 12.0, 1.0, 2.0, 3.0, 4.0, 9.0), ncol = 3)
#'     )
#'   )
#' )
#' geojson2wkt(mpoly, fmt=2)
#'
#' mpoly2 <- list(
#'   type = "MultiPolygon",
#'   coordinates = list(
#'     list(list(c(30, 20), c(45, 40), c(10, 40), c(30, 20))),
#'     list(list(c(15, 5), c(40, 10), c(10, 20), c(5 ,10), c(15, 5)))
#'   )
#' )
#'
#' mpoly2 <- list(
#'   type = "MultiPolygon",
#'   coordinates = list(
#'     list(
#'       matrix(c(30, 45, 10, 30, 20, 40, 40, 20), ncol = 2)
#'     ),
#'     list(
#'       matrix(c(15, 40, 10, 5, 15, 5, 10, 20, 10, 5), ncol = 2)
#'     )
#'   )
#' )
#' geojson2wkt(mpoly2, fmt=1)
#'
#' # geometrycollection
#' gmcoll <- list(
#'  type = 'GeometryCollection',
#'  geometries = list(
#'    list(type = 'Point', coordinates = c(0.0, 1.0)),
#'    list(type = 'LineString', coordinates = matrix(c(0.0, 2.0, 4.0, 5.0,
#'                            0.0, 1.0, 2.0, 4.0),
#'                            ncol = 2)),
#'    list(type = 'Polygon', coordinates = list(
#'      matrix(c(100.001, 101.1, 101.001, 100.001, 0.001, 0.001, 1.001, 0.001),
#'        ncol = 2),
#'      matrix(c(100.201, 100.801, 100.801, 100.201, 0.201, 0.201, 0.801, 0.201),
#'        ncol = 2)
#'   ))
#'  )
#' )
#' geojson2wkt(gmcoll, fmt=0)
#'
#' # Convert geojson as character string to WKT
#' str <- '
#' {
#'    "type": "Point",
#'    "coordinates": [
#'        -105.01621,
#'        39.57422
#'    ]
#' }'
#' geojson2wkt(str)
#'
#' str <-
#' '{"type":"LineString","coordinates":[[0,0,10],[2,1,20],[4,2,30],[5,4,40]]}'
#' geojson2wkt(str)
#'
#' # From a jsonlite json object
#' library("jsonlite")
#' json <- toJSON(list(type="Point", coordinates=c(-105,39)), auto_unbox=TRUE)
#' geojson2wkt(json)
#'
geojson2wkt <- function(obj, fmt = 16, ...) {
  UseMethod("geojson2wkt")
}

#' @export
geojson2wkt.character <- function(obj, fmt = 16, ...) {
  geojson2wkt(jsonlite::fromJSON(obj, ...), fmt)
}

#' @export
geojson2wkt.json <- function(obj, fmt = 16, ...) {
  geojson2wkt(jsonlite::fromJSON(obj, ...), fmt)
}

#' @export
geojson2wkt.list <- function(obj, fmt = 16, ...) {
  switch(
    tolower(obj$type),
    point = dump_point(obj, fmt),
    multipoint = dump_multipoint(obj, fmt),
    linestring = dump_linestring(obj, fmt),
    multilinestring = dump_multilinestring(obj, fmt),
    polygon = dump_polygon(obj, fmt),
    multipolygon = dump_multipolygon(obj, fmt),
    geometrycollection = dump_geometrycollection(obj, fmt),
    stop('type ', obj$type, ' not supported')
  )
}

dump_point <- function(obj, fmt = 16){
  coords <- obj$coordinates
  sprintf('POINT (%s)', paste0(format(coords, nsmall = fmt), collapse = " "))
}

dump_multipoint <- function(obj, fmt = 16){
  coords <- obj$coordinates
  str <- paste0(apply(coords, 1, function(z){
    sprintf("(%s)", paste0(str_trim_(format(z, nsmall = fmt)), collapse = " "))
  }), collapse = ", ")
  sprintf('MULTIPOINT (%s)', str)
}

dump_linestring <- function(obj, fmt = 16){
  coords <- obj$coordinates
  str <- paste0(apply(coords, 1, function(z){
    paste0(gsub("\\s", "", format(z, nsmall = fmt)), collapse = " ")
  }), collapse = ", ")
  sprintf('LINESTRING (%s)', str)
}

dump_multilinestring <- function(obj, fmt = 16){
  coords <- obj$coordinates
  str <- paste0(lapply(coords, function(z){
    sprintf("(%s)", paste0(gsub(",", "",
                                apply(str_trim_(format(z, nsmall = fmt)), 1, paste0, collapse = " ")), collapse = ", "))
  }), collapse = ", ")
  sprintf('MULTILINESTRING (%s)', str)
}

dump_polygon <- function(obj, fmt = 16){
  coords <- obj$coordinates
  str <- paste0(lapply(coords, function(z){
    sprintf("(%s)", paste0(apply(z, 1, function(w){
      paste0(gsub("\\s", "", format(w, nsmall = fmt)), collapse = " ")
    }), collapse = ", "))
  }), collapse = ", ")
  sprintf('POLYGON (%s)', str)
}

dump_multipolygon <- function(obj, fmt = 16){
  coords <- obj$coordinates
  if (!is.list(coords)) {
    stop("your top most element must be a list")
  }
  if (!all(vapply(coords, is.list, TRUE))) {
    stop("one or more of your secondary elements is not a list")
  }
  if (!all(vapply(coords, function(z) is.matrix(z[[1]]), TRUE))) {
    stop("one or more of your rings is not a matrix")
  }

  str <- paste0(lapply(coords, function(z) {
    sprintf("(%s)", paste0(sprintf("(%s)", lapply(z, function(w){
      paste0(gsub(",", "", unname(apply(str_trim_(format(w, nsmall = fmt)), 1, paste0, collapse = " "))), collapse = ", ")
    })), collapse = ", "))
  }), collapse = ", ")
  sprintf('MULTIPOLYGON (%s)', str)
}

dump_geometrycollection <- function(obj, fmt = 16){
  geoms <- obj$geometries
  str <- paste0(lapply(geoms, function(z){
    get_fxn(tolower(z$type))(z, fmt)
  }), collapse = ", ")
  sprintf('GEOMETRYCOLLECTION (%s)', str)
}

get_fxn <- function(type){
  switch(type,
         point = dump_point,
         multipoint = dump_multipoint,
         linestring = dump_linestring,
         multilinestring = dump_multilinestring,
         polygon = dump_polygon,
         multipolygon = dump_multipolygon,
         geometrycollection = dump_geometrycollection)
}
