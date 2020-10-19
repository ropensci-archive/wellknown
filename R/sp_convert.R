# get_coords <- function(sp_single){
#   unlist(lapply(sp_single@polygons, function(ss){
#     lapply(ss@Polygons, function(ss_i){
#       return(ss_i@coords)
#     })
#   }), recursive = FALSE)
# }
# get_coords_sf <- function(sf_single){
#   unlist(unclass(sf_single), recursive = FALSE)
# }

#' @title Convert spatial objects to WKT
#' @description `sp_convert` turns objects from the `sp` package
#' (SpatialPolygons, SpatialPolygonDataFrames) or the `sf` package
#' (sf, sfc, POLYGON, MULTIPOLYGON) - into WKT POLYGONs or MULTIPOLYGONs
#' @export
#' @param x an sf or sfc object. one or more can be submitted
#' @return a character vector of WKT objects
sf_convert <- function(x) as.character(wk::as_wkt(x))

# sp_convert <- function(x, group = TRUE){
#   if(!is.list(x)){
#     x <- list(x)
#   }
#   coords <- lapply(x, get_coords)
#   return(sp_convert_(coords, group))
# }
# sf_convert <- function(x, group = TRUE){
#   UseMethod("sf_convert")
# }
# sf_convert.POLYGON <- function(x, group = TRUE) {
#   coords <- list(lapply(x, get_coords_sf))
#   return(sp_convert_(coords, group))
# }
# sf_convert.MULTIPOLYGON <- function(x, group = TRUE) {
#   sp_convert_(list(get_coords_sf(unclass(x))), group)
# }
# sf_convert.sfc <- function(x, group = TRUE) {
#   x <- unclass(x)
#   x <- list(x)
#   coords <- lapply(x, get_coords_sf)
#   return(sp_convert_(coords, group))
# }
# sf_convert.sf <- function(x, group = TRUE) {
#   x <- x[[attr(x, "sf_column")]]
#   sf_convert(x)
# }
