#' Convert geojson R list to JSON
#'
#' @export
#' @importFrom jsonlite toJSON
#' @examples
#' str <- "POLYGON ((100 0.1, 101.1 0.3, 101 0.5, 100 0.1),
#'    (103.2 0.2, 104.8 0.2, 100.8 0.8, 103.2 0.2))"
#' as.json(wkt2geojson(str))
#' as.json(wkt2geojson(str), FALSE)
as.json <- function(x, pretty=TRUE, auto_unbox=TRUE, ...) UseMethod("as.json")

#' @export
#' @rdname as.json
as.json.geojson <- function(x, pretty=TRUE, auto_unbox=TRUE, ...) {
  jsonlite::toJSON(unclass(x), pretty=pretty, auto_unbox=auto_unbox, ...)
}
