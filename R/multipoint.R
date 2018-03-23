#' Make WKT multipoint objects
#'
#' @export
#'
#' @template fmt
#' @inheritParams point
#' @family R-objects
#' @examples
#' ## empty multipoint
#' multipoint("empty")
#' # multipoint("stuff")
#'
#' # numeric
#' multipoint(c(100.000, 3.101), c(101.000, 2.100), c(3.140, 2.180))
#'
#' # data.frame
#' df <- us_cities[1:25, c('long', 'lat')]
#' multipoint(df)
#'
#' # matrix
#' mat <- matrix(c(df$long, df$lat), ncol = 2)
#' multipoint(mat)
#'
#' # list
#' multipoint(list(c(100.000, 3.101), c(101.000, 2.100), c(3.140, 2.180)))
#'
#' 
#' ## a 3rd point is included
#' multipoint(c(100, 3, 0), c(101, 2, 0), c(3, 2, 0), 
#'   third = "z", fmt = 1)
#' multipoint(c(100, 3, 0), c(101, 2, 0), c(3, 2, 0), 
#'   third = "m", fmt = 1)
#' 
#' df <- us_cities[1:25, c('long', 'lat')]
#' df$altitude <- round(runif(25, 100, 500))
#' multipoint(df, fmt = 2)
#' multipoint(df, fmt = 2, third = "m")
#' 
#' mat <- matrix(1:9, 3)
#' multipoint(mat)
#' multipoint(mat, third = "m")
#' 
#' x <- list(c(100, 3, 0), c(101, 2, 1), c(3, 2, 5))
#' multipoint(x)
#' 
#'
#' ## a 4th point is included
#' multipoint(
#'   c(100, 3, 0, 500), c(101, 2, 0, 505), c(3, 2, 0, 600), 
#'   fmt = 1)
#' 
#' df <- us_cities[1:25, c('long', 'lat')]
#' df$altitude <- round(runif(25, 100, 500))
#' df$weight <- round(runif(25, 1, 100))
#' multipoint(df, fmt = 2)
#' 
#' mat <- matrix(1:12, 3)
#' multipoint(mat)
#' 
#' x <- list(c(100, 3, 0, 300), c(101, 2, 1, 200), c(3, 2, 5, 100))
#' multipoint(x, fmt = 3)
multipoint <- function(..., fmt = 16, third = "z") {
  UseMethod("multipoint")
}

#' @export
multipoint.character <- function(..., fmt = 16, third = "z") {
  pts <- list(...)
  if (grepl("empty", pts[[1]], ignore.case = TRUE)) {
    return('MULTIPOINT EMPTY')
  } else {
    check_str(pts)
  }
}

#' @export
multipoint.numeric <- function(..., fmt = 16, third = "z") {
  pts <- list(...)
  fmtcheck(fmt)
  invisible(lapply(pts, checker, type = 'MULTIPOINT', len = 2:4))
  str <- paste0(lapply(pts, function(z){
    sprintf("(%s)", paste0(str_trim_(format(z, nsmall = fmt, trim = TRUE)),
                           collapse = " "))
  }), collapse = ", ")
  len <- unique(vapply(pts, length, numeric(1)))
  make_multi(str, len, third)
}

#' @export
multipoint.data.frame <- function(..., fmt = 16, third = "z") {
  pts <- list(...)
  fmtcheck(fmt)
  invisible(lapply(pts, dfchecker, type = 'MULTIPOINT', len = 2:4))
  str <- paste0(apply(pts[[1]], 1, function(z){
    sprintf("(%s)", paste0(str_trim_(format(z, nsmall = fmt, trim = TRUE)),
                           collapse = " "))
  }), collapse = ", ")
  len <- unique(vapply(pts, NCOL, numeric(1)))
  make_multi(str, len, third)
}

#' @export
multipoint.matrix <- function(..., fmt = 16, third = "z") {
  pts <- list(...)
  fmtcheck(fmt)
  invisible(lapply(pts, dfchecker, type = 'MULTIPOINT', len = 2:4))
  str <- paste0(apply(pts[[1]], 1, function(z){
    sprintf("(%s)", paste0(str_trim_(format(z, nsmall = fmt, trim = TRUE)),
                           collapse = " "))
  }), collapse = ", ")
  len <- unique(vapply(pts, NCOL, numeric(1)))
  make_multi(str, len, third)
}

#' @export
multipoint.list <- function(..., fmt = 16, third = "z") {
  pts <- list(...)[[1]]
  fmtcheck(fmt)
  invisible(lapply(pts, checker, type = 'MULTIPOINT', len = 2:4))
  str <- paste0(lapply(pts, function(z) {
    sprintf("(%s)", paste0(str_trim_(format(z, nsmall = fmt, trim = TRUE)),
                           collapse = " "))
  }), collapse = ", ")
  # sprintf('MULTIPOINT (%s)', str)
  len <- unique(vapply(pts, length, numeric(1)))
  make_multi(str, len, third)
}

# helpers -----
make_multi <- function(str, len, third) {
  if (len == 3) {
    sprintf('MULTIPOINT %s(%s)', pick3(third), str)
  } else if (len == 4) {
    sprintf('MULTIPOINT ZM(%s)', str)
  } else {
    sprintf('MULTIPOINT (%s)', str)
  }   
}
