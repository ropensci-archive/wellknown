#' @examples \dontrun{
#' library(sp)
#' library(sf)
#' s1 <- SpatialPolygons(list(Polygons(list(Polygon(cbind(c(2,4,4,1,2),c(2,3,5,4,2)))), "s1")))
#' class(s1)
#' sp_convert(s1)
#' wk::as_wkt(s1)
#' x = st_as_sf(s1)
#' class(x)
#' sf_convert(x)
#' wk::as_wkt(x)
#'
#' library(sf)
#' one = Polygon(cbind(c(91,90,90,91), c(30,30,32,30)))
#' two = Polygon(cbind(c(94,92,92,94), c(40,40,42,40)))
#' spone = Polygons(list(one), "s1")
#' sptwo = Polygons(list(two), "s2")
#' z = SpatialPolygons(list(spone, sptwo), as.integer(1:2))
#' x = st_as_sf(z)
#' sp_convert(z)
#' # class: sf
#' sf_convert(x)
#' # class: sfc
#' sf_convert(x = x[[1]])
#' # class: polygon
#' sf_convert(x = unclass(x[[1]])[[1]])
#' sf_convert(x = unclass(x[[1]])[[2]])
#'
#' library(silicate)
#' x <- sfzoo$multipolygon
#' class(x)
#' x_sp <- as(x, "Spatial")
#' st_as_text(x)
#' sp_convert(x_sp)
#' sf_convert(x)
#' }
