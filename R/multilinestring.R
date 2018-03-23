#' Make WKT multilinestring objects
#'
#' @export
#'
#' @template fmt
#' @inheritParams point
#' @details There is no `numeric` input option for multilinestring.
#' There is no way as of yet to make a nested multilinestring with
#' `data.frame` input, but you can do so with list input. See examples.
#' @family R-objects
#' @examples
#' ## empty multilinestring
#' multilinestring("empty")
#' # multilinestring("stuff")
#'
#' # character string
#' x <- "MULTILINESTRING ((30 20, 45 40, 10 40), (15 5, 40 10, 10 20))"
#' multilinestring(x)
#'
#' # data.frame
#' df <- data.frame(long = c(30, 45, 10), lat = c(20, 40, 40))
#' df2 <- data.frame(long = c(15, 40, 10), lat = c(5, 10, 20))
#' multilinestring(df, df2, fmt=0)
#' multilinestring(df, df2, fmt=0) %>% lint
#' multilinestring(df, df2) %>% wktview(zoom=3)
#'
#' # matrix
#' mat <- matrix(c(df$long, df$lat), ncol = 2)
#' mat2 <- matrix(c(df2$long, df2$lat), ncol = 2)
#' multilinestring(mat, mat2, fmt=0)
#'
#' # list
#' x1 <- list(c(30, 20), c(45, 40), c(10, 40))
#' x2 <- list(c(15, 5), c(40, 10), c(10, 20))
#' multilinestring(x1, x2, fmt=2)
#'
#' polys <- list(
#'   list(c(30, 20), c(45, 40), c(10, 40)),
#'   list(c(15, 5), c(40, 10), c(10, 20))
#' )
#' multilinestring(polys, fmt=2) %>%
#'   wktview(zoom=3)
#' 
#' # 3D
#' ## data.frame
#' df <- data.frame(long = c(30, 45, 10), lat = c(20, 40, 40), altitude = 1:3)
#' df2 <- data.frame(long = c(15, 40, 10), lat = c(5, 10, 20), altitude = 1:3)
#' multilinestring(df, df2, fmt=0)
#' multilinestring(df, df2, fmt=0, third = "m")
#' ## matrix
#' mat <- matrix(unname(unlist(df)), ncol = 3)
#' mat2 <- matrix(unname(unlist(df2)), ncol = 3)
#' multilinestring(mat, mat2, fmt=0)
#' multilinestring(mat, mat2, fmt=0, third = "m")
#' ## list
#' x1 <- list(c(30, 20, 1), c(45, 40, 1), c(10, 40, 1))
#' x2 <- list(c(15, 5, 0), c(40, 10, 3), c(10, 20, 4))
#' multilinestring(x1, x2, fmt=2)
#' multilinestring(x1, x2, fmt=2, third = "m")
#' 
#' 
#' # 4D
#' ## data.frame
#' df <- data.frame(long = c(30, 45, 10), lat = c(20, 40, 40), 
#'   altitude = 1:3, weight = 4:6)
#' df2 <- data.frame(long = c(15, 40, 10), lat = c(5, 10, 20), 
#'   altitude = 1:3, weight = 4:6)
#' multilinestring(df, df2, fmt=0)
#' ## matrix
#' mat <- matrix(unname(unlist(df)), ncol = 4)
#' mat2 <- matrix(unname(unlist(df2)), ncol = 4)
#' multilinestring(mat, mat2, fmt=0)
#' ## list
#' x1 <- list(c(30, 20, 1, 40), c(45, 40, 1, 40), c(10, 40, 1, 40))
#' x2 <- list(c(15, 5, 0, 40), c(40, 10, 3, 40), c(10, 20, 4, 40))
#' multilinestring(x1, x2, fmt=2)
multilinestring <- function(..., fmt = 16, third = "z") {
  UseMethod("multilinestring")
}

#' @export
multilinestring.character <- function(..., fmt = 16, third = "z") {
  pts <- list(...)
  if (grepl("empty", pts[[1]], ignore.case = TRUE)) {
    return('MULTILINESTRING EMPTY')
  } else {
    check_str(pts)
  }
}

#' @export
multilinestring.data.frame <- function(..., fmt = 16, third = "z") {
  pts <- list(...)
  fmtcheck(fmt)
  str <- lapply(pts, function(v) {
    sprintf("(%s)", paste0(apply(v, 1, function(z){
      p0c(str_trim_(format(z, nsmall = fmt, trim = TRUE)))
    }), collapse = ", "))
  })
  len <- unique(vapply(pts, NCOL, numeric(1)))
  sprint_multil(str, len, third)
}

#' @export
multilinestring.matrix <- function(..., fmt = 16, third = "z") {
  pts <- list(...)
  fmtcheck(fmt)
  str <- lapply(pts, function(v) {
    sprintf("(%s)", paste0(apply(v, 1, function(z){
      p0c(str_trim_(format(z, nsmall = fmt, trim = TRUE)))
    }), collapse = ", "))
  })
  len <- unique(vapply(pts, NCOL, numeric(1)))
  sprint_multil(str, len, third)
}

#' @export
multilinestring.list <- function(..., fmt = 16, third = "z") {
  pts <- list(...)
  fmtcheck(fmt)
  pts <- un_nest(pts)
  str <- lapply(pts, function(z) {
    if (length(z) > 1 && sapply(z, class)[1] != "numeric") {
      inparens(paste0(lapply(z, make1multipoly, fmt = fmt), collapse = ", "))
    } else {
      make1multilinestr(z, fmt)
    }
  })
  len <- unique(vapply(pts, function(z) unique(vapply(z, length, numeric(1))), 
    numeric(1)))
  sprint_multil(str, len, third)
}


# helpers ---------
sprint_multil <- function(x, len, third) {
  if (len == 3) {
    sprintf('MULTILINESTRING %s(%s)', pick3(third), paste0(x, collapse = ", "))
  } else if (len == 4) {
    sprintf('MULTILINESTRING ZM(%s)', paste0(x, collapse = ", "))
  } else {
    sprintf('MULTILINESTRING (%s)', paste0(x, collapse = ", "))
  }
}

sprint <- function(type, str) {
  sprintf('%s (%s)', type, str)
}

make1multilinestr <- function(m, fmt) {
  inparens(paste0(lapply(m, function(b) {
      paste0(str_trim_(format(b, nsmall = fmt, trim = TRUE)), collapse = " ")
    }), collapse = ", ")
  )
}
