test_that("Plot generated", {
  
  plot <-  plot_top(df, x_val = "plt1_x", 
                    y_val = "plt1_y", 
                    size_col = "population_census16", 
                    label_col = "county_name", focus_date = ymd("2020-05-11"))
  
  expect_s3_class(plot,"ggplot")
})

test_that("Focus_on_day removes Infs and NA",{
  
  focused = focus_on_day(focus_day_test_data)
  expect_equal(nrow(focused), 3)
})


test_that("focus_on_day returns zero rows",{
  
  focused = focus_on_day(focus_day_test_data, focus_date = "2020-01-02")
  expect_equal(nrow(focused), 0)
})


test_that("focus_on_day handles ERROR for date filtering to zero rows",{
  expect_error( focus_on_day(focus_day_test_data, 
                             focus_date = "2019-01-02"),
                "No rows in the")
})






