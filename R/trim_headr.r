#' @title trim_headr
#'
#' @description
#' Trim column names by removing string matches or partial string matches. Supply character string values to a character vector, and all matches will be removed from column names. For instance, supplying c('foo', 'bar') will remove all instances of 'foo' and/or 'bar' present in column names.
#'
#' @param dat a data.frame.
#' @param ... a character vector of values to remove from column names.
#'
#'
#' @return a data.frame object.
#'
#' @export
trim_headr <- function(dat, ...) {
  char_vec <- paste(..., collapse = "|")
  names(dat) <- gsub(char_vec, "", names(dat))

  return(as.data.frame(dat))
}


