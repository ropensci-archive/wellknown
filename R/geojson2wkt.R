#' Convert GeoJSON-like objects to WKT
#'
#' @export
#'
#' @template fmt
#' @template geojson2wktegs
#' @param obj (list/json/character) A GeoJSON-like object representing a
#' Point, MultiPoint, LineString, MultiLineString, Polygon, MultiPolygon,
#' or GeometryCollection
#' @param third (character) Only applicable when there are three dimensions. 
#' If `m`, assign a `M` value for a measurement, and if `z` assign a 
#' `Z` value for three-dimenionsal system. Case is ignored. An `M` value 
#' represents  a measurement, while a `Z` value usually represents altitude 
#' (but can be something like depth in a water based location).
#' @param ... Further args passed on to [jsonlite::fromJSON()] only
#' in the event of json passed as a character string (can also be json
#' of class `json` as returned from [jsonlite::toJSON()] or simply coerced
#' to `json` by adding the class manually)
#' @seealso [wkt2geojson()]
#'
#' @references <https://tools.ietf.org/html/rfc7946>,
#' <https://en.wikipedia.org/wiki/Well-known_text>
#'
#' @section Inputs:
#' Input to `obj` parameter can take two forms:
#'
#' - A list with named elements `type` and `coordinates` OR
#'  `type` and `geometries` (only in the case of GeometryCollection).
#'  e.g., `list(type = "Point", coordinates = c(1, 0))`
#' - A list with single named element in the set Point, Multipoint,
#'  Polygon, Multipolygon, Linestring, Multilinestring,or Geometrycollection,
#'  e.g., `list(Point = c(1, 0))` - Note that this format is not proper
#'  GeoJSON, but is less verbose than the previous format, so should save
#'  the user time and make it easier to use.
#' 
#' @section Each point:
#' For any one point, 2 to 4 values can be used:
#' 
#' - 2 values: longitude, latitude
#' - 3 values: longitude, latitude, altitude 
#' - 4 values: longitude, latitude, altitude, measure
#' 
#' The 3rd value is typically altitude though can be depth in an 
#' aquatic context.
#' 
#' The 4th value is a measurement of some kind.
#' 
#' The GeoJSON spec <https://tools.ietf.org/html/rfc7946> actually
#' doesn't allow a 4th value for a point, but we allow it here since
#' we're converting to WKT which does allow a 4th value for a point.
#' 
#' @section Coordinates data formats:
#' Coordinates data should follow the following formats:
#' 
#' - Point: a vector or list, with a single point (2-4 values)
#' - MultiPoint: a matrix, with N points
#' - Linestring: a matrix, with N points
#' - MultiLinestring: the top most level is a list, containing N matrices
#' - Polygon: the top most level is a list, containing N matrices
#' - MultiPolygon: the top most level is a list, the next level is N 
#' lists, each of them containing N matrices
#' - Geometrycollection: a list containing any combination and number 
#' of the above types
#' 
#' Matrices by definition can not have unequal lengths in their columns, 
#' so we don't have to check for that user error.
#' 
#' Each matrix can have any number of rows, and from 2 to 4 columns. 
#' If > 5 columns we stop with an error message.
geojson2wkt <- function(obj, fmt = 16, third = "z", ...) {
  UseMethod("geojson2wkt")
}

#' @export
geojson2wkt.default <- function(obj, fmt = 16, third = "z", ...) {
  stop("No 'geojson2wkt' method for ", 
    paste0(class(obj), collapse = ", "), call. = FALSE)
}

#' @export
geojson2wkt.character <- function(obj, fmt = 16, third = "z", ...) {
  geojson2wkt(jsonlite::fromJSON(obj, ...), fmt, third)
}

#' @export
geojson2wkt.json <- function(obj, fmt = 16, third = "z", ...) {
  geojson2wkt(jsonlite::fromJSON(obj, ...), fmt, third)
}

#' @export
geojson2wkt.list <- function(obj, fmt = 16, third = "z", ...) {
  nms <- tolower(names(obj))
  if (
    !any(tolower(wkt_geojson_types) %in% nms) &&
    (
      !all(c('type', 'coordinates') %in% nms) &&
      !all(c('type', 'geometries') %in% nms)
    )
  ) {
    stop(
      strwrap(
        paste0(
          "'obj' must be list w/ either 'type' & 'coordinates' OR one of ", 
          paste0(tolower(wkt_geojson_types), collapse = ", ")), width = 80))
  }

  if (
    !all(c('type', 'coordinates') %in% nms) &&
    any(tolower(wkt_geojson_types) %in% nms)
  ) {
    if ("geometrycollection" == nms) {
      obj <- list(type = nms, geometries = obj[[1]])
    } else{
      obj <- list(type = nms, coordinates = obj[[1]])
    }
  }

  switch(
    tolower(obj$type),
    point = dump_point(obj, fmt, third),
    multipoint = dump_multipoint(obj, fmt, third),
    linestring = dump_linestring(obj, fmt, third),
    multilinestring = dump_multilinestring(obj, fmt, third),
    polygon = dump_polygon(obj, fmt, third),
    multipolygon = dump_multipolygon(obj, fmt, third),
    geometrycollection = dump_geometrycollection(obj, fmt),
    stop('type ', obj$type, ' not supported', call. = FALSE)
  )
}
