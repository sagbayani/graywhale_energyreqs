Es_preg_lact_source_bpm
================
S. Agbayani
31 July, 2025

``` r
# Set path for output figures: 
Figurespath <- paste0(getwd(), "/FMR/figures", collapse = NULL)
Figurespath
```

    ## [1] "C:/Users/AgbayaniS/Documents/R/graywhale_energyreqs/FMR/figures"

``` r
# Set path for input & output data  
datapath <- paste0(getwd(), "/data", collapse = NULL) 
datapath
```

    ## [1] "C:/Users/AgbayaniS/Documents/R/graywhale_energyreqs/data"

``` r
# Run Es preg and lact first, then read in data here
Es_preg_table <-  read_csv("data/Es_sensAnalysis_preg_peryear_source_bpm.csv")
```

    ## Rows: 272 Columns: 8
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr (2): Lifestage, MC_variable
    ## dbl (6): age_yrs, no_days, Es, Es_sd, Es_perday, Es_sd_perday
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
Es_lact_table  <-  read_csv("data/Es_sensAnalysis_lact_peryear_source_bpm.csv")
```

    ## Rows: 272 Columns: 8
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr (2): Lifestage, MC_variable
    ## dbl (6): age_yrs, no_days, Es, Es_sd, Es_perday, Es_sd_perday
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
Es_table_phase2_peryear <- read_csv("data/Es_sensAnalysis_phase2_peryear_source_bpm.csv")
```

    ## Rows: 124 Columns: 8
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr (2): Lifestage, MC_variable
    ## dbl (6): age_yrs, no_days, Es, Es_sd, Es_perday, Es_sd_perday
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
#Limit tibbles to 30 yrs
Es_lact_table_max30 <-   Es_lact_table %>% dplyr::filter(age_yrs <= 30)
Es_preg_table_max30 <-   Es_preg_table %>% dplyr::filter(age_yrs <= 30)

Es_table_alladults_preg_lact_peryear <- Es_table_phase2_peryear %>%
  dplyr::filter(Lifestage == "Juvenile/Adult" & age_yrs >= 1 & age_yrs <= 30)

Es_table_alladults_preg_lact_peryear <- rbind(Es_table_alladults_preg_lact_peryear,
                                              Es_preg_table_max30, 
                                              Es_lact_table_max30)

Es_table_alladults_preg_lact_peryear %>% write_csv("data/Es_sensAnalysis_alladults_preg_lact_peryear_bpm.csv", na = "", append = FALSE)


Es_table_alladults_preg_lact_peryear <- read_csv("data/Es_sensAnalysis_alladults_preg_lact_peryear_bpm.csv")
```

    ## Rows: 304 Columns: 8
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr (2): Lifestage, MC_variable
    ## dbl (6): age_yrs, no_days, Es, Es_sd, Es_perday, Es_sd_perday
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
# apply factors to enable facet wrap 
Es_table_alladults_preg_lact_peryear$Lifestage_f = factor(Es_table_alladults_preg_lact_peryear$Lifestage,
                                                          levels=c('Juvenile/Adult','Pregnant','Lactating'))


# plots  

plot_Es_table_alladults_preg_lact_yearly_perday <- Es_table_alladults_preg_lact_peryear %>% 
  ggplot(aes(x = age_yrs, y =Es_perday)) + #shape = Lifestage
  facet_grid(MC_variable~Lifestage_f)+
  geom_errorbar(aes(x = age_yrs, ymin = Es_perday - Es_sd_perday, ymax = Es_perday + Es_sd_perday),
                colour = 'gray40', width = 0, linetype = 1) +
  # geom_ribbon(aes(x = age_yrs, ymin = Es - Es_sd, ymax = Es + Es_sd),
  #                 fill = 'gray40', alpha = 0.3) +
  geom_point(size =0.5)+
  #geom_line()   +
  xlab("Age (years)") +
  
  ylab(bquote('Energetic expenditure (MJ day'^'-1'*')')) +
  
  scale_x_continuous(breaks = scales::pretty_breaks(n = 10), 
                     limits = c(0, 32)) +  # max x-axis 30 yrs. 
  scale_y_continuous(label = comma, 
                     breaks = scales::pretty_breaks(n = 8),
                     limits = c(0,max(Es_table_alladults_preg_lact_peryear$Es_perday +
                                        Es_table_alladults_preg_lact_peryear$Es_sd_perday)))+
  # scale_y_continuous(label = function(x){(x/1000)}, breaks = scales::pretty_breaks(n = 8),
  #                    limits = c(0, 1000000))+
  
  theme_bw()+
  theme(panel.grid = element_blank())+
  theme(axis.text = element_text(size = rel(1.2),
                                 colour = "black"))+
  theme(axis.title.x = element_text(size = rel(1.4)),
        axis.title.y = element_text(size = rel(1.2)))+
  theme(strip.background =element_rect(fill="transparent", 
                                       colour = "transparent"))+
  theme(strip.text = element_text(size = rel(1.2)))
#theme(legend.position = "none")

plot_Es_table_alladults_preg_lact_yearly_perday
```

![](Es_sensAnalysis_alladults_preg_lact_files/figure-gfm/plots_Es_preg_lact_annual_perday-1.png)<!-- -->
