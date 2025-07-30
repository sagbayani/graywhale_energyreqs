Vt - Tidal Volume (in L)
================
Selina Agbayani
Jan 19, 2021, updated and cleaned 29 July, 2025

``` r
############ Set path for output figures: ###############
Figurespath <- paste0(getwd(), "/Es/figures", collapse = NULL)

############ Set path for input & output data  ###########
datapath <- paste0(getwd(), "/data", collapse = NULL) 
```

``` r
#read in mths version of mass estimates
gw_pred_mass <- as_tibble(read_csv("data/mass_table.csv"),
                                 col_types = (list(cols(age_yrs = col_double(),
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

The relationship between Mass and tidal volume: Vt = 0.014 x Mass^1.04
(Sumich 1986)

``` r
# Calculate Mean Mass for all ages (Phase 1 and 2) - not including pregnant whales

#Original code was run with MC_reps <- 10000  
#and took a very long time
#To test and explore the code, use less reps 
MC_reps <- 10000

kable(head(gw_pred_mass))
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
pred_mass <- gw_pred_mass %>% 
    dplyr::select(age_yrs, mean_mass, sd_mass)

Vt_table_phase1 <- as.data.frame(matrix(ncol = 5, nrow = 0))

cnames <- c("age_yrs", "Vt_mean", "Vt_sd",  
            "quant025", "quant975"        #2.5% and 97.5% quantile from bootstrap estimates 
            )            

colnames(Vt_table_phase1) <- cnames

Vt_table_phase1<- as_tibble(Vt_table_phase1,
                        col_types = list(ID = col_integer(),
                                         age_yrs = col_double(),
                                         Vt_mean = col_double(),
                                         Vt_sd = col_double(),
                                         quant025 = col_double(),
                                         quant975 = col_double()
                                         )
                        )




for (i in seq(from = 0, to = 12, by = 0.5)){

    age_tibble <- age_yr_tibble %>% filter(age_mth == i)  
    age <- age_tibble$age_yrs   #calculate age_yrs (do not round up)
    
    strcolname <- as.character(age)
        
    pred_mass_i <- pred_mass %>% filter(round(age_yrs,3) == round(age,3))
        
    mass <- pred_mass_i$mean_mass
    sd <- pred_mass_i$sd_mass
        
    mass_i <- rnorm(MC_reps, mass, sd)
    
    #Calculate Tidal Volume using Sumich eqn 
    Vt_i <- 0.014 * mass_i^1.04  
    
    mean_Vt_i <- mean(Vt_i)    
    sd_Vt_i <- sd(Vt_i)
    quant025 <- quantile(Vt_i, 0.025, na.rm = TRUE)
    quant975 <- quantile(Vt_i, 0.975, na.rm = TRUE)
    
    
    row <- tibble(age_yrs = age, 
                      Vt_mean = mean_Vt_i, 
                      Vt_sd = sd_Vt_i, 
                      quant025 = quant025, 
                      quant975 = quant975)
    
    Vt_table_phase1 <- rbind(Vt_table_phase1, row)
    

    
    
   
}


kable(head(Vt_table_phase1))
```

|   age_yrs |  Vt_mean |     Vt_sd | quant025 | quant975 |
|----------:|---------:|----------:|---------:|---------:|
| 0.0000000 | 18.12581 | 0.5147521 | 17.13168 | 19.14827 |
| 0.0424658 | 22.92860 | 0.5862581 | 21.78283 | 24.06423 |
| 0.0849315 | 28.10492 | 0.7201252 | 26.70529 | 29.52348 |
| 0.1232877 | 32.98235 | 0.8853440 | 31.23818 | 34.71713 |
| 0.1616438 | 38.01827 | 1.0540049 | 35.93777 | 40.09095 |
| 0.2041096 | 43.72446 | 1.2212020 | 41.28144 | 46.10464 |

``` r
Vt_table_phase1 %>% write_csv("data/Vt_table_phase1.csv", na = "", append = FALSE)
```

``` r
################################ Vt Phase 1 - female  #########################################

pred_mass <- gw_pred_mass %>% 
    dplyr::select(age_yrs, female_mass, sd_mass)

Vt_table_phase1_f <- as.data.frame(matrix(ncol = 6, nrow = 0))

cnames <- c("age_mth", "age_yrs", "Vt_mean_f", "Vt_sd_f",  
            "quant025_f", "quant975_f"        #2.5% and 97.5% quantile from bootstrap estimates 
            )            

colnames(Vt_table_phase1_f) <- cnames

Vt_table_phase1_f <- as_tibble(Vt_table_phase1_f,
                                 col_types = (list(ID = col_integer(),
                                                   #age_mth = col_double(),
                                                   age_yrs = col_double(),
                                                   Vt_mean_f = col_double(),
                                                   Vt_sd_f = col_double(),
                                                   quant025_f = col_double(),
                                                   quant975_f = col_double()
                                                   )
                                              )
                                 )



#for (i in seq(from = 0, to = 75, by = 0.25)){
#for (i in c(0.00, 0.08, 0.17, 0.25, 0.33, 0.42, 0.5, 0.58, 0.67, 0.75, 0.83, 0.92)){
for (i in seq(from= 0, to = 12, by = 0.5)){
    
    age_tibble <- age_yr_tibble %>% filter(age_mth == i)  
    age <- age_tibble$age_yrs   #calculate age_yrs (do not round up)
    
    strcolname <- as.character(age)
        
    pred_mass_i <- pred_mass %>% filter(round(age_yrs,3) == round(age,3))
    
    mass <- pred_mass_i$female_mass
    sd <- pred_mass_i$sd_mass
        
    mass_i <- rnorm(MC_reps, mass, sd)
    
    #Calculate Tidal Volume using Sumich eqn 
    Vt_i <- 0.014 * mass_i^1.04  
    
    mean_Vt_i <- mean(Vt_i)    
    sd_Vt_i <- sd(Vt_i)
    quant025 <- quantile(Vt_i, 0.025, na.rm = TRUE)
    quant975 <- quantile(Vt_i, 0.975, na.rm = TRUE)
    
    
    row <- tibble(    age_yrs = age, 
                      Vt_mean_f = mean_Vt_i, 
                      Vt_sd_f = sd_Vt_i, 
                      quant025_f = quant025, 
                      quant975_f = quant975)
    
    Vt_table_phase1_f <- rbind(Vt_table_phase1_f, row)
    

    
    
   
}


kable(head(Vt_table_phase1_f))
```

|   age_yrs | Vt_mean_f |   Vt_sd_f | quant025_f | quant975_f |
|----------:|----------:|----------:|-----------:|-----------:|
| 0.0000000 |  18.68426 | 0.5157792 |   17.66552 |   19.70053 |
| 0.0424658 |  23.60793 | 0.5866110 |   22.46470 |   24.74850 |
| 0.0849315 |  28.93601 | 0.7258655 |   27.52234 |   30.36434 |
| 0.1232877 |  33.96348 | 0.8945695 |   32.23420 |   35.71526 |
| 0.1616438 |  39.15456 | 1.0564942 |   37.07269 |   41.21279 |
| 0.2041096 |  45.01013 | 1.2369293 |   42.59606 |   47.47038 |

``` r
Vt_table_phase1_f %>% write_csv("data/Vt_table_phase1_f.csv", na = "", append = FALSE)
# kable(tail(Vt_table_phase1_f))
```

``` r
################################ Vt Phase 1 - male ######################################

pred_mass <- gw_pred_mass %>% 
    dplyr::select(age_yrs, male_mass, sd_mass)

Vt_table_phase1_m <- as.data.frame(matrix(ncol = 6, nrow = 0))

cnames <- c("age_mth", "age_yrs", "Vt_mean_m", "Vt_sd_m",  
            "quant025_m", "quant975_m"        #2.5% and 97.5% quantile from bootstrap estimates 
            )            

colnames(Vt_table_phase1_m) <- cnames

Vt_table_phase1_m <- as_tibble(Vt_table_phase1_m,
                                 col_types = (list(ID = col_integer(),
                                                   age_mth = col_double(),
                                                   age_yrs = col_double(),
                                                   Vt_mean_f = col_double(),
                                                   Vt_sd_f = col_double(),
                                                   quant025_f = col_double(),
                                                   quant975_f = col_double()
                                                   )
                                              )
                                 )



#for (i in seq(from = 0, to = 75, by = 0.25)){
#for (i in c(0.00, 0.08, 0.17, 0.25, 0.33, 0.42, 0.5, 0.58, 0.67, 0.75, 0.83, 0.92)){
for (i in seq(from= 0, to = 12, by = 0.5)){
      
    
    age_tibble <- age_yr_tibble %>% filter(age_mth == i)  
    age <- age_tibble$age_yrs   #calculate age_yrs (do not round up)
    
    strcolname <- as.character(age)
        
    pred_mass_i <- pred_mass %>% filter(round(age_yrs,3) == round(age,3))
    
    mass <- pred_mass_i$male_mass
    sd <- pred_mass_i$sd_mass
        
    mass_i <- rnorm(MC_reps, mass, sd)
    
    #Calculate Tidal Volume using Sumich eqn 
    Vt_i <- 0.014 * mass_i^1.04  
    
    mean_Vt_i <- mean(Vt_i)    
    sd_Vt_i <- sd(Vt_i)
    quant025 <- quantile(Vt_i, 0.025, na.rm = TRUE)
    quant975 <- quantile(Vt_i, 0.975, na.rm = TRUE)
    
    
    row <- tibble(age_yrs = age, 
                      Vt_mean_m = mean_Vt_i, 
                      Vt_sd_m = sd_Vt_i, 
                      quant025_m = quant025, 
                      quant975_m = quant975)
    
    Vt_table_phase1_m <- rbind(Vt_table_phase1_m, row)
    

    
    
   
}


kable(head(Vt_table_phase1_m))
```

|   age_yrs | Vt_mean_m |   Vt_sd_m | quant025_m | quant975_m |
|----------:|----------:|----------:|-----------:|-----------:|
| 0.0000000 |  17.83288 | 0.5175812 |   16.82389 |   18.84292 |
| 0.0424658 |  22.56787 | 0.5845476 |   21.43950 |   23.71248 |
| 0.0849315 |  27.64071 | 0.7202812 |   26.23252 |   29.05670 |
| 0.1232877 |  32.44336 | 0.8869619 |   30.70077 |   34.19187 |
| 0.1616438 |  37.38348 | 1.0432061 |   35.36805 |   39.46719 |
| 0.2041096 |  42.98900 | 1.2432576 |   40.54423 |   45.44639 |

``` r
Vt_table_phase1_m %>% write_csv("data/Vt_table_phase1_m.csv", na = "", append = FALSE)
```

``` r
################################ Vt mean - Phase 2 -  ########################################

Vt_table_phase2 <- as.data.frame(matrix(ncol = 5, nrow = 0))

cnames <- c("age_yrs", "Vt_mean_m", "Vt_sd_m",  
            "quant025_m", "quant975_m"        #2.5% and 97.5% quantile from bootstrap estimates 
            )                     

colnames(Vt_table_phase2) <- cnames

Vt_table_phase2 <- as_tibble(Vt_table_phase2,
                                 col_types = (list(ID = col_integer(),
                                                   age_yrs = col_double(),
                                                   Vt_mean_f = col_double(),
                                                   Vt_sd_f = col_double(),
                                                   quant025_f = col_double(),
                                                   quant975_f = col_double()
                                                   )
                                              )
                                 )


kable(head(gw_pred_mass))
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
pred_mass <- gw_pred_mass %>% 
    select(age_yrs, mean_mass, sd_mass, female_mass, male_mass)

Vt_table_phase2 <- rbind(Vt_table_phase2, Vt_table_phase1)

for (i in seq(from = 1.5, to = 75, by = 0.5)){
    age <-  i
        
    strcolname <- as.character(age)
        
    pred_mass_i <- filter(pred_mass, age_yrs == age)
    
    age_mth <- pred_mass_i$age_mth    
    mass <- pred_mass_i$mean_mass
    sd <- pred_mass_i$sd_mass
    
    set.seed(12345)    
    mass_i <- rnorm(MC_reps, mass, sd)
    
    #Calculate Tidal Volume using Sumich eqn 
    Vt_i <- 0.014 * mass_i^1.04  
    
    mean_Vt_i <- mean(Vt_i)    
    sd_Vt_i <- sd(Vt_i)
    quant025 <- quantile(Vt_i, 0.025, na.rm = TRUE)
    quant975 <- quantile(Vt_i, 0.975, na.rm = TRUE)
    
    
    row <- tibble(age_yrs = age, 
                      Vt_mean = mean_Vt_i, 
                      Vt_sd = sd_Vt_i, 
                      quant025 = quant025, 
                      quant975 = quant975)
    
    Vt_table_phase2 <- rbind(Vt_table_phase2, row)
    

    
    
   
}

Vt_table_phase2 %>% filter(age_yrs >=1 & age_yrs <=5) %>% kable()
```

| age_yrs |  Vt_mean |    Vt_sd | quant025 | quant975 |
|--------:|---------:|---------:|---------:|---------:|
|     1.0 | 120.4387 | 4.194378 | 112.1974 | 128.6753 |
|     1.5 | 137.1352 | 3.717027 | 129.7506 | 144.4359 |
|     2.0 | 153.6801 | 3.378019 | 146.9680 | 160.3140 |
|     2.5 | 169.9373 | 3.168788 | 163.6403 | 176.1597 |
|     3.0 | 185.7780 | 3.103697 | 179.6100 | 191.8722 |
|     3.5 | 201.1014 | 3.151769 | 194.8378 | 207.2899 |
|     4.0 | 215.8324 | 3.300676 | 209.2728 | 222.3132 |
|     4.5 | 229.9168 | 3.496525 | 222.9680 | 236.7821 |
|     5.0 | 243.3192 | 3.714912 | 235.9364 | 250.6133 |

``` r
Vt_table_phase2 %>% write_csv("data/Vt_table_phase2.csv", na = "", append = FALSE)
# kable(tail(Vt_table_phase2))
```

``` r
#################### Vt table - Phase 2 - female #################################
Vt_table_phase2_f <- as.data.frame(matrix(ncol = 6, nrow = 0))

cnames <- c("age_mth", "age_yrs", "Vt_mean_f", "Vt_sd_f",  
            "quant025_f", "quant975_f"        #2.5% and 97.5% quantile from bootstrap estimates 
            )            

colnames(Vt_table_phase2_f) <- cnames


Vt_table_phase2_f <- as_tibble(Vt_table_phase2_f,
                                 col_types = (list(ID = col_integer(),
                                                   age_mth = col_double(),
                                                   age_yrs = col_double(),
                                                   Vt_mean_f = col_double(),
                                                   Vt_sd_f = col_double(),
                                                   quant025_f = col_double(),
                                                   quant975_f = col_double()
                                                   )
                                              )
                                 )



kable(head(gw_pred_mass))
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
pred_mass <- gw_pred_mass %>% 
    dplyr::select(age_mth, age_yrs, mean_mass, sd_mass, female_mass, male_mass)


Vt_table_phase2_f <- rbind(Vt_table_phase2_f, Vt_table_phase1_f)

for (i in seq(from = 2, to = 75, by = 0.5)){
    age <-  i
        
    strcolname <- as.character(age)
        
    pred_mass_i <- filter(pred_mass, age_yrs == age)
        
    age_mth <- pred_mass_i$age_mth
    mass <- pred_mass_i$female_mass
    sd <- pred_mass_i$sd_mass
    
    set.seed(12345)    
    mass_i <- rnorm(MC_reps, mass, sd)
    
    #Calculate Tidal Volume using Sumich eqn 
    Vt_i <- 0.014 * mass_i^1.04  
    
    mean_Vt_i <- mean(Vt_i)    
    sd_Vt_i <- sd(Vt_i)
    quant025 <- quantile(Vt_i, 0.025, na.rm = TRUE)
    quant975 <- quantile(Vt_i, 0.975, na.rm = TRUE)
    
    
    row <- tibble(age_mth = age_mth, 
                      age_yrs = age, 
                      Vt_mean_f = mean_Vt_i, 
                      Vt_sd_f = sd_Vt_i, 
                      quant025_f = quant025, 
                      quant975_f = quant975)
    
    Vt_table_phase2_f <- rbind(Vt_table_phase2_f, row)
    

    
    
   
}


Vt_table_phase2_f %>% write_csv("data/Vt_table_phase2_f.csv", na = "", append = FALSE)
kable(tail(Vt_table_phase2_f))
```

| age_yrs | Vt_mean_f |  Vt_sd_f | quant025_f | quant975_f |
|--------:|----------:|---------:|-----------:|-----------:|
|    72.5 |  431.8188 | 5.520291 |   420.8472 |   442.6569 |
|    73.0 |  431.8189 | 5.520349 |   420.8472 |   442.6571 |
|    73.5 |  431.8190 | 5.520390 |   420.8472 |   442.6573 |
|    74.0 |  431.8191 | 5.520442 |   420.8472 |   442.6575 |
|    74.5 |  431.8191 | 5.520502 |   420.8471 |   442.6577 |
|    75.0 |  431.8192 | 5.520538 |   420.8471 |   442.6578 |

``` r
#################### Vt table - Phase 2 - male #################################
Vt_table_phase2_m <- as.data.frame(matrix(ncol = 6, nrow = 0))

cnames <- c("age_mth", "age_yrs", "Vt_mean_m", "Vt_sd_m",  
            "quant025_m", "quant975_m"        #2.5% and 97.5% quantile from bootstrap estimates 
            )            

colnames(Vt_table_phase2_m) <- cnames


Vt_table_phase2_m <- as_tibble(Vt_table_phase2_m,
                                 col_types = (list(ID = col_integer(),
                                                   age_mth = col_double(),
                                                   age_yrs = col_double(),
                                                   Vt_mean_m = col_double(),
                                                   Vt_sd_m = col_double(),
                                                   quant025_m = col_double(),
                                                   quant975_m = col_double()
                                                   )
                                              )
                                 )



kable(head(gw_pred_mass))
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
pred_mass <- gw_pred_mass %>% 
    dplyr::select(age_mth, age_yrs, mean_mass, sd_mass, female_mass, male_mass)


Vt_table_phase2_m <- rbind(Vt_table_phase2_m, Vt_table_phase1_m)

for (i in seq(from = 2, to = 75, by = 0.5)){
    age <-  i
        
    strcolname <- as.character(age)
        
    pred_mass_i <- filter(pred_mass, age_yrs == age)
        
    age_mth <- pred_mass_i$age_mth
    mass <- pred_mass_i$female_mass
    sd <- pred_mass_i$sd_mass
    
    set.seed(12345)    
    mass_i <- rnorm(MC_reps, mass, sd)
    
    #Calculate Tidal Volume using Sumich eqn 
    Vt_i <- 0.014 * mass_i^1.04  
    
    mean_Vt_i <- mean(Vt_i)    
    sd_Vt_i <- sd(Vt_i)
    quant025 <- quantile(Vt_i, 0.025, na.rm = TRUE)
    quant975 <- quantile(Vt_i, 0.975, na.rm = TRUE)
    
    
    row <- tibble(age_mth = age_mth, 
                      age_yrs = age, 
                      Vt_mean_m = mean_Vt_i, 
                      Vt_sd_m = sd_Vt_i, 
                      quant025_m = quant025, 
                      quant975_m = quant975)
    
    Vt_table_phase2_m <- rbind(Vt_table_phase2_m, row)
    

    
    
   
}


Vt_table_phase2_m %>% write_csv("data/Vt_table_phase2_m.csv", na = "", append = FALSE)
kable(tail(Vt_table_phase2_m))
```

| age_yrs | Vt_mean_m |  Vt_sd_m | quant025_m | quant975_m |
|--------:|----------:|---------:|-----------:|-----------:|
|    72.5 |  431.8188 | 5.520291 |   420.8472 |   442.6569 |
|    73.0 |  431.8189 | 5.520349 |   420.8472 |   442.6571 |
|    73.5 |  431.8190 | 5.520390 |   420.8472 |   442.6573 |
|    74.0 |  431.8191 | 5.520442 |   420.8472 |   442.6575 |
|    74.5 |  431.8191 | 5.520502 |   420.8471 |   442.6577 |
|    75.0 |  431.8192 | 5.520538 |   420.8471 |   442.6578 |

Tidal Volume plots

![](TidalVolume_files/figure-gfm/Vt%20plots-1.png)<!-- -->![](TidalVolume_files/figure-gfm/Vt%20plots-2.png)<!-- -->

    ## png 
    ##   2
