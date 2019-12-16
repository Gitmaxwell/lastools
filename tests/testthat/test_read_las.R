library(lastools)

test_that("read extdata/example.las and verify version is '2'", {
  las = read_las(system.file("extdata", "example.las", package = "lastools"))
  expect_equal(las$VERSION, 2)
})

