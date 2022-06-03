here::i_am("tables/chem.R"); library(tidyverse)
source(here::here("data/clean.R")) #initChem,Chem
chem <- Chem %>% pivot_wider(everything(), names_from = Variable) %>%
  rstatix::get_summary_stats(type = "median_mad") %>%
  filter(variable != "resp_mg_4d") %>%
  mutate("Descriptor" = c("Very Low", rep("Optimal",4), "Medium", "Poor",
                        "Medium", "Very Low", "Optimal")
         # "Function" = c("Compaction", rep("",5), "Nutrient availability, toxicity",
         #                "", "Water, nutrient availability", "")
         ) %>%
  add_row(variable = "metals_ppm)", Descriptor = "Safe") %>%
  # mutate("type" = c())

  mutate(variable = as_factor(variable)) %>% #needed
  reorder_levels(variable, c("SOM_pct", "resp_mg_day", "aggStability_pct",
                             "pH", "P_ppm", "K_ppm", "Fe_ppm",
                             "Mg_ppm", "Mn_ppm", "Zn_ppm", "metals_ppm")) %>%
  arrange(variable)
chemTbl <- chem %>%
  mutate(variable = c(
    "Organic Matter (%)", "Respiration (mg per day)",
    "Aggregate Stability (%)",
    # expression(paste("Respiration (mg CO"~2, " day"^1, ")")),
    "pH",
    "Phosphorus (ppm)", "Potassium (ppm)", "Iron (ppm)",
    "Magnesium (ppm)", "Manganese (ppm)", "Zinc (ppm)",
    "Heavy metals (Pb, Al, As, Cu)"
  )) %>%
  mutate("type" = c(rep("Biological",2), "Physical", rep("Chemical",8)))
chemKbl <-
  # chem %>%
  chemTbl %>%
  rename("Variable" = variable, "Median (n=10)" = median, "Deviation" = mad) %>%
  select(!c(type, n)) %>%
  knitr::kable(caption = "Baseline Soil Health Assessment (Cornell, Ithaca, NY, USA)",
               align = "c"#, format = "simple"
               ) %>%
  kableExtra::kable_styling() %>%
  # kableExtra::group_rows("major", 1, 6) %>%
  kableExtra::group_rows("Biological", 1, 2) %>%
  kableExtra::group_rows("Physical", 3, 3) %>%
  kableExtra::group_rows("Chemical", 4, 11) %>%
  kableExtra::group_rows("-- minor", 7, 11) %>%
  kableExtra::row_spec(0, bold = T)
  # kableExtra::add_footnote(label = "n = 10")
# library(magick)
# kableExtra::save_kable(chemKbl, here::here("tables/chemKbl.png")) #pdf2

# chem_gtbl <- Chem %>% #group_by()
#   # flextable::flextable() %>%
#   # flextable::set_caption("Baseline Cornell Soil Health Assessment")
#   pivot_wider(everything(), names_from = Variable) %>%
#   gtsummary::tbl_summary(include = !c("sampleID"))
