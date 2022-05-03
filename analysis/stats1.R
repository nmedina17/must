here::i_am("analysis/stats1.R"); source(here::here("data/clean.R"))
library(rstatix); library(tidyverse); #options(digits = 3)
library(lmerTest)

#org----
varTbl <- Usmpg %>%
  ungroup() %>% #kruskal_test()
  pivot_longer(cols = !c(SAMPL_TIME : ROW), names_to = "variable") %>%
  ##de-bug----
  # filter(variable == "RADL_CM")
  # kruskal_test(formula = model_MIX)
  nest("varData" = !variable)
varTbl$varData[[1]] #head

#model----

model_TIL <- value ~ TIL; model_MIX <- value ~ MIX
# model <- value ~ TIL + (1 | SAMPL_TIME)

varTestTbl <- varTbl %>%
  mutate("statTest_TIL" = varData %>% modify(
    ~.x %>% kruskal_test(formula = model_TIL) %>%
      select(c(n, statistic, df, p)) %>% rename_with(~glue::glue("{.x}_TIL"))
    ),
    "statTest_MIX" = varData %>% modify_if(
      ~length(distinct(na.omit(.x), MIX)) > 1, #ok
      ~.x %>% kruskal_test(formula = model_MIX) %>%
        select(c(n, statistic, df, p)) %>% rename_with(~glue::glue("{.x}_MIX")),
      .else = ~NA
    )
    # "statTestLmer" = varData %>% modify(
    #   # ~length(distinct(na.omit(.x), MIX)) > 1, #ok
    #   ~.x %>% lmer(formula = model),
    #     # select(c(n, statistic, df, p)) %>% rename_with(~glue::glue("{.x}_MIX")),
    #   .else = ~NA
    # )
  ) %>% unnest(c(statTest_TIL, statTest_MIX))
  # nest("varData" = !variable)
  # filter(across(starts_with("p_")) < 0.125)


#attic----

# varTbl %>% lmer(formula = model)
# varTbl %>% getStatsTbl(model)
