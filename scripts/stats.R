source("clean.R")

library(ggstatsplot) #glance
library(lmerTest); library(lme4) #glmer


Compact <- Usmpgg %>% filter(variable == "PNDcm")

#model
CompactStat <- Compact %>%
  lmer(formula = median ~ MIX * TIL + (SAMPL_TIME | COL))
#assumptions
CompactStat %>% residuals() %>% shapiro_test() #check,pass
#variance
Compact %>% levene_test(formula = median ~ MIX * TIL)  #pass,novar


#pairwise
CompactStatPost <- Compact %>% #filter(TIL != "Roto") %>%
  group_by(TIL) %>%
  #kruskal_test(median ~ MIX)
  emmeans_test(median ~ MIX,
               p.adjust.method = "Holm") %>%
  myPHmods() %>%
  #add_xy_position() %>%
  filter(p.adj < 0.15) #includemarginalp
#CompactStatPost$p.adj <- round(
#  CompactStatPost$p.adj, digits = 3)
CompactStatPost$y.position <- CompactStatPost$y.position - 25
#compare_means(median ~ MIX,
#              method = "t.test", data = Compact)  #2nd

#specify/limitposthoc
#CompactPairs <- list(c("Null", "Perennial"))


#v2old

#pairwise
CompactStatPost2 <- Compact %>%
  group_by(MIX) %>%
  #kruskal_test(median ~ MIX)
  emmeans_test(median ~ TIL, p.adjust.method = "BH") %>%
  add_xy_position()

Fig1.2 <-  Compact %>%
  ggplot(aes(x = TIL, y = median)) + facet_wrap( ~ MIX) +
  geom_quasirandom(color = "grey") +
  stat_summary(fun = mean) +
  stat_summary(fun.data = mean_se, geom = "errorbar", width = 0.5) +
  scale_y_continuous(trans = "reverse") +
  labs(y = "Compaction depth (cm)", x = "Tillage") +
  theme(axis.text.x = element_text(angle = 25,
                                   hjust = 1, vjust = 1))
#addsignif
Fig1.2 + labs(caption = get_pwc_label(CompactStatPost2)) +
  stat_pvalue_manual(CompactStatPost2, hide.ns = T)
