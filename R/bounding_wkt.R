#' @title Generate Bounding Boxes
#' @description `bounding_wkt` takes bounding boxes, in various formats,
#' and turns them into WKT POLYGONs.
#' @export
#' @param min_x a numeric vector of the minimum value for `x` coordinates.
#' @param min_y a numeric vector of the minimum value for `y` coordinates.
#' @param max_x a numeric vector of the maximum value for `x` coordinates.
#' @param max_y a numeric vector of the maximum value for `y` coordinates.
#' @param values as an alternative to specifying the various values as vectors,
#' a list of length-4 numeric vectors containing min and max x and y values, or
#' just a single vector fitting that spec. NULL (meaning that the other
#' parameters will be expected) by default.
#' @return a character vector of WKT POLYGON objects
#' @seealso [wkt_bounding()], to turn WKT objects of various types into
#' a matrix or data.frame of bounding boxes.
#' @examples
#' # With individual columns
#' bounding_wkt(10, 12, 14, 16)
#' 
#' # With a list
#' bounding_wkt(values = list(c(10, 12, 14, 16)))
bounding_wkt <- function(min_x, min_y, max_x, max_y, values = NULL) {
  if (is.null(values)) {
    return(bounding_wkt_points(min_x, max_x, min_y, max_y))
  }
  if (is.list(values)) {
    return(bounding_wkt_list(values))
  }
  if (is.vector(values) && length(values) == 4) {
    return(bounding_wkt_list(list(values)))
  }
  stop("values must be NULL, a list or a length-4 vector")
}
