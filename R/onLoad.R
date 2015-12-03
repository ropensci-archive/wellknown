#' @importFrom V8 new_context
sh <- NULL
.onLoad <- function(libname, pkgname){
  sh <<- new_context();
  sh$source(system.file("js/wkx.js", package = pkgname))
  sh$source(system.file("js/buffer.js", package = pkgname))
}
