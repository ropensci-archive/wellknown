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
#' # multipoint
#' str <- 'MULTIPOINT ((100.000 3.101), (101.000 2.100), (3.140 2.180))'
#' wkt2geojson(str)
#' wkt2geojson(str, feature=FALSE)
#'
#' # polygon
#' str <- "POLYGON ((100 0.1, 101.1 0.3, 101 0.5, 100 0.1),
#'    (103.2 0.2, 104.8 0.2, 100.8 0.8, 103.2 0.2))"
#' wkt2geojson(str)
#' wkt2geojson(str, feature=FALSE)
#'
#' # linestring
#' str <- "LINESTRING (100.000 0.000, 101.000 1.000)"
#' wkt2geojson(str)
#' wkt2geojson(str, feature=FALSE)
#' wkt2geojson("LINESTRING (0 -1, -2 -3, -4 5)")
#' wkt2geojson("LINESTRING (0 1 2 3, 4 5 6 7)")

wkt2geojson <- function(str, fmt = 16, feature = TRUE){
  type <- get_type(str)
  switch(type,
         Point = load_point(str, fmt, feature),
         Polygon = load_polygon(str, fmt, feature),
         Multipoint = load_multipoint(str, fmt, feature),
         Linestring = load_linestring(str, fmt, feature)
  )
}

types <- c("POINT","POLYGON","LINESTRING",'MULTIPOINT',"MULTIPOLYGON")

get_type <- function(x){
  type <- cw(types[sapply(types, grepl, x = x)], onlyfirst = TRUE)
  if(length(type) > 1)
    grep(tolower(strextract(x, "[A-Za-z]+")), type, ignore.case = TRUE, value = TRUE)
  else
    type
}

#' Convert WKT to GeoJSON-like POINT object.
#'
#' @inheritParams wkt2geojson
#' @keywords internal
load_point <- function(str, fmt = 16, feature = TRUE){
  str_coord <- gsub("POINT|\\(|\\)", "", str)
  coords <- strsplit(str_trim_(str_coord), "\\s")[[1]]
  tmp <- list(type='Point', coordinates=as.numeric(coords))
  if(feature)
    list(type="Feature", geometry=tmp)
  else
    tmp
}

#' Convert WKT to GeoJSON-like MULTIPOINT object.
#'
#' @inheritParams wkt2geojson
#' @keywords internal
load_multipoint <- function(str, fmt = 16, feature = TRUE){
  str_coord <- str_trim_(gsub("MULTIPOINT\\s", "", str))
  str_coord <- gsub("^\\(|\\)$", "", str_coord)
  str_coord <- strsplit(str_coord, "\\),")[[1]]
  coords <- lapply(str_coord, function(z){
    pairs <- strsplit(strsplit(gsub("\\(|\\)", "", str_trim_(z)), ",|,\\s")[[1]], "\\s")
    lapply(pairs, as.numeric)
  })
  tmp <- list(type='Multipoint', coordinates=coords)
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
  str_coord <- str_trim_(gsub("POLYGON\\s", "", str))
  str_coord <- gsub("^\\(|\\)$", "", str_coord)
  str_coord <- strsplit(str_coord, "\\),")[[1]]
  coords <- lapply(str_coord, function(z){
    pairs <- strsplit(strsplit(gsub("\\(|\\)", "", str_trim_(z)), ",|,\\s")[[1]], "\\s")
    lapply(pairs, as.numeric)
  })
  tmp <- list(type='Polygon', coordinates=coords)
  if(feature)
    list(type="Feature", geometry=tmp)
  else
    tmp
}

#' Convert WKT to GeoJSON-like LINESTRING object.
#'
#' @inheritParams wkt2geojson
#' @keywords internal
load_linestring <- function(str, fmt = 16, feature = TRUE){
  str_coord <- str_trim_(gsub("LINESTRING\\s", "", str))
  str_coord <- gsub("^\\(|\\)$", "", str_coord)
  str_coord <- strsplit(str_coord, "\\),")[[1]]
  coords <- lapply(str_coord, function(z){
    pairs <- strsplit(strsplit(gsub("\\(|\\)", "", str_trim_(z)), ",|,\\s")[[1]], "\\s")
    lapply(pairs, as.numeric)
  })
  tmp <- list(type='Linestring', coordinates=coords)
  if(feature)
    list(type="Feature", geometry=tmp)
  else
    tmp
}
