# capitalize words
cw <- function(s, strict = FALSE, onlyfirst = FALSE) {
  cap <- function(s) paste(toupper(substring(s,1,1)),
        {s <- substring(s,2); if(strict) tolower(s) else s}, sep = "", 
        collapse = " " )
  if(!onlyfirst){
    sapply(strsplit(s, split = " "), cap, USE.NAMES = !is.null(names(s)))
  } else {
    sapply(s, function(x)
      paste(toupper(substring(x,1,1)),
            tolower(substring(x,2)),
            sep="", collapse=" "), USE.NAMES=F)
  }
}

# extract pattern from a string
strextract <- function(str, pattern) regmatches(str, regexpr(pattern, str))

# trim space from beginning and end of strings
str_trim_ <- function(str) gsub("^\\s+|\\s+$", "", str)

# remove zero length strings
nozero <- function(x) {
  x[nzchar(x)]
}

checker <- function(x, type, len) {
  if (!length(x) %in% len)
    stop(sprintf("%s input should be of length %s", type, p0c(len)), 
      call. = FALSE)
  if (!is.double(x) && !is.integer(x))
    stop(sprintf("%s input should be of type double (a number)", type), 
      call. = FALSE)
}

dfchecker <- function(x, type, len) {
  if (!NCOL(x) %in% len)
    stop(sprintf("%s input should have %s columns ", type, p0c(len)), 
      call. = FALSE)

  if (any(apply(x, 2, function(x) !is.double(x) && !is.integer(x))))
    stop(sprintf("%s input should be of type double (a number)", type), 
      call. = FALSE)
}

fmtcheck <- function(x) {
  if (!is.double(x) || is.na(x)) stop("fmt must be an integer value", 
    call. = FALSE)
  if (x < 0 || x > 20) stop("fmt must be 0 and 20", call. = FALSE)
}

# decfmt <- function(pts, fmt) {
#   rapply(pts, format, nsmall = fmt, trim = TRUE, how = "list")
# }

centroid <- function(x, center){
  if (!is.null(center)) {
    stopifnot(is.numeric(center))
    return(center)
  } else {
    if ("geometry" %in% names(x)) {
      obj <- x$geometry$coordinates
      # tryasnum <- tryCatch(as.numeric(obj), warning = function(w) w)
      if (!inherits(obj, "list")) {
        obj
      } else {
        # sapply(obj, function(z) sapply(z, function(b) b[2]))
        lngs <- rapply(obj, function(x) x[1])
        # sapply(obj, function(z) sapply(z, function(b) b[1]))
        lats <- rapply(obj, function(x) x[2])
        c(mean(as.numeric(lngs)), mean(as.numeric(lats)))
      }
    } else {
      c(
        mean(as.numeric(sapply(x$coordinates, function(z) 
          sapply(z, function(b) b[2])))),
        mean(as.numeric(sapply(x$coordinates, function(z) 
          sapply(z, function(b) b[1]))))
      )
    }
  }
}

check_str <- function(x) {
  checklog <- vapply(x, lint, logical(1))
  if (!all(checklog)) {
    notwkt <- x[!checklog]
    notwkt_cs <- vapply(notwkt, class, "")
    notwkt[notwkt_cs != "character"] <- notwkt_cs[notwkt_cs != "character"]
    notwkt <- paste0(notwkt, collapse = "\n")
    stop("The following strings are not WKT:\n", notwkt, call. = FALSE)
  }
  stopifnot(length(x[[1]]) == 1)
  x[[1]]
}

chek_for_pkg <- function(x) {
  if (!requireNamespace(x, quietly = TRUE)) {
    stop("Please install ", x, call. = FALSE)
  } else {
    invisible(TRUE)
  }
}

pick3 <- function(x) {
  x <- tolower(x)
  switch(
    x,
    `m` = "M",
    `z` = "Z",
    stop("'third' must be one of 'm' or 'z'")
  )
}

# count_regex('(1 2 3) (4 5 6) (6 7 8.6)', "[0-9]+(\\.[0-9]+)?")
count_regex <- function(str, x) {
  length(gregexpr(x, str)[[1]])
}

`%||%` <- function (x, y) if (is.null(x) || length(x) == 0) y else x
