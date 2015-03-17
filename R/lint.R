#' Validate WKT strings
#'
#' @export
#' @param str A WKT string
#' @return A logical (\code{TRUE} or \code{FALSE})
#' @examples
#' lint("POINT (1 2)")
#' lint("POINT (1 2 3)")
#' lint("LINESTRING EMPTY")
#' lint("LINESTRING (100 0, 101 1)")
#' lint("MULTIPOINT EMPTY")
#' lint("MULTIPOINT ((1 2), (3 4))")
#' lint("MULTIPOINT ((1 2), (3 4), (-10 100))")
#' lint("POLYGON ((1 2, 3 4, 0 5, 1 2))")
#' lint("POLYGON((20.3 28.6, 20.3 19.6, 8.5 19.6, 8.5 28.6, 20.3 28.6))")
lint <- function(str) {
  type <- get_type(str, ignore_case = TRUE)
  str <- str_trim_(gsub(toupper(type), "", str))
  rule <- switch(type,
                 Point = rule_point,
                 Linestring = rule_linestring,
                 Multipoint = rule_multipoint,
                 Polygon = rule_polygon)
  grepl(coll(rule), str)
}

# collapse rules into one string
coll <- function(x) paste0(x, collapse = "")

# put rules in vector separated by OR's
vor <- function(...) {
  rlz <- list(...)
  unlist(Map(function(x,y) c(x,y), rlz, c(rep("|", length(rlz)-1), "") ))
}

# make a string a repeat pattern
repeat_ <- function(x) sprintf("(%s)*", coll(x))

# short-hand nouns
number <- "[+-]?(\\d*\\.)?\\d+"
space <- "\\s"
spaceif <- "\\s?"
comma <- ","
lp <- "^\\("
lp_ <- "\\("
rp <- "\\)$"
rp_ <- "\\)"
empty <- "^EMPTY$"
pt <- c(number, space, number)
pt3 <- c(number, space, number, space, number)
commapt <- c(comma, spaceif, pt)
multipt <- c(lp_, pt, rp_)
linestr <- c(lp_, pt, repeat_(commapt), rp_)
commamultipt <- c(comma, spaceif, multipt)
commalinestr <- c(comma, spaceif, linestr)
commapt3 <- c(comma, spaceif, pt3)

# point rules
rule_point_empty <- empty
rule_point_2d <- c(lp, pt, rp)
rule_point_3d <- c(lp, number, space, number, space, number, rp)
rule_point_4d <- c(lp, number, space, number, space, number, space, number, rp)
rule_point <- vor(rule_point_empty, rule_point_2d, rule_point_3d, rule_point_4d)

# linestring rules
rule_linestring_empty <- empty
rule_linestring_2d <- c(lp, pt, repeat_(commapt), rp)
rule_linestring_3d <- c(lp, pt3, repeat_(commapt3), rp)
rule_linestring <- vor(rule_linestring_empty, rule_linestring_2d, rule_linestring_3d)

# multipoint rules
rule_multipoint_empty <- empty
rule_multipoint_2d <- c(lp, multipt, repeat_(commamultipt), rp)
rule_multipoint <- vor(rule_multipoint_empty, rule_multipoint_2d)

# polygon rules
rule_polygon_empty <- empty
rule_polygon_2d <- c(lp, linestr, repeat_(commalinestr), rp)
rule_polygon <- vor(rule_polygon_empty, rule_polygon_2d)
