library(wellknown)

# context("Test sp convert")
# test_that("sp_convert works", {
#   # library(sp)
#   # s1 <- SpatialPolygons(list(Polygons(list(Polygon(cbind(c(2,4,4,1,2),c(2,3,5,4,2)))), "s1")))
#   # save(s1, file = "tests/othertests/sp_convert1.rda") 
#   # load("tests/othertests/sp_convert1.rda")
  
#   load("sp_convert1.rda")
#   x <- sp_convert(s1)

#   expect_length(x, 1)
#   expect_is(x, "character")
#   expect_match(x, "POLYGON\\(\\(2 2,1 4,4 5,4 3,2 2\\)\\)")
# })

context("Test sf convert")
test_that("sf_convert works", {
  # library(sp)
  # library(sf)
  # tmp <- SpatialPolygons(list(Polygons(list(Polygon(cbind(c(2,4,4,1,2),c(2,3,5,4,2)))), "s1")))
  # s2 <- st_as_sf(tmp)
  # save(s2, file = "tests/othertests/sf_convert1.rda") 
  # load("tests/othertests/sf_convert1.rda")
  
  load("sf_convert1.rda")
  x <- sf_convert(s2)

  expect_length(x, 1)
  expect_is(x, "character")
  expect_match(x, "POLYGON \\(\\(2 2, 1 4, 4 5, 4 3, 2 2\\)\\)")

  # library(sp)
  # library(sf)
  # library(silicate)
  # s3 <- sfzoo$multipolygon
  # save(s3, file = "tests/othertests/sf_convert2.rda") 
  load("tests/othertests/sf_convert2.rda")

  load("sf_convert2.rda")
  x <- sf::st_sfc(s3)
  z <- sf_convert(x)
  # st_as_text(z)

  expect_length(z, 1)
  expect_is(z, "character")
})
