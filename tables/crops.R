here::i_am("tables/crops.R"); library(tidyverse)
#info----
mixes <- tibble(
  "Null" = "Existing vegetation (no manipulation)",
  "Perennial" = c("Hairy Vetch", "Red Clover", "Wheat"),
  "Compaction" = c("Forage Radish", "Crimson Clover", "Cereal Ryegrass"),
  "Weed Suppression" = c("Sorghum-Sudangrass", "Cowpea", "Buckwheat")
)
plants <- tibble(
  "Hairy Vetch" = taxize::comm2sci(mixes$Perennial[[1]])[[1]],
  "Red Clover" = taxize::comm2sci(mixes$Perennial[[2]])[[1]],
  "Wheat" = taxize::comm2sci(mixes$Perennial[[3]])[[1]],
  "Forage Radish" = taxize::comm2sci(mixes$Compaction[[1]])[[1]],
  "Crimson Clover" = "Trifolium incarnatum",
  "Cereal Ryegrass" = "Secale cereale",
  "Sorghum-Sudangrass" = "Sorghum bicolor x S. bicolor var. sudanese",
  "Cowpea" = taxize::comm2sci("Black-Eyed Pea")[[1]],
  "Buckwheat" = "Fagopyrum esculentum"
) %>% pivot_longer(everything(), names_to = "Plants", values_to = "Binomial")

#join----
cropTbl <- mixes %>% as_tibble() %>%
  pivot_longer(everything(), names_to = "Function", values_to = "Plants") %>%

  full_join(plants) %>% nest(!Function) %>% unnest()

#style----
cropKbl <- cropTbl %>%
  # select(!Function) %>%
  distinct() %>%
  knitr::kable(caption = "Cover crop mixes") %>%
  # as.data.frame(rvest::html_table()) %>%
  kableExtra::collapse_rows() %>% #bug
  # kableExtra::group_rows(names(mixes)[1], 1, 3) %>%
  # kableExtra::group_rows(names(mixes)[2], 4, 6) %>%
  # kableExtra::group_rows(names(mixes)[3], 7, 9) %>%
  # kableExtra::group_rows(names(mixes)[4], 10, 12) %>%
  kableExtra::kable_styling()

#save----
#library(magick)
# cropKbl %>% kableExtra::save_kable(here::here("tables/crops.png"))
