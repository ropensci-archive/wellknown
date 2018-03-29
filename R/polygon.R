#' Make WKT polygon objects
#'
#' @export
#'
#' @template fmt
#' @inheritParams point
#' @details You can create nested polygons with `list` and
#' `data.frame` inputs, but not from `numeric` inputs. See examples.
#' @family R-objects
#' @examples
#' ## empty polygon
#' polygon("empty")
#' # polygon("stuff")
#'
#' # numeric
#' polygon(c(100.001, 0.001), c(101.12345, 0.001), c(101.001, 1.001),
#'   c(100.001, 0.001), fmt=2)
#'
#' # data.frame
#' ## single polygon
#' df <- us_cities[2:5,c('long','lat')]
#' df <- rbind(df, df[1,])
#' wktview(polygon(df, fmt=2), zoom=4)
#' ## nested polygons
#' df2 <- data.frame(long = c(-85.9, -85.9, -93, -93, -85.9),
#'                   lat = c(37.5, 35.3, 35.3, 37.5, 37.5))
#' wktview(polygon(df, df2, fmt=2), zoom=4)
#'
#' # matrix
#' mat <- matrix(c(df$long, df$lat), ncol = 2)
#' polygon(mat)
#'
#' # list
#' # single list - creates single polygon
#' ply <- list(c(100.001, 0.001), c(101.12345, 0.001), c(101.001, 1.001),
#'   c(100.001, 0.001))
#' wktview(polygon(ply, fmt=2), zoom=7)
#' # nested list - creates nested polygon
#' vv <- polygon(list(c(35, 10), c(45, 45), c(15, 40), c(10, 20), c(35, 10)),
#'    list(c(20, 30), c(35, 35), c(30, 20), c(20, 30)), fmt=2)
#' wktview(vv, zoom=3)
#' # multiple lists nested within a list
#' zz <- polygon(list(list(c(35, 10), c(45, 45), c(15, 40), c(10, 20), c(35, 10)),
#'    list(c(20, 30), c(35, 35), c(30, 20), c(20, 30))), fmt=2)
#' wktview(zz, zoom=3)
#' 
#' 
#' ## a 3rd point is included
#' ### numeric
#' polygon(c(100, 0, 30), c(101, 0, 30), c(101, 1, 30),
#'   c(100, 0, 30), fmt = 2)
#' polygon(c(100, 0, 30), c(101, 0, 30), c(101, 1, 30),
#'   c(100, 0, 30), fmt = 2, third = "m")
#' 
#' ### data.frame
#' df <- us_cities[2:5, c('long','lat')]
#' df <- rbind(df, df[1,])
#' df$altitude <- round(runif(NROW(df), 10, 50))
#' polygon(df, fmt=2)
#' polygon(df, fmt=2, third = "m")
#' 
#' ### matrix
#' mat <- matrix(c(df$long, df$lat, df$altitude), ncol = 3)
#' polygon(mat, fmt=2)
#' polygon(mat, fmt=2, third = "m")
#' 
#' ### list
#' ply <- list(c(100, 0, 1), c(101, 0, 1), c(101, 1, 1),
#'   c(100, 0, 1))
#' polygon(ply, fmt=2)
#' polygon(ply, fmt=2, third = "m")
#' 
#' 
#' ## a 4th point is included
#' ### numeric
#' polygon(c(100, 0, 30, 3.5), c(101, 0, 30, 3.5), c(101, 1, 30, 3.5),
#'   c(100, 0, 30, 3.5), fmt = 2)
#' 
#' ### data.frame
#' df <- us_cities[2:5, c('long','lat')]
#' df <- rbind(df, df[1,])
#' df$altitude <- round(runif(NROW(df), 10, 50))
#' df$weight <- round(runif(NROW(df), 0, 1), 1)
#' polygon(df, fmt=2)
#' 
#' ### matrix
#' mat <- matrix(unname(unlist(df)), ncol = 4)
#' polygon(mat, fmt=2)
#' 
#' ### list
#' ply <- list(c(100, 0, 1, 40), c(101, 0, 1, 44), c(101, 1, 1, 45),
#'   c(100, 0, 1, 49))
#' polygon(ply, fmt=2)
polygon <- function(..., fmt = 16, third = "z") {
  UseMethod("polygon")
}

#' @export
polygon.character <- function(..., fmt = 16, third = "z") {
  pts <- list(...)
  if (grepl("empty", pts[[1]], ignore.case = TRUE)) {
    return('POLYGON EMPTY')
  } else {
    check_str(pts)
  }
}

#' @export
polygon.numeric <- function(..., fmt = 16, third = "z") {
  pts <- list(...)
  fmtcheck(fmt)
  invisible(lapply(pts, checker, type = 'POLYGON', len = 2:4))
  str <- paste0(lapply(pts, function(z){
    paste0(str_trim_(format(z, nsmall = fmt, trim = TRUE)), collapse = " ")
  }), collapse = ", ")
  len <- unique(vapply(pts, length, numeric(1)))
  if (len == 3) {
    sprintf('POLYGON %s((%s))', pick3(third), str)
  } else if (len == 4) {
    sprintf('POLYGON ZM((%s))', str)
  } else {
    sprintf('POLYGON ((%s))', str)
  }
}

#' @export
polygon.data.frame <- function(..., fmt = 16, third = "z") {
  pts <- list(...)
  fmtcheck(fmt)
  # invisible(lapply(pts, checker, type='POLYGON', len=2:4))
  str <- lapply(pts, function(v) {
    sprintf("(%s)", paste0(apply(v, 1, function(z){
      paste0(str_trim_(format(z, nsmall = fmt, trim = TRUE)), collapse = " ")
    }), collapse = ", "))
  })
  len <- unique(vapply(pts, NCOL, numeric(1)))
  make_poly(str, len, third)
}

#' @export
polygon.matrix <- function(..., fmt = 16, third = "z") {
  pts <- list(...)
  fmtcheck(fmt)
  # invisible(lapply(pts, checker, type='POLYGON', len=2:4))
  str <- lapply(pts, function(v) {
    sprintf("(%s)", paste0(apply(v, 1, function(z){
      paste0(str_trim_(format(z, nsmall = fmt, trim = TRUE)), collapse = " ")
    }), collapse = ", "))
  })
  len <- unique(vapply(pts, NCOL, numeric(1)))
  make_poly(str, len, third)
}

#' @export
polygon.list <- function(..., fmt = 16, third = "z") {
  pts <- list(...)
  fmtcheck(fmt)
  # invisible(lapply(pts, checker, type='POLYGON', len=2:4))
  pts <- un_nest(pts)
  str <- sprintf("(%s)", lapply(pts, function(z) {
    paste0(lapply(z, function(b)
      paste0(str_trim_(format(b, nsmall = fmt, trim = TRUE)), collapse = " ")),
      collapse = ", ")
  }))
  len <- unique(vapply(pts[[1]], length, numeric(1)))
  make_poly(str, len, third)
}


# helpers -----
un_nest <- function(x) {
  first <- sapply(x, class)
  if (length(first) == 1 && first == "list") {
    if (sapply(x[[1]], class)[1] == "list") {
      unlist(x, recursive = FALSE)
    } else {
      return(x)
    }
  } else {
    return(x)
  }
}

make_poly <- function(str, len, third) {
  if (len == 3) {
    sprintf('POLYGON %s(%s)', pick3(third), paste0(str, collapse = ", "))
  } else if (len == 4) {
    sprintf('POLYGON ZM(%s)', paste0(str, collapse = ", "))
  } else {
    sprintf('POLYGON (%s)', paste0(str, collapse = ", "))
  }   
}
