get_coords <- function(sp_single){
  unlist(lapply(sp_single@polygons, function(ss){
    lapply(ss@Polygons, function(ss_i){
      return(ss_i@coords)
    })
  }), recursive = FALSE)
}
get_coords_sf <- function(sf_single){
  unlist(unclass(sf_single), recursive = FALSE)
}

#' @title Convert spatial objects to WKT
#' @description `sp_convert` turns objects from the `sp` package
#' (SpatialPolygons, SpatialPolygonDataFrames) or the `sf` package
#' (sf, sfc, POLYGON, MULTIPOLYGON) - into WKT POLYGONs or MULTIPOLYGONs
#'
#' @param x for `sp_convert()`, a list of SP/SPDF objects (or a single object)
#' for `sf_convert()`, an sf, sfc, POLYGON, or MULTIPOLYGON sf object
#'
#' @param group whether or not to group coordinates together in the case
#' that an object in `x` has multiple sets of coordinates. If `TRUE`
#' (the default), such objects will be returned as `MULTIPOLYGON`'s
#' - if `FALSE`, as a vector of `POLYGON`'s
#'
#' @return either a character vector of WKT objects - one per sp object -
#' if `group` is `TRUE`, or a list of vectors if `group` is `FALSE`
#'
#' @seealso [bounding_wkt()], for turning bounding boxes within
#' `sp` objects into WKT objects.
#' @export
sp_convert <- function(x, group = TRUE){
  if(!is.list(x)){
    x <- list(x)
  }
  coords <- lapply(x, get_coords)
  return(sp_convert_(coords, group))
}

#' @export
#' @rdname sp_convert
sf_convert <- function(x, group = TRUE){
  UseMethod("sf_convert")
}
#' @export
sf_convert.POLYGON <- function(x, group = TRUE) {
  coords <- list(lapply(x, get_coords_sf))
  return(sp_convert_(coords, group))
}
#' @export
sf_convert.MULTIPOLYGON <- function(x, group = TRUE) {
  sp_convert_(list(get_coords_sf(unclass(x))), group)
}
#' @export
sf_convert.sfc <- function(x, group = TRUE) {
  x <- unclass(x)
  x <- list(x)
  coords <- lapply(x, get_coords_sf)
  return(sp_convert_(coords, group))
}
#' @export
sf_convert.sf <- function(x, group = TRUE) {
  x <- x[[attr(x, "sf_column")]]
  sf_convert(x)
}
