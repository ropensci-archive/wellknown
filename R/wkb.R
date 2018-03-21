#' Convert WKT to WKB
#'
#' @export
#' @name wkb
#' @param x A `character` string representing a WKT object, or an object
#' of class `raw`, representing a WKB object
#' @return `wkt_wkb` returns an object of class `raw`, a WKB
#' reprsentation. `wkb_wkt` returns an object of class `character`,
#' a WKT representation
#' @examples
#' # WKT to WKB
#' ## point
#' wkt_wkb("POINT (-116.4 45.2)")
#'
#' ## linestring
#' wkt_wkb("LINESTRING (-116.4 45.2, -118.0 47.0)")
#'
#' ## multipoint
#' ### only accepts the below format, not e.g., ((1 2), (3 4))
#' wkt_wkb("MULTIPOINT (100.000 3.101, 101.00 2.10, 3.14 2.18)")
#'
#' ## polygon
#' wkt_wkb("POLYGON ((100.0 0.0, 101.1 0.0, 101.0 1.0, 100.0 0.0))")
#'
#' # WKB to WKT
#' ## point
#' (x <- wkt_wkb("POINT (-116.4 45.2)"))
#' wkb_wkt(x)
#'
#' ## linestring
#' (x <- wkt_wkb("LINESTRING (-116.4 45.2, -118.0 47.0)"))
#' wkb_wkt(x)
#'
#' ## multipoint
#' (x <- wkt_wkb("MULTIPOINT (100.000 3.101, 101.00 2.10, 3.14 2.18)"))
#' wkb_wkt(x)
#'
#' ## polygon
#' (x <- wkt_wkb("POLYGON ((100.0 0.0, 101.1 0.0, 101.0 1.0, 100.0 0.0))"))
#' wkb_wkt(x)

wkt_wkb <- function(x) {
  sh$eval(sprintf("var tt = wkx.Geometry.parse('%s').toWkb();", x))
  as.raw(sh$get("tt")$data)
}

#' @export
#' @rdname wkb
wkb_wkt <- function(x) {
  sh$eval(sprintf("var w = new buffer('%s', 'hex')", paste0(x, collapse = "")))
  sh$eval("var tt = wkx.Geometry.parse(w).toWkt();")
  sh$get("tt")
}
