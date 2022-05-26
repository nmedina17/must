here::i_am("figs/compaction.R"); source(here::here("analysis/stats1.R"))
#local
# library(oir); library(glue);

# compactionData <- varTestTbl %>% filter(variable == "PNDcm") %>%
#   # mutate(varData = varData %>% modify(~.x %>% filter(SAMPL_TIME != "Spring"))) %>%
#   unnest(variable:varData)
theme_set(theme_bw() + theme(text = element_text(size = 6),
                             strip.background = element_rect(fill = "white"),
                             axis.text.x = element_text(size = 6),
                             strip.text = element_text(margin = margin(
                               0.05, 0.05, 0.05, 0.05, "cm"))))
compactionLabels <- c("Null", "Perennial", "Compaction", "Weed Suppression")
names(compactionLabels) <- c("null", "pere", "comp", "wdsp")
compactionPlot_a <- compactionData %>%
  # dotGraph("PNDcm", TIL, value, "Depth to hardpan", "Tillage")
  ggplot(aes(x = TIL, y = value,
             # shape = MIX
             )) +
  ggbeeswarm::geom_quasirandom(color = "gray") +
  labs(x = "Tillage", y = "Depth to hardpan (cm)",
       # shape = "Cover crop mix"
       ) +
  # scale_shape_discrete(labels = compactionLabels) +
  theme(legend.position = "top") +
  facet_wrap(~MIX, labeller = labeller(MIX = compactionLabels)) +
  scale_y_reverse()
compactionPlot_a <- compactionPlot_a %>%
  ggpubr::add_summary(fun = "median_mad", size = 0.25) +
  ggpubr::stat_compare_means(size = 1.5, label = "p.format", label.y.npc = "bottom") +
  ggpubr::stat_compare_means(comparisons = list(c("Roto", "Tractor"),
                                        c("No", "Roto"),
                                        c("No", "Tractor")),
                     label = "p.signif",
                     # hide.ns = T,
                     symnum.args = list(
                       cutpoints = c(0, 0.0001, 0.001, 0.01,
                                     # 0.11,
                                     1),
                       symbols = c("****", "***", "**",
                                   # "*'",
                                   "'")),
                     size = 1.5,
                     vjust = 0.5
                     ) +
  EnvStats::stat_n_text(size = 1.5)

compactionPlot_b <- compactionData %>%
  # dotGraph("PNDcm", TIL, value, "Depth to hardpan", "Tillage")
  # group_by(TIL) %>%
  ggplot(aes(x = MIX, y = value
             # color = TIL
             )) +
  theme(legend.position = "top") +
  ggbeeswarm::geom_quasirandom(color = "gray") +
  labs(x = "Cover crop mix", y = "Depth to hardpan (cm)") +
  scale_y_reverse() + facet_grid(~TIL)
compactionPlot_b <- compactionPlot_b %>%
  ggpubr::add_summary(fun = "median_mad", size = 0.25) +
  ggpubr::stat_compare_means(size = 1.5, label = "p.format", label.y.npc = "bottom") +
  ggpubr::stat_compare_means(comparisons = list(
    # c("null", "comp"), c("comp", "pere"),
    c("null", "pere"), c("pere", "wdsp")
    # c("comp", "wdsp"), c("null", "wdsp")
  ), label = "p.signif", # hide.ns = T,
  symnum.args = list(
    cutpoints = c(0, 0.0001, 0.001, 0.01,
                  # 0.11,
                  1),
    symbols = c("****", "***", "**",
                # "*'",
                "'")
  ),
  size = 1.5, vjust = 0.5
  ) +
  EnvStats::stat_n_text(size = 1.5)

compactionPlot <- ggpubr::ggarrange(compactionPlot_a, compactionPlot_b,
                            labels = c("a", "b"), nrow = 2)
ggplot2::ggsave("figs/compactionPlot.png", compactionPlot,
       height = 3, width = 3, units = "in")
