here::i_am("figs/weeds.R"); source(here::here("figs/infil.R"))
weedData <- varTestTbl %>% filter(variable == "Wd_Abn" |
                                    variable == "Wd_Cov" |
                                    variable == "Wd_Dn") %>% unnest()
theme_set(theme_bw() + theme(text = element_text(size = 8),
                             strip.background = element_rect(fill = "white"),
                             axis.text.x = element_text(size = 5)))
weedLabels <- c("Richness", "Cover (%)", "Density (stems)")
names(weedLabels) <- c("Wd_Abn", "Wd_Cov", "Wd_Dn")
weedPlot_a <- weedData %>%
  # dotGraph("PNDcm", TIL, value, "Depth to hardpan", "Tillage")
  ggplot(aes(x = TIL, y = value)) +
  ggbeeswarm::geom_quasirandom(color = "gray") +
  facet_wrap(~variable, labeller = labeller(variable = weedLabels)) +
  labs(x = "Tillage", y = "Weeds")
weedPlot_a <- weedPlot_a %>%
  ggpubr::add_summary(fun = "median_mad", size = 0.25) +
  stat_compare_means(size = 1.5, label = "p.format", label.y.npc = "bottom") +
  stat_compare_means(comparisons = list(c("Roto", "Tractor"),
                                        # c("No", "Roto"),
                                        c("No", "Tractor")),
                     label = "p.signif",
                     # hide.ns = T,
                     symnum.args = list(
                       cutpoints = c(0, 0.0001, 0.001, 0.01, 0.11, 1),
                       symbols = c("****", "***", "**", "*'", "'")),
                     size = 1.5, vjust = 0.5) +
  EnvStats::stat_n_text(size = 1.5)

weedPlot_b <- weedData %>%
  # dotGraph("PNDcm", TIL, value, "Depth to hardpan", "Tillage")
  ggplot(aes(x = MIX, y = value)) +
  ggbeeswarm::geom_quasirandom(color = "gray") +
  facet_wrap(~variable, labeller = labeller(variable = weedLabels)) +
  labs(x = "Cover crop mix", y = "Weeds")
weedPlot_b <- weedPlot_b %>%
  ggpubr::add_summary(fun = "mean_se_", size = 0.25) +
  stat_compare_means(label = "p.format", size = 1.5, label.y.npc = "bottom") +
  stat_compare_means(comparisons = list(
    c("null", "comp"), c("null", "pere"),
    c("null", "wdsp"),
    # c("comp", "pere"),
    c("comp", "wdsp"), c("pere", "wdsp")
  ), label = "p.signif", # hide.ns = T,
  symnum.args = list(
    cutpoints = c(0, 0.0001, 0.001, 0.01, 0.11, 1),
    symbols = c("****", "***", "**", "*'", "'")
  ), size = 1.5, vjust = 0.5) +
  EnvStats::stat_n_text(size = 1.5)

weedPlot <- ggarrange(weedPlot_a, weedPlot_b, labels = c("a", "b"), nrow = 2)
ggsave("figs/weedPlot.png", weedPlot,
       height = 3, width = 3, units = "in")
