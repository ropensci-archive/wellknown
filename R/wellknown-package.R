#' @title wellknown
#' @description WKT to GeoJSON and vice versa
#' @name wellknown-package
#' @aliases wellknown
#' @docType package
#' @author Scott Chamberlain \email{myrmecocystus@@gmail.com}
#' @keywords package
#' @importFrom wk wkt_translate_wkb wkb_translate_wkt
#' @examples
#' # GeoJSON to WKT
#' point <- list(Point = c(116.4, 45.2, 11.1))
#' geojson2wkt(point)
#' 
#' # WKT to GeoJSON
#' str <- "POINT (-116.4000000000000057 45.2000000000000028)"
#' wkt2geojson(str)
#' 
#' ## lint WKT
#' lint("POINT (1 2)")
#' lint("POINT (1 2 3 4 5)")
#' 
#' # WKT <--> WKB
#' wkt_wkb("POINT (-116.4 45.2)")
#' wkb_wkt(wkt_wkb("POINT (-116.4 45.2)"))
NULL

#' This is the same data set from the maps library, named differently
#'
#' This database is of us cities of population greater than about 40,000.
#' Also included are state capitals of any population size.
#'
#' @name us_cities
#' @format A list with 6 components, namely "name", "country.etc", "pop",
#' "lat", "long", and "capital", containing the city name, the state
#' abbreviation, approximate population (as at January 2006), latitude,
#' longitude and capital status indication (0 for non-capital, 1 for
#' capital, 2 for state capital.
#' @docType data
#' @keywords data
NULL
