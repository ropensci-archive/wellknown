#' Convert WKT to GeoJSON-like objects.
#'
#' @export
#'
#' @param str A GeoJSON-like object representing a Point, LineString, Polygon, MultiPolygon, etc.
#' @param fmt Format string which indicates the number of digits to display after the
#' decimal point when formatting coordinates.
#' @param feature (logical) Make a feature geojson object. Default: TRUE
#' @seealso \code{\link{geojson2wkt}}
#' @examples
#' # point
#' str <- "POINT (-116.4000000000000057 45.2000000000000028)"
#' wkt2geojson(str)
#' wkt2geojson(str, feature=FALSE)
#'
#' # polygon
#' str <- "POLYGON ((100 0.1, 101.1 0.3, 101 0.5, 100 0.1),
#'    (103.2 0.2, 104.8 0.2, 100.8 0.8, 103.2 0.2))"
#' wkt2geojson(str)
#' wkt2geojson(str, feature=FALSE)

wkt2geojson <- function(str, fmt = 16, feature = TRUE){
  type <- cw(types[sapply(types, grepl, x = str)], onlyfirst = TRUE)
  switch(type,
         Point = load_point(str, fmt, feature),
         Polygon = load_polygon(str, fmt, feature)
  )
}

types <- c("POINT","POLYGON","LINESTRING",'MULTIPOINT',"MULTIPOLYGON")

#' Convert WKT to GeoJSON-like POINT object.
#'
#' @inheritParams wkt2geojson
#' @keywords internal
load_point <- function(str, fmt = 16, feature = TRUE){
  str_coord <- gsub("POINT|\\(|\\)", "", str)
  coords <- strsplit(strtrim(str_coord), "\\s")[[1]]
  tmp <- list(type='Point', coordinates=as.numeric(coords))
  if(feature)
    list(type="Feature", geometry=tmp)
  else
    tmp
}

#' Convert WKT to GeoJSON-like POLYGON object.
#'
#' @inheritParams wkt2geojson
#' @keywords internal
load_polygon <- function(str, fmt = 16, feature = TRUE){
  str_coord <- strtrim(gsub("POLYGON\\s", "", str))
  str_coord <- gsub("^\\(|\\)$", "", str_coord)
  str_coord <- strsplit(str_coord, "\\),")[[1]]
  coords <- lapply(str_coord, function(z){
    pairs <- strsplit(strsplit(gsub("\\(|\\)", "", strtrim(z)), ",|,\\s")[[1]], "\\s")
    lapply(pairs, as.numeric)
  })
  tmp <- list(type='Polygon', coordinates=coords)
  if(feature)
    list(type="Feature", geometry=tmp)
  else
    tmp
}

#' Add properties to a geojson object
#'
#' @export
#'
#' @param x Input
#' @param style List of color, fillColor, etc., or NULL
#' @param popup Popup text, or NULL
#' @examples
#' str <- "POINT (-116.4000000000000057 45.2000000000000028)"
#' x <- wkt2geojson(str)
#' properties(x, style=list(color = "red"))
properties <- function(x, style = NULL, popup = NULL){
  modifyList(x, list(properties = list(style = style, popup = popup)))
}
