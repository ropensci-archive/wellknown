#' Make WKT point objects
#'
#' @export
#'
#' @template fmt
#' @param ... A GeoJSON-like object representing a Point, LineString, Polygon,
#' MultiPolygon, etc.
#' @param third if "2d", assign a "m" value for linear reference system,
#' and if "3d" assign a "z" value for three-dimenionsal system
#' @family R-objects
#' @details The \code{third} parameter is used only when there are sets of
#' three points, and  you can toggle whether the object gets a Z or M.
#'
#' When four points are included, the object automatically gets assigned
#' ZM.
#' @examples
#' ## empty point
#' point("empty")
#' # point("stuff")
#'
#' ## single point
#' point(-116.4, 45.2)
#' point(0, 1)
#'
#' ## single point, from data.frame
#' df <- data.frame(lon=-116.4, lat=45.2)
#' point(df)
#'
#' ## many points, from a data.frame
#' ussmall <- us_cities[1:5, ]
#' df <- data.frame(long = ussmall$long, lat = ussmall$lat)
#' point(df)
#'
#' ## many points, from a matrix
#' mat <- matrix(c(df$long, df$lat), ncol = 2)
#' point(mat)
#'
#' ## single point, from a list
#' point(list(c(100.0, 3.101)))
#'
#' ## many points, from a list
#' point(list(c(100.0, 3.101), c(101.0, 2.1), c(3.14, 2.18)))
#'
#' ## when a 3rd point is included
#' point(1:3, third = "2d")
#' point(1:3, third = "3d")
#' point(list(1:3, 4:6), third = "2d")
#' point(list(1:3, 4:6), third = "3d")
#' point(matrix(1:9, ncol = 3), third = "2d")
#' point(matrix(1:9, ncol = 3), third = "3d")
#' point(data.frame(1, 2, 3), third = "2d")
#' point(data.frame(1, 2, 3), third = "3d")
#' point(data.frame(1:3, 4:6, 7:9), third = "2d")
#'
#' ## when a 4th point is included
#' point(1:4)
#' point(list(1:4, 5:8))
#' point(matrix(1:12, ncol = 4))
#' point(data.frame(1, 2, 3, 4))
#' point(data.frame(1:3, 4:6, 7:9, 10:12))
point <- function(..., fmt = 16, third = "2d") {
  UseMethod("point")
}

#' @export
point.character <- function(..., fmt = 16, third = "2d") {
  pts <- list(...)
  if (grepl("empty", pts[[1]], ignore.case = TRUE)) {
    return('POINT EMPTY')
  } else {
    check_str(pts)
  }
}

#' @export
point.numeric <- function(..., fmt = 16, third = "2d") {
  pts <- unlist(list(...))
  fmtcheck(fmt)
  checker(pts, 'POINT', 2:4)
  str <- paste0(format(pts, nsmall = fmt, trim = TRUE), collapse = " ")
  # sprintf('POINT (%s)', paste0(format(pts, nsmall = fmt, trim = TRUE),
  #                              collapse = " "))
  if (length(pts) == 3) {
    sprintf('POINT %s(%s)', pick3(third), str)
  } else if (length(pts) == 4) {
    sprintf('POINT ZM(%s)', str)
  } else {
    sprintf('POINT (%s)', str)
  }
}

#' @export
point.data.frame <- function(..., fmt = 16, third = "2d") {
  pts <- list(...)
  fmtcheck(fmt)
  str <- apply(pts[[1]], 1, function(x)
    paste0(format(x, nsmall = fmt, trim = TRUE), collapse = " "))
  if (NCOL(pts[[1]]) == 3) {
    sprintf('POINT %s(%s)', pick3(third), str)
  } else if (NCOL(pts[[1]]) == 4) {
    sprintf('POINT ZM(%s)', str)
  } else {
    sprintf('POINT (%s)', str)
  }
}

#' @export
point.matrix <- function(..., fmt = 16, third = "2d") {
  pts <- list(...)
  fmtcheck(fmt)
  str <- apply(pts[[1]], 1, function(x)
    paste0(format(x, nsmall = fmt, trim = TRUE), collapse = " "))
  # sprintf('POINT (%s)', str)
  if (NCOL(pts[[1]]) == 3) {
    sprintf('POINT %s(%s)', pick3(third), str)
  } else if (NCOL(pts[[1]]) == 4) {
    sprintf('POINT ZM(%s)', str)
  } else {
    sprintf('POINT (%s)', str)
  }
}

#' @export
point.list <- function(..., fmt = 16, third = "2d") {
  pts <- list(...)[[1]]
  fmtcheck(fmt)
  str <- sapply(pts, function(x)
    paste0(format(x, nsmall = fmt, trim = TRUE), collapse = " "))
  # sprintf('POINT (%s)', str)
  if (length(pts[[1]]) == 3) {
    sprintf('POINT %s(%s)', pick3(third), str)
  } else if (length(pts[[1]]) == 4) {
    sprintf('POINT ZM(%s)', str)
  } else {
    sprintf('POINT (%s)', str)
  }
}

pick3 <- function(x) {
  switch(
    x,
    `2d` = "M",
    `3d` = "Z"
  )
}
