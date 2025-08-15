# Gray Whale Energy Requirements

This package contains the complementary R code for the Gray whale energy requirements paper (Agbayani et al. 2026). The code is designed to be run stepwise, and outputs from one file will be used as inputs into another.

The recommended sequence for running the code is as follows:

1.  Length/Mass Equation (Phase 1 and 2)

2.  Delta Mass (per month, per year, lactation)

3.  Production Cost (per month and per year)

4.  Energetic Expenditure (Es)

    i.  Tidal Volume (Vt)

    ii. Energetic expenditure (Es) - Phase 1, Phase 2, Preg, Lact, All adults

5.  Gross Energetic Requirements (GER)

    i.  GER Phase 1, Phase 2

    ii. GER Phase 1 birth to weaning (at 9.6 months)

    iii. GER preg/Lact Classic (Pregnant only, and Lactating from birth to weaning at 9.6 months)

    iv. GER preg/lact (Pregnant with first 6 months of lactation, and Lactating only for last 3.6 months)

***Note**: Some of the code using 10,000 Monte Carlo reps will run for a long time. If you would like to test/explore the code, use less reps.*

The final charts shown in the paper are located in the folder "results_for_paper".

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.16879095.svg)](https://doi.org/10.5281/zenodo.16879095)
