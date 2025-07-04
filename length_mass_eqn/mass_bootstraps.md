Mass Bootstraps
================
Selina Agbayani
November 8, 2018, updated and cleaned July 3, 2025

``` r
############ Set path for output figures: ###############
Figurespath <- paste0(getwd(), "/length_mass_eqn/figures", collapse = NULL)
Figurespath
```

    ## [1] "C:/Users/AgbayaniS/Documents/R/graywhale_energyreqs/length_mass_eqn/figures"

``` r
############ Set path for input & output data  ###########
datapath <- paste0(getwd(), "/data", collapse = NULL) 
```

**GREY WHALE LENGTHS AT AGE DATASET**

``` r
#Read in data for predicted lengths per age step (data from Agbayani et al. 2020)  
gw_pred_lengths <- as_tibble(
  read_csv("data/gw_predicted_phases_1_2_mthsversion_Feb2021.csv"),
  col_types = cols(age_yrs = col_double(),
                         fit = col_double(),
                         mean = col_double(),
                         sd = col_double(),
                         median = col_double(),
                         median_abs_dev = col_double(),
                         `2.5%` = col_double(),
                         `97.5%` = col_double(),
                         length_plus_sd = col_double(),
                         length_minus_sd = col_double()
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
#Read in data for observed age, mass, and length for non-pregnant gray whales 
gw_obs_mass_length_nonpreg <- as_tibble(
  read_csv("data/gw_obs_mass_length_nonpreg.csv",
           col_types = cols(ID = col_integer(),
                             sex = col_character(),
                             age_yrs = col_double(),
                             age_mths = col_double(),
                             age_wks = col_integer(),
                             length_m = col_double(),
                             girth_m = col_double(),
                             mass_kg_x_1000 = col_double(),
                             mass_kg = col_double(),
                             Details = col_character(),
                             source = col_character()
                            )
           )
  )

#Read in age tibble for the first 12 months for Phase 1
age_yr_tibble <- as_tibble(
  read_csv("data/age_yr_tibble.csv"), 
  col_types = cols(ID = col_integer(),
                   month = col_character(),
                   no_days_in_mth = col_double(),
                   age_mth = col_double(),
                   no_days_cumul = col_double(),
                   age_yrs = col_double()
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

*Fitting the mass/length data to a linear model*

``` r
#Calculate log base 10 for lengths and masss
gw_obs_mass_length_nonpreg$log10_length_m <- log10(gw_obs_mass_length_nonpreg$length_m)

gw_obs_mass_length_nonpreg$log10_mass_kg <- log10(gw_obs_mass_length_nonpreg$mass_kg)

#assign variable names to columns
log10_length_m <- gw_obs_mass_length_nonpreg$log10_length_m
log10_mass_kg <- gw_obs_mass_length_nonpreg$log10_mass_kg
length_m <- gw_obs_mass_length_nonpreg$length_m
mass_kg <- gw_obs_mass_length_nonpreg$mass_kg

kable(head(gw_obs_mass_length_nonpreg))
```

| ID | sex | age_yrs | age_mths | age_wks | length_m | girth_m | mass_kg_x_1000 | mass_kg | Details | source | log10_length_m | log10_mass_kg |
|---:|:---|---:|---:|---:|---:|---:|---:|---:|:---|:---|---:|---:|
| 4 | Male | NA | NA | NA | 11.720 | 6.00 | 15.686 | 15686 | NA | Rice and Wolman (1971) | 1.0689276 | 4.195512 |
| 5 | Male | NA | NA | NA | 12.400 | 5.50 | 16.594 | 16594 | NA | Rice and Wolman (1971) | 1.0934217 | 4.219951 |
| 7 | Unknown | NA | NA | NA | 8.534 | NA | 6.632 | 6632 | 28 feet | Gilmore (1961); Rice and Wolman (1971) | 0.9311526 | 3.821645 |
| 8 | Male | NA | NA | NA | 9.650 | 5.00 | 8.808 | 8808 | NA | Rice and Wolman (1971) | 0.9845273 | 3.944877 |
| 9 | Male | NA | NA | NA | 9.900 | 4.80 | 8.876 | 8876 | NA | Rice and Wolman (1971) | 0.9956352 | 3.948217 |
| 14 | Male | NA | NA | NA | 8.660 | 4.52 | 5.550 | 5550 | NA | Sumich (1986)- cited J.Harvey pers.comm | 0.9375179 | 3.744293 |

``` r
#fit linear model
lm_log10 <- lm(log10_mass_kg ~ log10_length_m)

#code above is equivalent to : lm_log10 <- lm(log10(mass_kg) ~ log10(length_m))

summary(lm_log10)
```

    ## 
    ## Call:
    ## lm(formula = log10_mass_kg ~ log10_length_m)
    ## 
    ## Residuals:
    ##      Min       1Q   Median       3Q      Max 
    ## -0.11144 -0.05568  0.00425  0.04750  0.12669 
    ## 
    ## Coefficients:
    ##                Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)      1.0354     0.1590   6.511 1.97e-05 ***
    ## log10_length_m   2.9509     0.1693  17.427 2.14e-10 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 0.07205 on 13 degrees of freedom
    ## Multiple R-squared:  0.9589, Adjusted R-squared:  0.9558 
    ## F-statistic: 303.7 on 1 and 13 DF,  p-value: 2.143e-10

``` r
# ## COMMENTED RESULTS FOR CONSISTENCY CHECK ####
# ## Call:
# ## lm(formula = log10_mass_kg ~ log10_length_m)
# ## 
# ## Residuals:
# ##      Min       1Q   Median       3Q      Max 
# ## -0.11144 -0.05568  0.00425  0.04750  0.12669 
# ## 
# ## Coefficients:
# ##                Estimate Std. Error t value Pr(>|t|)    
# ## (Intercept)      1.0354     0.1590   6.511 1.97e-05 ***
# ## log10_length_m   2.9509     0.1693  17.427 2.14e-10 ***
# ## ---
# ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
# ## 
# ## Residual standard error: 0.07205 on 13 degrees of freedom
# ## Multiple R-squared:  0.9589, Adjusted R-squared:  0.9558 
# ## F-statistic: 303.7 on 1 and 13 DF,  p-value: 2.143e-10
```

Create blank mass table

``` r
kable(head(gw_pred_lengths))
```

| age_yrs | fit | mean | sd | median | median_abs_dev | 2.5% | 97.5% | length_plus_sd | length_minus_sd |
|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 0.0000000 | 4.604509 | 4.586824 | 0.0430322 | 4.589779 | 0.0400501 | 4.493371 | 4.663257 | 4.647541 | 4.561477 |
| 0.0424658 | 4.971841 | 4.954376 | 0.0416372 | 4.957798 | 0.0380220 | 4.862800 | 5.025079 | 5.013478 | 4.930204 |
| 0.0849315 | 5.311469 | 5.294078 | 0.0451925 | 5.299534 | 0.0383599 | 5.189143 | 5.365944 | 5.356661 | 5.266276 |
| 0.1232877 | 5.596158 | 5.578779 | 0.0497288 | 5.586360 | 0.0406154 | 5.456699 | 5.653083 | 5.645887 | 5.546430 |
| 0.1616438 | 5.861382 | 5.843995 | 0.0534279 | 5.852798 | 0.0435037 | 5.713240 | 5.922023 | 5.914809 | 5.807953 |
| 0.2041096 | 6.133920 | 6.116466 | 0.0572376 | 6.127505 | 0.0462704 | 5.976218 | 6.197729 | 6.191158 | 6.076682 |

``` r
# Create blank data frame for age and predicted length data 
gw_pred_length_mass <- as.data.frame(gw_pred_lengths$age_yrs)
names(gw_pred_length_mass)[1] <-  "age_yrs"
gw_pred_length_mass$length_m <- gw_pred_lengths$fit 
gw_pred_length_mass$length_sd <- gw_pred_lengths$sd

kable(head(gw_pred_length_mass))
```

|   age_yrs | length_m | length_sd |
|----------:|---------:|----------:|
| 0.0000000 | 4.604509 | 0.0430322 |
| 0.0424658 | 4.971841 | 0.0416372 |
| 0.0849315 | 5.311469 | 0.0451925 |
| 0.1232877 | 5.596158 | 0.0497288 |
| 0.1616438 | 5.861382 | 0.0534279 |
| 0.2041096 | 6.133920 | 0.0572376 |

``` r
# Create blank data frame for age and predicted mass data 
mass_table <- as.data.frame(matrix(ncol = 7, nrow = 0))

cnames <- c("age_yrs", "mass_kg", "mass_sd", 
            "mean_lwr", "mean_upr",       #mean value of 95% CI from predict lm
            "quant025", "quant975"        #2.5% and 97.5% quantile from bootstrap estimates 
            # "calc_025CI", "calc_975CI"  #calculates 95% CI from mass_sd and sample size
            )                             
                                          # calc_025CI and calc_975CI not used 
                                          # because not sure what sample size to use
                                          # i.e. no. bootsrap replicates (10000)?
                                          # or original sample for lm? 14 whales                                            
colnames(mass_table) <- cnames

mass_table <- as.data.frame(mass_table,
                        col_types = list(age_yrs = col_double(),
                                         mass_kg = col_double(),
                                         mass_sd = col_double(),
                                         mean_lwr = col_double(),
                                         mean_upr = col_double(),
                                         quant025 = col_double(),
                                         quant975 = col_double()                    
                                         )
                        )

kable(head(mass_table))
```

| age_yrs | mass_kg | mass_sd | mean_lwr | mean_upr | quant025 | quant975 |
|:--------|:--------|:--------|:---------|:---------|:---------|:---------|

Predicting mass per year from linear model for first 12 months

``` r
# Predict mass 10,000 times per age step, and calculate the mean, 
# sd, lwr, upr and quantiles

age_list <- age_yr_tibble$age_yrs

for (i in age_list){  #step by 0.5 mths
    
    age <- i   #calculate age_yrs (do not round up)

    lengths_at_age <- gw_pred_lengths %>% filter(round(age_yrs,3) == round(age,3))
    
    len <- lengths_at_age$fit
    sd <- lengths_at_age$sd
    
    set.seed(1234)
    pred_lengths <- as.data.frame(rnorm(10000, len, sd))
    names(pred_lengths)[1]<-"length_m"

    pred_lengths$log10_length_m <- log10(pred_lengths$length_m)
    
    predicted_mass <- as.data.frame(predict.lm(object = lm_log10, 
                                       newdata = pred_lengths,
                                       interval = "confidence",
                                       level = 0.95
                                       )
                               )  
    
    pred_lengths$mass_kg <- 10^predicted_mass$fit
    pred_lengths$mass_lwr <- 10^predicted_mass$lwr
    pred_lengths$mass_upr <- 10^predicted_mass$upr
    
    mean_mass <-  mean(pred_lengths$mass_kg)
    sd_mass <- sd(pred_lengths$mass_kg)
    mean_lwr <- mean(pred_lengths$mass_lwr)
    mean_upr <- mean(pred_lengths$mass_upr)
    quant025 <- quantile(pred_lengths$mass_kg, 0.025, na.rm = TRUE)
    quant975 <- quantile(pred_lengths$mass_kg, 0.975, na.rm = TRUE)
    # calc_025CI <- mean_mass - 1.96 * (sd_mass/sqrt(14))  #z-score at 95% = 1.96
    # calc_975CI <- mean_mass + 1.96 * (sd_mass/sqrt(14))
    
    age_yrs = age
    
    # create new row of predicted mass data for each age step
    row <- NULL
    row <- as_tibble(cbind(age_yrs, mean_mass, sd_mass, 
                           mean_lwr, mean_upr, 
                           quant025, quant975
                           #calc_025CI,calc_975CI
                           )
                     )
    # append new row of predicted mass data for each age step
    mass_table <- rbind(mass_table, row)

}


mass_table <- mass_table %>% filter(!is.na(mean_mass))

kable(head(mass_table))
```

|   age_yrs | mean_mass |  sd_mass |  mean_lwr | mean_upr |  quant025 | quant975 |
|----------:|----------:|---------:|----------:|---------:|----------:|---------:|
| 0.0000000 |  983.0272 | 26.76770 |  769.3864 | 1256.003 |  931.5244 | 1036.295 |
| 0.0424658 | 1232.8231 | 30.08225 |  990.0386 | 1535.157 | 1174.8634 | 1292.607 |
| 0.0849315 | 1498.2581 | 37.14344 | 1229.5370 | 1825.723 | 1426.7071 | 1572.089 |
| 0.1232877 | 1747.8713 | 45.25512 | 1458.4778 | 2094.703 | 1660.7409 | 1837.873 |
| 0.1616438 | 2003.8171 | 53.21868 | 1696.1860 | 2367.260 | 1901.3875 | 2109.690 |
| 0.2041096 | 2291.4431 | 62.29993 | 1966.1135 | 2670.624 | 2171.5715 | 2415.419 |

Predicting mass per year from linear model for ages \>1 yr

``` r
# Predict mass 10,000 times per age step (0.5 yrs), and calculate the mean, 
# sd, lwr, upr and quantiles

for (i in seq(from = 1.5, to = 75, by = 0.5)){
    age <-  i 
    
    lengths_at_age <- filter(gw_pred_lengths, age_yrs == age)
    
    len <- lengths_at_age$fit
    sd <- lengths_at_age$sd
    
    set.seed(1234)
    pred_lengths <- as.data.frame(rnorm(10000, len, sd))
    names(pred_lengths)[1]<-"length_m"

    pred_lengths$log10_length_m <- log10(pred_lengths$length_m)
    
    predicted_mass <- as.data.frame(predict.lm(object = lm_log10, 
                                       newdata = pred_lengths, 
                                       interval = "confidence",
                                       level = 0.95
                                       )
                               )  
    
    pred_lengths$mass_kg <- 10^predicted_mass$fit
    pred_lengths$mass_lwr <- 10^predicted_mass$lwr
    pred_lengths$mass_upr <- 10^predicted_mass$upr
    
    mean_mass <-  mean(pred_lengths$mass_kg)
    sd_mass <- sd(pred_lengths$mass_kg)
    mean_lwr <- mean(pred_lengths$mass_lwr)
    mean_upr <- mean(pred_lengths$mass_upr)
    quant025 <- quantile(pred_lengths$mass_kg, 0.025, na.rm = TRUE)
    quant975 <- quantile(pred_lengths$mass_kg, 0.975, na.rm = TRUE)
    #calc_025CI <- mean_mass - 1.96 * (sd_mass/sqrt(14))  #z-score at 95% = 1.96. what n?
    #calc_975CI <- mean_mass + 1.96 * (sd_mass/sqrt(14))
    
    age_yrs = age
    
    # create new row of predicted mass data for each age step
    row <- NULL
    row <- as_tibble(cbind(age_yrs, mean_mass, sd_mass, 
                               mean_lwr, mean_upr, 
                               quant025, quant975
                               #calc_025CI,calc_975CI
                               )
                         )
    # append new row of predicted mass data for each age step
    mass_table <- rbind(mass_table, row)
}


kable(head(mass_table))
```

|   age_yrs | mean_mass |  sd_mass |  mean_lwr | mean_upr |  quant025 | quant975 |
|----------:|----------:|---------:|----------:|---------:|----------:|---------:|
| 0.0000000 |  983.0272 | 26.76770 |  769.3864 | 1256.003 |  931.5244 | 1036.295 |
| 0.0424658 | 1232.8231 | 30.08225 |  990.0386 | 1535.157 | 1174.8634 | 1292.607 |
| 0.0849315 | 1498.2581 | 37.14344 | 1229.5370 | 1825.723 | 1426.7071 | 1572.089 |
| 0.1232877 | 1747.8713 | 45.25512 | 1458.4778 | 2094.703 | 1660.7409 | 1837.873 |
| 0.1616438 | 2003.8171 | 53.21868 | 1696.1860 | 2367.260 | 1901.3875 | 2109.690 |
| 0.2041096 | 2291.4431 | 62.29993 | 1966.1135 | 2670.624 | 2171.5715 | 2415.419 |

*Plotting mass data onto graphs*

![](mass_bootstraps_files/figure-gfm/mass%20plots-1.png)<!-- -->![](mass_bootstraps_files/figure-gfm/mass%20plots-2.png)<!-- -->

*Plotting sex-specific mass curves*

``` r
# Percent diffs between measured predicted lengths 
# Correction factors for sexual dimorphism (data from Agbayani et al. 2020)

# --------------- PHASE 1 (< 1.5yr) ---------------
# if means are aggregated by year
# |sex     | mean_delta_length| mean_percent_diffs| sd_percent_diffs|
# |:-------|-----------------:|------------------:|----------------:|
# |Female  |         0.2875647|           4.141169|        0.0026405|
# |Male    |         0.3486719|           3.661017|        5.4187345|
# |Unknown |         0.9316482|          14.413196|       18.7861008|


# --------------- PHASE 2 (> 1.5yr) ---------------
# |sex     | mean_delta_length| mean_percent_diffs| sd_percent_diffs|
# |:-------|-----------------:|------------------:|----------------:|
# |Female  |         0.3754025|           2.848439|         3.004057|
# |Male    |        -0.1940471|          -1.592700|         3.330088|
# |Unknown |         0.1376889|           1.445391|         1.574740|

corr_factor_phase1f = (100+4.141169)/100
corr_factor_phase1m = (100+3.3600778)/100
corr_factor_phase2f = (100+2.848439)/100
corr_factor_phase2m = (100-1.592700)/100


mean_mass <- mass_table$mean_mass 

mass_table$female_mass <- mean_mass * corr_factor_phase2f # mean mass x 102.85 %
mass_table$male_mass <- mean_mass * corr_factor_phase2m   # mean mass x 98.4 %

female_mass <- mass_table$female_mass
male_mass <- mass_table$male_mass

kable(head(mass_table))
```

| age_yrs | mean_mass | sd_mass | mean_lwr | mean_upr | quant025 | quant975 | female_mass | male_mass |
|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 0.0000000 | 983.0272 | 26.76770 | 769.3864 | 1256.003 | 931.5244 | 1036.295 | 1011.028 | 967.3705 |
| 0.0424658 | 1232.8231 | 30.08225 | 990.0386 | 1535.157 | 1174.8634 | 1292.607 | 1267.939 | 1213.1879 |
| 0.0849315 | 1498.2581 | 37.14344 | 1229.5370 | 1825.723 | 1426.7071 | 1572.089 | 1540.935 | 1474.3954 |
| 0.1232877 | 1747.8713 | 45.25512 | 1458.4778 | 2094.703 | 1660.7409 | 1837.873 | 1797.658 | 1720.0329 |
| 0.1616438 | 2003.8171 | 53.21868 | 1696.1860 | 2367.260 | 1901.3875 | 2109.690 | 2060.895 | 1971.9023 |
| 0.2041096 | 2291.4431 | 62.29993 | 1966.1135 | 2670.624 | 2171.5715 | 2415.419 | 2356.713 | 2254.9473 |

``` r
#kable(mass_table)

#save mass_table csv
mass_table %>% write_csv("data/mass_table.csv", na = "", append = FALSE)
```

Predicted Mass by sex

![](mass_bootstraps_files/figure-gfm/plot%20age%20mass%20by%20sex-1.png)<!-- -->![](mass_bootstraps_files/figure-gfm/plot%20age%20mass%20by%20sex-2.png)<!-- -->![](mass_bootstraps_files/figure-gfm/plot%20age%20mass%20by%20sex-3.png)<!-- -->

    ## png 
    ##   2
