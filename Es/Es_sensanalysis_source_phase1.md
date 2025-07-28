Energy Expenditure (Es) Sensitivity Analysis - Phase 1
================
Selina Agbayani
02 March 2022 - code updated on 27 July, 2025

NOTE - this code will run for a long time.

``` r
############ Set path for output figures: ###############
Figurespath <- paste0(getwd(), "/Es/figures", collapse = NULL)
Figurespath
```

    ## [1] "C:/Users/AgbayaniS/Documents/R/graywhale_energyreqs/Es/figures"

``` r
############ Set path for input & output data  ###########
datapath <- paste0(getwd(), "/data", collapse = NULL) 
datapath
```

    ## [1] "C:/Users/AgbayaniS/Documents/R/graywhale_energyreqs/data"

``` r
# Read in Tidal Volume table - Vt
Vt_table_phase1 <- as_tibble(read_csv("data/Vt_table_phase1.csv"),                                
                          col_types = (list(cols(age_yrs = col_double(),
                                                 Vt_mean = col_double(),
                                                 Vt_sd = col_double(),
                                                 quant025 = col_double(),
                                                 quant975 = col_double()
                                                 )
                                            )
                                       )
                          )
```

    ## Rows: 25 Columns: 5
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## dbl (5): age_yrs, Vt_mean, Vt_sd, quant025, quant975
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
# Read in Activity Cost Reference data from csv  ORIGINAL SOURCE VALUES
A_cost_reference <- as_tibble(
  read_csv("data/ActivityCost_ReferenceData_BreathsPerDay_Table_VA_2017_original_sources.csv"),
  col_types = (list(cols(  ID = col_double(),
                           Lifestage = col_character(),
                           Description = col_character(),
                           Activity_stages = col_character(),
                           no_days = col_double(),
                           source_no_days = col_character(),
                           bpm = col_double(),
                           se_bpm = col_double(),
                           source_bpm = col_character(),
                           age_yrs = col_double(),
                           age_yrs_min = col_double(),
                           age_yrs_max = col_double(),
                           pct_O2 = col_double(),
                           pct_O2_sd = col_double()
  )
  )
  )
)
```

    ## Rows: 60 Columns: 14
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr (5): Lifestage, Description, Activity_stages, source_no_days, source_bpm
    ## dbl (9): ID, no_days, bpm, se_bpm, age_yrs, age_yrs_min, age_yrs_max, pct_O2...
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
kable(head(A_cost_reference))
```

| ID | Lifestage | Description | Activity_stages | no_days | source_no_days | bpm | se_bpm | source_bpm | age_yrs | age_yrs_min | age_yrs_max | pct_O2 | pct_O2_sd |
|---:|:---|:---|:---|---:|:---|---:|---:|:---|---:|---:|---:|---:|---:|
| 1 | Calf | Lagoon 0-1 mths (Jan) | calving grounds | 31 | Sumich (1986); Findley & Vidal (2002); Pike 1962 | 2.14 | 0.5 | Sumich (1986) as cited in Villegas-Amtmann et al. 2017 | 0.0849315 | 0.0000100 | 0.0849315 | 10.5 | 3 |
| 2 | Calf | Lagoon 2 mth (Feb) | calving grounds | 28 | Sumich (1986); Findley & Vidal (2002); Pike 1962 | 1.56 | 0.4 | Sumich (1986) as cited in Villegas-Amtmann et al. 2017 | 0.1616438 | 0.0849315 | 0.1616438 | 10.5 | 3 |
| 3 | Calf | Lagoon 3 mths (Mar) | calving grounds | 15 | Sumich (1986); Findley & Vidal (2002); Rice and Wolman 1971 | 1.39 | 0.3 | Sumich (1986) as cited in Villegas-Amtmann et al. 2017 | 0.2465753 | 0.1616438 | 0.2465753 | 10.5 | 3 |
| 4 | Calf | Northbound 3 mths (Mar) | northbound | 16 | Rodriguez de la Gala Hernandez 2008; Perryman et al. 2010; Poole 1984; Rice and Wolman 1971; Leatherwood 1974 | 0.70 | 0.1 | Rodriguez de la Gala-Hernandez et al. (2008) | 0.2465753 | 0.1616438 | 0.2465753 | 10.5 | 3 |
| 5 | Calf | Northbound 4 mths (Apr) | northbound | 30 | Poole (1984); Rodriguez de la Gala Hernandez et al. 2008; Perryman et al. 2010; Leatherwood 1974 | 0.70 | 0.1 | Rodriguez de la Gala-Hernandez et al. (2008) | 0.3287671 | 0.2465753 | 0.3287671 | 10.5 | 3 |
| 6 | Calf | Northbound 5 mths (May) | northbound | 31 | Braham (1984), Poole (1984); Rodriguez de la Gala Hernandez et al. 2008; Perryman et al. 2010; Rice and Wolman 1971; Leatherwood 1974 | 0.70 | 0.1 | Rodriguez de la Gala-Hernandez et al. (2008) | 0.4136986 | 0.3287671 | 0.4136986 | 10.5 | 3 |

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

## Total metabolic energy expenditure at a given stage (E<sub>s</sub>)

E<sub>s</sub> = 0.02 x %O<sub>2</sub> x T<sub>s</sub> x R<sub>s</sub> x
V<sub>t</sub> - Sumich (1986)

where:

0.02 - Amount of heat produced in MJ/L O2 consumed (Kleiber 1961)  
%O<sub>2</sub> - Extraction efficiency per breath  
T<sub>s</sub> - The no. of days in that stage  
R<sub>s</sub> - Respiration rate (breaths/day)  
V<sub>t</sub> - Tidal lung volume (L)

``` r
Lifestage <-  "Calf"

#Pull respiration rate data for calves from Activity Cost Reference (A_cost_Reference) table 
A_cost_calf <-  A_cost_reference %>%
  select(Lifestage, Activity_stages, age_yrs, no_days, bpm, se_bpm) %>%
  filter(Lifestage == "Calf")  


kable(A_cost_calf)
```

| Lifestage | Activity_stages             |   age_yrs | no_days |  bpm | se_bpm |
|:----------|:----------------------------|----------:|--------:|-----:|-------:|
| Calf      | calving grounds             | 0.0849315 |      31 | 2.14 |    0.5 |
| Calf      | calving grounds             | 0.1616438 |      28 | 1.56 |    0.4 |
| Calf      | calving grounds             | 0.2465753 |      15 | 1.39 |    0.3 |
| Calf      | northbound                  | 0.2465753 |      16 | 0.70 |    0.1 |
| Calf      | northbound                  | 0.3287671 |      30 | 0.70 |    0.1 |
| Calf      | northbound                  | 0.4136986 |      31 | 0.70 |    0.1 |
| Calf      | northbound                  | 0.4958904 |      23 | 0.70 |    0.1 |
| Calf      | nursing at foraging grounds | 0.4958904 |       7 | 1.22 |    0.3 |
| Calf      | nursing at foraging grounds | 0.5808219 |      31 | 1.22 |    0.3 |
| Calf      | nursing at foraging grounds | 0.6657534 |      31 | 1.22 |    0.3 |
| Calf      | nursing at foraging grounds | 0.7479452 |      30 | 1.22 |    0.3 |
| Calf      | nursing at foraging grounds | 0.8328767 |      20 | 1.22 |    0.3 |
| Calf      | southbound post-weaning     | 0.8328767 |      11 | 0.72 |    0.2 |
| Calf      | southbound post-weaning     | 0.9150685 |      30 | 0.72 |    0.2 |
| Calf      | southbound post-weaning     | 1.0000000 |      31 | 0.72 |    0.2 |

``` r
# Calves 
Es_sensAnalysis_phase1 <- as.data.frame(matrix(ncol = 18, nrow = 0))

colnames(Es_sensAnalysis_phase1) <- c("age_yrs","Lifestage", 
                               "Activity_stages", "no_days", 
                               "MC_variable", 
                               "mean_bpm", "se_bpm", "mean_bpd",
                               "Vt_mean", "Vt_sd",
                               "Es_perday", "Es_perday_sd",
                               "Es_perday_quant025", "Es_perday_quant975",
                               #2.5% and 97.5% quantile 
                               #from bootstrap estimates 
                               "Es","Es_sd","Es_quant025","Es_quant975"
)            




Es_sensAnalysis_phase1 <- 
  as_tibble(Es_sensAnalysis_phase1, 
            col_types = (list(ID = col_integer(), 
                              age_yrs = col_double(),
                              Lifestage = col_double(),
                              Activity_stages = col_character(),
                              no_days = col_double(),
                              MC_variable = col_character(),
                              mean_bpm = col_double(),
                              mean_bpd = col_double(),
                              se_bpm = col_double(),
                              Vt_mean = col_double(),
                              Vt_sd = col_double(), 
                              Es_perday = col_double(),
                              Es_perday_sd  = col_double(),
                              Es_perday_quant025 = col_double(),
                              Es_perday_quant975 = col_double(),
                              Es = col_double(),
                              Es_sd = col_double(),
                              Es_quant025 = col_double(),
                              Es_quant975 = col_double()
            )
            )
  )



#Original code was run with MC_reps <- 10000  and took a very long time
#To test and explore the code, use less reps 

MC_reps = 10000

for (a in seq(from = 1, to = 12, by = 1)){
  for (MC_var in c("all","Rs", "Vt", "pctO2")){
    
    age_yrs_i <- age_yr_tibble %>% 
     filter(age_mth == a)  %>% 
      pull(age_yrs)
    
    age_mid_i <- age_yr_tibble %>% 
      filter(age_mth == a-0.5) %>% 
      pull(age_yrs)
    
    #Lifestage <-  "Calf"
    
    strcolname <- as.character(age_yrs_i)
    A_cost_calf_i <- filter(A_cost_calf, 
                                   round(A_cost_calf$age_yrs*12) == a)
    
    if (nrow(A_cost_calf_i) == 0) {
      row <- NA
    }else{
      
      Activity_stages <- A_cost_calf_i$Activity_stages
      
      for (act in Activity_stages){
        activity <- act
        Lifestage
        activity
        
        strcolname <- as.character(age_yrs_i)
        
        A_cost_i <- A_cost_reference %>% dplyr::filter(
          Activity_stages == activity & 
            Lifestage == "Calf" 
          & round(age_yrs, 3) == round(age_yrs_i,3))
        
        A_cost_i
        
        # Lifestage <- A_cost_i$Lifestage
        # A_stage <- a
        
        set.seed(12345)
        
        
        #plot(pct_O2)
        #No. of days at each age (in months)
        no_days_i <-  A_cost_i$no_days   
        
        #Respiration rates at each activity stage 
        bpm_i <- A_cost_i$bpm 
        bpm_sd_i <- A_cost_i$se_bpm 
        
        #log() computes the natural logarithms (Ln)
        meanlog_bpm_i <- log(bpm_i^2 / sqrt(bpm_sd_i^2 + bpm_i^2))  #location
        meanlog_bpm_sd_i <- sqrt(log(1 + (bpm_sd_i^2 / bpm_i^2)))  #shape
        
        bpm_tibble <- as.data.frame(matrix(ncol = 2, nrow=0))
        colnames(bpm_tibble) <- c("mean_bpm", "sd_bpm")
        bpm_tibble <- as_tibble(bpm_tibble,
                                col_types = (list(ID = col_integer(), 
                                                  mean_bpm = col_double(),
                                                  sd_bpm = col_double()
                                                  
                                )))
        
        
        for (i in seq(from = 1, to = MC_reps, by = 1)){
          
          #generate lognormal distribution of breaths per minute (bpm)
          bpm <- rlnorm(MC_reps, meanlog_bpm_i, meanlog_bpm_sd_i)  
          # draws <- rlnorm(n=1000000, location, shape)
          # https://msalganik.wordpress.com/2017/01/21/making-sense-of-the-rlnorm-function-in-r/
          # plot(bpm)
          mean_bpm <- mean(bpm)
          sd_bpm <- sd(bpm)
          bpm_row <- tibble(mean_bpm = mean_bpm,
                            sd_bpm = sd_bpm)
          bpm_tibble <- rbind(bpm_tibble, bpm_row) 
          bpm_row <- NA
        }
        
        
        mean_bpm_i <- mean(bpm_tibble$mean_bpm)
        se_bpm_i <- sd(bpm_tibble$mean_bpm)     #sd of mean of means
        
        mean_bpm_reps <- bpm_tibble$mean_bpm
        

        # breaths/day
        bpd <- mean_bpm_reps * 60 * 24
        # plot(bpd)
        bpd_mean_i <-  mean(bpd)
        
        if (MC_var == "all" || MC_var == "Rs"){
          bpd_sd_i <- sd(bpd)  
        } else {
          bpd_sd_i = 0
        }
        
        
        #pull in tidal volume estimates (mass dependent)
        Vt_table_i <- filter(
          Vt_table_phase1, 
          round(Vt_table_phase1$age_yrs,digits = 3) == round(age_mid_i,digits =3)
        )
        
        Vt_i <- Vt_table_i$Vt_mean
        
        if (MC_var == "all" || MC_var == "Vt"){
          Vt_sd_i <- Vt_table_i$Vt_sd  
        } else {
          Vt_sd_i = 0
        }
        
        set.seed(12345)
        #generate normal distribution of Vt estimates
        Vt <- rnorm(MC_reps, Vt_i, Vt_sd_i)
        Vt_mean_i <- mean(Vt)
        Vt_sd_i <- sd(Vt)
        #plot(Vt)
        
        # O2 extraction efficiency
        if (a <= 5) {
          pct_O2_i <- 10.5/100
          
          if (MC_var == "all" || MC_var == "pctO2"){
            pct_O2_sd_i <- 3/100  
          } else {
            pct_O2_sd_i = 0
          }
          
        } else if (a > 5){
          pct_O2_i <- 11/100
          
          if (MC_var == "all" || MC_var == "pctO2"){
            pct_O2_sd_i <- 2.7/100  
          } else {
            pct_O2_sd_i = 0
          }
          
        }
        
        
        #generate normal distribution of pct_O2
        pct_O2 <- rnorm(MC_reps, pct_O2_i, pct_O2_sd_i)  
        
        
        #Energetic expenditure per day
        Es_perday <- 0.02 * pct_O2* bpd * Vt   
        #plot(Es_perday)
        
        Es_perday_mean <- mean(Es_perday)
        Es_perday_sd <- sd(Es_perday)
        Es_perday_quant025 <- quantile(Es_perday, 0.025, na.rm = TRUE)
        Es_perday_quant975 <- quantile(Es_perday, 0.975, na.rm = TRUE)
        
        #Energetic expenditure per month
        Es = Es_perday * no_days_i
        #plot(Es)
        Es_mean = mean(Es)
        Es_sd = sd(Es)
        Es_quant025 <- quantile(Es, 0.025, na.rm = TRUE)
        Es_quant975 <- quantile(Es, 0.975, na.rm = TRUE)
        
        
        # "age_yrs", "Es", "Es_sd", "quant025", "quant975" 
        row <- tibble(age_yrs = age_yrs_i,
                      Lifestage = Lifestage,
                      Activity_stages = activity,
                      no_days = no_days_i,
                      MC_variable = MC_var,
                      mean_bpm = mean_bpm_i,
                      se_bpm = se_bpm_i,
                      mean_bpd = bpd_mean_i,
                      Vt_mean = Vt_mean_i,
                      Vt_sd = Vt_sd_i,
                      Es_perday = Es_perday_mean, 
                      Es_perday_sd = Es_perday_sd, 
                      Es_perday_quant025 = Es_perday_quant025,
                      Es_perday_quant975  = Es_perday_quant975,
                      Es = Es_mean, 
                      Es_sd = Es_sd,
                      Es_quant025 = Es_quant025, 
                      Es_quant975 = Es_quant975)
        
        # append new row of data to Es_sensAnalysis_phase1
        Es_sensAnalysis_phase1 <- rbind(Es_sensAnalysis_phase1, row)
        row <-  NA #reset row for next iteration
        
      } 
    }
  }
}




kable(head(Es_sensAnalysis_phase1))
```

| age_yrs | Lifestage | Activity_stages | no_days | MC_variable | mean_bpm | se_bpm | mean_bpd | Vt_mean | Vt_sd | Es_perday | Es_perday_sd | Es_perday_quant025 | Es_perday_quant975 | Es | Es_sd | Es_quant025 | Es_quant975 |
|---:|:---|:---|---:|:---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 0.0849315 | Calf | calving grounds | 31 | all | 2.139991 | 0.0050110 | 3081.587 | 22.95101 | 0.5847316 | 148.4422 | 42.1294030 | 68.16864 | 231.5142 | 4601.708 | 1306.01149 | 2113.228 | 7176.939 |
| 0.0849315 | Calf | calving grounds | 31 | Rs | 2.139991 | 0.0050110 | 3081.587 | 22.95142 | 0.0000000 | 148.5262 | 0.3477870 | 147.83541 | 149.2173 | 4604.314 | 10.78140 | 4582.898 | 4625.736 |
| 0.0849315 | Calf | calving grounds | 31 | Vt | 2.139991 | 0.0050110 | 3081.587 | 22.95101 | 0.5847316 | 148.5236 | 3.7998712 | 140.99256 | 155.9472 | 4604.233 | 117.79601 | 4370.769 | 4834.363 |
| 0.0849315 | Calf | calving grounds | 31 | pctO2 | 2.139991 | 0.0050110 | 3081.587 | 22.95142 | 0.0000000 | 148.4969 | 42.4312801 | 64.06514 | 231.6992 | 4603.405 | 1315.36968 | 1986.019 | 7182.676 |
| 0.1616438 | Calf | calving grounds | 28 | all | 1.559994 | 0.0040089 | 2246.391 | 32.98501 | 0.8901977 | 155.5199 | 44.1658368 | 71.16298 | 242.7532 | 4354.556 | 1236.64343 | 1992.563 | 6797.090 |
| 0.1616438 | Calf | calving grounds | 28 | Rs | 1.559994 | 0.0040089 | 2246.391 | 32.98563 | 0.0000000 | 155.6071 | 0.3998796 | 154.81333 | 156.4012 | 4356.999 | 11.19663 | 4334.773 | 4379.234 |

``` r
#save Es_sensAnalysis_phase1 table
Es_sensAnalysis_phase1 %>% write_csv("data/Es_sensAnalysis_phase1_source_bpm.csv", na = "", append = FALSE)
```

``` r
Es_sensAnalysis_phase1$age_mth <- 
  round(Es_sensAnalysis_phase1$age_yrs *12)

Es_sensAnalysis_phase1_permth <- Es_sensAnalysis_phase1


#pull out blank Es_subtable
Es_subtable <- Es_sensAnalysis_phase1 %>% 
  dplyr::filter(age_yrs >999, 
                Lifestage == Lifestage)
kable(Es_subtable)
```

| age_yrs | Lifestage | Activity_stages | no_days | MC_variable | mean_bpm | se_bpm | mean_bpd | Vt_mean | Vt_sd | Es_perday | Es_perday_sd | Es_perday_quant025 | Es_perday_quant975 | Es | Es_sd | Es_quant025 | Es_quant975 | age_mth |
|---:|:---|:---|---:|:---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|

``` r
Es_sensAnalysis_phase1_permth  <- Es_subtable %>%  
  dplyr::select(age_yrs, age_mth, Lifestage, no_days, 
                MC_variable, Es, Es_sd, Es_perday, Es_perday_sd)

## Calculate sum of Es for phase 1 (per mth)
for (i in seq(from = 1, to = 12, by = 1)){
  for (MC_var in c("all","Rs", "Vt", "pctO2")){
    
    age <- age_yr_tibble %>% dplyr::filter(age_mth == i) %>%  pull(age_yrs)
    age_mth <-  i
    
    Es_subtable <- Es_sensAnalysis_phase1 %>% 
      dplyr::filter(age_yrs == age & MC_variable == MC_var)
    no_days <- sum(Es_subtable$no_days)
    Es <- sum(Es_subtable$Es)
    
    sum_of_variances <- 0
    for (row in 1:nrow(Es_subtable)){
     
      Es_subtable_i <- Es_subtable[row, "Es"]
      Es_sd_i <- Es_subtable[row, "Es_sd"]
      sum_of_variances <- sum_of_variances + (Es_sd_i)^2
    }
    Es_sd  <-  sqrt(sum_of_variances$Es_sd)
    
    Es_perday <- Es / no_days
    Es_perday_sd <- Es_sd / no_days
    
    newRow <- tibble(age_yrs = age,
                     age_mth = i,
                     Lifestage = Lifestage,
                     no_days = no_days,
                     MC_variable = MC_var,
                     Es = Es, 
                     Es_sd = Es_sd,
                     Es_perday = Es_perday,
                     Es_perday_sd = Es_perday_sd
    )
    
    Es_sensAnalysis_phase1_permth <- rbind(Es_sensAnalysis_phase1_permth, newRow)
  }
}



kable(head(Es_sensAnalysis_phase1_permth))
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
Es_sensAnalysis_phase1_permth %>% write_csv("data/Es_sensAnalysis_phase1_permth_source_bpm.csv", na = "", append = FALSE)
```

E<sub>s</sub> per month - Phase 1 - stacked plot from sensitivity
analysis

``` r
Es_sensAnalysis_phase1 <- read_csv("data/Es_sensAnalysis_phase1_source_bpm.csv")
```

    ## Rows: 60 Columns: 18
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr  (3): Lifestage, Activity_stages, MC_variable
    ## dbl (15): age_yrs, no_days, mean_bpm, se_bpm, mean_bpd, Vt_mean, Vt_sd, Es_p...
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
plot_Es_sensAnalysis_phase1 <- Es_sensAnalysis_phase1 %>% 
  ggplot(aes(x = age_yrs, y = Es))+
  geom_errorbar(aes(ymin = Es - Es_sd, ymax = Es + Es_sd),
                colour = "blue", width = 0.02)+
  geom_point()+
  facet_grid(MC_variable ~ Activity_stages,
             labeller = label_wrap_gen(width = 2, multi_line = TRUE)) +
  ggtitle("Es table - phase 1")

plot_Es_sensAnalysis_phase1
```

![](Es_sensanalysis_source_phase1_files/figure-gfm/plots_Es_phase1_stacked-1.png)<!-- -->

E<sub>s</sub> per month - Phase 1 - plot from sensitivity analysis

![](Es_sensanalysis_source_phase1_files/figure-gfm/plots_Es_phase1_permth-1.png)<!-- -->

E<sub>s</sub> per day at each age (month) - Phase 1 - plot from
sensitivity analysis

![](Es_sensanalysis_source_phase1_files/figure-gfm/plots_Es_phase1_mthly_perday-1.png)<!-- -->
