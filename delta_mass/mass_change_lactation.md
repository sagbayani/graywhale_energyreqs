Mass change needed to calculate cost of lactation
================
Selina Agbayani
Feb 11, 2021, updated and cleaned 04 July, 2025

``` r
############ Set path for output figures: ###############
Figurespath <- paste0(getwd(), "/delta_mass/figures", collapse = NULL)
Figurespath
```

    ## [1] "C:/Users/AgbayaniS/Documents/R/graywhale_energyreqs/delta_mass/figures"

``` r
############ Set path for input & output data  ###########
datapath <-  paste0(getwd(), "/data", collapse = NULL) 
datapath
```

    ## [1] "C:/Users/AgbayaniS/Documents/R/graywhale_energyreqs/data"

``` r
## Read data in

mass_table <- as_tibble(read_csv("data/mass_table.csv"), #monthly 
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
mass_at_birth_tibble <- mass_table %>% filter(age_yrs == 0)  #at birth

mass_at_birth_mean <- mass_at_birth_tibble$mean_mass 
mass_at_birth_sd <- mass_at_birth_tibble$sd_mass


mass_at_weaning_tibble <- mass_table %>%  filter(round(age_yrs,2) == round((10/12),2))  #10th mth  i.e. 0.8333333

mass_at_weaning_mean <-mass_at_weaning_tibble$mean_mass 
mass_at_weaning_sd <-mass_at_weaning_tibble$sd_mass
```

The mass change needed to calculate cost of lactation is the increase in
mass from newborn to weaning.

``` r
MC_reps = 10000

mass_at_birth_reps <- rnorm(MC_reps, mass_at_birth_mean, mass_at_birth_sd)
mass_at_weaning_reps <- rnorm(MC_reps, mass_at_weaning_mean, mass_at_weaning_sd)

mass_change_lactation_reps <- mass_at_weaning_reps - mass_at_birth_reps

masschange_lactation_mean <- mean(mass_change_lactation_reps)
masschange_lactation_sd <- sd(mass_change_lactation_reps)

masschange_lactation_mean
```

    ## [1] 4819.082

``` r
masschange_lactation_sd
```

    ## [1] 212.6991

Mean mass change: 4819.0817626.

Sd mass change: 212.6990788.
