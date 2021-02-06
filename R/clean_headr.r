#' @title clean_headr
#'
#' @description
#' This function was made to clean SurveyMonkey's "double header", which contains column names and sub-column (first row) names.
#'
#' @param dat a data.frame.
#' @param rep_val repeated value as a character class. When your column names repeat, what is the repeated value. (Common cases are "X" for .csv imports or "..." for .xlsx imports).
#' @param clean_names values are TRUE or FALSE. Should column names be converted to snake_case?
#'
#' @return a data.frame.
#'
#' @export
#' @examples
#' library(doubleheadr)
#' doubleheadr::demo %>%
#'   clean_headr(., "...")
clean_headr <- function(dat, rep_val = NULL, clean_names = TRUE){

  if (!clean_names %in% c(TRUE, FALSE)){
    stop("\"clean_names\" accepts two values: TRUE or FALSE")
  }

  if (is.null(rep_val)){
    stop("\"rep_val\" not specified")
  }

  if (any(grepl(rep_val, colnames(dat))) == F){
    stop("\"rep_val\" not found in column names.")
  }



  orig <- dat
  sv <- dat
  sv <- sv[1,]
  sv <- sv[, sapply(sv, Negate(anyNA)), drop = FALSE]
  sv <- t(sv)
  sv <- cbind(rownames(sv), data.frame(sv, row.names = NULL))
  names(sv)[1] <- "name"
  names(sv)[2] <- "value"
  sv$grp <- with(sv, ave(name, FUN = function(dat) cumsum(!startsWith(name, rep_val))))
  sv$new_value <- with(sv, ave(name, grp, FUN = function(dat) head(dat, 1)))
  sv$new_value <- paste0(sv$new_value, " ", sv$value)
  new_names <- as.character(sv$new_value)
  colnames(orig)[which(colnames(orig) %in% sv$name)] <- sv$new_value
  orig <- orig[-c(1),]

  if (clean_names == TRUE){
    orig <- janitor::clean_names(orig)
  }

  orig

}
