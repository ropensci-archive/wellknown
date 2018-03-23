#' Make WKT linestring objects
#'
#' @export
#'
#' @template fmt
#' @inheritParams point
#' @family R-objects
#' @examples
#' ## empty linestring
#' linestring("empty")
#' # linestring("stuff")
#'
#' ## character string
#' linestring("LINESTRING (-116.4 45.2, -118.0 47.0)")
#'
#' # numeric
#' ## 2D
#' linestring(c(100.000, 0.000), c(101.000, 1.000), fmt=2)
#' linestring(c(100.0, 0.0), c(101.0, 1.0), c(120.0, 5.00), fmt=2)
#' ## 3D
#' linestring(c(0.0, 0.0, 10.0), c(2.0, 1.0, 20.0),
#'            c(4.0, 2.0, 30.0), c(5.0, 4.0, 40.0), fmt=2)
#' ## 4D
#' linestring(c(0.0, 0.0, 10.0, 5.0), c(2.0, 1.0, 20.0, 5.0),
#'            c(4.0, 2.0, 30.0, 5.0), c(5.0, 4.0, 40.0, 5.0), fmt=2)
#'
#' # data.frame
#' df <- data.frame(lon=c(-116.4,-118), lat=c(45.2,47))
#' linestring(df, fmt=1)
#' df <- data.frame(lon=c(-116.4,-118,-120), lat=c(45.2,47,49))
#' linestring(df, fmt=1)
#' ## 3D
#' df$altitude <- round(runif(NROW(df), 10, 50))
#' linestring(df, fmt=1)
#' linestring(df, fmt=1, third = "m")
#' ## 4D
#' df$weight <- round(runif(NROW(df), 0, 1), 1)
#' linestring(df, fmt=1)
#' 
#'
#' # matrix
#' mat <- matrix(c(-116.4,-118, 45.2, 47), ncol = 2)
#' linestring(mat, fmt=1)
#' mat2 <- matrix(c(-116.4, -118, -120, 45.2, 47, 49), ncol = 2)
#' linestring(mat2, fmt=1)
#' ## 3D
#' mat <- matrix(c(df$long, df$lat, df$altitude), ncol = 3)
#' polygon(mat, fmt=2)
#' polygon(mat, fmt=2, third = "m")
#' ## 4D
#' mat <- matrix(unname(unlist(df)), ncol = 4)
#' polygon(mat, fmt=2)
#'
#' # list
#' linestring(list(c(100.000, 0.000), c(101.000, 1.000)), fmt=2)
#' ## 3D
#' line <- list(c(100, 0, 1), c(101, 0, 1), c(101, 1, 1),
#'   c(100, 0, 1))
#' linestring(line, fmt=2)
#' linestring(line, fmt=2, third = "m")
#' ## 4D
#' line <- list(c(100, 0, 1, 40), c(101, 0, 1, 44), c(101, 1, 1, 45),
#'   c(100, 0, 1, 49))
#' linestring(line, fmt=2)
linestring <- function(..., fmt = 16, third = "z") {
  UseMethod("linestring")
}

#' @export
linestring.character <- function(..., fmt = 16, third = "z") {
  pts <- list(...)
  if (grepl("empty", pts[[1]], ignore.case = TRUE)) {
    return('LINESTRING EMPTY')
  } else {
    check_str(pts)
  }
}

#' @export
linestring.numeric <- function(..., fmt = 16, third = "z") {
  pts <- list(...)
  fmtcheck(fmt)
  invisible(lapply(pts, checker, type = 'LINESTRING', len = 2:4))
  str <- paste0(lapply(pts, function(z){
    paste0(gsub("\\s", "", format(z, nsmall = fmt, trim = TRUE)),
           collapse = " ")
  }), collapse = ", ")
  len <- unique(vapply(pts, length, numeric(1)))
  make_linestring(str, len, third)
}

#' @export
linestring.data.frame <- function(..., fmt = 16, third = "z") {
  pts <- list(...)
  fmtcheck(fmt)
  str <- paste0(apply(pts[[1]], 1, function(x)
    paste0(format(x, nsmall = fmt, trim = TRUE), collapse = " ")),
    collapse = ", ")
  len <- unique(vapply(pts, length, numeric(1)))
  make_linestring(str, len, third)
}

#' @export
linestring.matrix <- function(..., fmt = 16, third = "z") {
  pts <- list(...)
  fmtcheck(fmt)
  str <- paste0(apply(pts[[1]], 1, function(x)
    paste0(format(x, nsmall = fmt, trim = TRUE), collapse = " ")),
    collapse = ", ")
  len <- unique(vapply(pts[[1]], length, numeric(1)))
  make_linestring(str, len, third)
}

#' @export
linestring.list <- function(..., fmt = 16, third = "z") {
  pts <- list(...)[[1]]
  fmtcheck(fmt)
  str <- paste0(lapply(pts, function(z){
    paste0(gsub("\\s", "", format(z, nsmall = fmt, trim = TRUE)),
           collapse = " ")
  }), collapse = ", ")
  len <- unique(vapply(pts, length, numeric(1)))
  make_linestring(str, len, third)
}

# helpers -----
make_linestring <- function(str, len, third) {
  if (len == 3) {
    sprintf('LINESTRING %s(%s)', pick3(third), str)
  } else if (len == 4) {
    sprintf('LINESTRING ZM(%s)', str)
  } else {
    sprintf('LINESTRING (%s)', str)
  }
}

