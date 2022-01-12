#' @title flag_mins
#'
#' @description
#' Flag survey duration based on how many minutes a respondent took. The assumption is that your data.frame contains two columns: "date_created" and "date_modified".
#'
#' @param dat a data.frame containing SurveyMonkey response data, with two columns "date_created" and "date_modified".
#' @param mins a whole number specifying the cutoff for the .
#'
#'
#' @return a data.frame object.
#'
#' @export
flag_mins <- function(dat, mins) {
  dat <- dat %>%
    dplyr::mutate(
      flag_mins = round(difftime(dat$date_modified, dat$date_created, units = "mins"), 0),
      flag_mins = ifelse(flag_mins < mins, TRUE, FALSE)
    )

  if (is.numeric(mins) == FALSE) {
    dat <- dat
    usethis::ui_warn('"mins" accepts numeric values only; All NA returned. Try using a non-negative integer.')
  }

  if (mins < 0) {
    dat <- dat
    usethis::ui_warn("Time travel does not yet exist (or does it?). Provide a non-negative number.")
  }

  return(dat)
}
