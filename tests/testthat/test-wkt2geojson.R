context("wkt2geojson")

test_that("convert point works", {
  point <- "POINT (116.4000000000000057 45.2000000000000028)"
  a <- wkt2geojson(point, fmt = 1)
  expect_is(a, "geojson")
  expect_that(typeof(a), equals("list"))
  expect_match(a$geometry$type, "Point")
  expect_equal(unclass(a), list(type="Feature", geometry=list('type' = 'Point', 'coordinates' = c(116.4, 45.2))))
})

test_that("convert multipoint works", {
  mp <- "MULTIPOINT ((100.0000000000000000 3.1010000000000000), (101.0000000000000000 2.1000000000000001), (3.1400000000000001 2.1800000000000002))"
  b <- wkt2geojson(mp, fmt = 2)
  expect_is(b, "geojson")
  expect_that(typeof(b), equals("list"))
  expect_match(b$geometry$type, "MultiPoint")
  expect_equal(unclass(b),
               list(
                 type = "Feature",
                 geometry = list(
                   type = 'MultiPoint',
                   coordinates = matrix(c(100.00, 101.00, 3.14, 3.101, 2.100, 2.180), ncol = 2)
                 )
               )
  )
})

test_that("convert linestring works", {
  #st <- "LINESTRING (0 0 10, 2 1 20, 4 2 30, 5 4 40)"
  st <- "LINESTRING (0 0, 2 1, 4 2, 5 4)"
  c <- wkt2geojson(st, fmt = 1)
  expect_is(c, "geojson")
  expect_that(typeof(c), equals("list"))
  expect_match(c$geometry$type, "LineString")
  expect_equal(unclass(c),
               list(
                 type = "Feature",
                 geometry = list(
                   type = 'LineString',
                   coordinates = matrix(c(0, 2, 4, 5, 0, 1, 2, 4), ncol = 2)
                 )
               )
  )
})


test_that("convert polygon works", {
  poly <- "POLYGON ((100 1, 104 2, 101 3, 100 1), (100 1, 103 2, 101 5, 100 1))"
  tomatch <- list(
    type = "Feature",
    geometry = list(
      type = 'Polygon',
      coordinates = list(
        matrix(c(100, 104, 101, 100, 1, 2, 3, 1),
           ncol = 2),
        matrix(c(100, 103, 101, 100, 1, 2, 5, 1),
           ncol = 2)
      )
    )
  )
  e <- wkt2geojson(poly, fmt = 0)
  expect_is(e, "geojson")
  expect_equal(typeof(e), "list")
  expect_equal(typeof(e), "list")
  expect_match(e$geometry$type, "Polygon")
  expect_equal(unclass(e), tomatch)
})

test_that("errors in wkt specification handled correctly", {
  # no spacing between wkt type and coords is okay
  expect_is(wkt2geojson("POINT(116.4000000000000057 45.2000000000000028)"), "geojson")
  # space after coordinates and parentheses is okay
  expect_is(wkt2geojson("POINT(116.4000000000000057 45.2000000000000028)  "), "geojson")
  # space between coordinates is okay
  expect_is(wkt2geojson("POINT(116.4000000000000057      45.2000000000000028)"), "geojson")
  # no space between coordiantes is not okay
  expect_error(wkt2geojson("POIN(116.400000000000005745.2000000000000028"), "EXPR must be a length 1 vector")
  # mis-spelled wkt type is NOT okay
  expect_error(wkt2geojson("POIN(116.4000000000000057 45.2000000000000028"), "EXPR must be a length 1 vector")
  # no spacing between wkt type and coords is okay
  ## 3D examples
  expect_is(wkt2geojson("LINESTRING(0 0 10, 2 1 20, 4 2 30, 5 4 40)"), "geojson")
  # no spacing between wkt type and coords is okay
  ## 3D examples
  expect_is(wkt2geojson("LINESTRING(0 0 10, 2 1 20, 4 2 30, 5 4 40)"), "geojson")
})

test_that("case no longer matters for WKT feature types", {
  # lower case wkt type used to NOT be okay, as of 2016-06-02 works
  expect_is(wkt2geojson("point (116.4000000000000057 45.2000000000000028"), "geojson")
  expect_is(wkt2geojson("Point (116.4000000000000057 45.2000000000000028"), "geojson")
  expect_is(wkt2geojson("poInt (116.4000000000000057 45.2000000000000028"), "geojson")
})

test_that("test simplify parameter", {
  # multipoint
  aa <- wkt2geojson("MULTIPOINT ((100 3))", simplify = FALSE)
  bb <- wkt2geojson("MULTIPOINT ((100 3))", simplify = TRUE)

  expect_is(aa, "geojson")
  expect_is(unclass(aa), "list")
  expect_is(bb, "geojson")
  expect_is(unclass(bb), "list")

  expect_equal(aa$type, "Feature")
  expect_equal(aa$geometry$type, "MultiPoint")
  expect_equal(bb$type, "Feature")
  expect_equal(bb$geometry$type, "Point")

  # multipolygon
  str <- "MULTIPOLYGON (((40 40, 20 45, 45 30, 40 40)))"
  aa <- wkt2geojson(str, simplify = FALSE)
  bb <- wkt2geojson(str, simplify = TRUE)

  expect_is(aa, "geojson")
  expect_is(unclass(aa), "list")
  expect_is(bb, "geojson")
  expect_is(unclass(bb), "list")

  expect_equal(aa$type, "Feature")
  expect_equal(aa$geometry$type, "MultiPolygon")
  expect_equal(bb$type, "Feature")
  expect_equal(bb$geometry$type, "Polygon")

  # multilinestring
  aa <- wkt2geojson("MULTILINESTRING ((30 1, 40 30, 50 20))", simplify = FALSE)
  bb <- wkt2geojson("MULTILINESTRING ((30 1, 40 30, 50 20))", simplify = TRUE)

  expect_is(aa, "geojson")
  expect_is(unclass(aa), "list")
  expect_is(bb, "geojson")
  expect_is(unclass(bb), "list")

  expect_equal(aa$type, "Feature")
  expect_equal(aa$geometry$type, "MultiLineString")
  expect_equal(bb$type, "Feature")
  expect_equal(bb$geometry$type, "LineString")
})
