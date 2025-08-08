ENERGY REQUIREMENTS OF GREY WHALES
================
Selina Agbayani
08 August, 2025

## RESULTS

### Production cost (P)

![](EnergeticsModeling_GreyWhales_Results_charts_files/figure-gfm/P_cost_peryear-1.png)<!-- -->

Figure 2. Production cost for calves (panel A) and juveniles and adults
(panel B).

### Total Energetic Expenditure (*E<sub>s</sub>*)

Figure 3. Estimates of average daily energetic expenditure (Es) from
activity (MJ day-1) for each month in the first year (Phase 1). calves
per month (Phase 1), and for juveniles and single adults (Phase 2),
pregnant, and lactating females per year. Values are plotted at the
midpoint of each month. Error bars show the standard deviation around
the mean of 10,000 Monte Carlo simulations. Note: Energetic expenditure
Es values for the 6th and 10th months represent energetic expenditures
across two activity stages.

### Gross Energy Requirements

#### Grey whale calves

![](EnergeticsModeling_GreyWhales_Results_charts_files/figure-gfm/predict_GER_table_phase1_permth-1.png)<!-- -->

Figure 6. Daily Gross Energy Requirements (GER) for calves in the first
year in MJ day<sup>-1</sup>. Error bars represent SD.

#### Grey whale juveniles / adults

![](EnergeticsModeling_GreyWhales_Results_charts_files/figure-gfm/predict_GER_table_phase2-1.png)<!-- -->

Figure 7. Daily gross energy requirements over the year compared to
gross daily requirements when foraging is limited to the summer season.
Foraging season spans ~154 days for juveniles and adults.

![](EnergeticsModeling_GreyWhales_Results_charts_files/figure-gfm/predict_GER_table_preg_lact-1.png)<!-- -->

Figure 8. Estimates for gross energy requirements (GER) for pregnant,
lactating females, and others (juvenile and other adult grey whales).
Daily gross energy requirements for a full year (annual) are represented
with black circles (365 for adults/juveniles, 396 for pregnant whales,
and 293 days for lactating whales). White circles represent daily gross
energy requirements for when feeding is limited during the foraging
season. Foraging season is assumed to be ~154 days for single juveniles
(1-7 y) and adults (\> 8 y), ~153 days for pregnant females, and ~119
days for lactating females. GER for pregnant whales shown here assumes
that the GER for first the 6 months of lactation while the mother is
fasting need to be consumed the previous year, when foraging while
pregnant. GER for lactating whales shown here is the GER for the
remaining 3.6 months of lactation when the mother resumes foraging while
lactating. Error bars represent SD.

### Milk / Food Requirements

#### Grey whale calves

![](EnergeticsModeling_GreyWhales_Results_charts_files/figure-gfm/plot_milk_food_reqs_phase1-1.png)<!-- -->

Figure 9. Daily milk requirements for calves. The left panel represents
milk requirements (L day<sup>-1</sup>) for calves up to 9 months (left
panel), and the right panel represents food requirements (kg of benthic
invertebrate prey day<sup>-1</sup>) for weaned calves over 9 months.

#### Grey whale juveniles and adults, including pregnant and lactating

![](EnergeticsModeling_GreyWhales_Results_charts_files/figure-gfm/plot_FoodReqs_3panel-1.png)<!-- -->

Figure 10. Food requirements (kg day-1) of benthic invertebrate prey for
pregnant females, lactating females, and others (juveniles and other
adult grey whales) during foraging season. Foraging season is assumed to
be ~154 days for single juveniles (1-7 y) and adults (\> 8 y), ~153 days
for pregnant females, and ~119 days for lactating females. Error bars
represent SD.

![](EnergeticsModeling_GreyWhales_Results_charts_files/figure-gfm/plot_pct_bodywt_consumed_3panel-1.png)<!-- -->

Figure 11. Percentage of body weight consumed day-1 during the foraging
season for juveniles and other adults, pregnant females, and lactating
females. Foraging season is assumed to be ~154 days for single juveniles
(1-7 y) and adults (\> 8 y), ~153 days for pregnant females, and ~119
days for lactating females. Note that the y-axis does not start at 0.
Error bars represent SD.

## Sensitivity Analyses

The sensitivity analyses show that the variable contributing the highest
range of uncertainty (±SD) to the gross energy requirements is
*E<sub>s</sub>* or total energetic expenditure (Figure 12), and that the
variable contributing the highest range of uncertainty within the Es
calculations is *%O<sub>2</sub>* or the percentage of oxygen absorbed
(Figure 13). The pattern holds for Phase 2, pregnant, and lactating life
stages, even when additional parameters are examined for the pregnant
and lactating stages (see Appendix D).

### Gross Energy Requirements (*GER*)

#### Grey whale calves

![](EnergeticsModeling_GreyWhales_Results_charts_files/figure-gfm/predict_GER_table_sensAnalysis_phase1-1.png)<!-- -->

Figure 14. Results for the sensitivity analysis on gross energy
requirements (*GER*) for grey whale calves.

#### Grey whale juveniles / adults

![](EnergeticsModeling_GreyWhales_Results_charts_files/figure-gfm/predict_GER_table_sensAnalysis_phase2-1.png)<!-- -->

Figure 15. Results for the sensitivity analysis on gross energy
requirements (*GER*) for juveniles and non-reproductive adults.

#### Pregnant grey whales (assuming GER for foraging while pregnant includes first 6 months of lactation)

![](EnergeticsModeling_GreyWhales_Results_charts_files/figure-gfm/predict_GER_table_sensAnalysis_preg-1.png)<!-- -->

Figure 16. Results for the sensitivity analysis on gross energy
requirements (*GER*) for pregnant females. GER calf represents the
energy required for the first 6 months.

#### Lactating grey whales (assuming GER for foraging while nursing includes only last 3.6 months of lactation)

![](EnergeticsModeling_GreyWhales_Results_charts_files/figure-gfm/predict_GER_table_sensAnalysis_lact-1.png)<!-- -->

Figure 17. Results for the sensitivity analysis on gross energy
requirements (*GER*) for lactating females. GER calf represents the
energy required for the last 3.6 months of nursing while mother and calf
are in the foraging grounds.

``` r
multiplot(plot_predict_GER_sensAnalysis_phase1_permth,
          plot_predict_GER_table_sensAnalysis_phase2,
          plot_predict_GER_sensAnalysis_preg,  
          plot_predict_GER_sensAnalysis_lact, 
          cols=1)
```

![](EnergeticsModeling_GreyWhales_Results_charts_files/figure-gfm/panel%20plot%20Es%20sensitivity%20analysis%20all%20stages-1.png)<!-- -->

``` r
jpeg(filename = paste0(Figurespath,"/GER_sensanalysis_allstages_multiplot.jpg"), 
     width = 5000,
     height = 5000,
     pointsize = 35, 
     quality = 100, 
     bg = "white", 
     res = 300, 
     restoreConsole = TRUE)


p <- multiplot(plot_predict_GER_sensAnalysis_phase1_permth,
          plot_predict_GER_table_sensAnalysis_phase2,
          plot_predict_GER_sensAnalysis_preg,  
          plot_predict_GER_sensAnalysis_lact, 
          cols=1)


dev.off()
```

    ## png 
    ##   2

### Total energetic expenditure (*E<sub>s</sub>*)

#### Grey whale calves

![](EnergeticsModeling_GreyWhales_Results_charts_files/figure-gfm/Es_sensAnalysis_phase1_permth-1.png)<!-- -->

``` r
Es_sensAnalysis_phase1 <- read_csv("data/Es_sensAnalysis_phase1_source_bpm.csv")

Es_sensAnalysis_phase1$age_mth <- round((Es_sensAnalysis_phase1$age_yrs*12),0)

Es_sensAnalysis_phase1$MC_var_factor <- 
  factor(Es_sensAnalysis_phase1$MC_variable, 
         levels=c("all","pctO2","Rs", "Vt"))


levels(Es_sensAnalysis_phase1$MC_var_factor) <- c("All variables","%O2", "Rs", "Vt")

plot_Es_sensAnalysis_phase1 <- Es_sensAnalysis_phase1 %>% 
  ggplot(aes(x = age_mth, y = Es_perday))+
  geom_errorbar(aes(ymin = Es_perday - Es_perday_sd, ymax = Es_perday + Es_perday_sd),
                 colour = "gray45", width = 0)+
  geom_point(size=0.5)+
  # geom_ribbon(aes(ymin = Es_perday - Es_perday_sd, ymax = Es_perday + Es_perday_sd),
  #               fill = "gray70")+
  # geom_line(linewidth = 0.5)+
  facet_grid(MC_var_factor~Activity_stages, 
             labeller = label_wrap_gen(width = 15, multi_line = TRUE)) +
             
  #ggtitle("Phase 2 - Juveniles/Adults")+
  xlab("Age (months)") +
  ylab(bquote('Es (MJ day '^'-1'*')')) +
  scale_x_continuous(breaks = scales::pretty_breaks(n = 5),
                     limits = c(0, 12))+
  #limits = c(0, 30.5), expand=c(0,0) +  # max x-axis 30 yrs.
  # scale_y_continuous(label=comma,
  #                     breaks = scales::pretty_breaks(n = 4),
  #                     limits =  c(0, 2000))+

  theme_bw() +
  labs(tag="A")+
  theme(plot.tag = element_text(size = rel(2),
                                    colour = "black"))+
  theme(panel.grid = element_blank())+
  theme(legend.position.inside = 0)+
  #theme(panel.border = element_blank())+
  theme(strip.background =element_rect(fill="transparent",
                                       colour = "transparent"))+
  #theme(axis.line = element_line(linewidth = 1, colour = "black"))+
  theme(axis.text = element_text(colour = "black", size = rel(1)))+
  theme(axis.title.y = element_text(colour = "black", 
                                    size = rel(1), angle = 90))+
  theme(axis.title.x = element_text(colour = "black", 
                                    size = rel(1)))+
  theme(strip.text = element_text(size = rel(1)))


plot_Es_sensAnalysis_phase1
```

![](EnergeticsModeling_GreyWhales_Results_charts_files/figure-gfm/unnamed-chunk-1-1.png)<!-- -->

``` r
ggsave(paste0(Figurespath,"/Es_sensanalysis_phase1_activitystages_facetgrid.jpg"),
       plot_Es_sensAnalysis_phase1,
       width = 8,
       height = 5, dpi = 300
     )
```

Figure 18. Results for the sensitivity analysis on total energetic
expenditure (*E<sub>s</sub>*) for grey whale calves.

#### Grey whale juveniles and adults, including pregnant and lactating females

![](EnergeticsModeling_GreyWhales_Results_charts_files/figure-gfm/Es_sensAnalysis_alladults_preg_lact-1.png)<!-- -->![](EnergeticsModeling_GreyWhales_Results_charts_files/figure-gfm/Es_sensAnalysis_alladults_preg_lact-2.png)<!-- -->![](EnergeticsModeling_GreyWhales_Results_charts_files/figure-gfm/Es_sensAnalysis_alladults_preg_lact-3.png)<!-- -->

Figure 19. Results for the sensitivity analysis on *E<sub>s</sub>*
(total energetic expenditure) for Juvenile and adult grey whales,
including pregnant and lactating females.

![](EnergeticsModeling_GreyWhales_Results_charts_files/figure-gfm/plots_Es_phase2_peryear-1.png)<!-- -->

![](EnergeticsModeling_GreyWhales_Results_charts_files/figure-gfm/plots_Es_phase2_stacked-1.png)<!-- -->

**Es for all adult life stages including pregnant and lactating**

![](EnergeticsModeling_GreyWhales_Results_charts_files/figure-gfm/Es%20preg%20lact-1.png)<!-- -->

**Sensitivity analysis for Es (all life stages)**

``` r
Es_sensAnalysis_phase1_permth <-  read_csv("data/Es_sensAnalysis_phase1_permth_source_bpm.csv")
Es_sensAnalysis_phase1_permth <-Es_sensAnalysis_phase1_permth %>% 
  select(age_yrs, Lifestage, MC_variable, Es, Es_sd, 
         Es_perday, Es_perday_sd)


Es_sensAnalysis_alladults_preg_lact_peryear <-
  as_tibble(read_csv("data/Es_sensAnalysis_alladults_preg_lact_peryear_source_bpm.csv"))

Es_sensAnalysis_alladults_preg_lact_peryear <- Es_sensAnalysis_alladults_preg_lact_peryear %>% 
  rename("Es_perday_sd" = "Es_sd_perday")

Es_sensAnalysis_alladults_preg_lact_peryear <-Es_sensAnalysis_alladults_preg_lact_peryear %>% 
  select(age_yrs, Lifestage, MC_variable, Es, Es_sd, 
         Es_perday, Es_perday_sd)

Es_sensAnalysis_allstages_permth_peryr <- rbind(Es_sensAnalysis_phase1_permth, Es_sensAnalysis_alladults_preg_lact_peryear)

Es_sensAnalysis_allstages_permth_peryr$MC_var_factor <- 
  factor(Es_sensAnalysis_allstages_permth_peryr$MC_variable, 
         levels=c("all","pctO2","Rs", "Vt"))

levels(Es_sensAnalysis_allstages_permth_peryr$MC_var_factor) <-   c("All variables","%O2", "Rs", "Vt")



plot_Es_sensAnalysis_allstages_permth_peryr <- Es_sensAnalysis_allstages_permth_peryr %>%
    filter(age_yrs <=30) %>% 
  ggplot(aes(x = age_yrs, y =Es_perday)) + #shape = Lifestage
  facet_grid(MC_var_factor~Lifestage, 
             scales="free_x",
             labeller = label_wrap_gen(width = 15, multi_line = TRUE))+
  geom_errorbar(aes(x = age_yrs, ymin = Es_perday - Es_perday_sd, ymax = Es_perday + Es_perday_sd),
                 colour = 'gray40', width = 0, linetype = 1) +
  # geom_ribbon(aes(x = age_yrs, ymin = Es_perday - Es_perday_sd, ymax = Es_perday + Es_perday_sd),
  #                 fill = 'gray40', alpha = 0.3) +
  geom_point(size=0.5)+
  #geom_line()   +
  xlab("Age (years)") +

  ylab(bquote('Es (MJ day'^'-1'*')')) +
 
  scale_x_continuous(breaks = scales::pretty_breaks(n = 5),
                      ) +  # max x-axis 30 yrs.
  scale_y_continuous(label = comma,
  breaks = scales::pretty_breaks(n = 4),
  limits = c(0,1500))+
  #scale_y_continuous(label = function(x){(x/1000)}, breaks = scales::pretty_breaks(n = 8),
  #                    limits = c(0, 1000000))+

  theme_bw()+
  theme(panel.grid = element_blank())+
  theme(axis.text = element_text(size = rel(1.2),
                                 colour = "black"))+
  theme(axis.title.x = element_text(size = rel(1.2)),
        axis.title.y = element_text(size = rel(1.2)))+
  theme(strip.background =element_rect(fill="transparent",
                                       colour = "transparent"))+
  theme(strip.text = element_text(size = rel(1.2)))
#theme(legend.position.inside = "none")

plot_Es_sensAnalysis_allstages_permth_peryr
```

![](EnergeticsModeling_GreyWhales_Results_charts_files/figure-gfm/Es%20sensanalysis%20allstages%20multiplot-1.png)<!-- -->

``` r
ggsave(paste0(Figurespath,"/Es_sensAnalysis_allstages_permth_peryr.jpg"),
       plot_Es_sensAnalysis_allstages_permth_peryr,
       width = 9,
       height = 7, dpi = 300
     )
```

![](EnergeticsModeling_GreyWhales_Results_charts_files/figure-gfm/Es_preg_stacked-1.png)<!-- -->

![](EnergeticsModeling_GreyWhales_Results_charts_files/figure-gfm/Es_lact_stacked-1.png)<!-- -->
