## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "##",
  message = FALSE,
  warning = FALSE,
  eval = FALSE
)

## ----load-pkg------------------------------------------------------------
#  library(completejourney)

## ----load-pkg-hidden, echo=FALSE-----------------------------------------
#  #devtools::load_all(path = "/Users/b294776/Desktop/Workspace/Packages/completejourney")

## ----load-transactions---------------------------------------------------
#  # get the full transactions data set
#  transactions <- get_transactions()
#  transactions
#  ## # A tibble: 1,469,307 x 11
#  ##    household_id store_id basket_id product_id quantity sales_value retail_disc
#  ##    <chr>        <chr>    <chr>     <chr>         <dbl>       <dbl>       <dbl>
#  ##  1 900          330      31198570… 1095275           1        0.5        0
#  ##  2 900          330      31198570… 9878513           1        0.99       0.1
#  ##  3 1228         406      31198655… 1041453           1        1.43       0.15
#  ##  4 906          319      31198705… 1020156           1        1.5        0.290
#  ##  5 906          319      31198705… 1053875           2        2.78       0.8
#  ##  6 906          319      31198705… 1060312           1        5.49       0.5
#  ##  7 906          319      31198705… 1075313           1        1.5        0.290
#  ##  8 1058         381      31198676… 985893            1        1.88       0.21
#  ##  9 1058         381      31198676… 988791            1        1.5        1.29
#  ## 10 1058         381      31198676… 9297106           1        2.69       0
#  ## # … with 1,469,297 more rows, and 4 more variables: coupon_disc <dbl>,
#  ## #   coupon_match_disc <dbl>, week <int>, transaction_timestamp <dttm>

## ----load-promotions-----------------------------------------------------
#  # get the full promotions data set
#  promotions <- get_promotions()
#  promotions
#  ## # A tibble: 20,940,529 x 5
#  ##    product_id store_id display_location mailer_location  week
#  ##    <chr>      <chr>    <fct>            <fct>           <int>
#  ##  1 1000050    316      9                0                   1
#  ##  2 1000050    337      3                0                   1
#  ##  3 1000050    441      5                0                   1
#  ##  4 1000092    292      0                A                   1
#  ##  5 1000092    293      0                A                   1
#  ##  6 1000092    295      0                A                   1
#  ##  7 1000092    298      0                A                   1
#  ##  8 1000092    299      0                A                   1
#  ##  9 1000092    304      0                A                   1
#  ## 10 1000092    306      0                A                   1
#  ## # … with 20,940,519 more rows

## ----load-both-----------------------------------------------------------
#  # a convenience function to get both
#  c(promotions, transactions) %<-% get_data(which = 'both', verbose = FALSE)
#  dim(promotions)
#  ## [1] 20940529        5
#  
#  dim(transactions)
#  ## [1] 1469307      11

## ----data-relationships, echo=FALSE, out.height="95%", out.width="95%", eval=TRUE----
knitr::include_graphics("data_relationships.png")

## ----example-transaction-data, echo=FALSE--------------------------------
#  library(dplyr)
#  library(lubridate)
#  
#  l1 <- transactions %>%
#    filter(basket_id == "35730137393",
#           product_id == "819063")
#  l2 <- transactions %>%
#    filter(basket_id == "31672240446",
#           product_id == "819063")
#  l3 <- transactions %>%
#    filter(basket_id == "36027750817",
#           product_id == "819063")
#  
#  bind_rows(l1, l2, l3) %>%
#    select(product_id, quantity, sales_value, retail_disc, coupon_disc, coupon_match_disc)
#  ## # A tibble: 3 x 6
#  ##   product_id quantity sales_value retail_disc coupon_disc coupon_match_disc
#  ##   <chr>         <dbl>       <dbl>       <dbl>       <dbl>             <dbl>
#  ## 1 819063            1        1.67        0           0                 0
#  ## 2 819063            2        3.34        0.36        0                 0
#  ## 3 819063            2        2.89        0           0.55              0.45

## ------------------------------------------------------------------------
#  demographics %>%
#    filter(household_id == "208")
#  ## # A tibble: 1 x 8
#  ##   household_id age   income home_ownership marital_status household_size household_comp
#  ##   <chr>        <ord> <ord>  <ord>          <ord>          <ord>          <ord>
#  ## 1 208          45-54 50-74K Homeowner      NA             2              2 Adults No K…
#  ## # … with 1 more variable: kids_count <ord>

## ------------------------------------------------------------------------
#  campaigns %>%
#    filter(household_id == "208")
#  ## # A tibble: 7 x 2
#  ##   campaign_id household_id
#  ##   <chr>       <chr>
#  ## 1 13          208
#  ## 2 17          208
#  ## 3 18          208
#  ## 4 22          208
#  ## 5 26          208
#  ## 6 27          208
#  ## 7 8           208

## ------------------------------------------------------------------------
#  campaigns %>%
#    filter(household_id == "208") %>%
#    left_join(., campaign_descriptions, by="campaign_id") %>%
#    arrange(start_date)
#  ## # A tibble: 7 x 5
#  ##   campaign_id household_id campaign_type start_date end_date
#  ##   <chr>       <chr>        <ord>         <date>     <date>
#  ## 1 26          208          Type B        2016-12-28 2017-02-19
#  ## 2 27          208          Type A        2017-02-08 2017-03-26
#  ## 3 8           208          Type A        2017-05-08 2017-06-25
#  ## 4 13          208          Type A        2017-08-08 2017-09-24
#  ## 5 17          208          Type B        2017-10-18 2017-11-19
#  ## 6 18          208          Type A        2017-10-30 2017-12-24
#  ## 7 22          208          Type B        2017-12-06 2018-01-07

## ------------------------------------------------------------------------
#  coupons %>%
#    filter(campaign_id == "18") %>%
#    distinct(coupon_upc)
#  ## # A tibble: 209 x 1
#  ##    coupon_upc
#  ##    <chr>
#  ##  1 10000085475
#  ##  2 10000085476
#  ##  3 10000085477
#  ##  4 10000085478
#  ##  5 10000085479
#  ##  6 10000085480
#  ##  7 10000085484
#  ##  8 10000089237
#  ##  9 10000089238
#  ## 10 10000089239
#  ## # … with 199 more rows

## ------------------------------------------------------------------------
#  coupons %>%
#    filter(campaign_id == "18",
#           coupon_upc == "55410000076")
#  ## # A tibble: 50 x 3
#  ##    coupon_upc  product_id campaign_id
#  ##    <chr>       <chr>      <chr>
#  ##  1 55410000076 1004458    18
#  ##  2 55410000076 1011841    18
#  ##  3 55410000076 1016495    18
#  ##  4 55410000076 10182852   18
#  ##  5 55410000076 1018696    18
#  ##  6 55410000076 1058591    18
#  ##  7 55410000076 1065032    18
#  ##  8 55410000076 1069973    18
#  ##  9 55410000076 107157     18
#  ## 10 55410000076 1110721    18
#  ## # … with 40 more rows

## ------------------------------------------------------------------------
#  coupons %>%
#    filter(campaign_id == "18",
#           coupon_upc == "55410000076") %>%
#    left_join(., products, by="product_id") %>%
#    select(product_id, manufacturer_id, department, brand,
#           product_category, product_type, package_size)
#  ## # A tibble: 50 x 7
#  ##    product_id manufacturer_id department brand product_category product_type
#  ##    <chr>      <chr>           <chr>      <fct> <chr>            <chr>
#  ##  1 1004458    1318            GROCERY    Nati… PICKLE/RELISH/P… PICKLES
#  ##  2 1011841    1318            GROCERY    Nati… PICKLE/RELISH/P… PICKLES
#  ##  3 1016495    1318            GROCERY    Nati… PICKLE/RELISH/P… PICKLD VEG …
#  ##  4 10182852   1318            GROCERY    Nati… PICKLE/RELISH/P… PICKLES
#  ##  5 1018696    1318            GROCERY    Nati… PICKLE/RELISH/P… PICKLES
#  ##  6 1058591    1318            GROCERY    Nati… PICKLE/RELISH/P… PICKLES
#  ##  7 1065032    1318            GROCERY    Nati… PICKLE/RELISH/P… PICKLES
#  ##  8 1069973    1318            GROCERY    Nati… PICKLE/RELISH/P… PICKLES
#  ##  9 107157     1318            GROCERY    Nati… PICKLE/RELISH/P… PICKLES
#  ## 10 1110721    1318            GROCERY    Nati… PICKLE/RELISH/P… PICKLES
#  ## # … with 40 more rows, and 1 more variable: package_size <chr>

## ------------------------------------------------------------------------
#  coupon_redemptions %>%
#    filter(household_id == "208")
#  ## # A tibble: 5 x 4
#  ##   household_id coupon_upc  campaign_id redemption_date
#  ##   <chr>        <chr>       <chr>       <date>
#  ## 1 208          55100090033 8           2017-05-23
#  ## 2 208          51800015050 18          2017-11-09
#  ## 3 208          51920021576 18          2017-11-09
#  ## 4 208          55410000076 18          2017-11-13
#  ## 5 208          10000085475 18          2017-11-18

## ------------------------------------------------------------------------
#  transactions %>%
#    filter(household_id == "208")
#  ## # A tibble: 756 x 11
#  ##    household_id store_id basket_id product_id quantity sales_value retail_disc
#  ##    <chr>        <chr>    <chr>     <chr>         <dbl>       <dbl>       <dbl>
#  ##  1 208          327      31268866… 845379            1        7.64        0
#  ##  2 208          327      31268866… 854133            1        4.69        0.5
#  ##  3 208          327      31268866… 862349            1        1           0.99
#  ##  4 208          327      31268866… 879504            1        2           1.19
#  ##  5 208          327      31268866… 990519            1        1.69        0
#  ##  6 208          327      31268866… 1068830           1        1.09        0
#  ##  7 208          327      31268866… 1097635           1        2.96        0
#  ##  8 208          324      31344175… 883932            1        2           0.59
#  ##  9 208          324      31344175… 885290            1        1.99        0
#  ## 10 208          324      31344175… 915502            2        4           2.78
#  ## # … with 746 more rows, and 4 more variables: coupon_disc <dbl>,
#  ## #   coupon_match_disc <dbl>, week <int>, transaction_timestamp <dttm>

## ------------------------------------------------------------------------
#  transactions %>%
#    filter(household_id == "208",
#           product_id == "896292",
#           as_date(transaction_timestamp) == "2017-11-13")
#  ## # A tibble: 1 x 11
#  ##   household_id store_id basket_id product_id quantity sales_value retail_disc
#  ##   <chr>        <chr>    <chr>     <chr>         <dbl>       <dbl>       <dbl>
#  ## 1 208          327      40715247… 896292            2           4        2.58
#  ## # … with 4 more variables: coupon_disc <dbl>, coupon_match_disc <dbl>, week <int>,
#  ## #   transaction_timestamp <dttm>

## ------------------------------------------------------------------------
#  promotions %>%
#    filter(product_id == "896292",
#           store_id == "327")
#  ## # A tibble: 2 x 5
#  ##   product_id store_id display_location mailer_location  week
#  ##   <chr>      <chr>    <fct>            <fct>           <int>
#  ## 1 896292     327      A                0                  47
#  ## 2 896292     327      A                0                  49

