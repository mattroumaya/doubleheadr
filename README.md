
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

## Usage

Your downloaded or inherited `.csv`/`.xlsx` file will look something
like the demo included in `doubleheadr`.

No worries though! Cleaning your column names is as easy as 1,2… that’s
it! Two steps.

Start with unhelpful column names:

``` r
colnames(doubleheadr::demo)
```

    ##  [1] "Respondent ID"                                
    ##  [2] "Please provide your contact information:"     
    ##  [3] "...3"                                         
    ##  [4] "...4"                                         
    ##  [5] "...5"                                         
    ##  [6] "...6"                                         
    ##  [7] "...7"                                         
    ##  [8] "...8"                                         
    ##  [9] "...9"                                         
    ## [10] "...10"                                        
    ## [11] "...11"                                        
    ## [12] "I wish it would have snowed more this winter."

##### `1. clean_headr`

-   Now you have some really long column names

-   You can make them easier to read by setting `clean_names == FALSE`

``` r
demo %>% 
  clean_headr(., "...") %>% 
  colnames(.)
```

    ##  [1] "respondent_id"                                          
    ##  [2] "please_provide_your_contact_information_name"           
    ##  [3] "please_provide_your_contact_information_company"        
    ##  [4] "please_provide_your_contact_information_address"        
    ##  [5] "please_provide_your_contact_information_address_2"      
    ##  [6] "please_provide_your_contact_information_city_town"      
    ##  [7] "please_provide_your_contact_information_state_province" 
    ##  [8] "please_provide_your_contact_information_zip_postal_code"
    ##  [9] "please_provide_your_contact_information_country"        
    ## [10] "please_provide_your_contact_information_email_address"  
    ## [11] "please_provide_your_contact_information_phone_number"   
    ## [12] "i_wish_it_would_have_snowed_more_this_winter_response"

##### 2. trim\_headr

``` r
demo %>% 
  clean_headr(., "...") %>% 
  trim_headr(., c("please_provide_your_contact_information_",
                  "i_wish_it_would_have_",
                  "_response")) %>% 
  colnames(.)
```

    ##  [1] "respondent_id"           "name"                   
    ##  [3] "company"                 "address"                
    ##  [5] "address_2"               "city_town"              
    ##  [7] "state_province"          "zip_postal_code"        
    ##  [9] "country"                 "email_address"          
    ## [11] "phone_number"            "snowed_more_this_winter"

##### flag\_mins

-   Coming to the `demo` soon…
