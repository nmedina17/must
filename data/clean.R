here::i_am("data/clean.R"); library(vroom);
library(rstatix); library(tidyverse)
# library(ggpubr)
# tidylog::
# janitor::  # clean_names()
# lubridate:: for dates
# tsibble:: for time series
# tidytext:: for word counts
# parse_number() to separate number from string

#reticulate:: #python

datafolder <- "data/raw/"

#makespatial?
# initChem <- vroom(paste(datafolder, "init_chem.csv", sep = "")) %>%
#   group_by(element) %>% get_summary_stats(type = "median_mad")
# maxChem <- vroom(paste(datafolder, "stds.csv", sep = ""))
#
# Chem <- merge(initChem, maxChem, by = "element")


#clean----

Usmp <- vroom(paste(datafolder, "USMPdata19.csv", sep = ""))
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
  reorder_levels(MIX, c("null", "pere", "comp", "wdsp")) %>%
  # mutate(across(where(is_character), as_factor)) %>%
  ###units----
  mutate("PNDcm" = (PND + 1) * 2.5 - 2.5, #inches2cm
         "INFILmL" = (INFIL_OZ.SEC + 1) * 29.5 - 29.5, #oz2mL
         "TOTRAD_kg" = ((TOTRAD_oz + 1) * 28.35 - 28.35) / 1000
         ) %>%
  ###pool----
  group_by(SAMPL_TIME, MIX, TIL, COL, PLOT) %>%
  summarize(across(.fns = median, na.rm = T))

#center----
Usmpgg <- Usmpg %>% get_summary_stats(type = "median_mad")
