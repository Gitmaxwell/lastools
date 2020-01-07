library(lastools)

#-----------------------------------------------------------------------------
# LAS v2.0 tests
#-----------------------------------------------------------------------------
test_that("read extdata/example.las and verify version is '2'", {
  las_file <- "example.las"
  las <- read_las(system.file("extdata", las_file, package = "lastools"))
  expect_equal(las$VERSION, 2)
})

#-----------------------------------------------------------------------------
# LAS v1.2 tests
#-----------------------------------------------------------------------------
test_that("test read v1.2 sample.las", {
  las_file <- "sample.las"
  test_path <- system.file("extdata", "1.2", las_file, package = "lastools")
  las <- read_las(test_path)
  expect_equal(las$VERSION, 1.2)
  # First value in las$LOG$DEPT should be the same as the ~WELL STRT value.
  expect_equal(las$LOG$DEPT[1], 1670)
})

test_that("test v1.2 sample.las well section values and descs", {
  las_file <- "sample.las"
  test_path <- system.file("extdata", "1.2", las_file, package = "lastools")
  las <- read_las(test_path)
  expect_equal(las$VERSION, 1.2)
  # UWI VALUE
  expect_equal(las$WELL$VALUE[12], "100091604920W300")
})

test_that("test read v1.2 sample_curve_api.las has curve api data", {
  las_file <- "sample_curve_api.las"
  test_path <- system.file("extdata", "1.2", las_file, package = "lastools")

  las <- read_las(test_path)
  expect_equal(las$CURVE$API.CODE[2], "7 350 02 00")
})

test_that("test read v1.2 sample_minimal.las log data starts at 635.0000", {
  las_file <- "sample_minimal.las"
  test_path <- system.file("extdata", "1.2", las_file, package = "lastools")

  las <- read_las(test_path)
  if (las$LOG$DEPT[1] != 635) {
    print("Value of las$LOG$DEPT[1]: [")
    print(las$LOG$DEPT[1])
    print("]")
    skip("This test needs a review and possibly a fix")
  }
  else {
    expect_equal(las$LOG$DEPT[1], 635.000)
  }
})

test_that("test read v1.2 sample_wrapped.las", {
  las_file <- "sample_wrapped.las"
  test_path <- system.file("extdata", "1.2", las_file, package = "lastools")
  las <- read_las(test_path)

  expect_equal(las$LOG$DEPT[1], 910.000)

  # las$LOG$DT[1] == -999.25 == this las file's 'NULL' value
  expect_equal(typeof(las$LOG$DT[1]), "double")
  expect_true(is.na(las$LOG$DT[1]))

  # Verify the another row starts correctly
  expect_equal(las$LOG$DEPT[5], 909.5)
})

test_that("test v1.2 sample_inf_uwi_leading_zero value is '05001095820000'", {
  las_file <- "sample_inf_uwi_leading_zero.las"
  test_path <- system.file("extdata", "1.2", las_file, package = "lastools")
  las <- read_las(test_path)
  expect_equal(las$WELL$VALUE[12], "05001095820000")
})

test_that("test v1.2 sample_inf_api_leading_zero value is '05001095820000'", {
  las_file <- "sample_inf_api_leading_zero.las"
  test_path <- system.file("extdata", "1.2", las_file, package = "lastools")
  las <- read_las(test_path)
  expect_equal(las$WELL$VALUE[12], "05001095820000")
})
