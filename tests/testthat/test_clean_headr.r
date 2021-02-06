library(dplyr)
library(doubleheadr)

dat <- doubleheadr::demo

test_that("non-existant repeated values are caught", {
  expect_error(clean_headr(dat, "xyz"))
})

test_that("NULL rep_val is caught", {
  expect_error(clean_headr(dat))
})

test_that("incorrect clean_names arg is caught", {
  expect_error(clean_headr(dat, "...", clean_names = "oh yeah"))
})

