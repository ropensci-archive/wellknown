# capitalize words
cw <- function(s, strict = FALSE, onlyfirst = FALSE) {
  cap <- function(s) paste(toupper(substring(s,1,1)),
        {s <- substring(s,2); if(strict) tolower(s) else s}, sep = "", collapse = " " )
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
  if(length(x) != len)
    stop(sprintf("%s input should be of length %s", type, len), call. = FALSE)
  if(!is.double(x))
    stop(sprintf("%s input should be of type double (a number)", type), call. = FALSE)
}

fmtcheck <- function(x) {
  if(!is.double(x) || is.na(x)) stop("fmt must be an integer value", call. = FALSE)
  if(x < 0 || x > 20) stop("fmt must be 0 and 20", call. = FALSE)
}

# decfmt <- function(pts, fmt) {
#   rapply(pts, format, nsmall = fmt, trim = TRUE, how = "list")
# }
