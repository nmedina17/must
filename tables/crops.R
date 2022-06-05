here::i_am("tables/crops.R"); library(tidyverse);
taxize::taxize_options(quiet = T, taxon_state_messages = T) #need2source2PDF!
#info----
mixes <- tibble(
  "Null" = "Existing vegetation (no manipulation)",
  "Perennial" = c("Hairy Vetch", "Red Clover", "Wheat"),
  "Compaction" = c("Forage Radish", "Crimson Clover", "Cereal Ryegrass"),
  "Weed Suppression" = c("Sorghum-Sudangrass", "Cowpea/Black-Eyed Pea", "Buckwheat")
)
plantCommNames <- c("Hairy Vetch", "Red Clover", "Wheat",
                    "Forage Radish", "Crimson Clover", "Cereal Ryegrass",
                    "Sorghum-Sudangrass", "Cowpea/Black-Eyed Pea", "Buckwheat")
plants <- c(
  "Hairy Vetch" = taxize::comm2sci(mixes$Perennial[[1]])[[1]],
  "Red Clover" = taxize::comm2sci(mixes$Perennial[[2]])[[1]],
  "Wheat" = taxize::comm2sci(mixes$Perennial[[3]])[[1]],

  "Forage Radish" = "Raphanus sativus var. longipinnatus",
  "Crimson Clover" = "Trifolium incarnatum",
  "Cereal Ryegrass" = "Secale cereale",

  "Sorghum-Sudangrass" = "Sorghum bicolor x S. bicolor var. sudanese",
  "Cowpea/Black-Eyed Pea" = taxize::comm2sci("Black-Eyed Pea")[[1]],
  "Buckwheat" = "Fagopyrum esculentum"
) %>% as_tibble() %>% rename("Binomial" = value) %>% mutate("Plants" = plantCommNames)
  # pivot_longer(everything(), names_to = "Plants", values_to = "Binomial")

#join----
cropTbl <- mixes %>% as_tibble() %>%
  pivot_longer(everything(), names_to = "Function", values_to = "Plants") %>%

  full_join(plants) %>%
  rstatix::reorder_levels(Function, c(
    "Weed Suppression", "Perennial", "Compaction", "Null"
  )) %>% arrange(Function) %>%
  nest(!Function) %>% unnest()
  # mutate(Binomial = Binomial)

#style----
cropKbl <- cropTbl %>%
  distinct() %>%
  mutate(Function = ifelse(duplicated(Function), "", as.character(Function))
         # Binomial = map(Binomial, ~stringr::str_c("*", Binomial, "*"))
         ) %>%
  # select(!Function) %>%

  knitr::kable(caption = "Cover crop mixes", align = "c", format = "simple"
               ) %>%
  # as.data.frame(rvest::html_table()) %>%
  # kableExtra::collapse_rows() %>% #bug
  # kableExtra::group_rows(names(mixes)[4], 1, 3) %>%
  # kableExtra::group_rows(names(mixes)[2], 4, 6) %>%
  # kableExtra::group_rows(names(mixes)[3], 7, 9) %>%
  # kableExtra::group_rows(names(mixes)[1], 10, 10) %>%
  # kableExtra::kable_styling() %>%
  kableExtra::column_spec(3, italic = T) %>%
  kableExtra::row_spec(0, bold = T)

#save----
# kableExtra::save_kable(cropKbl, here::here("tables/cropKbl.png")) #pdf2
