library(vroom); library(tidyverse)
library(ggpubr)
# tidylog::
# janitor::  # clean_names()
# lubridate:: for dates
# tsibble:: for time series
# tidytext:: for word counts
# parse_number() to separate number from string

#reticulate:: #python

datafolder <- "../data/raw"

#makespatial?
initChem <- vroom(paste(datafolder, "init_chem.csv", sep = "")) %>%
  group_by(element) %>% get_summary_stats(type = "median_mad")
maxChem <- vroom(paste(datafolder, "stds.csv", sep = ""))

Chem <- merge(initChem, maxChem, by = "element")


#clean

Usmp <- vroom(paste(datafolder, "USMPdata2019.csv", sep = ""))
#na.strings = c("", "NA"))

#cropmixes
Usmp$MIX <- as.factor(Usmp$MIX)
MixLabel <- c("Compaction", "Null",
              "Perennial", "Weed Suppression")
levels(Usmp$MIX) <- MixLabel
MixOrder <- c("Null", "Perennial",
              "Compaction", "Weed Suppression")
Usmp$MIX <- factor(Usmp$MIX, levels = MixOrder)  #reorder

#subsamples
Usmpg <- Usmp %>%
  mutate(PLOT = paste(COL, ROW)) %>% #uniqueplots
  #units
  mutate(PNDcm = (PND + 1) * 2.5 - 2.5) %>% #inches2cm
  mutate(INFILmL = (INFIL_OZ.SEC + 1) * 29.5 - 29.5)  %>% #oz2mL
  #pool
  group_by(SAMPL_TIME, MIX, TIL, COL, PLOT) %>%
  summarize_all("median", na.rm = T)

Usmpgg <- Usmpg %>% get_summary_stats(type = "median_mad")
