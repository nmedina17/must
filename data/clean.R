here::i_am("data/clean.R"); library(rstatix); library(tidyverse); library(measurements)
# library(ggpubr)
# tidylog::
# janitor::  # clean_names()
# lubridate:: for dates
# tsibble:: for time series
# tidytext:: for word counts
# parse_number() to separate number from string

#reticulate:: #python

# datafolder <- "data/raw/"

#makespatial? #digitized
initChem <- tibble(
  "sampleID" = c("s818", "s819", "s820", "s821", "s822",
                 "s823", "s824", "s825", "s826", "s827"),
  "aggStability_pct" = c(19.8, 16.2, 18.4, 16.9, 13.1, 15.7, 47.1, 30.2, 23.7, 19.5),
  "SOM_pct" = c(2.6, 2.5, 2.4, 2.8, 2.5, 3.2, 2.3, 3.3, 2.8, 2.5),
  "resp_mg_4d" = c(0.5, 0.6, 0.6, 0.8, 0.7, 1.0, 0.5, 1.1, 0.7, 0.7),
  "pH" = c(8.1, 8.1, 8.2, 8.1, 8.3, 8.1, 8.2, 8.1, 8.0, 8.0),
  "P_ppm" = c(1.8, 1.4, 1.7, 2.2, 1.2, 2.3, 13.6, 8.0, 5.0, 2.5),
  "K_ppm" = c(62.4, 82.3, 110.6, 107.8, 78.4, 99.8, 242.5, 159.9, 128.2, 79.2),
  "Mg_ppm" = c(321.9, 475.1, 470.5, 468.8, 515.3, 455.0, 485.7, 458.4, 344.5, 283.7),
  "Fe_ppm" = c(9.2, 9.6, 6.2, 6.5, 8.5, 5.9, 1.0, 2.2, 2.2, 3.3),
  "Mn_ppm" = c(41.4, 44.2, 43.3, 38.8, 38.8, 42.8, 48.9, 50.8, 33.5, 24.1),
  "Zn_ppm" = c(1.5, 1.7, 2.9, 2.6, 2.0, 5.4, 6.3, 6.6, 6.9, 4.7)
)
Chem <- initChem %>% mutate("resp_mg_day" = resp_mg_4d/4) %>%
  pivot_longer(!sampleID, names_to = "Variable")
  # vroom(paste(datafolder, "init_chem.csv", sep = "")) %>%
  # group_by(Variable) %>% rstatix::get_summary_stats(type = "median_mad")
# maxChem <- vroom(paste(datafolder, "stds.csv", sep = ""))
#
# Chem <- merge(initChem, maxChem, by = "element")


#clean----

Usmp <- vroom::vroom(here::here("data/raw/USMPdata19.csv"))
#na.strings = c("", "NA"))

##treats----

# Usmp$MIX <- as.factor(Usmp$MIX)
# MixLabel <- c("Compaction", "Null",
#               "Perennial", "Weed Suppression")
# levels(Usmp$MIX) <- MixLabel
# MixOrder <- c("Null", "Perennial",
#               "Compaction", "Weed Suppression")
# Usmp$MIX <- factor(Usmp$MIX, levels = MixOrder)  #reorder

# UsmpMod <- Usmp %>%
#   mutate()


##subsamples----
Usmpg <- Usmp %>%
  mutate("PLOT" = paste(COL, ROW)) %>% #uniqueplots
  rstatix::reorder_levels(MIX, c("null", "pere", "comp", "wdsp")) %>%
  # mutate(across(where(is_character), as_factor)) %>%
  ###units----
  mutate(
    "PNDcm" = (PND + 1) * 2.5 - 2.5, #inches2cm
    # "PNDcm" = conv_unit(PND + 1)
    "INFILmL" = (INFIL_OZ.SEC + 1) * 29.5 - 29.5, #oz2mL
    "TOTRAD_kg" = ((TOTRAD_oz + 1) * 28.35 - 28.35) / 1000,
    "TOTRAD_kg_m2" = TOTRAD_kg / 4.6, #plotArea
    "TOTRAD_g_m2" = TOTRAD_kg_m2 *1000,
    "Wd_Dn_m2" = Wd_Dn *10 / 4.6,
    "Wd_Abn" = Wd_Abn *10
  ) %>%
  ###pool----
  group_by(SAMPL_TIME, MIX, TIL, COL, PLOT) %>%
  summarize(across(.fns = median, na.rm = T))

#center----
Usmpgg_TIL <- Usmpg %>% group_by(TIL) %>%
  rstatix::get_summary_stats(type = "median_mad")
Usmpgg_MIX <- Usmpg %>% group_by(MIX) %>%
  rstatix::get_summary_stats(type = "median_mad")


compData_TIL <- filter(Usmpgg_TIL, variable=="PNDcm")
compData_MIX <- filter(Usmpgg_MIX, variable=="PNDcm")

infilData_TIL <- filter(Usmpgg_TIL, variable=="INFILmL")
infilData_MIX <- filter(Usmpgg_MIX, variable=="INFILmL")
