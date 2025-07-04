Mass change - phase 2 - per year
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
##Read in predicted mass data (mass_table from mass_bootstraps.Rmd)

gw_pred_mass <- as_tibble(read_csv("data/mass_table.csv"), #monthly 
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
#Read in data for per  year only
gw_pred_mass <- gw_pred_mass %>% filter(age_yrs == 0 | age_yrs %% 1 == 0)
```

Calculate change in mass per year.

``` r
#Original code was run with MC_reps <- 10000  and took a very long time
#To test and explore the code, use less reps 
MC_reps <- 10

kable(head(gw_pred_mass))
```

| age_yrs | mean_mass | sd_mass | mean_lwr | mean_upr | quant025 | quant975 | female_mass | male_mass |
|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 0 | 983.0272 | 26.7677 | 769.3864 | 1256.003 | 931.5244 | 1036.295 | 1011.028 | 967.3705 |
| 1 | 6072.8559 | 202.1109 | 5535.5539 | 6662.311 | 5685.3490 | 6476.221 | 6245.837 | 5976.1335 |
| 2 | 7675.1795 | 162.2450 | 6967.9413 | 8454.206 | 7362.0875 | 7997.123 | 7893.802 | 7552.9369 |
| 3 | 9210.7914 | 147.9849 | 8289.2833 | 10234.752 | 8924.5190 | 9503.733 | 9473.155 | 9064.0911 |
| 4 | 10639.3400 | 156.4716 | 9483.1963 | 11936.449 | 10336.4523 | 10948.882 | 10942.395 | 10469.8872 |
| 5 | 11939.1149 | 175.2988 | 10546.1836 | 13516.043 | 11599.7789 | 12285.898 | 12279.193 | 11748.9607 |

``` r
pred_mass <- gw_pred_mass %>% 
    select(age_yrs, mean_mass, sd_mass, female_mass, male_mass)



####################################################################
##### Generate mean mass at age (with sd) 
MC_mass = NA

for (i in seq(from = 0, to = 75, by = 1)){ 
    age <-  i
    
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
    
    MC_mass <- rbind(MC_mass, mass_i)
    
    
}

# move age_yrs to first column and delete first row (NAs)
MC_mass <- MC_mass %>% 
  relocate(age_yrs) %>% 
  slice(-1)  

# head(MC_mass)


#########################################################
#### Calculate mass change per age step (not sex-specific)

MC_mass_diffs <- NA

# Mass for newborn
M_nb <- pred_mass %>% filter(age_yrs == 0) 

for (i in seq(from = 1, to = MC_reps, by = 1)){

    colnumber = i
    colname = as.character(colnumber)
    
    #first row - Mass change from newborn
    mass_chg <- MC_mass %>% 
        filter(age_yrs == 0) %>% 
        select(all_of(colname))
    
    delta_mass_yr1 <- as.data.frame(mass_chg) 
    
    mass_column <- MC_mass %>% 
        select(all_of(colname))     
    
    #str(mass_column)
    
    diffs_mass <-  diff(as.matrix(mass_column))  #calculate delta mass
    diffs_mass <- as.data.frame(diffs_mass) 
    names(diffs_mass)[1] <- as.character(colname)
    
    #head(diffs_mass)
    #diffs_mass <- diffs_mass %>% slice(-1) #remove NA row
    
    mass_chg <- rbind(delta_mass_yr1, diffs_mass) 
    #head(mass_chg)
    MC_mass_diffs <-cbind(MC_mass_diffs, mass_chg) 

}

#Drop first column called MC_mass_diffs (all NA)
MC_mass_diffs  <-  MC_mass_diffs %>% 
  select(-MC_mass_diffs)

#transpose matrix of mass diffs
MC_mass_diffs_t <- t(MC_mass_diffs)


# transpose mass_diffs - t() will return matrix, convert to tibble
MC_mass_diffs_t <- as_tibble(MC_mass_diffs_t)

#save calculated mass diffs to file
MC_mass_diffs_t %>% write_csv("data/MC_mass_diffs_t_per_year.csv", na = "", append = FALSE)


#calculate mean mass changes across all columns (ages)
mean_masschange <- MC_mass_diffs_t %>% summarise_all(list(mean))

kable(head(mean_masschange))
```

| V1 | V2 | V3 | V4 | V5 | V6 | V7 | V8 | V9 | V10 | V11 | V12 | V13 | V14 | V15 | V16 | V17 | V18 | V19 | V20 | V21 | V22 | V23 | V24 | V25 | V26 | V27 | V28 | V29 | V30 | V31 | V32 | V33 | V34 | V35 | V36 | V37 | V38 | V39 | V40 | V41 | V42 | V43 | V44 | V45 | V46 | V47 | V48 | V49 | V50 | V51 | V52 | V53 | V54 | V55 | V56 | V57 | V58 | V59 | V60 | V61 | V62 | V63 | V64 | V65 | V66 | V67 | V68 | V69 | V70 | V71 | V72 | V73 | V74 | V75 | V76 |
|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 986.566 | 5113.01 | 1597.053 | 1533.727 | 1429.671 | 1302.264 | 1164.954 | 1027.138 | 897.339 | 776.7342 | 668.1527 | 571.7487 | 487.2812 | 413.9324 | 350.73 | 296.7667 | 250.4869 | 211.3376 | 177.9792 | 149.8377 | 125.9382 | 105.7385 | 88.83062 | 74.49615 | 62.53304 | 52.34922 | 43.85342 | 36.73353 | 30.79309 | 25.75173 | 21.57241 | 18.06704 | 15.10758 | 12.62806 | 10.54985 | 8.847369 | 7.400838 | 6.192999 | 5.170932 | 4.335437 | 3.619959 | 3.029696 | 2.528891 | 2.116912 | 1.769148 | 1.484412 | 1.240983 | 1.034886 | 0.8626185 | 0.7263743 | 0.611222 | 0.5017761 | 0.4242798 | 0.3567578 | 0.2966436 | 0.2475808 | 0.2064114 | 0.1736177 | 0.1446807 | 0.1221086 | 0.101803 | 0.084716 | 0.0713065 | 0.058973 | 0.0502923 | 0.0412603 | 0.0345408 | 0.0289262 | 0.0246737 | 0.0202686 | 0.0173144 | 0.0139829 | 0.0120657 | 0.0099413 | 0.0082736 | 0.0070366 |

``` r
mean_masschange <-  t(mean_masschange)

mean_masschange <- as_tibble(mean_masschange)
colnames(mean_masschange)[colnames(mean_masschange)=="V1"] <- "mean_masschange"

#calculate sd for mass changes across all columns (ages)
sd_masschange <- MC_mass_diffs_t %>% summarise_all(c("sd"))
sd_masschange <-  t(sd_masschange)

sd_masschange <- as_tibble(sd_masschange)
colnames(sd_masschange)[colnames(sd_masschange)=="V1"] <- "sd_masschange"

mean_masschange$sd_masschange <- sd_masschange$sd_masschange
mean_masschange$sex <- "N/A"

#add age_yrs column (starting from 0) and move to front
mean_masschange <- mean_masschange %>%
  mutate("age_yrs" = row_number()-1) %>%
  relocate("age_yrs")

kable(head(mean_masschange))
```

| age_yrs | mean_masschange | sd_masschange | sex |
|--------:|----------------:|--------------:|:----|
|       0 |         986.566 |      20.89449 | N/A |
|       1 |        5113.010 |     136.87045 | N/A |
|       2 |        1597.053 |      31.11877 | N/A |
|       3 |        1533.727 |      11.13125 | N/A |
|       4 |        1429.671 |       6.62462 | N/A |
|       5 |        1302.264 |      14.69623 | N/A |

``` r
###########################################################################
# Calculate mean mass for females (with sd)

MC_female_mass = NA


for (i in seq(from = 0, to = 75, by = 1)){ 
    age <-  i
    
    strcolname <- as.character(age)
    
    pred_mass_i <- filter(pred_mass, age_yrs == age)
    
    mass <- pred_mass_i$female_mass
    sd <- pred_mass_i$sd_mass
    
    set.seed(1)
    mass_i <- as_tibble(rnorm(MC_reps, mass, sd), col.names = str(i))
    names(mass_i)[1] <- strcolname
    
    mass_i <- mass_i %>%  dplyr::mutate(ID = row_number())
    
    #transpose the table -- result is a matrix
    mass_i <-  t(mass_i)    
    
    #make ID the column name, then remove the unneeded row
    colnames(mass_i) <- unlist(mass_i[row.names(mass_i)=='ID',])
    mass_i  <- mass_i[!row.names(mass_i)=='ID',]
    
    #turn matrix into data frame (need to include the t() to keep the matrix format)
    mass_i <- as_tibble(t(mass_i))
    
    mass_i$age_yrs <- age

    MC_female_mass <- rbind(MC_female_mass, mass_i)
    
    
}

# move age_yrs to first column and delete first row (NAs)
MC_female_mass <- MC_female_mass %>% 
  relocate(age_yrs) %>% 
  slice(-1)

head(MC_female_mass)
```

    ## # A tibble: 6 × 11
    ##   age_yrs    `1`    `2`    `3`    `4`    `5`    `6`    `7`    `8`    `9`   `10`
    ##     <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>
    ## 1       0   994.  1016.   989.  1054.  1020.   989.  1024.  1031.  1026.  1003.
    ## 2       1  6119.  6283.  6077.  6568.  6312.  6080.  6344.  6395.  6362.  6184.
    ## 3       2  7792.  7924.  7758.  8153.  7947.  7761.  7973.  8014.  7987.  7844.
    ## 4       3  9380.  9500.  9349.  9709.  9522.  9352.  9545.  9582.  9558.  9428.
    ## 5       4 10844. 10971. 10812. 11192. 10994. 10814. 11019. 11058. 11032. 10895.
    ## 6       5 12169. 12311. 12133. 12559. 12337. 12135. 12365. 12409. 12380. 12226.

``` r
#################################################
#### Calculate mass change for females

MC_female_mass_diffs <- NA

# Mass for newborn 
M_nb <- pred_mass %>% filter(age_yrs == 0) 
    

for (i in seq(from = 1, to = MC_reps, by = 1)){
    
    colnumber = i
    colname = as.character(colnumber)
    
    #first row - mass change from newborn
    mass_chg_Female <- MC_mass %>% 
        dplyr::filter(age_yrs == 0) %>% 
        dplyr::select(all_of(colname))
    delta_mass_yr1 <- mass_chg_Female 
        
    delta_mass_yr1 <- as.data.frame(mass_chg_Female) 
    
    #names(delta_mass_yr1)[1] <- colname
    
    mass_column <- MC_female_mass %>% 
        dplyr:: select(all_of(colname))     
    
    #str(mass_column)
    
    diffs_mass_Female <-  diff(as.matrix(mass_column))  #calculate delta mass
    diffs_mass_Female <- as.data.frame(diffs_mass_Female) 
    names(diffs_mass_Female)[1] <- as.character(colname)
    
    #head(diffs_mass_Female)
    #diffs_mass_Female <- diffs_mass_Female %>% slice(-1) #remove NA row
    
    mass_chg_Female <- rbind(delta_mass_yr1, diffs_mass_Female) 
    #head(mass_chg_Female)
    MC_female_mass_diffs <-cbind(MC_female_mass_diffs, mass_chg_Female) 

}

#Drop first column called MC_mass_diffs (all NA)
MC_female_mass_diffs  <-  MC_female_mass_diffs %>% 
    select(-MC_female_mass_diffs)

#transpose the table -- result is a matrix
MC_female_mass_diffs <- t(MC_female_mass_diffs)

# convert to tibble
MC_female_mass_diffs_t <- as_tibble(MC_female_mass_diffs)

#save calculated mass diffs to file
MC_female_mass_diffs_t %>% write_csv("data/MC_female_mass_diffs_t_per_year.csv", na = "", append = FALSE)

#calculate mean mass changes across all columns (ages)
mean_masschange_female <- MC_female_mass_diffs_t %>% summarise_all(list(mean))

kable(head(mean_masschange_female))
```

| V1 | V2 | V3 | V4 | V5 | V6 | V7 | V8 | V9 | V10 | V11 | V12 | V13 | V14 | V15 | V16 | V17 | V18 | V19 | V20 | V21 | V22 | V23 | V24 | V25 | V26 | V27 | V28 | V29 | V30 | V31 | V32 | V33 | V34 | V35 | V36 | V37 | V38 | V39 | V40 | V41 | V42 | V43 | V44 | V45 | V46 | V47 | V48 | V49 | V50 | V51 | V52 | V53 | V54 | V55 | V56 | V57 | V58 | V59 | V60 | V61 | V62 | V63 | V64 | V65 | V66 | V67 | V68 | V69 | V70 | V71 | V72 | V73 | V74 | V75 | V76 |
|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 986.566 | 5257.99 | 1642.694 | 1577.468 | 1470.362 | 1339.287 | 1198.073 | 1056.374 | 922.8854 | 798.8713 | 687.2098 | 588.0668 | 501.1937 | 425.7521 | 360.7426 | 305.2288 | 257.624 | 217.3478 | 183.0335 | 154.0836 | 129.5014 | 108.7265 | 91.33485 | 76.59362 | 64.28924 | 53.81883 | 45.08293 | 37.76193 | 31.65316 | 26.47075 | 22.17352 | 18.5695 | 15.5275 | 12.97894 | 10.84301 | 9.092383 | 7.605552 | 6.364041 | 5.313804 | 4.454826 | 3.719681 | 3.113008 | 2.598474 | 2.175045 | 1.817706 | 1.524988 | 1.274876 | 1.06319 | 0.8862533 | 0.746131 | 0.6277357 | 0.5155438 | 0.4357933 | 0.3663806 | 0.3046768 | 0.2542896 | 0.2120135 | 0.1783 | 0.1485904 | 0.1253776 | 0.1045326 | 0.0869949 | 0.0732114 | 0.0605623 | 0.0516226 | 0.0423693 | 0.0354672 | 0.0297001 | 0.0253216 | 0.0208087 | 0.0177666 | 0.0143592 | 0.0123811 | 0.0102043 | 0.0084932 | 0.0072203 |

``` r
mean_masschange_female <-  t(mean_masschange_female)

mean_masschange_female <- as_tibble(mean_masschange_female)
colnames(mean_masschange_female)[colnames(mean_masschange_female)=="V1"] <- "mean_masschange"


#calculate sd for mass changes across all columns (ages)
sd_masschange_female <- MC_female_mass_diffs_t %>% summarise_all(c("sd"))
sd_masschange_female <-  t(sd_masschange_female)

sd_masschange_female <- as_tibble(sd_masschange_female)
colnames(sd_masschange_female)[colnames(sd_masschange_female)=="V1"] <- "sd_masschange"

mean_masschange_female$sd_masschange <- sd_masschange_female$sd_masschange
mean_masschange_female$sex <- "Female"

#add the age column (starting from 0) and move to front
mean_masschange_female <- mean_masschange_female %>%
  mutate("age_yrs" = row_number()-1) %>%
  relocate("age_yrs")

kable(head(mean_masschange_female))
```

| age_yrs | mean_masschange | sd_masschange | sex    |
|--------:|----------------:|--------------:|:-------|
|       0 |         986.566 |      20.89449 | Female |
|       1 |        5257.990 |     136.87045 | Female |
|       2 |        1642.694 |      31.11877 | Female |
|       3 |        1577.468 |      11.13125 | Female |
|       4 |        1470.362 |       6.62462 | Female |
|       5 |        1339.287 |      14.69623 | Female |

``` r
####################################################################
##### Calulate mean mass for males (with sd)
MC_male_mass = NA

for (i in seq(from = 0, to = 75, by = 1)){ 
    age <-  i
    
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
    
    MC_male_mass <- rbind(MC_male_mass, mass_i)
    
    
}

# move age_yrs to first column and delete first row (NAs)
MC_male_mass <- MC_male_mass %>% 
  relocate(age_yrs) %>% 
  slice(-1)

head(MC_male_mass)
```

    ## # A tibble: 6 × 11
    ##   age_yrs    `1`    `2`    `3`    `4`    `5`    `6`    `7`    `8`    `9`   `10`
    ##     <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>
    ## 1       0   951.   972.   945.  1010.   976.   945.   980.   987.   983.   959.
    ## 2       1  5850.  6013.  5807.  6299.  6043.  5810.  6075.  6125.  6093.  5914.
    ## 3       2  7451.  7583.  7417.  7812.  7606.  7420.  7632.  7673.  7646.  7503.
    ## 4       3  8971.  9091.  8940.  9300.  9113.  8943.  9136.  9173.  9149.  9019.
    ## 5       4 10372. 10499. 10339. 10720. 10521. 10342. 10546. 10585. 10560. 10422.
    ## 6       5 11639. 11781. 11602. 12029. 11807. 11605. 11834. 11878. 11850. 11695.

``` r
#################################################
#### Calculate mass change for males

MC_male_mass_diffs <- NA

for (i in seq(from = 1, to = MC_reps, by = 1)){
    
    colnumber = i
    colname = as.character(colnumber)
    
    #mass_chg <- rnorm(1, M_nb$mean_mass, M_nb$sd_mass)     
    mass_chg_male <- MC_mass %>% 
        filter(age_yrs == 0) %>% 
        select(all_of(colname))
    
    delta_mass_yr1 <- mass_chg_male 
    
    
    delta_mass <- as.data.frame(mass_chg_male) 
    
    mass_column <- MC_male_mass %>% 
        dplyr:: select(all_of(colname))     
    
    #str(mass_column)
    
    diffs_mass_male <-  diff(as.matrix(mass_column))  #calculate delta mass
    diffs_mass_male <- as.data.frame(diffs_mass_male) 
    names(diffs_mass_male)[1] <- as.character(colname)
    
    #head(diffs_mass_male)
    #diffs_mass_male <- diffs_mass_male %>% slice(-1) #remove NA row
    
    mass_chg_male <- rbind(delta_mass_yr1, diffs_mass_male) 
    #head(mass_chg_male)
    MC_male_mass_diffs <-cbind(MC_male_mass_diffs, mass_chg_male) 

}

#Drop first column called MC_mass_diffs (all NA)
MC_male_mass_diffs  <-  MC_male_mass_diffs %>% 
    select(-MC_male_mass_diffs)

# transpose matrix of mass_diffs
MC_male_mass_diffs_t <- t(MC_male_mass_diffs)

## transpose mass_diffs - t() will return matrix, convert to tibble
MC_male_mass_diffs_t <- as_tibble(MC_male_mass_diffs_t)


MC_male_mass_diffs_t %>% write_csv("data/MC_male_mass_diffs_t_per_year.csv", na = "", append = FALSE)

#MC_male_mass_diffs_t <- as_tibble(read_csv("data/MC_male_mass_diffs_t_per_year.csv"))

#calculate mean mass changes across all columns (ages)
mean_masschange_male <- MC_male_mass_diffs_t %>% summarise_all(list(mean))

kable(head(mean_masschange_male))
```

| V1 | V2 | V3 | V4 | V5 | V6 | V7 | V8 | V9 | V10 | V11 | V12 | V13 | V14 | V15 | V16 | V17 | V18 | V19 | V20 | V21 | V22 | V23 | V24 | V25 | V26 | V27 | V28 | V29 | V30 | V31 | V32 | V33 | V34 | V35 | V36 | V37 | V38 | V39 | V40 | V41 | V42 | V43 | V44 | V45 | V46 | V47 | V48 | V49 | V50 | V51 | V52 | V53 | V54 | V55 | V56 | V57 | V58 | V59 | V60 | V61 | V62 | V63 | V64 | V65 | V66 | V67 | V68 | V69 | V70 | V71 | V72 | V73 | V74 | V75 | V76 |
|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 986.566 | 5031.944 | 1571.533 | 1509.269 | 1406.918 | 1281.562 | 1146.436 | 1010.79 | 883.0548 | 764.3563 | 657.497 | 562.6244 | 479.502 | 407.3235 | 345.1315 | 292.0352 | 246.4962 | 207.9769 | 175.1531 | 147.4636 | 123.9458 | 104.0678 | 87.43038 | 73.32336 | 61.55106 | 51.52749 | 43.16594 | 36.15851 | 30.31219 | 25.3497 | 21.23631 | 17.78608 | 14.87279 | 12.43187 | 10.38593 | 8.71037 | 7.286372 | 6.097361 | 5.091044 | 4.268681 | 3.5642 | 2.983112 | 2.489984 | 2.084408 | 1.741997 | 1.461724 | 1.222032 | 1.01906 | 0.8494031 | 0.7153274 | 0.6019884 | 0.4940779 | 0.4178421 | 0.3513772 | 0.2921518 | 0.2438296 | 0.203279 | 0.1709996 | 0.1424946 | 0.1202808 | 0.1002767 | 0.0834417 | 0.0702414 | 0.0580844 | 0.0495484 | 0.0406403 | 0.0340228 | 0.0284934 | 0.0243115 | 0.0199666 | 0.0170616 | 0.0137725 | 0.0118893 | 0.0097942 | 0.0081508 | 0.0069338 |

``` r
mean_masschange_male <-  t(mean_masschange_male)

mean_masschange_male <- as_tibble(mean_masschange_male)
colnames(mean_masschange_male)[colnames(mean_masschange_male)=="V1"] <- "mean_masschange"

#calculate sd for mass changes across all columns (ages)
sd_masschange_male <- MC_male_mass_diffs_t %>% summarise_all(c("sd"))
sd_masschange_male <-  t(sd_masschange_male)

sd_masschange_male <- as_tibble(sd_masschange_male)
colnames(sd_masschange_male)[colnames(sd_masschange_male)=="V1"] <- "sd_masschange"

mean_masschange_male$sd_masschange <- sd_masschange_male$sd_masschange
mean_masschange_male$sex <- "Male"

#add the age column and move to front
mean_masschange_male <- mean_masschange_male %>%
  mutate("age_yrs" = row_number()-1) %>%
  relocate("age_yrs")

kable(head(mean_masschange_male))
```

| age_yrs | mean_masschange | sd_masschange | sex  |
|--------:|----------------:|--------------:|:-----|
|       0 |         986.566 |      20.89449 | Male |
|       1 |        5031.944 |     136.87045 | Male |
|       2 |        1571.533 |      31.11877 | Male |
|       3 |        1509.269 |      11.13125 | Male |
|       4 |        1406.918 |       6.62462 | Male |
|       5 |        1281.562 |      14.69623 | Male |

Combine mass change tables into one for plotting

``` r
mean_masschange <- rbind(mean_masschange, mean_masschange_female, mean_masschange_male)

kable(mean_masschange)
```

| age_yrs | mean_masschange | sd_masschange | sex    |
|--------:|----------------:|--------------:|:-------|
|       0 |     986.5659845 |    20.8944895 | N/A    |
|       1 |    5113.0095062 |   136.8704519 | N/A    |
|       2 |    1597.0532713 |    31.1187662 | N/A    |
|       3 |    1533.7266687 |    11.1312540 | N/A    |
|       4 |    1429.6705456 |     6.6246201 | N/A    |
|       5 |    1302.2639505 |    14.6962303 | N/A    |
|       6 |    1164.9541196 |    13.3235872 | N/A    |
|       7 |    1027.1377415 |     4.4327352 | N/A    |
|       8 |     897.3390438 |     2.8579043 | N/A    |
|       9 |     776.7342342 |     2.5455174 | N/A    |
|      10 |     668.1526950 |     5.2115788 | N/A    |
|      11 |     571.7486556 |     6.6895294 | N/A    |
|      12 |     487.2811751 |     6.7715023 | N/A    |
|      13 |     413.9324206 |     6.0229142 | N/A    |
|      14 |     350.7300475 |     4.6075472 | N/A    |
|      15 |     296.7667408 |     1.8227823 | N/A    |
|      16 |     250.4869250 |     0.4355764 | N/A    |
|      17 |     211.3375563 |     1.9760876 | N/A    |
|      18 |     177.9791727 |     3.1727319 | N/A    |
|      19 |     149.8377226 |     4.5868483 | N/A    |
|      20 |     125.9381877 |     4.9770688 | N/A    |
|      21 |     105.7384819 |     4.9571403 | N/A    |
|      22 |      88.8306172 |     5.4001183 | N/A    |
|      23 |      74.4961516 |     5.0812627 | N/A    |
|      24 |      62.5330406 |     5.1850115 | N/A    |
|      25 |      52.3492165 |     4.4619824 | N/A    |
|      26 |      43.8534199 |     4.0679207 | N/A    |
|      27 |      36.7335326 |     3.7183900 | N/A    |
|      28 |      30.7930907 |     3.5352186 | N/A    |
|      29 |      25.7517336 |     3.0075209 | N/A    |
|      30 |      21.5724138 |     2.7711904 | N/A    |
|      31 |      18.0670353 |     2.5204031 | N/A    |
|      32 |      15.1075830 |     2.1593413 | N/A    |
|      33 |      12.6280632 |     1.8289550 | N/A    |
|      34 |      10.5498469 |     1.5228413 | N/A    |
|      35 |       8.8473695 |     1.4506787 | N/A    |
|      36 |       7.4008379 |     1.2632908 | N/A    |
|      37 |       6.1929987 |     1.1113763 | N/A    |
|      38 |       5.1709315 |     0.9158032 | N/A    |
|      39 |       4.3354367 |     0.8505262 | N/A    |
|      40 |       3.6199593 |     0.7028561 | N/A    |
|      41 |       3.0296960 |     0.6191152 | N/A    |
|      42 |       2.5288908 |     0.5080275 | N/A    |
|      43 |       2.1169121 |     0.4490870 | N/A    |
|      44 |       1.7691482 |     0.3804968 | N/A    |
|      45 |       1.4844118 |     0.3537861 | N/A    |
|      46 |       1.2409832 |     0.3016851 | N/A    |
|      47 |       1.0348861 |     0.2434196 | N/A    |
|      48 |       0.8626185 |     0.1940863 | N/A    |
|      49 |       0.7263743 |     0.1935331 | N/A    |
|      50 |       0.6112220 |     0.1858456 | N/A    |
|      51 |       0.5017761 |     0.1088329 | N/A    |
|      52 |       0.4242798 |     0.1185427 | N/A    |
|      53 |       0.3567578 |     0.1117744 | N/A    |
|      54 |       0.2966436 |     0.0863347 | N/A    |
|      55 |       0.2475808 |     0.0711781 | N/A    |
|      56 |       0.2064114 |     0.0574978 | N/A    |
|      57 |       0.1736177 |     0.0545352 | N/A    |
|      58 |       0.1446807 |     0.0438270 | N/A    |
|      59 |       0.1221086 |     0.0433737 | N/A    |
|      60 |       0.1018030 |     0.0352624 | N/A    |
|      61 |       0.0847160 |     0.0278083 | N/A    |
|      62 |       0.0713065 |     0.0261645 | N/A    |
|      63 |       0.0589730 |     0.0187599 | N/A    |
|      64 |       0.0502923 |     0.0211929 | N/A    |
|      65 |       0.0412603 |     0.0137470 | N/A    |
|      66 |       0.0345408 |     0.0119101 | N/A    |
|      67 |       0.0289262 |     0.0103628 | N/A    |
|      68 |       0.0246737 |     0.0113940 | N/A    |
|      69 |       0.0202686 |     0.0077150 | N/A    |
|      70 |       0.0173144 |     0.0084985 | N/A    |
|      71 |       0.0139829 |     0.0045559 | N/A    |
|      72 |       0.0120657 |     0.0058654 | N/A    |
|      73 |       0.0099413 |     0.0041764 | N/A    |
|      74 |       0.0082736 |     0.0033323 | N/A    |
|      75 |       0.0070366 |     0.0034565 | N/A    |
|       0 |     986.5659845 |    20.8944895 | Female |
|       1 |    5257.9901704 |   136.8704519 | Female |
|       2 |    1642.6944832 |    31.1187662 | Female |
|       3 |    1577.4676369 |    11.1312540 | Female |
|       4 |    1470.3618803 |     6.6246201 | Female |
|       5 |    1339.2872470 |    14.6962303 | Female |
|       6 |    1198.0728512 |    13.3235872 | Female |
|       7 |    1056.3737490 |     4.4327352 | Female |
|       8 |     922.8854120 |     2.8579043 | Female |
|       9 |     798.8713152 |     2.5455174 | Female |
|      10 |     687.2097587 |     5.2115788 | Female |
|      11 |     588.0668390 |     6.6895294 | Female |
|      12 |     501.1937493 |     6.7715023 | Female |
|      13 |     425.7520889 |     6.0229142 | Female |
|      14 |     360.7426067 |     4.6075472 | Female |
|      15 |     305.2287539 |     1.8227823 | Female |
|      16 |     257.6239936 |     0.4355764 | Female |
|      17 |     217.3478446 |     1.9760876 | Female |
|      18 |     183.0334949 |     3.1727319 | Female |
|      19 |     154.0836308 |     4.5868483 | Female |
|      20 |     129.5014497 |     4.9770688 | Female |
|      21 |     108.7264638 |     4.9571403 | Female |
|      22 |      91.3348518 |     5.4001183 | Female |
|      23 |      76.5936159 |     5.0812627 | Female |
|      24 |      64.2892425 |     5.1850115 | Female |
|      25 |      53.8188264 |     4.4619824 | Female |
|      26 |      45.0829333 |     4.0679207 | Female |
|      27 |      37.7619266 |     3.7183900 | Female |
|      28 |      31.6531584 |     3.5352186 | Female |
|      29 |      26.4707470 |     3.0075209 | Female |
|      30 |      22.1735220 |     2.7711904 | Female |
|      31 |      18.5695048 |     2.5204031 | Female |
|      32 |      15.5274961 |     2.1593413 | Female |
|      33 |      12.9789426 |     1.8289550 | Female |
|      34 |      10.8430063 |     1.5228413 | Female |
|      35 |       9.0923830 |     1.4506787 | Female |
|      36 |       7.6055519 |     1.2632908 | Female |
|      37 |       6.3640410 |     1.1113763 | Female |
|      38 |       5.3138043 |     0.9158032 | Female |
|      39 |       4.4548258 |     0.8505262 | Female |
|      40 |       3.7196809 |     0.7028561 | Female |
|      41 |       3.1130083 |     0.6191152 | Female |
|      42 |       2.5984739 |     0.5080275 | Female |
|      43 |       2.1750446 |     0.4490870 | Female |
|      44 |       1.8177057 |     0.3804968 | Female |
|      45 |       1.5249876 |     0.3537861 | Female |
|      46 |       1.2748765 |     0.3016851 | Female |
|      47 |       1.0631899 |     0.2434196 | Female |
|      48 |       0.8862533 |     0.1940863 | Female |
|      49 |       0.7461310 |     0.1935331 | Female |
|      50 |       0.6277357 |     0.1858456 | Female |
|      51 |       0.5155438 |     0.1088329 | Female |
|      52 |       0.4357933 |     0.1185427 | Female |
|      53 |       0.3663806 |     0.1117744 | Female |
|      54 |       0.3046768 |     0.0863347 | Female |
|      55 |       0.2542896 |     0.0711781 | Female |
|      56 |       0.2120135 |     0.0574978 | Female |
|      57 |       0.1783000 |     0.0545352 | Female |
|      58 |       0.1485904 |     0.0438270 | Female |
|      59 |       0.1253776 |     0.0433737 | Female |
|      60 |       0.1045326 |     0.0352624 | Female |
|      61 |       0.0869949 |     0.0278083 | Female |
|      62 |       0.0732114 |     0.0261645 | Female |
|      63 |       0.0605623 |     0.0187599 | Female |
|      64 |       0.0516226 |     0.0211929 | Female |
|      65 |       0.0423693 |     0.0137470 | Female |
|      66 |       0.0354672 |     0.0119101 | Female |
|      67 |       0.0297001 |     0.0103628 | Female |
|      68 |       0.0253216 |     0.0113940 | Female |
|      69 |       0.0208087 |     0.0077150 | Female |
|      70 |       0.0177666 |     0.0084985 | Female |
|      71 |       0.0143592 |     0.0045559 | Female |
|      72 |       0.0123811 |     0.0058654 | Female |
|      73 |       0.0102043 |     0.0041764 | Female |
|      74 |       0.0084932 |     0.0033323 | Female |
|      75 |       0.0072203 |     0.0034565 | Female |
|       0 |     986.5659845 |    20.8944895 | Male   |
|       1 |    5031.9438054 |   136.8704519 | Male   |
|       2 |    1571.5330624 |    31.1187662 | Male   |
|       3 |    1509.2689781 |    11.1312540 | Male   |
|       4 |    1406.9180524 |     6.6246201 | Male   |
|       5 |    1281.5624350 |    14.6962303 | Male   |
|       6 |    1146.4358351 |    13.3235872 | Male   |
|       7 |    1010.7904757 |     4.4327352 | Male   |
|       8 |     883.0548339 |     2.8579043 | Male   |
|       9 |     764.3563217 |     2.5455174 | Male   |
|      10 |     657.4969691 |     5.2115788 | Male   |
|      11 |     562.6243700 |     6.6895294 | Male   |
|      12 |     479.5019820 |     6.7715023 | Male   |
|      13 |     407.3234724 |     6.0229142 | Male   |
|      14 |     345.1315414 |     4.6075472 | Male   |
|      15 |     292.0352201 |     1.8227823 | Male   |
|      16 |     246.4962448 |     0.4355764 | Male   |
|      17 |     207.9769134 |     1.9760876 | Male   |
|      18 |     175.1530567 |     3.1727319 | Male   |
|      19 |     147.4636300 |     4.5868483 | Male   |
|      20 |     123.9457956 |     4.9770688 | Male   |
|      21 |     104.0677568 |     4.9571403 | Male   |
|      22 |      87.4303786 |     5.4001183 | Male   |
|      23 |      73.3233579 |     5.0812627 | Male   |
|      24 |      61.5510632 |     5.1850115 | Male   |
|      25 |      51.5274865 |     4.4619824 | Male   |
|      26 |      43.1659395 |     4.0679207 | Male   |
|      27 |      36.1585078 |     3.7183900 | Male   |
|      28 |      30.3121852 |     3.5352186 | Male   |
|      29 |      25.3496983 |     3.0075209 | Male   |
|      30 |      21.2363051 |     2.7711904 | Male   |
|      31 |      17.7860803 |     2.5204031 | Male   |
|      32 |      14.8727892 |     2.1593413 | Male   |
|      33 |      12.4318695 |     1.8289550 | Male   |
|      34 |      10.3859272 |     1.5228413 | Male   |
|      35 |       8.7103705 |     1.4506787 | Male   |
|      36 |       7.2863724 |     1.2632908 | Male   |
|      37 |       6.0973607 |     1.1113763 | Male   |
|      38 |       5.0910445 |     0.9158032 | Male   |
|      39 |       4.2686805 |     0.8505262 | Male   |
|      40 |       3.5642002 |     0.7028561 | Male   |
|      41 |       2.9831121 |     0.6191152 | Male   |
|      42 |       2.4899835 |     0.5080275 | Male   |
|      43 |       2.0844075 |     0.4490870 | Male   |
|      44 |       1.7419974 |     0.3804968 | Male   |
|      45 |       1.4617239 |     0.3537861 | Male   |
|      46 |       1.2220318 |     0.3016851 | Male   |
|      47 |       1.0190601 |     0.2434196 | Male   |
|      48 |       0.8494031 |     0.1940863 | Male   |
|      49 |       0.7153274 |     0.1935331 | Male   |
|      50 |       0.6019884 |     0.1858456 | Male   |
|      51 |       0.4940779 |     0.1088329 | Male   |
|      52 |       0.4178421 |     0.1185427 | Male   |
|      53 |       0.3513772 |     0.1117744 | Male   |
|      54 |       0.2921518 |     0.0863347 | Male   |
|      55 |       0.2438296 |     0.0711781 | Male   |
|      56 |       0.2032790 |     0.0574978 | Male   |
|      57 |       0.1709996 |     0.0545352 | Male   |
|      58 |       0.1424946 |     0.0438270 | Male   |
|      59 |       0.1202808 |     0.0433737 | Male   |
|      60 |       0.1002767 |     0.0352624 | Male   |
|      61 |       0.0834417 |     0.0278083 | Male   |
|      62 |       0.0702414 |     0.0261645 | Male   |
|      63 |       0.0580844 |     0.0187599 | Male   |
|      64 |       0.0495484 |     0.0211929 | Male   |
|      65 |       0.0406403 |     0.0137470 | Male   |
|      66 |       0.0340228 |     0.0119101 | Male   |
|      67 |       0.0284934 |     0.0103628 | Male   |
|      68 |       0.0243115 |     0.0113940 | Male   |
|      69 |       0.0199666 |     0.0077150 | Male   |
|      70 |       0.0170616 |     0.0084985 | Male   |
|      71 |       0.0137725 |     0.0045559 | Male   |
|      72 |       0.0118893 |     0.0058654 | Male   |
|      73 |       0.0097942 |     0.0041764 | Male   |
|      74 |       0.0081508 |     0.0033323 | Male   |
|      75 |       0.0069338 |     0.0034565 | Male   |

``` r
#Save mean mass change to file
mean_masschange %>% write_csv("data/mean_masschange_per_year.csv", na = "", append = FALSE)

#mean_masschange <- as_tibble(read_csv("data/mean_masschange_per_year.csv"))
```

Mean Mass Change by Sex

![](mass_change_per_year_files/figure-gfm/plot%20mean%20mass%20change%20by%20sex-1.png)<!-- -->

Mean Mass Change per year - with error bars

![](mass_change_per_year_files/figure-gfm/plot%20mean%20mass%20change%20NA-1.png)<!-- -->

Mean Mass Change - SD ribbon

![](mass_change_per_year_files/figure-gfm/plot%20mean%20mass%20change-1.png)<!-- -->
