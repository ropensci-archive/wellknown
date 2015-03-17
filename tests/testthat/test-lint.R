context("lint")

test_that("lint works for valid WKT strings - points", {
  # good
  expect_true(lint("POINT (1 2)"))
  expect_true(lint("POINT (1 2 3)"))
  expect_true(lint("POINT (1 2 3 4)"))
  expect_true(lint("POINT EMPTY"))
})

test_that("lint works for invalid WKT strings - points", {
  # bad
  expect_false(lint("POINT (1 2 3 4 5)"))
  expect_false(lint("POINT (1 a)"))
  expect_false(lint("POINT (1 )"))
  expect_false(lint("POINT (1)"))
  expect_false(lint("POINT ()"))
  expect_false(lint("POINT "))
  expect_false(lint("POINT empty"))
  expect_false(lint("POINT emp"))
  expect_false(lint("POINT12"))
  expect_false(lint("point (1 2)"))
})

test_that("lint works for valid WKT strings - linestring", {
  # good
  expect_true(lint("LINESTRING EMPTY"))
  expect_true(lint("LINESTRING (100 0, 101 1)"))
  expect_true(lint("LINESTRING (100 0, 101 1, 4 6)"))
  expect_true(lint("LINESTRING (100 0,101 1,4 6)"))
  expect_true(lint("LINESTRING(100 0,101 1,4 6)"))
  expect_true(lint("LINESTRING (100 0, 101 1, 4 6, 4 5, 23434343 45454545)"))
  expect_true(lint("LINESTRING (100 3 4)"))
  expect_true(lint("LINESTRING (100 3 4.454545)"))
  expect_true(lint("LINESTRING (100 3.23434343 0)"))
  expect_true(lint("LINESTRING(7.127130925655365 44.872856971822685,50.545099675655365 42.5869135116598,31.560724675655365 33.02876067050816,42.986505925655365 24.408955129015624,24.002130925655365 22.311272019147477,34.724787175655365 14.308903161964137,15.037287175655365 14.649299083976166,19.431818425655365 6.535627729378449,3.084162175655365 13.113523650016484,4.666193425655365 0.7490445384366899,-7.638494074344635 11.223467666031517,-14.845525324344635 -2.5898954605716416,-20.470525324344635 11.912306151187774,-27.150212824344635 -1.1844435030433105,-29.435369074344635 18.68976902906233,-16.251775324344635 17.687796432467547,-22.579900324344635 26.472359363941862,-10.978337824344635 25.999343543885978,-19.240056574344635 31.3928609826332,-3.595525324344635 29.72795526109783,-10.978337824344635 36.21043323531069,3.963068425655365 33.76254102463172,-1.661931574344635 39.81006899259359)"))
})

test_that("lint works for valid WKT strings - linestring", {
  # bad
  expect_false(lint("LINESTRING (100 3 4 5)"))
  expect_false(lint("LINESTRING (100 3 4 5 7)"))
  expect_false(lint("LINESTRING (100 adf)"))
  expect_false(lint("LINESTRING (100)"))
  expect_false(lint("LINESTRING ()"))
  expect_false(lint("LINESTRING "))
  expect_false(lint("LINESTRING ("))
  expect_false(lint("LINESTRING )"))
  expect_false(lint("LINESTRING"))
  expect_false(lint("LINESTRING (100 4, 1)"))
  expect_false(lint("LINESTRING (100 4, 1 ad)"))
  expect_false(lint("LINESTRING (100 4, 1, 1)"))
  expect_false(lint("linestring (1 2)"))
  expect_false(lint("Linestring (1 2)"))
  expect_false(lint("LineString (1 2)"))
})
