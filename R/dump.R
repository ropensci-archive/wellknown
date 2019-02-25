# dumpers used in geojson2wkt ------------------------------------
dump_point <- function(obj, fmt = 16, third = "z"){
  coords <- obj$coordinates
  if (!is.vector(coords) || is.list(coords)) {
    stop("expecting a vector in 'coordinates', got a ", class(coords))
  }
  str <- paste0(format(coords, nsmall = fmt), collapse = "")
  make_it('POINT', str, length(coords), third)
}

dump_multipoint <- function(obj, fmt = 16, third = "z"){
  coords <- obj$coordinates
  if (!is.matrix(coords)) {
    stop("expecting a matrix in 'coordinates', got a ", class(coords))
  }
  str <- paste0(apply(coords, 1, function(z){
    sprintf("(%s)", paste0(str_trim_(format(z, nsmall = fmt)), collapse = " "))
  }), collapse = ", ")
  make_it('MULTIPOINT', str, NCOL(coords), third)
}

dump_linestring <- function(obj, fmt = 16, third = "z"){
  coords <- obj$coordinates
  if (!is.matrix(coords)) {
    stop("expecting a matrix in 'coordinates', got a ", class(coords))
  }

  str <- paste0(apply(coords, 1, function(z){
    paste0(gsub("\\s", "", format(z, nsmall = fmt)), collapse = " ")
  }), collapse = ", ")
  make_it('LINESTRING', str, NCOL(coords), third)
}

dump_multilinestring <- function(obj, fmt = 16, third = "z"){
  coords <- obj$coordinates
  if (!is.list(coords)) {
    stop("your top most element must be a list")
  }
  if (!all(vapply(coords, is.matrix, TRUE))) {
    stop("expecting matrices for all 'coordinates' elements")
  }

  coords <- check_diff_dim(coords)
  str <- paste0(lapply(coords, function(z){
    sprintf("(%s)", paste0(gsub(",", "",
      apply(str_trim_(format(z, nsmall = fmt)),
        1, paste0, collapse = " ")),
    collapse = ", "))
  }), collapse = ", ")
  len <- unique(vapply(coords, NCOL, numeric(1)))
  make_it('MULTILINESTRING', str, len, third)
}

dump_polygon <- function(obj, fmt = 16, third = "z"){
  coords <- obj$coordinates
  if (!is.list(coords)) {
    stop("your top most element must be a list")
  }
  if (!all(vapply(coords, is.matrix, TRUE))) {
    stop("expecting matrices for all 'coordinates' elements")
  }

  coords <- check_diff_dim(coords)
  str <- paste0(lapply(coords, function(z){
    sprintf("(%s)", paste0(apply(z, 1, function(w){
      paste0(gsub("\\s", "", format(w, nsmall = fmt)), collapse = " ")
    }), collapse = ", "))
  }), collapse = ", ")
  len <- unique(vapply(coords, NCOL, numeric(1)))
  make_it('POLYGON', str, len, third)
}

dump_multipolygon <- function(obj, fmt = 16, third = "z"){
  coords <- obj$coordinates
  if (!is.list(coords)) {
    stop("your top most element must be a list")
  }
  if (!all(vapply(coords, is.list, TRUE))) {
    stop("one or more of your secondary elements is not a list")
  }
  if (!all(vapply(coords, function(z) is.matrix(z[[1]]), TRUE))) {
    stop("one or more of your rings is not a matrix")
  }

  coords <- check_diff_dim_multi(coords)
  str <- paste0(lapply(coords, function(z) {
    sprintf("(%s)", paste0(sprintf("(%s)", lapply(z, function(w){
      paste0(gsub(",", "", unname(apply(str_trim_(format(w, nsmall = fmt)), 1, paste0, collapse = " "))), collapse = ", ")
    })), collapse = ", "))
  }), collapse = ", ")
  len <- unique(vapply(coords, function(z) unique(vapply(z, NCOL, numeric(1))),
    numeric(1)))
  make_it('MULTIPOLYGON', str, len, third)
}

dump_geometrycollection <- function(obj, fmt = 16, third = "z"){
  geoms <- obj$geometries
  if (!is.list(geoms)) {
    stop("your top most element must be a list")
  }
  str <- paste0(lapply(geoms, function(z) {
    if (all(c('type', 'coordinates') %in% tolower(names(z)))) {
      get_fxn(tolower(z$type))(z, fmt)
    } else {
      get_fxn(tolower(names(z)))(list(coordinates = z[[1]]), fmt)
    }
  }), collapse = ", ")
  sprintf('GEOMETRYCOLLECTION (%s)', str)
}

# dump helpers ------------------
# case function to get correct dump* function
get_fxn <- function(type){
  switch(type,
         point = dump_point,
         multipoint = dump_multipoint,
         linestring = dump_linestring,
         multilinestring = dump_multilinestring,
         polygon = dump_polygon,
         multipolygon = dump_multipolygon,
         geometrycollection = dump_geometrycollection)
}

# vector of acceptable types
# some WKT types are not valid GeoJSON types so make no sense to allow
wkt_geojson_types <- c("POINT",'MULTIPOINT',"POLYGON","MULTIPOLYGON",
                     "LINESTRING","MULTILINESTRING","GEOMETRYCOLLECTION")

# make WKT string from components
make_it <- function(geom, x, len, third) {
  if (len == 3) {
    sprintf('%s %s(%s)', geom, pick3(third), x)
  } else if (len == 4) {
    sprintf('%s ZM(%s)', geom, x)
  } else {
    sprintf('%s (%s)', geom, x)
  }
}

# convert any matrices to have all same dimensionality if they differ
# - for most types
check_diff_dim <- function(coords) {
  lns <- vapply(coords, NCOL, numeric(1))
  if (any(lns > 4)) stop("only 2D, 3D, and 4D supported")
  if (length(unique(lns)) > 1) {
    to_add <- max(lns) - min(lns)
    to_fix <- coords[[which.min(lns)]]
    coords[[which.min(lns)]] <-
      cbind(to_fix, replicate(to_add, rep(0, NROW(to_fix))))
  }
  return(coords)
}

# convert any matrices to have all same dimensionality if they differ
# - for mulitpolygon's
check_diff_dim_multi <- function(coords) {
  lns_ <- lapply(coords, function(x) vapply(x, NCOL, numeric(1)))
  lns <- unlist(lns_)
  if (any(lns > 4)) stop("only 2D, 3D, and 4D supported")
  if (length(unique(lns)) > 1) {
    to_add <- max(lns) - min(lns)
    coords <- lapply(coords, function(z) {
      to_fix <- z[vapply(z, NCOL, 1) == min(lns)]
      z[vapply(z, NCOL, 1) == min(lns)] <-
       lapply(to_fix, function(w) cbind(w, replicate(to_add, rep(0, NROW(w)))))
      z
    })
  }
  return(coords)
}
