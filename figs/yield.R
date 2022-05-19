here::i_am("figs/yield.R"); source(here::here("figs/weeds.R"))
# yieldData <- varTestTbl %>% filter(variable == "RADL_CM" |
#                                      variable == "TOTRAD_kg_m2") %>%
#   unnest(variable:varData)
theme_set(theme_bw() + theme(text = element_text(size = 8),
                             strip.background = element_rect(fill = "white"),
                             axis.text.x = element_text(size = 8)))
yieldLabels <- c("Length (cm)", expression(paste("Mass (kg m"^-2,")")))
names(yieldLabels) <- c("RADL_CM", "TOTRAD_kg")
yieldPlot <- yieldData %>%
  # dotGraph("PNDcm", TIL, value, "Depth to hardpan", "Tillage")
  ggplot(aes(x = TIL, y = value)) +
  ggbeeswarm::geom_quasirandom(color = "gray") +
  facet_wrap(~variable, labeller = labeller(variable = yieldLabels),
             # scales = "free",
             nrow = 2) + #scale_y_log10() +
  labs(x = "Tillage", y = "Radish yield")
  # scale_y_reverse()
yieldPlot <- yieldPlot %>%
  ggpubr::add_summary(fun = "median_mad", size = 0.25) +
  ggpubr::stat_compare_means(label.y.npc = "bottom", label = "p.format", size = 1.5) +
  # ggpubr::stat_compare_means(comparisons = list(c("No", "Tractor")),
  #   # c("Roto", "Tractor"), c("No", "Roto"),
  #                    label = "p.signif",
  #                    # hide.ns = T,
  #                    symnum.args = list(
  #                      cutpoints = c(0, 0.0001, 0.001, 0.01, 0.11, 1),
  #                      symbols = c("****", "***", "**", "*'", "'")),
  #   size = 1.5, vjust = 0.5) +
  EnvStats::stat_n_text(size = 1.5)

# yieldPlot_b <- yieldData %>%
#   # dotGraph("PNDcm", TIL, value, "Depth to hardpan", "Tillage")
#   ggplot(aes(x = MIX, y = value)) +
#   ggbeeswarm::geom_quasirandom(color = "gray") +
#   facet_wrap(~variable) +
#   labs(x = "Tillage", y = "Yield (cm, oz)")
# yieldPlot_b <- yieldPlot_b %>%
#   ggpubr::add_summary(fun = "median_mad", size = 0.25) +
#   stat_compare_means() +
#   stat_compare_means(comparisons = list(
#     c("null", "comp"), c("null", "pere"),
#     c("null", "wdsp"),
#     c("comp", "pere"),
#     c("comp", "wdsp"), c("pere", "wdsp")
#   ), label = "p.signif", # hide.ns = T,
#   symnum.args = list(
#     cutpoints = c(0, 0.0001, 0.001, 0.01, 0.11, 1),
#     symbols = c("****", "***", "**", "*'", "ns")
#   ), size = 2) +
#   EnvStats::stat_n_text(size = 2)

# yieldPlot <- ggarrange(yieldPlot_a, yieldPlot_b, labels = c("a", "b"))
ggplot2::ggsave("figs/yieldPlot.png", yieldPlot,
       height = 3, width = 3, units = "in")
