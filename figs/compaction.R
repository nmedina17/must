here::i_am("figs/compaction.R"); source(here::here("analysis/stats1.R"))
#local
# library(oir); library(glue);

compactionData <- varTestTbl %>% filter(variable == "PNDcm") %>%
  mutate(varData = varData %>% modify(~.x %>% filter(SAMPL_TIME != "Spring"))) %>%
  unnest()
theme_set(theme_bw() + theme(text = element_text(size = 8),
                             strip.background = element_rect(fill = "white"),
                             axis.text.x = element_text(size = 8)))
compactionPlot <- compactionData %>%
  # dotGraph("PNDcm", TIL, value, "Depth to hardpan", "Tillage")
  ggplot(aes(x = TIL, y = value)) +
  ggbeeswarm::geom_quasirandom(color = "gray") +
  labs(x = "Tillage", y = "Depth to hardpan (cm)") +
  facet_wrap(~MIX) +
  scale_y_reverse()
compactionPlot <- compactionPlot %>%
  ggpubr::add_summary(fun = "median_mad", size = 0.25) +
  stat_compare_means(size = 1.5, label = "p.format", label.y.npc = "bottom") +
  stat_compare_means(comparisons = list(c("Roto", "Tractor"),
                                        c("No", "Roto"),
                                        c("No", "Tractor")),
                     label = "p.signif",
                     # hide.ns = T,
                     symnum.args = list(
                       cutpoints = c(0, 0.0001, 0.001, 0.01, 0.11, 1),
                       symbols = c("****", "***", "**", "*'", "'")),
                     size = 1.5,
                     vjust = 0.5
                     ) +
  EnvStats::stat_n_text(size = 1.5)

# compactionPlot_b <- compactionData %>%
#   # dotGraph("PNDcm", TIL, value, "Depth to hardpan", "Tillage")
#   # group_by(TIL) %>%
#   ggplot(aes(x = MIX, y = value, color = TIL)) +
#   theme(legend.position = "top") +
#   ggbeeswarm::geom_quasirandom() +
#   labs(x = "Cover crop mix", y = "Depth to hardpan (cm)") +
#   # facet_grid(SAMPL_TIME ~ MIX) + #confusing
#   scale_y_reverse()
# compactionPlot_b <- compactionPlot_b %>%
#   ggpubr::add_summary(fun = "median_mad", size = 0.25) +
#   stat_compare_means(size = 2, label = "p.format") +
#   # stat_compare_means(comparisons = list(
#   #   c("null", "comp"), c("null", "pere"), c("null", "wdsp"),
#   #   c("comp", "pere"), c("comp", "wdsp"), c("pere", "wdsp")
#   # ), label = "p.signif", # hide.ns = T,
#   # symnum.args = list(
#   #   cutpoints = c(0, 0.0001, 0.001, 0.01, 0.11, 1),
#   #   symbols = c("****", "***", "**", "*'", "ns")),
#   # size = 2
#   # ) +
#   EnvStats::stat_n_text(size = 2)

# compactionPlot <- ggarrange(compactionPlot_a, compactionPlot_b,
#                             labels = c("a", "b"))
ggsave("figs/compactionPlot.png", compactionPlot,
       height = 3, width = 3, units = "in")
