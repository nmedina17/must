here::i_am("tables/chem.R"); library(tidyverse)
source(here::here("data/clean.R")) #initChem,Chem
chem <- Chem %>% pivot_wider(everything(), names_from = Variable) %>%
  rstatix::get_summary_stats(type = "median_mad") %>%
  filter(variable != "resp_mg_4d") %>%
  # mutate("type" = c())

  mutate(variable = as_factor(variable)) %>% #needed
  reorder_levels(variable, c("SOM_pct", "resp_mg_day", "aggStability_pct",
                             "pH", "P_ppm", "K_ppm", "Fe_ppm",
                             "Mg_ppm", "Mn_ppm", "Zn_ppm")) %>%
  arrange(variable)
chemTbl <- chem %>%
  mutate(variable = c(
    "Organic Matter (%)", "Respiration (mg per day)",
    "Aggregate Stability (%)",
    # expression(paste("Respiration (mg CO"~2, " day"^1, ")")),
    "pH",
    "Phosphorus (ppm)", "Potassium (ppm)", "Iron (ppm)",
    "Magnesium (ppm)", "Manganese (ppm)", "Zinc (ppm)"
  )) %>%
  mutate("type" = c(rep("Biological",2), "Physical", rep("Chemical",7)))
chemKbl <-
  # chem %>%
  chemTbl %>%
  rename("Variable" = variable, "Median" = median, "Deviation" = mad) %>%
  select(!c(type, n)) %>%
  knitr::kable(caption = "Baseline Cornell Soil Health Assessment",
               align = "c") %>%
  kableExtra::kable_styling() %>%
  # kableExtra::group_rows("major", 1, 6) %>%
  kableExtra::group_rows("Biological", 1, 2) %>%
  kableExtra::group_rows("Physical", 3, 3) %>%
  kableExtra::group_rows("Chemical", 4, 10) %>%
  kableExtra::group_rows("-- minor", 7, 10)
# kableExtra::save_kable(chemKbl, here::here("tables/chemTbl.png"))

chem_gtbl <- Chem %>% #group_by()
  # flextable::flextable() %>%
  # flextable::set_caption("Baseline Cornell Soil Health Assessment")
  pivot_wider(everything(), names_from = Variable) %>%
  gtsummary::tbl_summary(include = !c("sampleID"))
