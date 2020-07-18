#' @title Turn column names and first row names into column names
#'
#' @description
#' This function was made to clean SurveyMonkey's "double header", which contains column names and sub-column names found in the first row
#'
#' @param dat a data.frame
#' @param rep_val repeated value as a character class. When your column names repeat, what is the repeated value. (Common cases are "X" for .csv imports or "..." for .xlsx imports)
#'
#'
#'
#' @return a data.frame with one less row
#' @export
#' @examples
#'
#' mtcars %>%
#'   tabyl(am, cyl) %>%
#'   adorn_percentages("col") %>%
#'   adorn_pct_formatting() %>%
#'   adorn_ns(position = "front")


.onAttach <- function(libname, pkgname) {
  packageStartupMessage("Welcome to doubleheadr. Let's get those columns cleaned!")
}



clean_headr <- function(dat, rep_val){

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
  return(orig)
}
