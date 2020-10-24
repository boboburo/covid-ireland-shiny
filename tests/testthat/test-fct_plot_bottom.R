df <- load_covid_ireland(src = "offline_sqlite")

test_that("Plot generated", {
  plot <- plot_btm(df, y_val = "plt1_x",
           county = "Dublin",
           end_date = ymd("2020-05-29"), days_before =30, type = "line")
  
  expect_s3_class(plot,"ggplot")
})



