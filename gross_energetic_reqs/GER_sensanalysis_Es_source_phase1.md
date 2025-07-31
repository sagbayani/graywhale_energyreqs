Gross Energetic Requirements(GER) Sensitivity Analysis - phase 1
================
Selina Agbayani
25 Jan 2022 - code updated 31 July, 2025

``` r
# Set path for output figures: 
Figurespath <- paste0(getwd(), "/gross_energetic_reqs/figures", collapse = NULL)
Figurespath
```

    ## [1] "C:/Users/AgbayaniS/Documents/R/graywhale_energyreqs/gross_energetic_reqs/figures"

``` r
# Set path for input & output data  
datapath <- paste0(getwd(), "/data", collapse = NULL) 
datapath
```

    ## [1] "C:/Users/AgbayaniS/Documents/R/graywhale_energyreqs/data"

``` r
## Read data in Production Cost, Es 


P_cost_table <- as_tibble(read_csv("data/P_cost_table_phase1.csv"), 
                          col_types = (list(cols(age_mth = col_double(),
                                                 age_yrs = col_double(),
                                                 mean_masschange = col_double(),
                                                 sd_masschange = col_double(),
                                                 sex = col_character(),
                                                 mean_P = col_double(),
                                                 sd_P = col_double(),
                                                 quant025 = col_double(),
                                                 quant975 = col_double(),
                                                 p_lipid = col_double(),
                                                 p_protein = col_double()
                                                 )
                                            )
                                       )
) 
```

    ## Rows: 39 Columns: 18
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr  (1): sex
    ## dbl (17): age_mth, age_yrs, mean_masschange, sd_masschange, mean_P, sd_P, qu...
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
#P_cost_table <- P_cost_table %>% dplyr::filter(age_yrs >= 0)
kable(head(P_cost_table))
```

| age_mth | age_yrs | mean_masschange | sd_masschange | sex | mean_P | sd_P | quant025 | quant975 | p_lipid | p_protein | mass | mass_sd | Ts | mean_masschange_perday | sd_masschange_perday | mean_P_perday | sd_P_perday |
|---:|---:|---:|---:|:---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 0 | 0.0000000 | 986.5660 | 20.894489 | N/A | 17045.480 | 766.9967 | 15657.439 | 15657.439 | 0.3638438 | 0.1260 | 983.0272 | 26.76770 | 0 | Inf | Inf | Inf | Inf |
| 1 | 0.0849315 | 516.6026 | 8.099161 | N/A | 8749.367 | 379.7509 | 8081.308 | 8081.308 | 0.3898447 | 0.1116 | 1498.2581 | 37.14344 | 31 | 16.66460 | 0.2612633 | 282.2376 | 12.25003 |
| 2 | 0.1616438 | 507.6841 | 12.548106 | N/A | 8425.023 | 405.8457 | 7683.912 | 7683.912 | 0.3721566 | 0.0972 | 2003.8171 | 53.21868 | 28 | 18.13158 | 0.4481466 | 300.8937 | 14.49449 |
| 3 | 0.2465753 | 578.9767 | 13.529226 | N/A | 9608.130 | 456.2691 | 8778.818 | 8778.818 | 0.3872586 | 0.0972 | 2580.5024 | 70.55082 | 31 | 18.67667 | 0.4364266 | 309.9397 | 14.71836 |
| 4 | 0.3287671 | 555.4428 | 9.504603 | N/A | 9217.611 | 412.1595 | 8489.886 | 8489.886 | 0.3358296 | 0.0972 | 3134.3355 | 82.72707 | 30 | 18.51476 | 0.3168201 | 307.2537 | 13.73865 |
| 5 | 0.4136986 | 552.6109 | 6.368057 | N/A | 9170.642 | 393.0700 | 8496.816 | 8496.816 | 0.3745950 | 0.0972 | 3685.8679 | 90.88511 | 31 | 17.82616 | 0.2054212 | 295.8271 | 12.67968 |

``` r
Es_table_phase1_permth <- as_tibble(read_csv("data/Es_sensAnalysis_phase1_permth_source_bpm.csv"), 
                             col_types = (list(cols(age_yrs = col_double(),
                                                    lifestage = col_character(),
                                                    no_days = col_double(),
                                                    Es = col_double(),
                                                    Es_sd = col_double(),
                                                    age_mth = col_double()
                                                    )
                                               )
                                          )
                             )
```

    ## Rows: 48 Columns: 9
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr (2): Lifestage, MC_variable
    ## dbl (7): age_yrs, age_mth, no_days, Es, Es_sd, Es_perday, Es_perday_sd
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
kable(head(Es_table_phase1_permth))
```

| age_yrs | age_mth | Lifestage | no_days | MC_variable | Es | Es_sd | Es_perday | Es_perday_sd |
|---:|---:|:---|---:|:---|---:|---:|---:|---:|
| 0.0849315 | 1 | Calf | 31 | all | 4601.708 | 1306.01149 | 148.4422 | 42.1294030 |
| 0.0849315 | 1 | Calf | 31 | Rs | 4604.314 | 10.78140 | 148.5262 | 0.3477870 |
| 0.0849315 | 1 | Calf | 31 | Vt | 4604.233 | 117.79601 | 148.5236 | 3.7998712 |
| 0.0849315 | 1 | Calf | 31 | pctO2 | 4603.405 | 1315.36968 | 148.4969 | 42.4312801 |
| 0.1616438 | 2 | Calf | 28 | all | 4354.556 | 1236.64343 | 155.5199 | 44.1658368 |
| 0.1616438 | 2 | Calf | 28 | Rs | 4356.999 | 11.19663 | 155.6071 | 0.3998796 |

``` r
mass_table <- as_tibble(read_csv("data/mass_table.csv"), 
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
mean_masschange <- as_tibble(read_csv("data/mean_masschange.csv"),
                             col_types = (list(cols(age_yrs = col_double(),
                                                    mean_masschange = col_double(),
                                                    sd_masschange = col_double(),
                                                    sex = col_character(),
                                                    age_mth = col_double()
                                                    )
                                               )
                                          )
                             )
```

    ## Rows: 39 Columns: 5
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr (1): sex
    ## dbl (4): age_yrs, mean_masschange, sd_masschange, age_mth
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
mean_masschange <- mean_masschange %>% dplyr::filter(age_yrs >=0)
kable(head(mean_masschange))
```

|   age_yrs | mean_masschange | sd_masschange | sex | age_mth |
|----------:|----------------:|--------------:|:----|--------:|
| 0.0000000 |        982.8522 |     27.098452 | N/A |       0 |
| 0.0849315 |        515.1631 |     10.503953 | N/A |       1 |
| 0.1616438 |        505.4539 |     16.273872 | N/A |       2 |
| 0.2465753 |        576.5720 |     17.546305 | N/A |       3 |
| 0.3287671 |        553.7534 |     12.326696 | N/A |       4 |
| 0.4136986 |        551.4791 |      8.258852 | N/A |       5 |

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

``` r
kable(age_yr_tibble)
```

| month | no_days_in_mth | age_mth | no_days_cumul |   age_yrs |
|:------|---------------:|--------:|--------------:|----------:|
| Jan   |            0.0 |     0.0 |           0.0 | 0.0000000 |
| Jan   |           15.5 |     0.5 |          15.5 | 0.0424658 |
| Jan   |           15.5 |     1.0 |          31.0 | 0.0849315 |
| Feb   |           14.0 |     1.5 |          45.0 | 0.1232877 |
| Feb   |           14.0 |     2.0 |          59.0 | 0.1616438 |
| Mar   |           15.5 |     2.5 |          74.5 | 0.2041096 |
| Mar   |           15.5 |     3.0 |          90.0 | 0.2465753 |
| Apr   |           15.0 |     3.5 |         105.0 | 0.2876712 |
| Apr   |           15.0 |     4.0 |         120.0 | 0.3287671 |
| May   |           15.5 |     4.5 |         135.5 | 0.3712329 |
| May   |           15.5 |     5.0 |         151.0 | 0.4136986 |
| Jun   |           15.0 |     5.5 |         166.0 | 0.4547945 |
| Jun   |           15.0 |     6.0 |         181.0 | 0.4958904 |
| Jul   |           15.5 |     6.5 |         196.5 | 0.5383562 |
| Jul   |           15.5 |     7.0 |         212.0 | 0.5808219 |
| Aug   |           15.5 |     7.5 |         227.5 | 0.6232877 |
| Aug   |           15.5 |     8.0 |         243.0 | 0.6657534 |
| Sep   |           15.0 |     8.5 |         258.0 | 0.7068493 |
| Sep   |           15.0 |     9.0 |         273.0 | 0.7479452 |
| Oct   |           15.5 |     9.5 |         288.5 | 0.7904110 |
| Oct   |           15.5 |    10.0 |         304.0 | 0.8328767 |
| Nov   |           15.0 |    10.5 |         319.0 | 0.8739726 |
| Nov   |           15.0 |    11.0 |         334.0 | 0.9150685 |
| Dec   |           15.5 |    11.5 |         349.5 | 0.9575342 |
| Dec   |           15.5 |    12.0 |         365.0 | 1.0000000 |

MC calculations for Production Cost and Es

``` r
#All sd values set to 0 except for variable being varied. 

#Energy Density values
ED_milk = 22.33 #MJ/kg   Average between Tomilin 1946 and Zenkovich 1938,    (Sumich 1986 - cited 22.4  MJ/kg)

MC_reps = 10000
```

``` r
predict_GER_table_sensAnalysis <- as.data.frame(matrix(ncol = 22, nrow = 0))

cnames <- c("phase", "age_yrs", "sex","MC_variable",
            "mean_GER", "GER_sd", 
            "quant025", "quant975", "GER_foraging",
            "sd_foraging","quant025_foraging", "quant975_foraging",
            "FR_foraging", "FR_sd_foraging", 
            "FR_quant025", "FR_quant975", "Ts", "mass",
                    "mass_sd", "pctbodywt", "pctbodywt_sd", "pct_unit")            

colnames(predict_GER_table_sensAnalysis) <- cnames

predict_GER_table_sensAnalysis <- as_tibble(
  predict_GER_table_sensAnalysis,
  col_types = (list(ID = col_integer(),
                    phase = col_character(),
                    age_yrs = col_double(), 
                    sex = col_character(),
                    MC_variable = col_character(),
                    mean_GER = col_double(), 
                    GER_sd = col_double(), 
                    quant025 = col_double(), 
                    quant975 = col_double(), 
                    GER_foraging = col_double(),
                    sd_foraging = col_double(), 
                    quant025_foraging = col_double(),
                    quant975_foraging = col_double(),
                    FR_foraging = col_double(),
                    FR_sd_foraging = col_double(),
                    FR_quant025 = col_double(),
                    FR_quant975 = col_double(),
                    Ts = col_double(),
                    mass = col_double(),
                    mass_sd = col_double(),
                    pctbodywt = col_double(),
                    pctbodywt_sd = col_double(),
                    pct_unit = col_character()
  )
  )
)



for (s in c("N/A")){
  for (MC_var in c("all","P_cost", "Es", "E_FnU")){
    for (i in seq(from = 1, to = 12, by = 1)){ 
      
      # Age values
      age <- age_yr_tibble %>% 
        filter(age_mth == i) %>% 
        pull(age_yrs) #calculate age_yrs (do not round up)
      
      age_mid_i <- age_yr_tibble %>% 
        filter(age_mth == i-0.5)  %>% 
        pull(age_yrs)
      
      # Mass values
      mass <- mass_table %>% 
        filter(round(age_yrs,3) == round(age,3)) %>% 
        pull(mean_mass)
      if (MC_var == "all"){
        mass_sd <- mass_table %>%
        filter(round(age_yrs,3) == round(age,3)) %>%
        pull(sd_mass)  
      } else {
        mass_sd = 0
      }
      
      # Production Cost (P_cost)
      P_cost_i <- P_cost_table %>%
        dplyr::filter(round(P_cost_table$age_yrs*12) == i
                      & P_cost_table$sex == s)
      
      Ts <- P_cost_i$Ts
      mean_P <- P_cost_i$mean_P
      
      if (MC_var == "P_cost" || MC_var == "all"){
        sd_P <- P_cost_i$sd_P
      } else {
        sd_P = 0
      }
      
      
      #Total metabolic energy expenditure (Es)
      Es_table_i <- Es_table_phase1_permth %>%
        dplyr::filter(Es_table_phase1_permth$age_yrs == age)
      
      Es <- Es_table_i$Es
      if (MC_var == "Es" || MC_var == "all"){
        Es_sd <- Es_table_i$Es_sd
      } else {
        Es_sd = 0   
      }
      
      
      #Fecal and Urinary cost - E_FnU
      E_FnU_min = 0.740
      E_FnU_max = 0.858
      E_FnU_mean = (E_FnU_min + E_FnU_max)/2
      
      #Energetic density of Prey - ED_prey
      ED_prey_mean = 2.90 #MJ/kg  from average I calculated... 
      
      if (MC_var == "all"){
        ED_prey_sd = 0.0408  #calculated from table 3  
      } else {
        ED_prey_sd = 0
      }
      
      ED_prey_min = 2.51   #from Coyle et al. 2007
      ED_prey_max = 3.41   #from Stoker 1978

      
      #### Monte carlo - Production cost 
      set.seed(12345)
      MC_vars_i <- as_tibble(rnorm(MC_reps, mean_P, sd_P))
      names(MC_vars_i)[1] <- "P_cost"
      
      #Add columns and move to the front
      MC_vars_i$sex <- s
      MC_vars_i$GER <- NA
      MC_vars_i<- MC_vars_i %>%  dplyr::select(sex, GER, everything()) 
      
      
      #### Monte carlo - Energy expenditure - Es
      set.seed(12345)
      Es_i <-  as_tibble(rnorm(MC_reps, Es, Es_sd))
      names(Es_i)[1] <- "Es"
      
      MC_vars_i <- cbind(MC_vars_i, Es_i)
      
      #### Monte carlo - Fecal and urinary waste - E_FnU
      set.seed(12345)
      if (MC_var == "E_FnU" || MC_var == "all"){
        E_FnU_i <- as_tibble(runif(MC_reps, min = E_FnU_min, max = E_FnU_max)) 
      } else {
        E_FnU_i <- as_tibble(runif(MC_reps, min = E_FnU_mean, max = E_FnU_mean)) 
      }
      names(E_FnU_i)[1] <- "E_FnU"
      
      MC_vars_i <- cbind(MC_vars_i, E_FnU_i)
      
      #### Monte carlo - Energetic density of prey - ED_prey
      set.seed(12345)
      ED_prey_i <- as_tibble(rnorm(MC_reps, ED_prey_mean, ED_prey_sd)) 
      names(ED_prey_i)[1] <- "ED_prey"
      
      MC_vars_i <- cbind(MC_vars_i, ED_prey_i)
      
      #### Monte carlo - Mass 
      set.seed(12345)
      mass_i <-  as_tibble(rnorm(MC_reps, mass, mass_sd))
      names(mass_i)[1] <- "mass"
      
      MC_vars_i <- cbind(MC_vars_i, mass_i)
      
      
      # pulling values from the MC_vars_i tibble 
      P_cost <- MC_vars_i$P_cost # should be P_cost at monthly time step
      Es <- MC_vars_i$Es
      E_FnU <- MC_vars_i$E_FnU
      ED_prey <- MC_vars_i$ED_prey
      mass <- MC_vars_i$mass
      
      #GER calculation  -- Es includes digestion, maintenance and activity
      MC_vars_i$GER <- (((P_cost + Es)/(E_FnU))/Ts) # per day for the timestep
      MC_vars_i$GER_foraging <- (((P_cost + Es)/(E_FnU))/Ts) # per day for # days actively foraging
      
      
      if (age <= 0.84){
        MC_vars_i$FR_foraging <- (MC_vars_i$GER / ED_milk) 
        MC_vars_i$pctbodywt <- (MC_vars_i$FR_foraging / MC_vars_i$mass)
        pct_unit_i <- "L milk/kg body weight"
        
      } else {
        MC_vars_i$FR_foraging <- (MC_vars_i$GER_foraging /MC_vars_i$ED_prey) 
        MC_vars_i$pctbodywt <- (MC_vars_i$FR_foraging / MC_vars_i$mass)*100 
        pct_unit_i <- "% of body weight"
      }
      
      MC_vars_i <- MC_vars_i %>%  dplyr::mutate(ID = row_number())
      MC_vars_i<- MC_vars_i %>%  dplyr::select(ID,everything()) # move ID to the first column
      
      mean_GER_i <- mean(MC_vars_i$GER)
      sd_GER_i <- sd(MC_vars_i$GER)
      
      quant025 <- quantile(MC_vars_i$GER, 0.025, na.rm = TRUE)
      quant975 <- quantile(MC_vars_i$GER, 0.975, na.rm = TRUE)
      
      GER_foraging_i <- mean(MC_vars_i$GER_foraging)
      sd_foraging_i <- sd(MC_vars_i$GER_foraging)
      
      quant025_foraging <- quantile(MC_vars_i$GER_foraging, 0.025, na.rm = TRUE)
      quant975_foraging <- quantile(MC_vars_i$GER_foraging, 0.975, na.rm = TRUE)
      
      FR_foraging_i <- mean(MC_vars_i$FR_foraging)
      FR_sd_foraging_i <- sd(MC_vars_i$FR_foraging)
      FR_quant025_i <- quantile(MC_vars_i$FR_foraging, 0.025, na.rm = TRUE)
      FR_quant975_i <- quantile(MC_vars_i$FR_foraging, 0.975, na.rm = TRUE)
      
      pctbodywt_i <- mean(MC_vars_i$pctbodywt)
      pctbodywt_sd_i <- sd(MC_vars_i$pctbodywt)
      
      mass <- mean(MC_vars_i$mass)
      mass_sd <- sd(MC_vars_i$mass)
      
      
      
      row <- tibble(phase = "1",
                    age_yrs = age, 
                    sex = s, 
                    MC_variable = MC_var,
                    mean_GER = mean_GER_i, 
                    GER_sd = sd_GER_i, 
                    quant025 = quant025, 
                    quant975 = quant975, 
                    GER_foraging = GER_foraging_i,
                    sd_foraging = sd_foraging_i, 
                    quant025_foraging = quant025_foraging,
                    quant975_foraging = quant975_foraging,
                    FR_foraging = FR_foraging_i,
                    FR_sd_foraging = FR_sd_foraging_i,
                    FR_quant025 = FR_quant025_i,
                    FR_quant975 = FR_quant975_i,
                    Ts = Ts,
                    mass = mass,
                    mass_sd = mass_sd,
                    pctbodywt = pctbodywt_i,
                    pctbodywt_sd = pctbodywt_sd_i,
                    pct_unit = pct_unit_i
      )
      
      predict_GER_table_sensAnalysis <- rbind(predict_GER_table_sensAnalysis, row)
      
    }  
  } 
  
}

predict_GER_table_sensAnalysis_phase1_permth <- predict_GER_table_sensAnalysis

predict_GER_table_sensAnalysis_phase1_permth$age_mth <- round(predict_GER_table_sensAnalysis_phase1_permth$age_yrs * 12)

predict_GER_table_sensAnalysis_phase1_permth %>% write_csv("data/predict_GER_table_sensAnalysis_phase1_permth_source_bpm.csv", na = "", append = FALSE)

kable(predict_GER_table_sensAnalysis_phase1_permth)
```

| phase | age_yrs | sex | MC_variable | mean_GER | GER_sd | quant025 | quant975 | GER_foraging | sd_foraging | quant025_foraging | quant975_foraging | FR_foraging | FR_sd_foraging | FR_quant025 | FR_quant975 | Ts | mass | mass_sd | pctbodywt | pctbodywt_sd | pct_unit | age_mth |
|:---|---:|:---|:---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|:---|---:|
| 1 | 0.0849315 | N/A | all | 539.6875 | 55.439240 | 420.5985 | 658.8054 | 539.6875 | 55.439240 | 420.5985 | 658.8054 | 24.16872 | 2.4827246 | 18.83558 | 29.50315 | 31 | 1498.233 | 37.13787 | 0.0161090 | 0.0013667 | L milk/kg body weight | 1 |
| 1 | 0.1616438 | N/A | all | 571.9377 | 59.897249 | 443.5188 | 700.2593 | 571.9377 | 59.897249 | 443.5188 | 700.2593 | 25.61297 | 2.6823667 | 19.86201 | 31.35958 | 28 | 2003.780 | 53.21070 | 0.0127628 | 0.0010882 | L milk/kg body weight | 2 |
| 1 | 0.2465753 | N/A | all | 559.6718 | 47.883514 | 461.0710 | 657.4962 | 559.6718 | 47.883514 | 461.0710 | 657.4962 | 25.06367 | 2.1443580 | 20.64805 | 29.44452 | 31 | 2580.454 | 70.54024 | 0.0097022 | 0.0006426 | L milk/kg body weight | 3 |
| 1 | 0.3287671 | N/A | all | 530.9762 | 49.648403 | 427.1272 | 634.5545 | 530.9762 | 49.648403 | 427.1272 | 634.5545 | 23.77860 | 2.2233947 | 19.12795 | 28.41713 | 30 | 3134.278 | 82.71465 | 0.0075770 | 0.0005639 | L milk/kg body weight | 4 |
| 1 | 0.4136986 | N/A | all | 546.1253 | 54.070410 | 431.1852 | 661.0533 | 546.1253 | 54.070410 | 431.1852 | 661.0533 | 24.45702 | 2.4214245 | 19.30968 | 29.60382 | 31 | 3685.805 | 90.87147 | 0.0066267 | 0.0005384 | L milk/kg body weight | 5 |
| 1 | 0.4958904 | N/A | all | 599.4550 | 51.179542 | 492.0861 | 706.3557 | 599.4550 | 51.179542 | 492.0861 | 706.3557 | 26.84527 | 2.2919634 | 22.03699 | 31.63259 | 30 | 4188.934 | 92.44531 | 0.0064026 | 0.0004498 | L milk/kg body weight | 6 |
| 1 | 0.5808219 | N/A | all | 743.6525 | 89.813260 | 545.3535 | 942.8078 | 743.6525 | 89.813260 | 545.3535 | 942.8078 | 33.30284 | 4.0220896 | 24.42246 | 42.22158 | 31 | 4670.710 | 91.40099 | 0.0071201 | 0.0007617 | L milk/kg body weight | 7 |
| 1 | 0.6657534 | N/A | all | 762.6517 | 96.531867 | 547.8885 | 977.9855 | 762.6517 | 96.531867 | 547.8885 | 977.9855 | 34.15368 | 4.3229676 | 24.53598 | 43.79693 | 31 | 5110.500 | 90.41413 | 0.0066738 | 0.0007618 | L milk/kg body weight | 8 |
| 1 | 0.7479452 | N/A | all | 777.3938 | 102.645174 | 548.1038 | 1006.8728 | 777.3938 | 102.645174 | 548.1038 | 1006.8728 | 34.81387 | 4.5967387 | 24.54563 | 45.09059 | 30 | 5495.401 | 93.43444 | 0.0063263 | 0.0007602 | L milk/kg body weight | 9 |
| 1 | 0.8328767 | N/A | all | 683.9532 | 122.894134 | 424.6957 | 939.1442 | 683.9532 | 122.894134 | 424.6957 | 939.1442 | 30.62934 | 5.5035439 | 19.01906 | 42.05751 | 31 | 5802.591 | 211.60921 | 0.0052542 | 0.0007828 | L milk/kg body weight | 10 |
| 1 | 0.9150685 | N/A | all | 424.8265 | 64.693934 | 279.1008 | 569.1465 | 424.8265 | 64.693934 | 279.1008 | 569.1465 | 146.28308 | 20.8020603 | 98.56456 | 192.14816 | 30 | 5935.437 | 207.11639 | 2.4587485 | 0.2970785 | % of body weight | 11 |
| 1 | 1.0000000 | N/A | all | 432.6626 | 66.135785 | 283.7109 | 580.1292 | 432.6626 | 66.135785 | 283.7109 | 580.1292 | 148.98084 | 21.2745822 | 100.16555 | 195.94384 | 31 | 6072.716 | 202.08059 | 2.4476053 | 0.2994033 | % of body weight | 12 |
| 1 | 0.0849315 | N/A | P_cost | 539.0819 | 15.329991 | 508.6042 | 569.1905 | 539.0819 | 15.329991 | 508.6042 | 569.1905 | 24.14160 | 0.6865200 | 22.77672 | 25.48995 | 31 | 1498.258 | 0.00000 | 0.0161131 | 0.0004582 | L milk/kg body weight | 1 |
| 1 | 0.1616438 | N/A | P_cost | 571.2898 | 18.138672 | 535.2277 | 606.9147 | 571.2898 | 18.138672 | 535.2277 | 606.9147 | 25.58396 | 0.8123006 | 23.96900 | 27.17934 | 28 | 2003.817 | 0.00000 | 0.0127676 | 0.0004054 | L milk/kg body weight | 2 |
| 1 | 0.2465753 | N/A | P_cost | 558.9276 | 18.418729 | 522.3083 | 595.1025 | 558.9276 | 18.418729 | 522.3083 | 595.1025 | 25.03035 | 0.8248423 | 23.39043 | 26.65036 | 31 | 2580.502 | 0.00000 | 0.0096998 | 0.0003196 | L milk/kg body weight | 3 |
| 1 | 0.3287671 | N/A | P_cost | 530.3148 | 17.192668 | 496.1330 | 564.0813 | 530.3148 | 17.192668 | 496.1330 | 564.0813 | 23.74898 | 0.7699359 | 22.21823 | 25.26114 | 30 | 3134.335 | 0.00000 | 0.0075770 | 0.0002456 | L milk/kg body weight | 4 |
| 1 | 0.4136986 | N/A | P_cost | 545.4901 | 15.867603 | 513.9432 | 576.6545 | 545.4901 | 15.867603 | 513.9432 | 576.6545 | 24.42857 | 0.7105958 | 23.01582 | 25.82421 | 31 | 3685.868 | 0.00000 | 0.0066276 | 0.0001928 | L milk/kg body weight | 5 |
| 1 | 0.4958904 | N/A | P_cost | 598.7002 | 14.394875 | 570.0824 | 626.9725 | 598.7002 | 14.394875 | 570.0824 | 626.9725 | 26.81147 | 0.6446429 | 25.52989 | 28.07758 | 30 | 4188.998 | 0.00000 | 0.0064005 | 0.0001539 | L milk/kg body weight | 6 |
| 1 | 0.5808219 | N/A | P_cost | 743.0011 | 13.317365 | 716.5151 | 769.1563 | 743.0011 | 13.317365 | 716.5151 | 769.1563 | 33.27367 | 0.5963889 | 32.08756 | 34.44498 | 31 | 4670.773 | 0.00000 | 0.0071238 | 0.0001277 | L milk/kg body weight | 7 |
| 1 | 0.6657534 | N/A | P_cost | 762.0392 | 12.157980 | 737.8607 | 785.9172 | 762.0392 | 12.157980 | 737.8607 | 785.9172 | 34.12625 | 0.5444684 | 33.04347 | 35.19558 | 31 | 5110.562 | 0.00000 | 0.0066776 | 0.0001065 | L milk/kg body weight | 8 |
| 1 | 0.7479452 | N/A | P_cost | 776.8214 | 11.129523 | 754.6954 | 798.6639 | 776.8214 | 11.129523 | 754.6954 | 798.6639 | 34.78824 | 0.4984112 | 33.79738 | 35.76641 | 30 | 5495.466 | 0.00000 | 0.0063304 | 0.0000907 | L milk/kg body weight | 9 |
| 1 | 0.8328767 | N/A | P_cost | 683.3143 | 63.274363 | 557.5177 | 807.5683 | 683.3143 | 63.274363 | 557.5177 | 807.5683 | 30.60073 | 2.8336034 | 24.96720 | 36.16517 | 31 | 5802.737 | 0.00000 | 0.0052735 | 0.0004883 | L milk/kg body weight | 10 |
| 1 | 0.9150685 | N/A | P_cost | 424.5656 | 4.515806 | 415.5838 | 433.4266 | 424.5656 | 4.515806 | 415.5838 | 433.4266 | 146.40192 | 1.5571743 | 143.30475 | 149.45743 | 30 | 5935.580 | 0.00000 | 2.4665141 | 0.0262346 | % of body weight | 11 |
| 1 | 1.0000000 | N/A | P_cost | 432.4019 | 4.632349 | 423.1871 | 441.4918 | 432.4019 | 4.632349 | 423.1871 | 441.4918 | 149.10412 | 1.5973619 | 145.92658 | 152.23856 | 31 | 6072.856 | 0.00000 | 2.4552553 | 0.0263033 | % of body weight | 12 |
| 1 | 0.0849315 | N/A | Es | 538.7680 | 37.688796 | 449.9233 | 625.9349 | 538.7680 | 37.688796 | 449.9233 | 625.9349 | 24.12754 | 1.6878099 | 20.14883 | 28.03112 | 31 | 1498.258 | 0.00000 | 0.0161037 | 0.0011265 | L milk/kg body weight | 1 |
| 1 | 0.1616438 | N/A | Es | 570.9638 | 39.507292 | 477.8238 | 662.2855 | 570.9638 | 39.507292 | 477.8238 | 662.2855 | 25.56936 | 1.7692473 | 21.39829 | 29.65900 | 28 | 2003.817 | 0.00000 | 0.0127603 | 0.0008829 | L milk/kg body weight | 2 |
| 1 | 0.2465753 | N/A | Es | 558.7214 | 25.637376 | 498.2579 | 617.9543 | 558.7214 | 25.637376 | 498.2579 | 617.9543 | 25.02111 | 1.1481136 | 22.31339 | 27.67373 | 31 | 2580.502 | 0.00000 | 0.0096962 | 0.0004449 | L milk/kg body weight | 3 |
| 1 | 0.3287671 | N/A | Es | 530.0736 | 29.584858 | 460.3198 | 598.4415 | 530.0736 | 29.584858 | 460.3198 | 598.4415 | 23.73818 | 1.3248929 | 20.61441 | 26.79989 | 30 | 3134.335 | 0.00000 | 0.0075736 | 0.0004227 | L milk/kg body weight | 4 |
| 1 | 0.4136986 | N/A | Es | 545.1954 | 35.545710 | 461.3967 | 627.3885 | 545.1954 | 35.545710 | 461.3967 | 627.3885 | 24.41538 | 1.5918365 | 20.66264 | 28.09622 | 31 | 3685.868 | 0.00000 | 0.0066241 | 0.0004319 | L milk/kg body weight | 5 |
| 1 | 0.4958904 | N/A | Es | 598.4346 | 32.273103 | 522.3241 | 673.0037 | 598.4346 | 32.273103 | 522.3241 | 673.0037 | 26.79958 | 1.4452800 | 23.39114 | 30.13899 | 30 | 4188.998 | 0.00000 | 0.0063976 | 0.0003450 | L milk/kg body weight | 6 |
| 1 | 0.5808219 | N/A | Es | 742.3794 | 73.206541 | 569.8241 | 911.7335 | 742.3794 | 73.206541 | 569.8241 | 911.7335 | 33.24583 | 3.2783942 | 25.51832 | 40.82998 | 31 | 4670.773 | 0.00000 | 0.0071178 | 0.0007019 | L milk/kg body weight | 7 |
| 1 | 0.6657534 | N/A | Es | 761.3447 | 81.035914 | 570.2727 | 948.9437 | 761.3447 | 81.035914 | 570.2727 | 948.9437 | 34.09515 | 3.6290154 | 25.53841 | 42.49636 | 31 | 5110.562 | 0.00000 | 0.0066715 | 0.0007101 | L milk/kg body weight | 8 |
| 1 | 0.7479452 | N/A | Es | 776.0603 | 88.131170 | 568.1455 | 980.2082 | 776.0603 | 88.131170 | 568.1455 | 980.2082 | 34.75416 | 3.9467608 | 25.44315 | 43.89647 | 30 | 5495.466 | 0.00000 | 0.0063242 | 0.0007182 | L milk/kg body weight | 9 |
| 1 | 0.8328767 | N/A | Es | 682.7981 | 64.091970 | 531.5748 | 831.2840 | 682.7981 | 64.091970 | 531.5748 | 831.2840 | 30.57761 | 2.8702181 | 23.80541 | 37.22723 | 31 | 5802.737 | 0.00000 | 0.0052695 | 0.0004946 | L milk/kg body weight | 10 |
| 1 | 0.9150685 | N/A | Es | 424.0945 | 58.279670 | 286.9086 | 558.3927 | 424.0945 | 58.279670 | 286.9086 | 558.3927 | 146.23949 | 20.0964378 | 98.93401 | 192.54921 | 30 | 5935.580 | 0.00000 | 2.4637777 | 0.3385758 | % of body weight | 11 |
| 1 | 1.0000000 | N/A | Es | 431.9172 | 59.595505 | 291.5281 | 569.2292 | 431.9172 | 59.595505 | 291.5281 | 569.2292 | 148.93695 | 20.5501740 | 100.52694 | 196.28594 | 31 | 6072.856 | 0.00000 | 2.4525026 | 0.3383939 | % of body weight | 12 |
| 1 | 0.0849315 | N/A | E_FnU | 540.0102 | 22.948195 | 503.7839 | 579.6952 | 540.0102 | 22.948195 | 503.7839 | 579.6952 | 24.18317 | 1.0276845 | 22.56086 | 25.96038 | 31 | 1498.258 | 0.00000 | 0.0161409 | 0.0006859 | L milk/kg body weight | 1 |
| 1 | 0.1616438 | N/A | E_FnU | 572.2749 | 24.319305 | 533.8840 | 614.3308 | 572.2749 | 24.319305 | 533.8840 | 614.3308 | 25.62807 | 1.0890866 | 23.90882 | 27.51146 | 28 | 2003.817 | 0.00000 | 0.0127896 | 0.0005435 | L milk/kg body weight | 2 |
| 1 | 0.2465753 | N/A | E_FnU | 559.8918 | 23.793048 | 522.3314 | 601.0375 | 559.8918 | 23.793048 | 522.3314 | 601.0375 | 25.07353 | 1.0655194 | 23.39147 | 26.91614 | 31 | 2580.502 | 0.00000 | 0.0097165 | 0.0004129 | L milk/kg body weight | 3 |
| 1 | 0.3287671 | N/A | E_FnU | 531.2295 | 22.574997 | 495.5919 | 570.2688 | 531.2295 | 22.574997 | 495.5919 | 570.2688 | 23.78994 | 1.0109716 | 22.19400 | 25.53824 | 30 | 3134.335 | 0.00000 | 0.0075901 | 0.0003225 | L milk/kg body weight | 4 |
| 1 | 0.4136986 | N/A | E_FnU | 546.4296 | 23.220975 | 509.7726 | 586.5863 | 546.4296 | 23.220975 | 509.7726 | 586.5863 | 24.47065 | 1.0399004 | 22.82905 | 26.26898 | 31 | 3685.868 | 0.00000 | 0.0066390 | 0.0002821 | L milk/kg body weight | 5 |
| 1 | 0.4958904 | N/A | E_FnU | 599.7293 | 25.486024 | 559.4973 | 643.8036 | 599.7293 | 25.486024 | 559.4973 | 643.8036 | 26.85756 | 1.1413356 | 25.05586 | 28.83133 | 30 | 4188.998 | 0.00000 | 0.0064115 | 0.0002725 | L milk/kg body weight | 6 |
| 1 | 0.5808219 | N/A | E_FnU | 744.2752 | 31.628781 | 694.3635 | 798.9783 | 744.2752 | 31.628781 | 694.3635 | 798.9783 | 33.33073 | 1.4164255 | 31.09554 | 35.78049 | 31 | 4670.773 | 0.00000 | 0.0071360 | 0.0003033 | L milk/kg body weight | 7 |
| 1 | 0.6657534 | N/A | E_FnU | 763.3448 | 32.439222 | 712.1603 | 819.4446 | 763.3448 | 32.439222 | 712.1603 | 819.4446 | 34.18472 | 1.4527193 | 31.89253 | 36.69702 | 31 | 5110.562 | 0.00000 | 0.0066890 | 0.0002843 | L milk/kg body weight | 8 |
| 1 | 0.7479452 | N/A | E_FnU | 778.1515 | 33.068505 | 725.9772 | 835.3402 | 778.1515 | 33.068505 | 725.9772 | 835.3402 | 34.84781 | 1.4809004 | 32.51130 | 37.40888 | 30 | 5495.466 | 0.00000 | 0.0063412 | 0.0002695 | L milk/kg body weight | 9 |
| 1 | 0.8328767 | N/A | E_FnU | 684.5213 | 29.089605 | 638.6277 | 734.8292 | 684.5213 | 29.089605 | 638.6277 | 734.8292 | 30.65478 | 1.3027141 | 28.59954 | 32.90771 | 31 | 5802.737 | 0.00000 | 0.0052828 | 0.0002245 | L milk/kg body weight | 10 |
| 1 | 0.9150685 | N/A | E_FnU | 425.2914 | 18.073313 | 396.7812 | 456.5480 | 425.2914 | 18.073313 | 396.7812 | 456.5480 | 146.65222 | 6.2321769 | 136.82110 | 157.43033 | 30 | 5935.580 | 0.00000 | 2.4707312 | 0.1049969 | % of body weight | 11 |
| 1 | 1.0000000 | N/A | E_FnU | 433.1412 | 18.406908 | 404.1053 | 464.9754 | 433.1412 | 18.406908 | 404.1053 | 464.9754 | 149.35905 | 6.3472097 | 139.34665 | 160.33634 | 31 | 6072.856 | 0.00000 | 2.4594532 | 0.1045177 | % of body weight | 12 |

``` r
predict_GER_table_sensAnalysis_phase1_permth_allvary <- predict_GER_table_sensAnalysis_phase1_permth %>% 
  dplyr::filter(sex == "N/A", MC_variable == "all")
  
average_GER_first_yr <- 
  mean(predict_GER_table_sensAnalysis_phase1_permth_allvary$mean_GER)
average_GER_first_yr
```

    ## [1] 597.7495

``` r
average_GER_first_yr_sd <- 
  mean(predict_GER_table_sensAnalysis_phase1_permth_allvary$GER_sd)
average_GER_first_yr_sd
```

    ## [1] 71.73604

``` r
predict_GER_table_sensAnalysis_phase1_permth$MC_var_factor <- 
  factor(predict_GER_table_sensAnalysis_phase1_permth$MC_variable, 
         levels=c('all','P_cost','Es','E_FnU'))

# New facet label names for MC_var_factor variable
MC_var_factor.labs <- c("All variables", "P", "Es", "E F+U")
names(MC_var_factor.labs) <- c("all", "P_cost", "Es","E_FnU")

plot_predict_GER_sensAnalysis_phase1_permth <- 
  predict_GER_table_sensAnalysis_phase1_permth %>%
  dplyr::filter(sex == "N/A") %>% 
  ggplot(aes(x = age_mth, y = mean_GER)) +
  geom_errorbar(aes(x = age_mth-0.5, 
                    ymin = mean_GER-GER_sd, 
                    ymax = mean_GER+GER_sd), 
                width=0, 
                linetype = 3,
                color="gray40") + 
  geom_point(aes(x = age_mth-0.5, y= mean_GER), 
             shape = 21, fill = "black")+
  facet_grid(~MC_var_factor, 
             labeller = labeller(MC_var_factor = MC_var_factor.labs)) +
  xlab("Age (months)") +
  ylab(bquote('Gross Energetic Reqs (MJ day '^'-1'*')')) +
  scale_x_continuous(breaks = scales::pretty_breaks(n = 5)) + 
  #limits = c(0, 30)) +  # max x-axis 30 yrs. 
  scale_y_continuous(breaks = scales::pretty_breaks(n = 7),
                     limits = c(0,1100)) + 
  theme_bw()+
  theme(panel.grid = element_blank())+
  theme(panel.spacing = unit(0.6, "lines"))+
  theme(strip.background = element_rect(
    color="black", fill=NA))+
  theme(axis.text = element_text(size = rel(1),
                                 colour = "black")) +
  theme(axis.title.x = element_text(size = rel(1.2),
                                    colour = "black")) +
  theme(axis.title.y = element_text(size = rel(1.2),
                                    colour = "black"))


plot_predict_GER_sensAnalysis_phase1_permth
```

![](GER_sensanalysis_Es_source_phase1_files/figure-gfm/plotsGERphase1-1.png)<!-- -->

``` r
plot_predict_GER_sensAnalysis_phase1_permth_black <- predict_GER_table_sensAnalysis_phase1_permth %>%
  dplyr::filter(sex == "N/A") %>% 
  ggplot(aes(x = age_mth, y = mean_GER)) +
  geom_errorbar(aes(x = age_mth-0.5, 
                    ymin = mean_GER-GER_sd, 
                    ymax = mean_GER+GER_sd), 
                width=0, 
                linetype = 3,
                linewidth = 1,
                color="gray60") + 
  geom_point(aes(x = age_mth-0.5, y= mean_GER), 
             size = 1.5, shape = 21, fill = "white")+
  facet_grid(~MC_var_factor, labeller = labeller(MC_var_factor = MC_var_factor.labs)) +
  xlab("Age (months)") +
  ylab(bquote('Gross Energetic Reqs (MJ day '^'-1'*')')) +
  scale_x_continuous(breaks = scales::pretty_breaks(n = 5)) + 
  #limits = c(0, 30)) +  # max x-axis 30 yrs. 
  scale_y_continuous(breaks = scales::pretty_breaks(n = 7),
                     limits = c(0,1100)) + 
  theme_bw()+
  theme(panel.spacing = unit(0.6, "lines"))+
  theme(strip.background = element_rect(
    color="white", fill="black"))+
   theme(strip.text = element_text(colour = 'white'))+
  theme(panel.grid = element_blank()) +
  theme(legend.position = "none") +
  theme(legend.background = element_rect(fill = "black")) +
  theme(legend.text = element_text(colour = "white", 
                                   size = rel(1))) +
  theme(legend.key = element_rect(fill = "transparent")) + 
  theme(plot.background = element_rect(fill = "black", colour = NA)) + 
  theme(panel.background = element_rect(fill = "black")) + 
  theme(panel.border = element_rect(colour = "white")) +
  theme(axis.line = element_line(#linewidth = 1, 
                                 colour = "white")) +
  theme(axis.text = element_text(colour = "white", 
                                 size = rel(1))) + 
  theme(axis.title.y = element_text(colour = "white", 
                                    size = rel(1.2), 
                                    angle = 90)) +
  theme(axis.title.x = element_text(colour = "white", 
                                    size = rel(1.2))) +
  theme(axis.ticks = element_line(colour="white"))


plot_predict_GER_sensAnalysis_phase1_permth_black
```

![](GER_sensanalysis_Es_source_phase1_files/figure-gfm/plotsGERphase1-2.png)<!-- -->
