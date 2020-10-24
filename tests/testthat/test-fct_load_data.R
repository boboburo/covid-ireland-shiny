test_that("Loading data works", {
  #check that is data.frame
  expect_s3_class(df, "data.frame")
})

test_that("Number of columns is correct", {
  expect_equal(ncol(df), 26)
  })

test_that("All counties included",{
  expect_equal(length(unique(df$county_name)), 26)
})