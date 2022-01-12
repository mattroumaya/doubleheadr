#' @title flag_text
#'
#' @description
#' Scan each row for elements in a character vector and create a boolean column flag_text if any element is present.
#'
#' A use case would be to scan survey data for PID such as first/last names, scan free-text survey responses for foul language or non-alphanumeric values, etc.
#'
#' @param dat a data.frame.
#' @param text_vector a character vector of values to identify in the data.frame.
#' @param ignore_columns a character vector of column names that will be ignored when flagging rows.
#'
#'
#' @return a data.frame object.
#'
#' @export
#' @importFrom magrittr %>%
flag_text <- function(dat, text_vector, ignore_columns) {
  text_vector <- paste(text_vector, collapse = "|")
  text_vector <- tolower(text_vector)

  # Check if dat is grouped and if so, save structure and ungroup temporarily
  is_grouped <- dplyr::is_grouped_df(dat)

  if (is_grouped) {
    dat_groups <- dplyr::group_vars(dat)
    dat <- dat %>% dplyr::ungroup()
    if (getOption("flag_text.grouped_warning", TRUE) & interactive()) {
      message(paste0("Data is grouped by [", paste(dat_groups, collapse = "|"), "]. Note that flag_text() operates rowwise and is not group aware. It does not limit text flagging to within-groups, but rather checks over the entire data frame rowwise. However grouping structure is preserved.\nThis message is shown once per session and may be disabled by setting options(\"flag_text.grouped_warning\" = FALSE).")) # nocov
      options("flag_text.grouped_warning" = FALSE) # nocov
    }
  }


  if (!missing(ignore_columns)) {
    ignore_columns <- rlang::enquo(ignore_columns)


    dat <- dat %>%
      dplyr::mutate(join = dplyr::row_number())

    rejoin <- dat %>%
      dplyr::select(dplyr::join, {{ ignore_columns }})


    temp <- dat %>%
      dplyr::select(-{{ ignore_columns }}) %>%
      dplyr::rowwise() %>%
      dplyr::mutate(dplyr::across(dplyr::everything(), as.character),
        dplyr::across(dplyr::everything(), ~ tolower(.)),
        flag_text = as.logical(+any(stringr::str_detect(dplyr::c_across(dplyr::everything()), paste(text_vector, collapse = "|"))))
      ) %>%
      dplyr::ungroup() %>%
      dplyr::mutate(
        flag_text = ifelse(is.na(flag_text), FALSE, flag_text),
        join = dplyr::row_number()
      ) %>%
      dplyr::select(join, flag_text)

    temp <- dplyr::left_join(temp, rejoin, by = "join")

    dat <- dplyr::left_join(dat, temp) %>%
      dplyr::select(-join)
  } else {
    dat <- dat %>%
      dplyr::mutate(join = dplyr::row_number())

    temp <- dat %>%
      dplyr::rowwise() %>%
      dplyr::mutate(dplyr::across(dplyr::everything(), as.character),
        dplyr::across(dplyr::everything(), ~ tolower(.)),
        flag_text = as.logical(+any(stringr::str_detect(dplyr::c_across(dplyr::everything()), paste(text_vector, collapse = "|"))))
      ) %>%
      dplyr::ungroup() %>%
      dplyr::mutate(
        flag_text = ifelse(is.na(flag_text), FALSE, flag_text),
        join = dplyr::row_number()
      ) %>%
      dplyr::select(join, flag_text)

    dat <- dplyr::left_join(dat, temp, by = "join") %>%
      dplyr::select(-join)
  }


  # Reapply groups if dat was grouped
  if (is_grouped) dat <- dat %>% dplyr::group_by(!!!rlang::syms(dat_groups))

  dat
}
