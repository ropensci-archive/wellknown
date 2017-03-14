#' Convert GeoJSON-like objects to WKT.
#'
#' @export
#'
#' @template fmt
#' @param obj (list/json/character) A GeoJSON-like object representing a
#' Point, MultiPoint, LineString, MultiLineString, Polygon, MultiPolygon,
#' or GeometryCollection
#' @param ... Further args passed on to [jsonlite::fromJSON()] only
#' in the event of json passed as a character string.
#' @seealso [wkt2geojson()]
#'
#' @references <https://tools.ietf.org/html/rfc7946>,
#' <https://en.wikipedia.org/wiki/Well-known_text>
#'
#' @details
#' Input to `obj` parameter can take two forms:
#'
#' \itemize{
#'  \item A list with named elements `type` and `coordinates` OR
#'  `type` and `geometries` (only in the case of GeometryCollection).
#'  e.g., `list(type = "Point", coordinates = c(1, 0))`
#'  \item A list with single named element in the set Point, Multipoint,
#'  Polygon, Multipolygon, Linestring, Multilinestring,or Geometrycollection,
#'  e.g., `list(Point = c(1, 0))` - Note that this format is not proper
#'  GeoJSON, but is less verbose than the previous format, so should save
#'  the user time and make it easier to use.
#' }
#' @examples
#' # point
#' ## new format
#' point <- list(Point = c(116.4, 45.2))
#' geojson2wkt(point)
#' ## old format, warns
#' point <- list(type = 'Point', coordinates = c(116.4, 45.2))
#' geojson2wkt(point)
#'
#' # multipoint
#' ## new format
#' mp <- list(MultiPoint = matrix(c(100, 101, 3.14, 3.101, 2.1, 2.18),
#'    ncol = 2))
#' geojson2wkt(mp)
#' ## old format, warns
#' mp <- list(
#'   type = 'MultiPoint',
#'   coordinates = matrix(c(100, 101, 3.14, 3.101, 2.1, 2.18), ncol = 2)
#' )
#' geojson2wkt(mp)
#'
#' # linestring
#' ## new format
#' st <- list(LineString = matrix(c(0.0, 2.0, 4.0, 5.0,
#'                                0.0, 1.0, 2.0, 4.0),
#'                                ncol = 2))
#' geojson2wkt(st)
#' ## old format, warns
#' st <- list(
#'   type = 'LineString',
#'   coordinates = matrix(c(0.0, 2.0, 4.0, 5.0,
#'                          0.0, 1.0, 2.0, 4.0), ncol = 2)
#' )
#' geojson2wkt(st)
#' ## 3D
#' st <- list(LineString = matrix(c(0.0, 2.0, 4.0, 5.0,
#'                                0.0, 1.0, 2.0, 4.0,
#'                                10, 20, 30, 40),
#'                                ncol = 3))
#' geojson2wkt(st, fmt = 2)
#'
#' ## 4D
#' st <- list(LineString = matrix(c(0.0, 2.0, 4.0, 5.0,
#'                                0.0, 1.0, 2.0, 4.0,
#'                                10, 20, 30, 40,
#'                                1, 2, 3, 4),
#'                                ncol = 4))
#' geojson2wkt(st, fmt = 2)
#'
#'
#' # multilinestring
#' ## new format
#' multist <- list(MultiLineString = list(
#'    matrix(c(0, -2, -4, -1, -3, -5), ncol = 2),
#'    matrix(c(1.66, 10.9999, 10.9, 0, -31.5, 3.0, 1.1, 0), ncol = 2)
#'  )
#' )
#' geojson2wkt(multist)
#' ## old format, warns
#' multist <- list(
#'   type = 'MultiLineString',
#'   coordinates = list(
#'    matrix(c(0, -2, -4, -1, -3, -5), ncol = 2),
#'    matrix(c(1.66, 10.9999, 10.9, 0, -31.5, 3.0, 1.1, 0), ncol = 2)
#'  )
#' )
#' geojson2wkt(multist)
#'
#'
#' # polygon
#' ## new format
#' poly <- list(Polygon = list(
#'    matrix(c(100.001, 101.1, 101.001, 100.001, 0.001, 0.001, 1.001, 0.001), ncol = 2),
#'    matrix(c(100.201, 100.801, 100.801, 100.201, 0.201, 0.201, 0.801, 0.201), ncol = 2)
#' ))
#' geojson2wkt(poly)
#' geojson2wkt(poly, fmt=6)
#' ## old format, warns
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
#' ## new format
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
#' geojson2wkt(mpoly, fmt=2)
#' ## old format, warns
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
#' ## new format
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
#' geojson2wkt(gmcoll, fmt=0)
#' ## old format, warns
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
#' # new format
#' str <- '{
#'    "Point": [
#'        -105.01621,
#'        39.57422
#'    ]
#' }'
#' geojson2wkt(str)
#'
#' ## old format, warns
#' str <- '{
#'    "type": "Point",
#'    "coordinates": [
#'        -105.01621,
#'        39.57422
#'    ]
#' }'
#' geojson2wkt(str)
#'
#' ## new format
#' str <- '{"LineString":[[0,0,10],[2,1,20],[4,2,30],[5,4,40]]}'
#' geojson2wkt(str)
#' ## old format, warns
#' str <-
#' '{"type":"LineString","coordinates":[[0,0,10],[2,1,20],[4,2,30],[5,4,40]]}'
#' geojson2wkt(str)
#'
#' # From a jsonlite json object
#' library("jsonlite")
#' json <- toJSON(list(Point=c(-105,39)), auto_unbox=TRUE)
#' geojson2wkt(json)
#' ## old format, warns
#' json <- toJSON(list(type="Point", coordinates=c(-105,39)), auto_unbox=TRUE)
#' geojson2wkt(json)
#'
geojson2wkt <- function(obj, fmt = 16, ...) {
  UseMethod("geojson2wkt")
}

#' @export
geojson2wkt.default <- function(obj, fmt = 16, ...) {
  stop("not 'geojson2wkt' method for ", class(obj), call. = FALSE)
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
  nms <- tolower(names(obj))
  if (
    !any(tolower(wkt_geojson_types) %in% nms) &&
    (
      !all(c('type', 'coordinates') %in% nms) &&
      !all(c('type', 'geometries') %in% nms)
    )
  ) {
    stop(strwrap(paste0("'obj' must be list w/ either 'type' & 'coordinates' OR one of ", paste0(tolower(wkt_geojson_types), collapse = ", ")), width = 80))
  }

  if (
    (
      all(c('type', 'coordinates') %in% nms) ||
      all(c('type', 'geometries') %in% nms)
    ) &&
    !all(tolower(wkt_geojson_types) %in% nms)
  ) {
    warning('using old format - move to new format - see ?geojson2wkt',
            call. = FALSE)
  } else if (
    !all(c('type', 'coordinates') %in% nms) &&
    any(tolower(wkt_geojson_types) %in% nms)
  ) {
    if ("geometrycollection" == nms) {
      obj <- list(type = nms, geometries = obj[[1]])
    } else{
      obj <- list(type = nms, coordinates = obj[[1]])
    }
  } else {
    stop("bad input", call. = FALSE)
  }

  switch(
    tolower(obj$type),
    point = dump_point(obj, fmt),
    multipoint = dump_multipoint(obj, fmt),
    linestring = dump_linestring(obj, fmt),
    multilinestring = dump_multilinestring(obj, fmt),
    polygon = dump_polygon(obj, fmt),
    multipolygon = dump_multipolygon(obj, fmt),
    geometrycollection = dump_geometrycollection(obj, fmt),
    stop('type ', obj$type, ' not supported', call. = FALSE)
  )
}

dump_point <- function(obj, fmt = 16){
  coords <- obj$coordinates
  if (!is.vector(coords) || is.list(coords)) {
    stop("expecting a vector in 'coordinates', got a ", class(coords))
  }

  sprintf('POINT (%s)', paste0(format(coords, nsmall = fmt), collapse = " "))
}

dump_multipoint <- function(obj, fmt = 16){
  coords <- obj$coordinates
  if (!is.matrix(coords)) {
    stop("expecting a matrix in 'coordinates', got a ", class(coords))
  }

  str <- paste0(apply(coords, 1, function(z){
    sprintf("(%s)", paste0(str_trim_(format(z, nsmall = fmt)), collapse = " "))
  }), collapse = ", ")
  sprintf('MULTIPOINT (%s)', str)
}

dump_linestring <- function(obj, fmt = 16){
  coords <- obj$coordinates
  if (!is.matrix(coords)) {
    stop("expecting a matrix in 'coordinates', got a ", class(coords))
  }

  str <- paste0(apply(coords, 1, function(z){
    paste0(gsub("\\s", "", format(z, nsmall = fmt)), collapse = " ")
  }), collapse = ", ")
  sprintf('LINESTRING (%s)', str)
}

dump_multilinestring <- function(obj, fmt = 16){
  coords <- obj$coordinates
  if (!is.list(coords)) {
    stop("your top most element must be a list")
  }
  if (!all(vapply(coords, is.matrix, TRUE))) {
    stop("expecting matrices for all 'coordinates' elements")
  }

  str <- paste0(lapply(coords, function(z){
    sprintf("(%s)", paste0(gsub(",", "",
                                apply(str_trim_(format(z, nsmall = fmt)), 1, paste0, collapse = " ")), collapse = ", "))
  }), collapse = ", ")
  sprintf('MULTILINESTRING (%s)', str)
}

dump_polygon <- function(obj, fmt = 16){
  coords <- obj$coordinates
  if (!is.list(coords)) {
    stop("your top most element must be a list")
  }
  if (!all(vapply(coords, is.matrix, TRUE))) {
    stop("expecting matrices for all 'coordinates' elements")
  }

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
  str <- paste0(lapply(geoms, function(z) {
    if (all(c('type', 'coordinates') %in% tolower(names(z)))) {
      get_fxn(tolower(z$type))(z, fmt)
    } else {
      get_fxn(tolower(names(z)))(list(coordinates = z[[1]]), fmt)
    }
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

wkt_geojson_types <- c("POINT",'MULTIPOINT',"POLYGON","MULTIPOLYGON",
                     "LINESTRING","MULTILINESTRING","GEOMETRYCOLLECTION")
