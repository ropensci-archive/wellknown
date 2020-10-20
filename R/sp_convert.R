#' @title Convert spatial objects to WKT
#' @description `sp_convert` turns objects from the `sp` package
#' (SpatialPolygons, SpatialPolygonDataFrames) or the `sf` package
#' (sf, sfc, POLYGON, MULTIPOLYGON) - into WKT POLYGONs or MULTIPOLYGONs
#' @export
#' @param x an sf or sfc object. one or more can be submitted
#' @return a character vector of WKT objects
sf_convert <- function(x) as.character(wk::as_wkt(x))
