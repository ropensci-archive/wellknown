#' Visualize well-known text area's on a map using leaflet and htmlwidgets packages
#'
#' @name vis
#'
#' @examples \dontrun{
#' # Using htmlwidgets and leaflet packages
#' library("leaflet")
#' library("htmlwidgets")
#'
#' ## points
#' str <- "POINT (-116.4000000000000057 45.2000000000000028)"
#' geojson <- wkt2geojson(str) %>% properties(style=list(color = "red"))
#' leaflet() %>%
#'  addTiles() %>%
#'  addGeoJSON(geojson)
#'
#' ## polygons
#' geojson <- x %>% properties(style=list(color = "red"))
#' cen <- centroid(geojson)
#' leaflet() %>%
#'  addTiles() %>%
#'  setView(lng = cen[2], lat = cen[1], zoom = 6) %>%
#'  addGeoJSON(geojson)
#' }
NULL

# str <- "POLYGON ((100 0.1, 101.1 0.3, 101 0.5, 100 0.1),
#    (103.2 0.2, 104.8 0.2, 100.8 0.8, 103.2 0.2))"
# x <- wkt2geojson(str)
# vis(x)

# vis <- function(x, zoom = 6) {
#   geojson <- jsonlite::toJSON(list(type="Feature", geometry = x), auto_unbox = TRUE)
#   centroid <- getcentr(x)
#   map <- paste0('
#     <!DOCTYPE html>
#     <html>
#     <head>
#     <meta charset=utf-8 />
#     <title>spocc WKT Viewer</title>
#     <meta name="viewport" content="initial-scale=1,maximum-scale=1,user-scalable=no" />
#     <script src="https://api.tiles.mapbox.com/mapbox.js/v1.6.4/mapbox.js"></script>
#     <link href="https://api.tiles.mapbox.com/mapbox.js/v1.6.4/mapbox.css" rel="stylesheet" />
#     <style>
#       body { margin:0; padding:0; }
#       #map { position:absolute; top:0; bottom:0; width:100%; }
#     </style>
#     </head>
#     <body>
#
#     <div id="map"></div>
#
#     <script>
#     L.mapbox.accessToken = "pk.eyJ1IjoicmVjb2xvZ3kiLCJhIjoiZWlta1B0WSJ9.u4w33vy6kkbvmPyGnObw7A";
#
#     var geojson = [
#      ',  as.character(geojson),
#                     '];
#
#     var map = L.mapbox.map("map", "examples.map-i86nkdio")
#       .setView([',  centroid[1], ", ",  centroid[2], '],', zoom, ');
#
#     L.geoJson(geojson, { style: L.mapbox.simplestyle.style }).addTo(map);
#     </script>
#
#     </body>
#     </html>
#   ')
#   tmpfile <- tempfile(pattern = 'spocc', fileext = ".html")
#   write(map, file = tmpfile)
#   browseURL(tmpfile)
# }

getcentr <- function(x){
  c(
    mean(sapply(x$coordinates, function(z) sapply(z, function(b) b[2]))),
    mean(sapply(x$coordinates, function(z) sapply(z, function(b) b[1])))
  )
}

centroid <- function(x){
  if("geometry" %in% names(x)) {
    c(
      mean(sapply(x$geometry$coordinates, function(z) sapply(z, function(b) b[2]))),
      mean(sapply(x$geometry$coordinates, function(z) sapply(z, function(b) b[1])))
    )
  } else {
    c(
      mean(sapply(x$coordinates, function(z) sapply(z, function(b) b[2]))),
      mean(sapply(x$coordinates, function(z) sapply(z, function(b) b[1])))
    )
  }
}
