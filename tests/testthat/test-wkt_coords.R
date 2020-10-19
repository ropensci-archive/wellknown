test_that("Coordinates can be extracted from valid polygons", {
  result <- wkt_coords("POLYGON ((30 10, 40 40, 20 40, 10 20, 30 10))")
  expect_true(is.data.frame(result))
  expect_length(result, 4)
  expect_equal(nrow(result), 5)
  expect_equal(result[1,1], 1)
  expect_equal(result[1,2], "outer")
  expect_equal(result[1,3], 30)
  expect_equal(result[1,4], 10)

})

test_that("Invalid polygons are handled correctly", {
  result <- wkt_coords("POLYGGKFDMGLFKGMON ((30 10, 40 40, 20 40, 10 20, 30 10))")
  expect_true(is.data.frame(result))
  expect_length(result, 4)
  expect_equal(nrow(result), 1)
  expect_equal(result[1,1], 1)
  expect_equal(sum(is.na(result)), 3)
})

test_that("non-objects are handled correctly", {
  result <- wkt_coords(NA_character_)
  expect_true(is.data.frame(result))
  expect_length(result, 4)
  expect_equal(nrow(result), 1)
  expect_equal(result[1,1], 1)
  expect_equal(sum(is.na(result)), 3)
})

test_that("multi-layer polygons are handled correctly", {
  p <- "POLYGON((-125 40.9, -125 38.4), (-115 22.4, -111.8 22.4))"
  result <- wkt_coords(p)
  expect_true(is.data.frame(result))
  expect_length(result, 4)
  expect_equal(nrow(result), 4)
  expect_equal(result[1,1], 1)
  expect_equal(result[3,2], "inner 1")
  expect_equal(result[3,4], 22.4)
})
