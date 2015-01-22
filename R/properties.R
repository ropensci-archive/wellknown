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
