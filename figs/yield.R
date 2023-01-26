here::i_am("figs/yield.R"); source(here::here("figs/weeds.R"))
yieldNT <- magick::image_read(here::here("figs/yieldNT.jpg")) %>%
  magick::image_ggplot()
yieldTT <- magick::image_read(here::here("figs/yieldTT.jpg")) %>%
  magick::image_ggplot()

# yieldData <- varTestTbl %>% filter(variable == "RADL_CM" |
#                                      variable == "TOTRAD_kg_m2") %>%
#   unnest(variable:varData)
theme_set(theme_bw() + theme(text = element_text(size = 10),
                             strip.background = element_rect(fill = "white"),
                             axis.text.x = element_text(size = 10)))
yieldLabels <- c("Length (cm)", "Mass (g per sq m)")
names(yieldLabels) <- c("RADL_CM", "TOTRAD_g_m2")
yieldPlot <- yieldData %>%
  # dotGraph("PNDcm", TIL, value, "Depth to hardpan", "Tillage")
  ggplot(aes(x = TIL, y = value)) +
  ggbeeswarm::geom_quasirandom(color = "gray") +
  facet_wrap(~variable, labeller = labeller(variable = yieldLabels),
             scales = "free",
             nrow = 1) + #scale_y_log10() +
  # remotes::install_github("teunbrand/ggh4x")
  # ggh4x::facetted_pos_scales(y = list(NULL, scale_y_continuous(limits = c(0, 100)))) +
  labs(x = "Tillage", y = "Radish yield")
  # scale_y_reverse()
yieldPlot <- yieldPlot +
  ggplot2::stat_summary(fun.data = ggpubr::mean_se_,
                      size = 0.25) +
  ggpubr::stat_compare_means(label.y.npc = "bottom", label = "p.format", size = 3) +
  # ggpubr::stat_compare_means(comparisons = list(c("No", "Tractor")),
  #   # c("Roto", "Tractor"), c("No", "Roto"),
  #                    label = "p.signif",
  #                    # hide.ns = T,
  #                    symnum.args = list(
  #                      cutpoints = c(0, 0.0001, 0.001, 0.01, 0.11, 1),
  #                      symbols = c("****", "***", "**", "*'", "'")),
  #   size = 1.5, vjust = 0.5) +
  EnvStats::stat_n_text(size = 3)

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

yieldPlot <- ggpubr::ggarrange(
  ggpubr::ggarrange(yieldNT, yieldTT, labels = c("a", "b"), nrow = 1),
  yieldPlot, labels = c("", "c"), nrow = 2
  # align = "hv"
)
# ggplot2::ggsave("figs/yieldPlot.png", yieldPlot,
#        height = 3, width = 3, units = "in")
