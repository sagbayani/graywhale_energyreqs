Mass change - phase 1 per month
================
Selina Agbayani
Jan 19, 2021, updated and cleaned 04 July, 2025

NOTE: This code will run for a long time.

``` r
############ Set path for output figures: ###############
Figurespath <- paste0(getwd(), "/figures", collapse = NULL)

############ Set path for input & output data  ###########
datapath <- paste0(getwd(), "/data", collapse = NULL) 
```

``` r
#Read in predicted lengths from Agbayani et al. 2020
gw_pred_lengths <- as_tibble(
  read_csv("data/gw_predicted_phases_1_2_mthsversion_Feb2021.csv"),
  col_types = (list(
    cols(age_yrs = col_double(),
         fit = col_double(),
         mean = col_double(),
         sd = col_double(),
         median = col_double(),
         median_abs_dev = col_double(),
         `2.5%` = col_double(),
         `97.5%` = col_double(),
         length_plus_sd = col_double(),
         length_minus_sd = col_double(),
         female_length = col_double(),
         male_length = col_double()
    )
  )
  )
)
```

    ## Rows: 1506 Columns: 10
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## dbl (10): age_yrs, fit, mean, sd, median, median_abs_dev, 2.5%, 97.5%, lengt...
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
gw_pred_lengths <-gw_pred_lengths %>% 
  filter(age_yrs <=1) %>% 
  filter(row_number() <= n()-1) #remove duplicate row for age-yr==1

#Read in predicted mass from mass_boostraps.Rmd
gw_pred_mass <- as_tibble(
  read_csv("data/mass_table.csv"), #monthly 
  col_types = (list(
    cols(age_yrs = col_double(),
         mean_mass = col_double(),
         sd_mass = col_double(),
         mean_lwr = col_double(),
         mean_upr = col_double(),
         quant025 = col_double(),
         quant975 = col_double(),
         female_mass = col_double(),
         male_mass = col_double()
    )
  )
  )
)
```

    ## Rows: 173 Columns: 9
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## dbl (9): age_yrs, mean_mass, sd_mass, mean_lwr, mean_upr, quant025, quant975...
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
gw_pred_mass <-gw_pred_mass %>% 
  filter(age_yrs <=1)

#read in age table (months converted to decimal yr)
age_yr_tibble <- as_tibble(
  read_csv("data/age_yr_tibble.csv"), 
  col_types = (list(ID = col_integer(),
                    month = col_character(),
                    no_days_in_mth = col_double(),
                    age_mth = col_double(),
                    no_days_cumul = col_double(),
                    age_yrs = col_double()
  )
  )
)
```

    ## Rows: 25 Columns: 5
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr (1): month
    ## dbl (4): no_days_in_mth, age_mth, no_days_cumul, age_yrs
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

Calculate change in mass per month (up to 1 yr).

``` r
#Original code was run with MC_reps <- 10000  and took a very long time
#To test and explore the code, use less reps 
MC_reps <- 10

kable(gw_pred_mass)
```

| age_yrs | mean_mass | sd_mass | mean_lwr | mean_upr | quant025 | quant975 | female_mass | male_mass |
|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 0.0000000 | 983.0272 | 26.76770 | 769.3864 | 1256.003 | 931.5244 | 1036.295 | 1011.028 | 967.3705 |
| 0.0424658 | 1232.8231 | 30.08225 | 990.0386 | 1535.157 | 1174.8634 | 1292.607 | 1267.939 | 1213.1879 |
| 0.0849315 | 1498.2581 | 37.14344 | 1229.5370 | 1825.723 | 1426.7071 | 1572.089 | 1540.935 | 1474.3954 |
| 0.1232877 | 1747.8713 | 45.25512 | 1458.4778 | 2094.703 | 1660.7409 | 1837.873 | 1797.658 | 1720.0329 |
| 0.1616438 | 2003.8171 | 53.21868 | 1696.1860 | 2367.260 | 1901.3875 | 2109.690 | 2060.895 | 1971.9023 |
| 0.2041096 | 2291.4431 | 62.29993 | 1966.1135 | 2670.624 | 2171.5715 | 2415.419 | 2356.713 | 2254.9473 |
| 0.2465753 | 2580.5024 | 70.55082 | 2239.6310 | 2973.274 | 2444.7652 | 2720.907 | 2654.006 | 2539.4028 |
| 0.2876712 | 2859.0329 | 76.53073 | 2504.6919 | 3263.521 | 2711.7497 | 3011.297 | 2940.471 | 2813.4971 |
| 0.3287671 | 3134.3355 | 82.72707 | 2767.6103 | 3549.671 | 2975.0985 | 3298.899 | 3223.615 | 3084.4149 |
| 0.3712329 | 3413.5230 | 86.53765 | 3034.7044 | 3839.644 | 3246.8671 | 3585.582 | 3510.755 | 3359.1559 |
| 0.4136986 | 3685.8679 | 90.88511 | 3295.2869 | 4122.756 | 3510.7807 | 3866.512 | 3790.858 | 3627.1630 |
| 0.4547945 | 3941.6511 | 91.42970 | 3539.7234 | 4389.226 | 3765.3901 | 4123.252 | 4053.927 | 3878.8724 |
| 0.4958904 | 4188.9977 | 92.45919 | 3775.5555 | 4647.721 | 4010.6552 | 4372.546 | 4308.319 | 4122.2796 |
| 0.5383562 | 4434.9913 | 91.82531 | 4009.3493 | 4905.825 | 4257.7544 | 4617.163 | 4561.319 | 4364.3552 |
| 0.5808219 | 4670.7728 | 91.41471 | 4232.5596 | 5154.359 | 4494.2320 | 4852.033 | 4803.817 | 4596.3814 |
| 0.6232877 | 4896.0196 | 91.08355 | 4444.8610 | 5392.974 | 4720.0362 | 5076.540 | 5035.480 | 4818.0407 |
| 0.6657534 | 5110.5620 | 90.42769 | 4646.1276 | 5621.423 | 4935.7692 | 5289.706 | 5256.133 | 5029.1660 |
| 0.7068493 | 5307.9930 | 91.27160 | 4830.4602 | 5832.735 | 5131.5266 | 5488.766 | 5459.188 | 5223.4526 |
| 0.7479452 | 5495.4655 | 93.44847 | 5004.6710 | 6034.392 | 5314.7738 | 5680.533 | 5652.001 | 5407.9392 |
| 0.7904110 | 5678.8683 | 96.36957 | 5174.2964 | 6232.644 | 5492.5252 | 5869.718 | 5840.627 | 5588.4210 |
| 0.8328767 | 5802.7365 | 211.64097 | 5287.9733 | 6367.611 | 5397.3545 | 6225.735 | 5968.024 | 5710.3163 |
| 0.8739726 | 5869.1305 | 208.61037 | 5348.9964 | 6439.843 | 5469.3720 | 6285.891 | 6036.309 | 5775.6529 |
| 0.9150685 | 5935.5799 | 207.14747 | 5409.9546 | 6512.275 | 5538.4997 | 6349.293 | 6104.651 | 5841.0440 |
| 0.9575342 | 6004.2031 | 204.11616 | 5472.8012 | 6587.204 | 5612.7610 | 6411.690 | 6175.229 | 5908.5742 |
| 1.0000000 | 6072.8559 | 202.11091 | 5535.5539 | 6662.311 | 5685.3490 | 6476.221 | 6245.837 | 5976.1335 |

``` r
pred_mass <- gw_pred_mass %>% 
    dplyr::select(age_yrs, mean_mass, sd_mass, female_mass, male_mass)


####################################################################
##### Calculate mean mass per month
MC_mass = NA

for (i in seq(from = 0, to = 12, by = 1)){  #step by 1 mths
    
    age_tibble <- age_yr_tibble %>% filter(age_mth == i)  
    age <- age_tibble$age_yrs   #calculate age_yrs (do not round up)
    
    strcolname <- as.character(age)
    
    pred_mass_i <- filter(pred_mass, age_yrs == age)
    
    mass <- pred_mass_i$mean_mass
    sd <- pred_mass_i$sd_mass
    
    set.seed(1)
    mass_i <- as_tibble(rnorm(MC_reps, mass, sd), col.names = str(i))
    names(mass_i)[1] <- strcolname
    
    mass_i <- mass_i %>%  dplyr::mutate(ID = row_number())
    
    #transpose the dataframe -- result is a matrix
    mass_i <-  t(mass_i)    
    
    #make ID the column name, then remove the unneeded row
    colnames(mass_i) <- unlist(mass_i[row.names(mass_i)=='ID',])
    mass_i  <- mass_i[!row.names(mass_i)=='ID',]
    
    #turn matrix into data frame (need to include the t() to keep the matrix format)
    mass_i <- as_tibble(t(mass_i))
    
    mass_i$age_yrs <- age
    
    mass_i$age_mth <- i
    
    MC_mass <- rbind(MC_mass, mass_i)
    
    
}

# move age_yrs to first column
MC_mass <- MC_mass %>%
  relocate(age_yrs)

MC_mass = MC_mass[-1,]

head(MC_mass)
```

    ## # A tibble: 6 × 12
    ##   age_yrs   `1`   `2`   `3`   `4`   `5`   `6`   `7`   `8`   `9`  `10` age_mth
    ##     <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>   <dbl>
    ## 1  0       966.  988.  961. 1026.  992.  961.  996. 1003.  998.  975.       0
    ## 2  0.0849 1475. 1505. 1467. 1558. 1510. 1468. 1516. 1526. 1520. 1487.       1
    ## 3  0.162  1970. 2014. 1959. 2089. 2021. 1960. 2030. 2043. 2034. 1988.       2
    ## 4  0.247  2536. 2593. 2522. 2693. 2604. 2523. 2615. 2633. 2621. 2559.       3
    ## 5  0.329  3083. 3150. 3065. 3266. 3162. 3066. 3175. 3195. 3182. 3109.       4
    ## 6  0.414  3629. 3703. 3610. 3831. 3716. 3611. 3730. 3753. 3738. 3658.       5

``` r
MC_mass_diffs <- NA

######################################################
#### Calculate mass change (not sex-specific)

# Mass for newborn
M_nb <- pred_mass %>% filter(age_yrs == 0) 

for (i in seq(from = 1, to = MC_reps, by = 1)){
    
    colnumber = i
    colname = as.character(colnumber)
    
    #first row - Mass change from newborn   
    mass_chg <- MC_mass %>% 
        filter(age_yrs == 0) %>% 
        select(all_of(colname))
    delta_mass <- mass_chg 
    
    
    delta_mass <- as.data.frame(mass_chg) 
    #names(delta_mass)[1] <- colname
    
    mass_column <- MC_mass %>% 
        select(all_of(colname))     
    
    str(mass_column)
    
    diffs_mass <-  diff(as.matrix(mass_column))  #calculate delta mass
    diffs_mass <- as.data.frame(diffs_mass) 
    names(diffs_mass)[1] <- as.character(colname)
    
    head(diffs_mass)
    
    mass_chg <- rbind(delta_mass, diffs_mass) 
    head(mass_chg)
    MC_mass_diffs <-cbind(MC_mass_diffs, mass_chg) 

}
```

    ## tibble [13 × 1] (S3: tbl_df/tbl/data.frame)
    ##  $ 1: num [1:13] 966 1475 1970 2536 3083 ...
    ## tibble [13 × 1] (S3: tbl_df/tbl/data.frame)
    ##  $ 2: num [1:13] 988 1505 2014 2593 3150 ...
    ## tibble [13 × 1] (S3: tbl_df/tbl/data.frame)
    ##  $ 3: num [1:13] 961 1467 1959 2522 3065 ...
    ## tibble [13 × 1] (S3: tbl_df/tbl/data.frame)
    ##  $ 4: num [1:13] 1026 1558 2089 2693 3266 ...
    ## tibble [13 × 1] (S3: tbl_df/tbl/data.frame)
    ##  $ 5: num [1:13] 992 1510 2021 2604 3162 ...
    ## tibble [13 × 1] (S3: tbl_df/tbl/data.frame)
    ##  $ 6: num [1:13] 961 1468 1960 2523 3066 ...
    ## tibble [13 × 1] (S3: tbl_df/tbl/data.frame)
    ##  $ 7: num [1:13] 996 1516 2030 2615 3175 ...
    ## tibble [13 × 1] (S3: tbl_df/tbl/data.frame)
    ##  $ 8: num [1:13] 1003 1526 2043 2633 3195 ...
    ## tibble [13 × 1] (S3: tbl_df/tbl/data.frame)
    ##  $ 9: num [1:13] 998 1520 2034 2621 3182 ...
    ## tibble [13 × 1] (S3: tbl_df/tbl/data.frame)
    ##  $ 10: num [1:13] 975 1487 1988 2559 3109 ...

``` r
MC_mass_diffs  <-  MC_mass_diffs %>% 
    select(-MC_mass_diffs)

names(MC_mass_diffs)[0] <-  "age_yrs"

#transpose the table -- result is a matrix
MC_mass_diffs <- t(MC_mass_diffs)

#convert to tibble
MC_mass_diffs_t <- as_tibble(MC_mass_diffs)

#save calculated mass diffs to file
MC_mass_diffs_t %>% write_csv("data/MC_mass_diffs_t.csv", na = "", append = FALSE)


####################################################################
##### Calulate mean  mass change (not sex-specific) across all columns (ages)

mean_masschange <- MC_mass_diffs_t %>% summarise_all(funs(mean))

kable(head(mean_masschange))
```

| V1 | V2 | V3 | V4 | V5 | V6 | V7 | V8 | V9 | V10 | V11 | V12 | V13 |
|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 986.566 | 516.6026 | 507.6841 | 578.9767 | 555.4428 | 552.6109 | 503.338 | 481.637 | 439.6587 | 385.3029 | 322.8964 | 132.2494 | 136.6101 |

``` r
mean_masschange <-  t(mean_masschange)

mean_masschange <- as_tibble(mean_masschange)
colnames(mean_masschange)[colnames(mean_masschange)=="V1"] <- "mean_masschange"

mean_masschange$age_yrs <- MC_mass$age_yrs
mean_masschange <- mean_masschange %>%
  dplyr::select(age_yrs, everything())

#calculate sd for mass changes across all columns (ages)
sd_masschange <- MC_mass_diffs_t %>% summarise_all(funs(sd))
sd_masschange <-  t(sd_masschange)

sd_masschange <- as_tibble(sd_masschange)
colnames(sd_masschange)[colnames(sd_masschange)=="V1"] <- "sd_masschange"

mean_masschange$sd_masschange <- sd_masschange$sd_masschange
mean_masschange$sex <- "N/A"


###########################################################################
# Calculate mass change for females

MC_female_mass = NA

for (i in seq(from = 0, to = 12, by = 1)){  #step by 0.5 mths
    
    age_tibble <- age_yr_tibble %>% filter(age_mth == i)  
    age <- age_tibble$age_yrs   #calculate age_yrs (do not round up)
    
    strcolname <- as.character(age)
    
    pred_mass_i <- filter(pred_mass, age_yrs == age)
    
    mass <- pred_mass_i$female_mass
    sd <- pred_mass_i$sd_mass
    
    set.seed(1)
    mass_i <- as_tibble(rnorm(MC_reps, mass, sd), col.names = str(i))
    names(mass_i)[1] <- strcolname
    
    mass_i <- mass_i %>%  dplyr::mutate(ID = row_number())
    
    #transpose the dataframe -- result is a matrix
    mass_i <-  t(mass_i)    
    
    #make ID the column name, then remove the unneeded row
    colnames(mass_i) <- unlist(mass_i[row.names(mass_i)=='ID',])
    mass_i  <- mass_i[!row.names(mass_i)=='ID',]
    
    #turn matrix into data frame (need to include the t() to keep the matrix format)
    mass_i <- as_tibble(t(mass_i))
    
    mass_i$age_yrs <- age
    
    mass_i$age_mth <- i
    
    MC_female_mass <- rbind(MC_female_mass, mass_i)
    
    
}

# move age_yrs to first column
MC_female_mass <- MC_female_mass %>%
  dplyr::select(age_yrs, everything())

MC_female_mass = MC_female_mass[-1,]

head(MC_female_mass)
```

    ## # A tibble: 6 × 12
    ##   age_yrs   `1`   `2`   `3`   `4`   `5`   `6`   `7`   `8`   `9`  `10` age_mth
    ##     <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>   <dbl>
    ## 1  0       994. 1016.  989. 1054. 1020.  989. 1024. 1031. 1026. 1003.       0
    ## 2  0.0849 1518. 1548. 1510. 1600. 1553. 1510. 1559. 1568. 1562. 1530.       1
    ## 3  0.162  2028. 2071. 2016. 2146. 2078. 2017. 2087. 2100. 2092. 2045.       2
    ## 4  0.247  2610. 2667. 2595. 2767. 2677. 2596. 2688. 2706. 2695. 2632.       3
    ## 5  0.329  3172. 3239. 3154. 3356. 3251. 3156. 3264. 3285. 3271. 3198.       4
    ## 6  0.414  3734. 3808. 3715. 3936. 3821. 3716. 3835. 3858. 3843. 3763.       5

``` r
MC_female_mass_diffs <- NA

#### Calculate mass change for females
##first row must start at 0 because no chnange in mass from 0 to 0
M_nb <- pred_mass %>% filter(age_yrs == 0) 
    

for (i in seq(from = 1, to = MC_reps, by = 1)){
    
    colnumber = i
    colname = as.character(colnumber)
    
    #mass_chg <- rnorm(1, M_nb$mean_mass, M_nb$sd_mass)     
    mass_chg_Female <- MC_mass %>% 
        dplyr::filter(age_yrs == 0) %>% 
        dplyr::select(colname)
    delta_mass <- mass_chg_Female 
        
    delta_mass <- as.data.frame(mass_chg_Female) 
    names(delta_mass)[1] <- colname
    
    mass_column <- MC_female_mass %>% 
        dplyr:: select(colname)     
    
    str(mass_column)
    
    diffs_mass_Female <-  diff(as.matrix(mass_column))  #calculate delta mass
    diffs_mass_Female <- as.data.frame(diffs_mass_Female) 
    names(diffs_mass_Female)[1] <- as.character(colname)
    
    head(diffs_mass_Female)
    
    mass_chg_Female <- rbind(delta_mass, diffs_mass_Female) 
    head(mass_chg_Female)
    MC_female_mass_diffs <-cbind(MC_female_mass_diffs, mass_chg_Female) 

}
```

    ## tibble [13 × 1] (S3: tbl_df/tbl/data.frame)
    ##  $ 1: num [1:13] 994 1518 2028 2610 3172 ...
    ## tibble [13 × 1] (S3: tbl_df/tbl/data.frame)
    ##  $ 2: num [1:13] 1016 1548 2071 2667 3239 ...
    ## tibble [13 × 1] (S3: tbl_df/tbl/data.frame)
    ##  $ 3: num [1:13] 989 1510 2016 2595 3154 ...
    ## tibble [13 × 1] (S3: tbl_df/tbl/data.frame)
    ##  $ 4: num [1:13] 1054 1600 2146 2767 3356 ...
    ## tibble [13 × 1] (S3: tbl_df/tbl/data.frame)
    ##  $ 5: num [1:13] 1020 1553 2078 2677 3251 ...
    ## tibble [13 × 1] (S3: tbl_df/tbl/data.frame)
    ##  $ 6: num [1:13] 989 1510 2017 2596 3156 ...
    ## tibble [13 × 1] (S3: tbl_df/tbl/data.frame)
    ##  $ 7: num [1:13] 1024 1559 2087 2688 3264 ...
    ## tibble [13 × 1] (S3: tbl_df/tbl/data.frame)
    ##  $ 8: num [1:13] 1031 1568 2100 2706 3285 ...
    ## tibble [13 × 1] (S3: tbl_df/tbl/data.frame)
    ##  $ 9: num [1:13] 1026 1562 2092 2695 3271 ...
    ## tibble [13 × 1] (S3: tbl_df/tbl/data.frame)
    ##  $ 10: num [1:13] 1003 1530 2045 2632 3198 ...

``` r
MC_female_mass_diffs  <-  MC_female_mass_diffs %>% 
    dplyr::select(-(MC_female_mass_diffs))

#add the age column and move to front
MC_female_mass_diffs$age_yrs <- MC_female_mass$age_yrs
MC_female_mass_diffs <- MC_female_mass_diffs %>%
  relocate(age_yrs)


# transpose matrix of mass_diffs
MC_female_mass_diffs <- t(MC_female_mass_diffs)

#convert to tibble
MC_female_mass_diffs_t <- MC_female_mass_diffs %>% as_tibble()

#save calculated mass diffs to file
MC_female_mass_diffs_t %>% write_csv("data/MC_female_mass_diffs_t.csv", na = "", append = FALSE)


#calculate mean mass changes across all columns (ages)
mean_masschange_female <- MC_female_mass_diffs_t %>% summarise_all(funs(mean))

kable(head(mean_masschange_female))
```

| V1 | V2 | V3 | V4 | V5 | V6 | V7 | V8 | V9 | V10 | V11 | V12 | V13 |
|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 896.8782 | 482.9883 | 474.6371 | 541.2981 | 519.3193 | 516.6931 | 470.6536 | 450.3801 | 411.1385 | 360.3104 | 301.5746 | 123.7499 | 127.8366 |

``` r
mean_masschange_female <-  t(mean_masschange_female)

mean_masschange_female <- as_tibble(mean_masschange_female)
colnames(mean_masschange_female)[colnames(mean_masschange_female)=="V1"] <- "mean_masschange"

mean_masschange_female$age_yrs <- MC_female_mass$age_yrs
mean_masschange_female <- mean_masschange_female %>%
  dplyr::select(age_yrs, everything())

#calculate sd for mass changes across all columns (ages)
sd_masschange_female <- MC_female_mass_diffs_t %>% summarise_all(funs(sd))
sd_masschange_female <-  t(sd_masschange_female)

sd_masschange_female <- as_tibble(sd_masschange_female)
colnames(sd_masschange_female)[colnames(sd_masschange_female)=="V1"] <- "sd_masschange"

mean_masschange_female$sd_masschange <- sd_masschange_female$sd_masschange
mean_masschange_female$sex <- "Female"



####################################################################
##### Calulate mass change for males
MC_male_mass = NA

for (i in seq(from = 0, to = 12, by = 1)){  #step by 0.5 mths
    
    age_tibble <- age_yr_tibble %>% filter(age_mth == i)  
    age <- age_tibble$age_yrs   #calculate age_yrs (do not round up)
    
    strcolname <- as.character(age)
    
    pred_mass_i <- filter(pred_mass, age_yrs == age)
    
    mass <- pred_mass_i$male_mass
    sd <- pred_mass_i$sd_mass
    
    set.seed(1)
    mass_i <- as_tibble(rnorm(MC_reps, mass, sd), col.names = str(i))
    names(mass_i)[1] <- strcolname
    
    mass_i <- mass_i %>%  dplyr::mutate(ID = row_number())
    
    #transpose the dataframe -- result is a matrix
    mass_i <-  t(mass_i)    
    
    #make ID the column name, then remove the unneeded row
    colnames(mass_i) <- unlist(mass_i[row.names(mass_i)=='ID',])
    mass_i  <- mass_i[!row.names(mass_i)=='ID',]
    
    #turn matrix into data frame (need to include the t() to keep the matrix format)
    mass_i <- as_tibble(t(mass_i))
    
    mass_i$age_yrs <- age
    
    mass_i$age_mth <- i
    
    MC_male_mass <- rbind(MC_male_mass, mass_i)
    
    
}

# move age_yrs to first column
MC_male_mass <- MC_male_mass %>%
  relocate(age_yrs)

MC_male_mass = MC_male_mass[-1,]

head(MC_male_mass)
```

    ## # A tibble: 6 × 12
    ##   age_yrs   `1`   `2`   `3`   `4`   `5`   `6`   `7`   `8`   `9`  `10` age_mth
    ##     <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>   <dbl>
    ## 1  0       951.  972.  945. 1010.  976.  945.  980.  987.  983.  959.       0
    ## 2  0.0849 1451. 1481. 1443. 1534. 1487. 1444. 1493. 1502. 1496. 1463.       1
    ## 3  0.162  1939. 1982. 1927. 2057. 1989. 1928. 1998. 2011. 2003. 1956.       2
    ## 4  0.247  2495. 2552. 2480. 2652. 2563. 2482. 2574. 2591. 2580. 2518.       3
    ## 5  0.329  3033. 3100. 3015. 3216. 3112. 3017. 3125. 3145. 3132. 3059.       4
    ## 6  0.414  3570. 3644. 3551. 3772. 3657. 3553. 3671. 3694. 3679. 3599.       5

``` r
MC_male_mass_diffs <- NA

#### Calculate mass change for males
##first row must start at 0 because no chnange in mass from 0 to 0


for (i in seq(from = 1, to = MC_reps, by = 1)){
    
    colnumber = i
    colname = as.character(colnumber)
    
    #mass_chg <- rnorm(1, M_nb$mean_mass, M_nb$sd_mass)     
    mass_chg_male <- MC_mass %>% 
        dplyr::filter(age_yrs == 0) %>% 
        dplyr::select(colname)
    delta_mass <- mass_chg_male 
    
    
    delta_mass <- as.data.frame(mass_chg_male) 
    names(delta_mass)[1] <- colname
    
    mass_column <- MC_male_mass %>% 
        dplyr:: select(colname)     
    
    str(mass_column)
    
    diffs_mass_male <-  diff(as.matrix(mass_column))  #calculate delta mass
    diffs_mass_male <- as.data.frame(diffs_mass_male) 
    names(diffs_mass_male)[1] <- as.character(colname)
    
    head(diffs_mass_male)
    
    mass_chg_male <- rbind(delta_mass, diffs_mass_male) 
    head(mass_chg_male)
    MC_male_mass_diffs <-cbind(MC_male_mass_diffs, mass_chg_male) 

}
```

    ## tibble [13 × 1] (S3: tbl_df/tbl/data.frame)
    ##  $ 1: num [1:13] 951 1451 1939 2495 3033 ...
    ## tibble [13 × 1] (S3: tbl_df/tbl/data.frame)
    ##  $ 2: num [1:13] 972 1481 1982 2552 3100 ...
    ## tibble [13 × 1] (S3: tbl_df/tbl/data.frame)
    ##  $ 3: num [1:13] 945 1443 1927 2480 3015 ...
    ## tibble [13 × 1] (S3: tbl_df/tbl/data.frame)
    ##  $ 4: num [1:13] 1010 1534 2057 2652 3216 ...
    ## tibble [13 × 1] (S3: tbl_df/tbl/data.frame)
    ##  $ 5: num [1:13] 976 1487 1989 2563 3112 ...
    ## tibble [13 × 1] (S3: tbl_df/tbl/data.frame)
    ##  $ 6: num [1:13] 945 1444 1928 2482 3017 ...
    ## tibble [13 × 1] (S3: tbl_df/tbl/data.frame)
    ##  $ 7: num [1:13] 980 1493 1998 2574 3125 ...
    ## tibble [13 × 1] (S3: tbl_df/tbl/data.frame)
    ##  $ 8: num [1:13] 987 1502 2011 2591 3145 ...
    ## tibble [13 × 1] (S3: tbl_df/tbl/data.frame)
    ##  $ 9: num [1:13] 983 1496 2003 2580 3132 ...
    ## tibble [13 × 1] (S3: tbl_df/tbl/data.frame)
    ##  $ 10: num [1:13] 959 1463 1956 2518 3059 ...

``` r
MC_male_mass_diffs  <-  MC_male_mass_diffs %>% 
    dplyr::select(-(MC_male_mass_diffs))

# add the age column and move to front
MC_male_mass_diffs$age_yrs <- MC_male_mass$age_yrs
MC_male_mass_diffs <- MC_male_mass_diffs %>%
  relocate(age_yrs)


# transpose table of mass diffs
MC_male_mass_diffs <- t(MC_male_mass_diffs)

# convert to tibble
MC_male_mass_diffs_t <- MC_male_mass_diffs %>% as_tibble()

# save calculated mass diffs to file
MC_male_mass_diffs_t %>% write_csv("data/MC_male_mass_diffs_t.csv", na = "", append = FALSE)


# calculate mean mass changes across all columns (ages)
mean_masschange_male <- MC_male_mass_diffs_t %>% summarise_all(funs(mean))

kable(head(mean_masschange_male))
```

| V1 | V2 | V3 | V4 | V5 | V6 | V7 | V8 | V9 | V10 | V11 | V12 | V13 |
|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 896.8782 | 462.1864 | 454.2257 | 518.015 | 496.9588 | 494.4255 | 450.3402 | 430.9289 | 393.3825 | 344.7703 | 289.1689 | 118.3864 | 122.2943 |

``` r
mean_masschange_male <-  t(mean_masschange_male)

mean_masschange_male <- as_tibble(mean_masschange_male)
colnames(mean_masschange_male)[colnames(mean_masschange_male)=="V1"] <- "mean_masschange"

mean_masschange_male$age_yrs <- MC_male_mass$age_yrs
mean_masschange_male <- mean_masschange_male %>%
  relocate(age_yrs)

#calculate sd for mass changes across all columns (ages)
sd_masschange_male <- MC_male_mass_diffs_t %>% summarise_all(funs(sd))
sd_masschange_male <-  t(sd_masschange_male)

sd_masschange_male <- as_tibble(sd_masschange_male)
colnames(sd_masschange_male)[colnames(sd_masschange_male)=="V1"] <- "sd_masschange"

mean_masschange_male$sd_masschange <- sd_masschange_male$sd_masschange
mean_masschange_male$sex <- "Male"
```

Combine mass change tables into one for plotting

``` r
mean_masschange <- rbind(mean_masschange, mean_masschange_female, mean_masschange_male)

kable(mean_masschange)
```

|   age_yrs | mean_masschange | sd_masschange | sex    |
|----------:|----------------:|--------------:|:-------|
| 0.0000000 |        986.5660 |    20.8944895 | N/A    |
| 0.0849315 |        516.6026 |     8.0991611 | N/A    |
| 0.1616438 |        507.6841 |    12.5481058 | N/A    |
| 0.2465753 |        578.9767 |    13.5292261 | N/A    |
| 0.3287671 |        555.4428 |     9.5046028 | N/A    |
| 0.4136986 |        552.6109 |     6.3680569 | N/A    |
| 0.4958904 |        503.3380 |     1.2286994 | N/A    |
| 0.5808219 |        481.6370 |     0.8153022 | N/A    |
| 0.6657534 |        439.6587 |     0.7704506 | N/A    |
| 0.7479452 |        385.3029 |     2.3579711 | N/A    |
| 0.8328767 |        322.8964 |    92.2594101 | N/A    |
| 0.9150685 |        132.2494 |     3.5075607 | N/A    |
| 1.0000000 |        136.6101 |     3.9314679 | N/A    |
| 0.0000000 |        896.8782 |   298.1205645 | Female |
| 0.0849315 |        482.9883 |   160.3451310 | Female |
| 0.1616438 |        474.6371 |   157.8153295 | Female |
| 0.2465753 |        541.2981 |   179.9049106 | Female |
| 0.3287671 |        519.3193 |   172.3656943 | Female |
| 0.4136986 |        516.6931 |   171.3370316 | Female |
| 0.4958904 |        470.6536 |   155.9380131 | Female |
| 0.5808219 |        450.3801 |   149.1835505 | Female |
| 0.6657534 |        411.1385 |   136.1403832 | Female |
| 0.7479452 |        360.3104 |   119.2743572 | Female |
| 0.8328767 |        301.5746 |   132.7012964 | Female |
| 0.9150685 |        123.7499 |    40.8753621 | Female |
| 1.0000000 |        127.8366 |    42.2319711 | Female |
| 0.0000000 |        896.8782 |   298.1205645 | Male   |
| 0.0849315 |        462.1864 |   153.4541937 | Male   |
| 0.1616438 |        454.2257 |   151.0657731 | Male   |
| 0.2465753 |        518.0150 |   172.2033421 | Male   |
| 0.3287671 |        496.9588 |   164.9601828 | Male   |
| 0.4136986 |        494.4255 |   163.9565150 | Male   |
| 0.4958904 |        450.3402 |   149.2010301 | Male   |
| 0.5808219 |        430.9289 |   142.7324141 | Male   |
| 0.6657534 |        393.3825 |   130.2514583 | Male   |
| 0.7479452 |        344.7703 |   114.1212389 | Male   |
| 0.8328767 |        289.1689 |   129.6370282 | Male   |
| 0.9150685 |        118.3864 |    39.1026894 | Male   |
| 1.0000000 |        122.2943 |    40.4012813 | Male   |

``` r
#keep this 
mean_masschange$age_mth <- round(mean_masschange$age_yrs * 12)

mean_masschange %>% write_csv("data/mean_masschange.csv", na = "", append = FALSE)

mean_masschange <- as_tibble(read_csv("data/mean_masschange.csv"))
```

    ## Rows: 39 Columns: 5
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr (1): sex
    ## dbl (4): age_yrs, mean_masschange, sd_masschange, age_mth
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

Mean mass change by sex
![](mass_change_per_month_files/figure-gfm/plot%20mean%20mass%20change%20by%20sex-1.png)<!-- -->

Mean mass change (not sex-specific)

![](mass_change_per_month_files/figure-gfm/plot%20mean%20mass%20change%20NA-1.png)<!-- -->![](mass_change_per_month_files/figure-gfm/plot%20mean%20mass%20change%20NA-2.png)<!-- -->
