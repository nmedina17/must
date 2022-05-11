here::i_am("figs/infil.R"); source(here::here("figs/compaction.R"))
infilData <- varTestTbl %>% filter(variable == "INFILmL") %>%
  mutate(varData = varData %>% modify(~.x %>% filter(SAMPL_TIME != "Spring"))) %>%
  unnest(variable:statTest_MIX)
theme_set(theme_bw() + theme(text = element_text(size = 8),
                             strip.background = element_rect(fill = "white"),
                             axis.text.x = element_text(size = 8)))
infilPlot_a <- infilData %>%
  # dotGraph("PNDcm", TIL, value, "Depth to hardpan", "Tillage")
  ggplot(aes(x = TIL, y = value)) +
  ggbeeswarm::geom_quasirandom(color = "gray") +
  facet_wrap(~SAMPL_TIME) +
  labs(x = "Tillage", y = expression(paste("Infiltration (mL sec"^-1, ")")),
       size = 8)
infilPlot_a <- infilPlot_a %>%
  ggpubr::add_summary(fun = "median_mad", size = 0.25) +
  ggpubr::stat_compare_means(size = 1.5, label = "p.format") +
  ggpubr::stat_compare_means(comparisons = list(c("Roto", "Tractor"),
                                        c("No", "Roto"),
                                        c("No", "Tractor")),
                     label = "p.signif",
                     # hide.ns = T,
                     symnum.args = list(
                       cutpoints = c(0, 0.0001, 0.001, 0.01, 0.11, 1),
                       symbols = c("****", "***", "**", "*'", "'")),
                     size = 1.5, vjust = 0.5) +
  EnvStats::stat_n_text(size = 1.5)

infilPlot_b <- infilData %>%
  # dotGraph("PNDcm", TIL, value, "Depth to hardpan", "Tillage")
  ggplot(aes(x = MIX, y = value)) +
  ggbeeswarm::geom_quasirandom(color = "gray") +
  # facet_wrap(~SAMPL_TIME) +
  labs(x = "Cover crop mix",
       y = expression(paste("Infiltration (mL sec"^-1, ")")),
       size = 8) +
  scale_y_log10()
infilPlot_b <- infilPlot_b %>%
  ggpubr::add_summary(fun = "median_mad", size = 0.25) +
  ggpubr::stat_compare_means(size = 1.5, label = "p.format", digits = 3) +
  ggpubr::stat_compare_means(comparisons = list(
    # c("null", "comp"), c("null", "pere"),
    c("null", "wdsp")
    # c("comp", "pere"), c("comp", "wdsp"), c("pere", "wdsp")
  ), label = "p.signif", # hide.ns = T,
  symnum.args = list(
    cutpoints = c(0, 0.0001, 0.001, 0.01, 0.11, 1),
    symbols = c("****", "***", "**", "*'", "'")),
  size = 1.5, vjust = 0.5
  ) +
  EnvStats::stat_n_text(size = 1.5)

infilPlot <- ggarrange(infilPlot_a, infilPlot_b, labels = c("a", "b"), nrow = 2)
ggsave("figs/infilPlot.png", infilPlot,
       height = 3, width = 3, units = "in")
