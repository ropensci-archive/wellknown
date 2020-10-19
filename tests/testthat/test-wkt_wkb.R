# from point  ----------------
test_that("wkt_wkb", {
  str <- "POINT (-116.4 45.2)"
  pt1 <- wkt_wkb(str)

  expect_is(pt1, "raw")
  expect_equal(pt1[1], as.raw("01"))
  expect_equal(wkb_wkt(pt1), str)
})

# from multipoint -----------------------------
test_that("wkt_wkb works with multipoint", {
  mpt <- multipoint(c(100, 3), c(101, 2), c(3, 2), fmt=0)
  mpt1 <- wkt_wkb(mpt)

  expect_is(mpt1, "raw")
  expect_equal(mpt1[1], as.raw("01"))
  expect_equal(wkb_wkt(mpt1), mpt)
})

# from polygon ----------------
test_that("wkt_wkb works with polygon input", {
  ply <- polygon(c(100, 1), c(101, 1), c(101, 1), c(100, 1), fmt = 0)
  poly1 <- wkt_wkb(ply)

  expect_is(poly1, "raw")
  expect_equal(poly1[1], as.raw("01"))
  expect_equal(wkb_wkt(poly1), ply)
})

# from multipolygon  --------------------------------
test_that("wkt_wkb works with multipolygon", {
  df <- data.frame(long = c(30, 45, 10, 30), lat = c(20, 40, 40, 20))
  df2 <- data.frame(long = c(15, 40, 10, 5, 15), lat = c(5, 10, 20, 10, 5))
  mpoly <- multipolygon(df, df2, fmt = 0)
  mpoly1 <- wkt_wkb(mpoly)

  expect_is(mpoly1, "raw")
  expect_equal(mpoly1[1], as.raw("01"))
  expect_equal(wkb_wkt(mpoly1), mpoly)
})

# from linestring  ----------------
test_that("wkt_wkb works with linestring", {
  line <- linestring("LINESTRING (-116 45, -118 47)")
  line1 <- wkt_wkb(line)

  expect_is(line1, "raw")
  expect_equal(line1[1], as.raw("01"))
  expect_equal(wkb_wkt(line1), line)
})

# from multilinestring  ----------------
test_that("wkt_wkb works with multilinestring", {
  df <- data.frame(long = c(30, 45, 10), lat = c(20, 40, 40))
  df2 <- data.frame(long = c(15, 40, 10), lat = c(5, 10, 20))
  mline <- multilinestring(df, df2, fmt = 0)
  mline1 <- wkt_wkb(mline)

  expect_is(mline1, "raw")
  expect_equal(mline1[1], as.raw("01"))
  expect_equal(wkb_wkt(mline1), mline)
})

test_that("wkt_wkb fails well", {
  # missing arguments
  expect_error(wkt_wkb(), "\"x\" is missing")
  # non zero string doesn't work
  expect_error(wkt_wkb(""))
  # wrong type
  expect_error(wkt_wkb(5))
  # bad character input
  expect_error(wkt_wkb("foobar"))
})
