#' Add properties to a GeoJSON object
#'
#' @export
#' @param x (list) GeoJSON as a list
#' @param style (list) named list of color, fillColor, etc. attributes.
#' Default: `NULL`
#' @param popup (list) named list of popup values. Default: `NULL`
#' @examples
#' str <- "POINT (-116.4000000000000057 45.2000000000000028)"
#' x <- wkt2geojson(str)
#' properties(x, style = list(color = "red"))
properties <- function(x, style = NULL, popup = NULL){
  if (is.null(style) && is.null(popup)) {
    stop("Supply a list of named options to either style, popup, or both")
  } else {
    if (inherits(style, "list") || inherits(popup, "list")) {
      if (length(style) == 0 && length(popup) == 0)
        stop("At least one of style or popup needs a non-empty list",
             call. = FALSE)
    }
    utils::modifyList(x,
      list(properties = wc(list(style = style, popup = popup))))
  }
}
