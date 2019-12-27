library(lastools)


#-----------------------------------------------------------------------------
# LAS v1.2 tests
#-----------------------------------------------------------------------------
test_that("test write v1.2 sample.las", {
  las_file <- "sample.las"
  test_path <- system.file("extdata", "1.2", las_file, package = "lastools")
  las <- read_las(test_path)
  write_las(las, "new_file.las")
  newlas <- read_las("new_file.las")
  expect_equal(las$WELL$VALUE[12], newlas$WELL$VALUE[12])
  unlink("new_file.las")
})
