here::i_am("analysis/stats1.R"); source(here::here("data/clean.R"));
library(tidyverse);
#options(digits = 3)
# library(lmerTest);

#org----
varTbl <- Usmpg %>% ungroup() %>% #kruskal_test()
  pivot_longer(cols = !c(SAMPL_TIME : ROW), names_to = "variable") %>%
  ##de-bug----
  # filter(variable == "RADL_CM")
  # kruskal_test(formula = model_MIX)
  nest("varData" = !variable) %>%
  mutate(varData = modify(varData, ~na.omit(.x))) #QAsampleSizes
varTbl$varData[[1]] #head


#draft----


#model----

model_TIL <- value ~ TIL; model_MIX <- value ~ MIX
model_test <- value ~ SAMPL_TIME
model1_TIL <- value ~ TIL | SAMPL_TIME; model1_MIX <- value ~ MIX | SAMPL_TIME

#separateSAMPL_TIMEs
varTestTbl <- varTbl %>%
  mutate(
    "statTest_TIL" = varData %>% modify(
      ~ .x %>%
      # ~ ifelse(
      #   .x %>% na.omit(value) %>% pull(SAMPL_TIME) %>% unique() %>% length() > 1,
      #   yes = .x %>% #group_by(MIX) %>%
      #     rstatix::friedman_test(formula = model1_TIL), #%>%
      #     # select(c(statistic, n, p)) %>% rename_with(~ glue::glue("{.x}_TIL")),
      #   no = .x %>%
          rstatix::kruskal_test(formula = model_TIL) %>%
          select(c(statistic, df, n, p)) %>% rename_with(~ glue::glue("{.x}_TIL"))
    ),
    "statTest_MIX" = varData %>% modify_if(
      ~ length(pull(distinct(na.omit(.x), MIX))) > 1, #ok
      # variable != "INFIL_OZ.SEC" | variable != "RADL_CM" |
      #   variable != "TOTRAD_oz" | variable != "TOTRAD_kg" | variable != "TOTRAD_kg_m2",
      ~ .x %>% rstatix::kruskal_test(formula = model_MIX) %>%
        select(c(n, statistic, df, p)) %>% rename_with(~ glue::glue("{.x}_MIX")),
      .else = ~NA
    ),
    "posthoc_TIL" = varData %>% modify(
      ~ .x %>% ggpubr::compare_means(formula = model_TIL)
    ),
    "posthoc_MIX" = varData %>% modify_if(
      ~ length(pull(distinct(na.omit(.x), MIX))) > 1, #ok
      ~ .x %>% ggpubr::compare_means(formula = model_MIX)
    ),
    "effsize_TIL" = varData %>% modify(
      ~ .x %>% kruskal_effsize(formula = model_TIL) %>%
        select(!.y.) %>% rename_with(~ glue::glue("{.x}_TIL"))
    ),
    "effsize_MIX" = varData %>% modify_if(
      ~ length(pull(distinct(na.omit(.x), MIX))) > 1, #ok
      ~ .x %>% kruskal_effsize(formula = model_MIX) %>%
        select(!.y.) %>% rename_with(~ glue::glue("{.x}_MIX"))
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


compactionData <- varTestTbl %>% filter(variable == "PNDcm") %>%
  # mutate(varData = varData %>% modify(~.x %>% filter(SAMPL_TIME != "Spring"))) %>%
  unnest(variable:varData)
infilData <- varTestTbl %>% filter(variable == "INFILmL") %>%
  # mutate(varData = varData %>% modify(~.x %>% filter(SAMPL_TIME != "Spring"))) %>%
  unnest(variable:varData)
weedData <- varTestTbl %>% filter(variable == "Wd_Abn" |
                                    variable == "Wd_Cov" |
                                    variable == "Wd_Dn_m2") %>%
  unnest(variable:varData)
yieldData <- varTestTbl %>% filter(variable == "RADL_CM" |
                                     variable == "TOTRAD_kg_m2") %>%
  unnest(variable:varData)




#attic----

# varTbl %>% lmer(formula = model)
# model <- value ~ TIL
# model <- value ~ MIX #symmetrybug
# statTbl <- varTbl %>% oir::getStatsTbl(model)
#parametricResultsNotVeryDiff
