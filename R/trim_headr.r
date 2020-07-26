#' @title trim_headr
#'
#' @description
#' Trim column names by removing string matches or partial string matches.
#'
#' @param dat a data.frame
#' @param ... a character vector of strings or partial strings to remove from column names
#'
#'
#' @return a data.frame object
#'
#' @export
trim_headr <- function(dat, ...){
  char_vec <- paste(..., collapse = "|")
  names(dat) <- gsub(char_vec, "", names(dat))

  return(as.data.frame(dat))

}


