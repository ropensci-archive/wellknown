test_that("bounding_wkt: Individual values can be turned into a bounding box", {
  result <- bounding_wkt(10, 12, 14, 16)
  expect_equal(result, "POLYGON((10 12,10 16,14 16,14 12,10 12))")
  expect_length(result, 1)
  expect_type(result, "character")
})

test_that("Listed values can be turned into a bounding box", {
  result <- bounding_wkt(values = list(c(10, 12, 14, 16)))
  expect_equal(result, "POLYGON((10 12,10 16,14 16,14 12,10 12))")
  expect_length(result, 1)
  expect_type(result, "character")
})

test_that("Individual value bounding-box generation handles NAs", {
  result <- bounding_wkt(10, NA_complex_, 14, 16)
  expect_length(result, 1)
  expect_type(result, "character")
  expect_true(is.na(result))
})

test_that("Listed value bounding-box generation handles NAs", {
  result <- bounding_wkt(values = list(c(NA_complex_, 12, 14, 16)))
  expect_length(result, 1)
  expect_type(result, "character")
  expect_true(is.na(result))
})

test_that("wkt_bounding: WKT objects can be turned into data.frames of bounding boxes", {
  result <- wkt_bounding("POLYGON ((30 10, 40 40, 20 40, 10 20, 30 10))")
  expect_length(result, 4)
  expect_type(result, "list")
  expect_true(is.data.frame(result))
})

test_that("WKT objects can be turned into matrices of bounding boxes", {
  result <- wkt_bounding("POLYGON ((30 10, 40 40, 20 40, 10 20, 30 10))", TRUE)
  expect_length(result, 4)
  expect_type(result, "double")
  expect_true(is.matrix(result))
})

test_that("Invalid or NA WKT objects are handled in data.frames", {
  result <- wkt_bounding(c(NA_character_, "akfmsldgkmflkg"))
  expect_length(result, 4)
  expect_type(result, "list")
  expect_true(is.data.frame(result))
  expect_true(all(is.na(result)))
})

test_that("Invalid or NA WKT objects are handled in matrices", {
  result <- wkt_bounding(c(NA_character_, "akfmsldgkmflkg"), TRUE)
  expect_length(result, 8)
  expect_type(result, "double")
  expect_true(is.matrix(result))
  expect_true(all(is.na(result)))
})
