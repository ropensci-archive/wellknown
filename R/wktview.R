#' Visualize geojson from a character string or list
#'
#' @export
#' @template fmt
#' @param x Input, a geojson character string or list
#' @param center (numeric) A length two vector of the form:
#' `longitude, latitude`
#' @param zoom (integer) A number between 1 and 18 (1 zoomed out, 18 zoomed in)
#' @seealso [as_featurecollection()]
#' @return Opens a map with the geojson object(s) using `leaflet`
#' @examples \dontrun{
#' # point
#' str <- "POINT (-116.4000000000000057 45.2000000000000028)"
#' wktview(str)
#'
#' # multipoint
#' df <- us_cities[1:5,c('long','lat')]
#' str <- multipoint(df)
#' wktview(str, center = c(-100,40))
#' wktview(str, center = c(-100,40), zoom = 3)
#'
#' # linestring
#' wktview(linestring(c(100.000, 0.000), c(101.000, 1.000), fmt=2),
#'   center = c(100, 0))
#'
#' # polygon
#' a <- polygon(list(c(100.001, 0.001), c(101.12345, 0.001), c(101.001, 1.001),
#'   c(100.001, 0.001)))
#' wktview(a, center = c(100, 0))
#' wktview(a, center = c(100.5, 0), zoom=9)
#' }
wktview <- function(x, center = NULL, zoom = 5, fmt = 16) {
  UseMethod("wktview")
}

#' @export
wktview.character <- function(x, center = NULL, zoom = 5, fmt = 16) {
  not_some(x)
  make_view(x, center = center, zoom = zoom, fmt = fmt)
}

make_view <- function(x, center = NULL, zoom = 5, fmt = 16) {
  chek_for_pkg("leaflet")
  geojson <- properties(wkt2geojson(x, fmt = fmt), style = list(NULL))
  cen <- centroid(geojson, center)
  w <- leaflet::leaflet()
  w <- leaflet::addTiles(w)
  w <- leaflet::setView(w, lng = cen[1], lat = cen[2], zoom = zoom)
  leaflet::addGeoJSON(w, geojson)
}

not_some <- function(x) {
  types <- c("POINT",'MULTIPOINT',"POLYGON","MULTIPOLYGON",
             "LINESTRING","MULTILINESTRING","GEOMETRYCOLLECTION")
  if (!grepl(paste0(types, collapse = "|"), x)) {
    stop("Only these supported:\n", paste0(types, collapse = ", "),
         call. = FALSE)
  }
}
