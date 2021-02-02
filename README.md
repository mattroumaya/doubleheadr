Untitled
================

# doubleheadr :performing\_arts:

[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)

This package provides helper functions for cleaning data exports from
SurveyMonkey.

### The Main Issue

SurveyMonkey provides response data that contains a column and a second
row containing column-name data, which requires data cleaning before
starting your analysis.

### Why `doubleheadr`?

-   Adopting `clean_headr` + `trim_headr` will (hopefully) make your
    workflow more efficient.

-   Quick and simple approach when working with downloaded or inherited
    `.csv` or `.xlsx` files, or when there are too many responses to
    pull via API. (Another highly recommended solution for Advantage and
    Premier-level users is pulling data via the SurveyMonkey API with
    [the surveymonkey package.](https://github.com/tntp/surveymonkey))

### Lifecycle

This package is in the early stages of development. Any and all issues
are welcome, please report them and I will be happy to troubleshoot
anything that comes up.

### Overview

-   `clean_headr` concatenates values from column names and the first
    row so that it makes sense.

-   `trim_headr` trims long strings from column names.

-   `flag_mins` flags respondents not meeting a minimum duration in
    minutes to complete the survey

### Install `doubleheadr`

``` r
# install.packages("devtools")
# library(devtools)
devtools::install_github('mattroumaya/doubleheadr')
```

    ## WARNING: Rtools is required to build R packages, but is not currently installed.
    ## 
    ## Please download and install Rtools 4.0 from https://cran.r-project.org/bin/windows/Rtools/.

    ## Skipping install of 'doubleheadr' from a github remote, the SHA1 (78ad98dc) has not changed since last install.
    ##   Use `force = TRUE` to force installation

## Usage

Your downloaded or inherited `.csv`/`.xlsx` file will look something
like the demo included in `doubleheadr`:

``` r
head(doubleheadr::demo)
```

    ## # A tibble: 6 x 12
    ##   `Respondent ID` `Please provide~ ...3  ...4  ...5  ...6  ...7  ...8  ...9 
    ##             <dbl> <chr>            <chr> <chr> <chr> <chr> <chr> <chr> <chr>
    ## 1              NA Name             Comp~ Addr~ Addr~ City~ Stat~ ZIP/~ Coun~
    ## 2     11385284375 Benjamin Frankl~ Poor~ <NA>  <NA>  Phil~ PA    19104 <NA> 
    ## 3     11385273621 Mae Jemison      NASA  <NA>  <NA>  Deca~ Alab~ 20104 <NA> 
    ## 4     11385258069 Carl Sagan       Smit~ <NA>  <NA>  Wash~ D.C.  33321 <NA> 
    ## 5     11385253194 W. E. B. Du Bois NAACP <NA>  <NA>  Grea~ MA    1230  <NA> 
    ## 6     11385240121 Florence Nighti~ Publ~ <NA>  <NA>  Flor~ IT    33225 <NA> 
    ## # ... with 3 more variables: ...10 <chr>, ...11 <chr>, `I wish it would have
    ## #   snowed more this winter.` <chr>

##### `clean_headr`

``` r
demo %>% 
  clean_headr(., "...") 
```

    ## # A tibble: 7 x 12
    ##   respondent_id please_provide_~ please_provide_~ please_provide_~
    ##           <dbl> <chr>            <chr>            <chr>           
    ## 1   11385284375 Benjamin Frankl~ Poor Richard's   <NA>            
    ## 2   11385273621 Mae Jemison      NASA             <NA>            
    ## 3   11385258069 Carl Sagan       Smithsonian      <NA>            
    ## 4   11385253194 W. E. B. Du Bois NAACP            <NA>            
    ## 5   11385240121 Florence Nighti~ Public Health Co <NA>            
    ## 6   11385226951 Galileo Galilei  NASA             <NA>            
    ## 7   11385212508 Albert Einstein  ThinkTank        <NA>            
    ## # ... with 8 more variables:
    ## #   please_provide_your_contact_information_address_2 <chr>,
    ## #   please_provide_your_contact_information_city_town <chr>,
    ## #   please_provide_your_contact_information_state_province <chr>,
    ## #   please_provide_your_contact_information_zip_postal_code <chr>,
    ## #   please_provide_your_contact_information_country <chr>,
    ## #   please_provide_your_contact_information_email_address <chr>,
    ## #   please_provide_your_contact_information_phone_number <chr>,
    ## #   i_wish_it_would_have_snowed_more_this_winter_response <chr>

##### trim\_headr

``` r
demo %>% 
  clean_headr(., "...") %>% 
  trim_headr(., c("please_provide_your_contact_information_",
                  "i_wish_it_would_have_",
                  "_response"))
```

    ##   respondent_id                 name          company address address_2
    ## 1   11385284375    Benjamin Franklin   Poor Richard's    <NA>      <NA>
    ## 2   11385273621          Mae Jemison             NASA    <NA>      <NA>
    ## 3   11385258069           Carl Sagan      Smithsonian    <NA>      <NA>
    ## 4   11385253194     W. E. B. Du Bois            NAACP    <NA>      <NA>
    ## 5   11385240121 Florence Nightingale Public Health Co    <NA>      <NA>
    ## 6   11385226951      Galileo Galilei             NASA    <NA>      <NA>
    ## 7   11385212508      Albert Einstein        ThinkTank    <NA>      <NA>
    ##          city_town state_province zip_postal_code country        email_address
    ## 1     Philadelphia             PA           19104    <NA>  benjamins@gmail.com
    ## 2          Decatur        Alabama           20104    <NA>    mjemison@nasa.gov
    ## 3       Washington           D.C.           33321    <NA>  stargazer@gmail.com
    ## 4 Great Barrington             MA            1230    <NA>       dubois@web.com
    ## 5         Florence             IT           33225    <NA>   firstnurse@aol.com
    ## 6             Pisa             IT           12345    <NA> galileo123@yahoo.com
    ## 7        Princeton             NJ            8540    <NA> imthinking@gmail.com
    ##   phone_number    snowed_more_this_winter
    ## 1 215-555-4444          Strongly disagree
    ## 2 221-134-4646             Strongly agree
    ## 3 999-999-4422 Neither agree nor disagree
    ## 4 999-000-1234          Strongly disagree
    ## 5 123-456-7899                   Disagree
    ## 6 111-888-9944                      Agree
    ## 7 215-999-8877             Strongly agree

##### flag\_mins

-   Coming to the `demo` soon…
