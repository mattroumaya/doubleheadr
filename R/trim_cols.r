#' @title trim_cols
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
trim_cols <- function(dat, ...){
  check_vec <- as.character(...)
  char_vec <- paste(..., collapse = "|")
  names(dat) <- gsub(char_vec, "", names(dat))


  if (any(sapply(check_vec, function(x) any(grep(x, colnames(dat))))==F)){
    ui_warn('One or more strings in your character vector was not found in your column names.')
  }

    return(as.data.frame(dat))

}


