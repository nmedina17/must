here::i_am("figs/plots.R"); library(tidyverse)
ggplot2::theme_set(theme_bw())
#drone/Maps----
map <- magick::image_read(here::here("figs/site_SSURGO_short.jpg"), strip = T) %>%
  magick::image_ggplot()
#soilProfile----
soil <- magick::image_read(here::here("figs/soilProfile.jpg"), strip = T) %>%
  magick::image_ggplot()
#plotsDiag----
plotsViewN <- magick::image_read(here::here("figs/plotsViewN.jpg"), strip = T) %>%
  magick::image_ggplot()
#plotDesign----
design <- magick::image_read(here::here("figs/design.jpg"), strip = T) %>%
  magick::image_ggplot()

siteImgs <- ggpubr::ggarrange(map, soil, design, plotsViewN,
                              labels = c("a","b","c","d"),
                              align = "hv", nrow = 2
                              # widths = c(1, 1), heights = c(1, 1)
                              )
# ggplot2::ggsave(here::here("figs/siteImgs.png"), siteImgs,
                # height = 3, width = 3, units = "in")
