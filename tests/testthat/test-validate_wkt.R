test_that("Individual types are supported", {
  result <- validate_wkt(c("GEOMETRYCOLLECTION(POINT(4 6),LINESTRING(4 6,7 10))",
                           "POINT (30 10)",
                           "LINESTRING (30 10, 10 30, 40 40)",
                           "POLYGON ((30 10, 40 40, 20 40, 10 20, 30 10))",
                           "POLYGON ((35 10, 45 45, 15 40, 10 20, 35 10),(20 30, 35 35, 30 20, 20 30))",
                           "MULTIPOINT ((10 40), (40 30), (20 20), (30 10))",
                           "MULTIPOINT (10 40, 40 30, 20 20, 30 10)",
                           "MULTILINESTRING ((10 10, 20 20, 10 40), (40 40, 30 30, 40 20, 30 10))",
                           "MULTIPOLYGON (((30 20, 45 40, 10 40, 30 20)), ((15 5, 40 10, 10 20, 5 10, 15 5)))"
                         ))

  expect_length(result, 2)
  expect_type(result, "list")
  expect_true(is.data.frame(result))
  expect_equal(sum(result$is_valid), 6)
})
