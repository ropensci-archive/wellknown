#' Convert WKT to GeoJSON-like objects.
#'
#' @export
#'
#' @template fmt
#' @param str A GeoJSON-like object representing a Point, LineString, Polygon,
#' MultiPolygon, etc.
#' @param feature (logical) Make a feature geojson object. Default: `TRUE`
#' @param numeric (logical) Give back values as numeric. Default: `TRUE`
#' @param simplify (logical) Attempt to simplify from a multi- geometry type 
#' to a single type. Applies to multi features only. Default: `FALSE` 
#' 
#' @details Should be robust against a variety of typing errors, including
#' extra spaces between coordinates, no space between WKT type and coordinates.
#' However, some things won't pass, including lowercase WKT types, no
#' spaces between coordinates.
#' 
#' WKT with a 3rd value and when Z is found will be left as is and assumed to 
#' be a altitude or similar value. WKT with a 3rd value and when M is found 
#' will be discarded as the GeoJSON spec says to do so. WKT with a 4th value 
#' as (presumably as a measurement) will also be discarded.
#' @seealso [geojson2wkt()]
#' @references <https://tools.ietf.org/html/rfc7946>
#' @examples
#' # point
#' str <- "POINT (-116.4000000000000057 45.2000000000000028)"
#' wkt2geojson(str)
#' wkt2geojson(str, feature=FALSE)
#' wkt2geojson(str, numeric=FALSE)
#' wkt2geojson("POINT (-116 45)")
#' wkt2geojson("POINT (-116 45 0)")
#' ## 3D
#' wkt2geojson("POINT Z(100 3 35)")
#' wkt2geojson("POINT M(100 3 35)") # dropped if M
#' ## 4D
#' wkt2geojson("POINT ZM(100 3 35 1.5)") # Z retained
#'
#' # multipoint
#' str <- 'MULTIPOINT ((100.000 3.101), (101.000 2.100), (3.140 2.180))'
#' wkt2geojson(str, fmt = 2)
#' wkt2geojson(str, fmt = 2, feature=FALSE)
#' wkt2geojson(str, numeric=FALSE)
#' wkt2geojson("MULTIPOINT ((100 3), (101 2), (3 2))")
#' wkt2geojson("MULTIPOINT ((100 3 0), (101 2 0), (3 2 0))")
#' wkt2geojson("MULTIPOINT ((100 3 0 1), (101 2 0 1), (3 2 0 1))") 
#' ## 3D
#' wkt2geojson("MULTIPOINT Z((100 3 35), (101 2 45), (3 2 89))")
#' wkt2geojson("MULTIPOINT M((100 3 1.3), (101 2 1.4), (3 2 1.9))")
#' ## 4D
#' wkt2geojson("MULTIPOINT ZM((100 3 35 0), (101 2 45 0), (3 2 89 0))")
#' 
#' ## simplify
#' wkt2geojson("MULTIPOINT ((100 3))", simplify = FALSE)
#' wkt2geojson("MULTIPOINT ((100 3))", simplify = TRUE)
#' 
#'
#' # polygon
#' str <- "POLYGON ((100 0.1, 101.1 0.3, 101 0.5, 100 0.1),
#'    (103.2 0.2, 104.8 0.2, 100.8 0.8, 103.2 0.2))"
#' wkt2geojson(str)
#' wkt2geojson(str, feature=FALSE)
#' wkt2geojson(str, numeric=FALSE)
#' ## 3D
#' str <- "POLYGON Z((100 0.1 3, 101.1 0.3 1, 101 0.5 5, 100 0.1 8),
#'    (103.2 0.2 3, 104.8 0.2 4, 100.8 0.8 5, 103.2 0.2 9))"
#' wkt2geojson(str)
#' ## 4D
#' str <- "POLYGON ZM((100 0.1 3 0, 101.1 0.3 1 0, 101 0.5 5 0, 100 0.1 8 0),
#'    (103.2 0.2 3 0, 104.8 0.2 4 0, 100.8 0.8 5 0, 103.2 0.2 9 0))"
#' wkt2geojson(str)
#' 
#'
#' # multipolygon
#' str <- "MULTIPOLYGON (((40 40, 20 45, 45 30, 40 40)),
#'  ((20 35, 45 20, 30 5, 10 10, 10 30, 20 35), (30 20, 20 25, 20 15, 30 20)))"
#' wkt2geojson(str)
#' wkt2geojson(str, feature=FALSE)
#' wkt2geojson(str, numeric=FALSE)
#' ## 3D
#' str <- "MULTIPOLYGON Z(((40 40 1, 20 45 3, 45 30 10, 40 40 0)),
#'  ((20 35 5, 45 20 67, 30 5 890, 10 10 2, 10 30 0, 20 35 4), 
#'  (30 20 4, 20 25 54, 20 15 56, 30 20 89)))"
#' wkt2geojson(str)
#' ## 4D
#' str <- "MULTIPOLYGON ZM(((40 40 1 0, 20 45 3 4, 45 30 10 45, 40 40 0 1)),
#'  ((20 35 5 8, 45 20 67 9, 30 5 890 89, 10 10 2 234, 10 30 0 5, 20 35 4 1), 
#'  (30 20 4 0, 20 25 54 5, 20 15 56 55, 30 20 89 78)))"
#' wkt2geojson(str)
#' 
#' # simplify multipolygon to polygon if possible
#' str <- "MULTIPOLYGON (((40 40, 20 45, 45 30, 40 40)))"
#' wkt2geojson(str, simplify = FALSE)
#' wkt2geojson(str, simplify = TRUE)
#' 
#'
#' # linestring
#' str <- "LINESTRING (100.000 0.000, 101.000 1.000)"
#' wkt2geojson(str)
#' wkt2geojson(str, feature = FALSE)
#' wkt2geojson("LINESTRING (0 -1, -2 -3, -4 5)")
#' wkt2geojson("LINESTRING (0 1 2, 4 5 6)")
#' wkt2geojson(str, numeric = FALSE)
#' ## 3D
#' wkt2geojson("LINESTRING Z(100.000 0.000 3, 101.000 1.000 5)")
#' wkt2geojson("LINESTRING M(100.000 0.000 10, 101.000 1.000 67)")
#' ## 4D
#' wkt2geojson("LINESTRING ZM(100 0 1 4, 101 1 5 78)")
#' 
#'
#' # multilinestring
#' str <- "MULTILINESTRING ((30 1, 40 30, 50 20)(10 0, 20 1))"
#' wkt2geojson(str)
#' wkt2geojson(str, numeric=FALSE)
#'
#' str <- "MULTILINESTRING (
#'    (-105.0 39.5, -105.0 39.5, -105.0 39.5, -105.0 39.5,
#'      -105.0 39.5, -105.0 39.5),
#'    (-105.0 39.5, -105.0 39.5, -105.0 39.5),
#'    (-105.0 39.5, -105.0 39.5, -105.0 39.5, -105.0 39.5, -105.0 39.5),
#'    (-105.0 39.5, -105.0 39.5, -105.0 39.5, -105.0 39.5))"
#' wkt2geojson(str)
#' wkt2geojson(str, numeric=FALSE)
#' 
#' ## 3D
#' str <- "MULTILINESTRING Z((30 1 0, 40 30 0, 50 20 0)(10 0 1, 20 1 1))"
#' wkt2geojson(str)
#' str <- "MULTILINESTRING M((30 1 0, 40 30 0, 50 20 0)(10 0 1, 20 1 1))"
#' wkt2geojson(str)
#' ## 4D
#' str <- "MULTILINESTRING ZM((30 1 0 5, 40 30 0 7, 50 20 0 1)(10 0 1 1, 20 1 1 1))"
#' wkt2geojson(str)
#' 
#' # simplify multilinestring to linestring if possible
#' str <- "MULTILINESTRING ((30 1, 40 30, 50 20))"
#' wkt2geojson(str, simplify = FALSE)
#' wkt2geojson(str, simplify = TRUE)
#' 
#'
#' # Geometrycollection
#' str <- "GEOMETRYCOLLECTION (
#'  POINT Z(0 1 4),
#'  LINESTRING (-100 0, -101 -1),
#'  POLYGON ((100.001 0.001, 101.1235 0.0010, 101.001 1.001, 100.001 0.001),
#'            (100.201 0.201, 100.801 0.201, 100.801 0.801, 100.201 0.201)),
#'  MULTIPOINT ((100.000 3.101), (101.0 2.1), (3.14 2.18)),
#'  MULTILINESTRING ((0 -1, -2 -3, -4 -5),
#'        (1.66 -31.50, 10.0 3.0, 10.9 1.1, 0.0 4.4)),
#'  MULTIPOLYGON (((100.001 0.001, 101.001 0.001, 101.001 1.001, 100.001 0.001),
#'                (100.201 0.201, 100.801 0.201, 100.801 0.801, 100.201 0.201)),
#'                  ((1 2 3, 5 6 7, 9 10 11, 1 2 3))))"
#' wkt2geojson(str)
#' wkt2geojson(str, numeric=FALSE)
#'
#' # case doesn't matter
#' str <- "point (-116.4000000000000057 45.2000000000000028)"
#' wkt2geojson(str)

wkt2geojson <- function(str, fmt = 16, feature = TRUE, numeric = TRUE, 
  simplify = FALSE) {

  type <- get_type(str, ignore_case = TRUE)
  res <- switch(type,
         Point = load_point(str, fmt, feature, numeric),
         Multipoint = load_multipoint(str, fmt, feature, numeric, 
          simplify),
         Polygon = load_polygon(str, fmt, feature, numeric),
         Multipolygon = load_multipolygon(str, fmt, feature, numeric, 
            simplify),
         Linestring = load_linestring(str, fmt, feature, numeric),
         Multilinestring = load_multilinestring(str, fmt, feature, numeric, 
            simplify),
         Geometrycollection = 
            load_geometrycollection(str, fmt, feature, numeric)
  )
  structure(res, class = "geojson")
}

wellknown_types <- c("POINT",'MULTIPOINT',"POLYGON","MULTIPOLYGON",
           "LINESTRING","MULTILINESTRING","GEOMETRYCOLLECTION",
           "TRIANGLE","CIRCULARSTRING","COMPOUNDCURVE")

get_type <- function(x, ignore_case = FALSE){
  type <- cw(wellknown_types[sapply(wellknown_types, grepl, x = x, ignore.case = ignore_case)],
             onlyfirst = TRUE)
  if (length(type) > 1) {
    grep(tolower(strextract(x, "[A-Za-z]+")), type, ignore.case = TRUE,
         value = TRUE)
  } else {
    type
  }
}

load_point <- function(str, fmt = 16, feature = TRUE, numeric = TRUE) {

  zm <- tolower(strextract(strextract(str, "[zmZM]+\\("), "[A-Za-z]+")) %||% ""
  str_coord <- str_trim_(gsub("POINT\\s?([ZMzm]+)?\\(| \\)", "", str, 
    ignore.case = TRUE))
  coords <- strsplit(gsub("[[:punct:]]$", "", 
    str_trim_(str_coord)), "\\s")[[1]]
  coords <- nozero(coords)
  if (nzchar(zm)) {
    coords <- switch(
      zm, 
      "zm" = coords[-4],
      "m" = coords[-3],
      "z" = coords
    )
  }
  iffeat('Point', if (numeric) as.numeric(coords, fmt) else
    format_num(coords, fmt), feature)
}

format_num <- function(x, fmt) {
  sprintf(paste0("%.", fmt, "f"), as.numeric(x))
}

load_multipoint <- function(str, fmt = 16, feature = TRUE, numeric = TRUE, 
  simplify = FALSE) {

  zm <- tolower(strextract(strextract(str, "[zmZM]+\\("), "[A-Za-z]+")) %||% ""
  str_coord <- str_trim_(gsub("MULTIPOINT\\s?([ZMzm]+)?\\(", "", str, 
    ignore.case = TRUE))
  str_coord <- gsub("^\\(|\\)$", "", str_coord)
  str_coord <- strsplit(str_coord, "\\),")[[1]]
  if (simplify) {
    if (length(str_coord) == 1) return(load_point(str_coord, fmt, feature, numeric))
  }
  coords <- unname(lapply(str_coord, function(z){
    pairs <- strsplit(strsplit(gsub("\\(|\\)", "", 
      str_trim_(z)), ",|,\\s")[[1]], "\\s")
    do.call("rbind", lapply(pairs, function(x) {
      tmp <- if (numeric) as.numeric(nozero(x), fmt) else format_num(nozero(x), fmt)
      matrix(tmp, ncol = length(tmp))
    }))
  }))
  coords <- do.call("rbind", coords)
  if (nzchar(zm)) {
    coords <- switch(
      zm, 
      "zm" = coords[,-4],
      "m" = coords[,-3],
      "z" = coords
    )
  }
  iffeat('MultiPoint', coords, feature)
}

load_polygon <- function(str, fmt = 16, feature = TRUE, numeric = TRUE) {

  zm <- tolower(strextract(strextract(str, "[zmZM]+\\("), "[A-Za-z]+")) %||% ""
  str_coord <- str_trim_(gsub("POLYGON\\s?([ZMzm]+)?\\(", "", str, 
    ignore.case = TRUE))
  str_coord <- gsub("^\\(|\\)$", "", str_coord)
  str_coord <- strsplit(str_coord, "\\),")[[1]]
  coords <- lapply(str_coord, function(z){
    pairs <- strsplit(strsplit(gsub("\\(|\\)", "", 
      str_trim_(z)), ",|,\\s")[[1]], "\\s")
    do.call("rbind", lapply(pairs, function(x) {
      tmp <- if (numeric) as.numeric(nozero(x), fmt) else format_num(nozero(x), fmt)
      matrix(tmp, ncol = length(tmp))
    }))
  })
  if (nzchar(zm)) {
    coords <- switch(
      zm, 
      "zm" = lapply(coords, function(z) z[,-4]),
      "m" = lapply(coords, function(z) z[,-3]),
      "z" = coords
    )
  }
  iffeat('Polygon', coords, feature)
}

load_multipolygon <- function(str, fmt = 16, feature = TRUE, numeric = TRUE, 
  simplify = FALSE) {

  str <- gsub("\n", "", str)
  zm <- tolower(strextract(strextract(str, "[zmZM]+\\("), "[A-Za-z]+")) %||% ""
  str_coord <- str_trim_(gsub("MULTIPOLYGON\\s?([Zmzm]+)?", "", str, ignore.case = TRUE))
  str_coord <- gsub("^\\(|\\)$", "", str_coord)
  str_coord <- strsplit(str_coord, "\\)),")[[1]]
  if (simplify) {
    if (length(str_coord) == 1) return(load_polygon(str_coord, fmt, feature, numeric))
  }
  coords <- lapply(str_coord, function(z){
    pairs <- strsplit( gsub("\\(|\\)", "", strsplit(str_trim_(z), "\\),")[[1]]), ",|,\\s")
    lapply(pairs, function(zz){
      do.call("rbind", unname(lapply(sapply(str_trim_(zz), strsplit, split = "\\s"), function(x) {
        tmp <- if (numeric) as.numeric(nozero(x), fmt) else format_num(nozero(x), fmt)
        matrix(tmp, ncol = length(tmp))
      })))
    })
  })
  if (nzchar(zm)) {
    coords <- switch(
      zm, 
      "zm" = lapply(coords, function(z) lapply(z, function(w) w[,-4])),
      "m" = lapply(coords, function(z) lapply(z, function(w) w[,-3])),
      "z" = coords
    )
  }
  iffeat('MultiPolygon', coords, feature)
}

load_linestring <- function(str, fmt = 16, feature = TRUE, numeric = TRUE){
  str <- gsub("\n", "", str)
  zm <- tolower(strextract(strextract(str, "[zmZM]+\\("), "[A-Za-z]+")) %||% ""
  str_coord <- str_trim_(gsub("LINESTRING\\s?([Zmzm]+)?", "", str, ignore.case = TRUE))
  str_coord <- gsub("^\\(|\\)$", "", str_coord)
  str_coord <- strsplit(str_coord, "\\),")[[1]]
  coords <- lapply(str_coord, function(z){
    pairs <- strsplit(strsplit(gsub("\\(|\\)", "", str_trim_(z)), ",|,\\s")[[1]], "\\s")
    do.call("rbind", lapply(pairs, function(x) {
      tmp <- if (numeric) as.numeric(nozero(x), fmt) else format_num(nozero(x), fmt)
      matrix(tmp, ncol = length(tmp))
    }))
  })
  coords <- do.call("rbind", coords)
  if (nzchar(zm)) {
    coords <- switch(
      zm, 
      "zm" = coords[,-4],
      "m" = coords[,-3],
      "z" = coords
    )
  }
  iffeat('LineString', coords, feature)
}

load_multilinestring <- function(str, fmt = 16, feature = TRUE, numeric = TRUE, 
  simplify = FALSE) {

  str <- gsub("\n", "", str)
  zm <- tolower(strextract(strextract(str, "[zmZM]+\\("), "[A-Za-z]+")) %||% ""
  str_coord <- str_trim_(gsub("MULTILINESTRING\\s?([ZMzm]+)?", "", str, ignore.case = TRUE))
  str_coord <- gsub("^\\(|\\)$", "", str_coord)
  str_coord <- strsplit(str_coord, "\\),|\\)\\(")[[1]]
  if (simplify) {
    if (length(str_coord) == 1) return(load_linestring(str_coord, fmt, feature, numeric))
  }
  coords <- lapply(str_coord, function(z){
    pairs <- strsplit(strsplit(str_trim_(gsub("\\(|\\)", "", str_trim_(z))), ",|,\\s")[[1]], "\\s")
    do.call("rbind", lapply(pairs, function(x) {
      tmp <- if (numeric) as.numeric(nozero(x), fmt) else format_num(nozero(x), fmt)
      matrix(tmp, ncol = length(tmp))
    }))
  })
  if (nzchar(zm)) {
    coords <- switch(
      zm, 
      "zm" = lapply(coords, function(z) z[,-4]),
      "m" = lapply(coords, function(z) z[,-3]),
      "z" = coords
    )
  }
  iffeat('MultiLineString', coords, feature)
}

load_geometrycollection <- function(str, fmt = 16, feature = TRUE, numeric = TRUE){
  str_coord <- str_trim_(gsub("GEOMETRYCOLLECTION\\s?", "",
                              gsub("\n", "", str), ignore.case = TRUE))
  str_coord <- gsub("^\\(|\\)$", "", str_coord)
  matches <- noneg(sort(sapply(wellknown_types, regexpr, text = str_coord)))
  out <- list()
  for (i in seq_along(matches)) {
    end <- if (i == length(matches)) nchar(str_coord) else matches[[i + 1]] - 1
    strg <- substr(str_coord, matches[[i]], end)
    strg <- gsub(",\\s+?$", "", strg)
    out[[ i ]] <- get_load_fxn(tolower(names(matches[i])))(strg, fmt, feature, numeric)
  }
  list(type = 'GeometryCollection', geometries = out)
}

get_load_fxn <- function(type){
  switch(type,
         point = load_point,
         multipoint = load_multipoint,
         linestring = load_linestring,
         multilinestring = load_multilinestring,
         polygon = load_polygon,
         multipolygon = load_multipolygon,
         geometrycollection = load_geometrycollection)
}

noneg <- function(x) x[!x < 0]

iffeat <- function(type, cd, feature) {
  tmp <- list(type = type, coordinates = cd)
  if (feature) {
    list(type = "Feature", geometry = tmp)
  } else {
    tmp
  }
}
