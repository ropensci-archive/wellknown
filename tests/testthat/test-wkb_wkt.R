# from point  ----------------
test_that("wkb_wkt", {
  str <- "POINT (-116.4 45.2)"
  pt1 <- wkb_wkt(wkt_wkb(str))

  expect_is(pt1, "character")
  expect_match(pt1, "POINT")
  expect_equal(wkt_wkb(pt1), wkt_wkb(str))
})

# from multipoint -----------------------------
test_that("wkb_wkt works with multipoint", {
  mpt <- multipoint(c(100, 3), c(101, 2), c(3, 2), fmt=0)
  mpt1 <- wkb_wkt(wkt_wkb(mpt))

  expect_is(mpt1, "character")
  expect_match(mpt1, "MULTIPOINT")
  expect_equal(wkt_wkb(mpt1), wkt_wkb(mpt))
})

# from polygon ----------------
test_that("wkb_wkt works with polygon input", {
  ply <- polygon(c(100, 1), c(101, 1), c(101, 1), c(100, 1), fmt = 0)
  poly1 <- wkb_wkt(wkt_wkb(ply))

  expect_is(poly1, "character")
  expect_match(poly1, "POLYGON")
  expect_equal(wkt_wkb(poly1), wkt_wkb(ply))
})

# from multipolygon  --------------------------------
test_that("wkb_wkt works with multipolygon", {
  df <- data.frame(long = c(30, 45, 10, 30), lat = c(20, 40, 40, 20))
  df2 <- data.frame(long = c(15, 40, 10, 5, 15), lat = c(5, 10, 20, 10, 5))
  mpoly <- multipolygon(df, df2, fmt = 0)
  mpoly1 <- wkb_wkt(wkt_wkb(mpoly))

  expect_is(mpoly1, "character")
  expect_match(mpoly1, "MULTIPOLYGON")
  expect_equal(wkt_wkb(mpoly1), wkt_wkb(mpoly))
})

# from linestring  ----------------
test_that("wkb_wkt works with linestring", {
  line <- linestring("LINESTRING (-116 45, -118 47)")
  line1 <- wkb_wkt(wkt_wkb(line))

  expect_is(line1, "character")
  expect_match(line1, "LINESTRING")
  expect_equal(wkt_wkb(line1), wkt_wkb(line))
})

# from multilinestring  ----------------
test_that("wkb_wkt works with multilinestring", {
  df <- data.frame(long = c(30, 45, 10), lat = c(20, 40, 40))
  df2 <- data.frame(long = c(15, 40, 10), lat = c(5, 10, 20))
  mline <- multilinestring(df, df2, fmt = 0)
  mline1 <- wkb_wkt(wkt_wkb(mline))

  expect_is(mline1, "character")
  expect_match(mline1, "MULTILINESTRING")
  expect_equal(wkt_wkb(mline1), wkt_wkb(mline))
})

test_that("wkb_wkt fails well", {
  # missing arguments
  expect_error(wkb_wkt(), "\"x\" is missing")
  # wrong type
  expect_error(wkb_wkt(5))
})
