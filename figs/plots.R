here::i_am("figs/plots.R"); library(tidyverse)
#drone/Maps----
map <- magick::image_read(here::here("figs/site_SSURGO_short.jpg")) %>%
  magick::image_ggplot()
#soilProfile----
soil <- magick::image_read(here::here("figs/soilProfile.jpeg")) %>%
  magick::image_ggplot()
#plotsDiag----
plotsView <- magick::image_read(here::here("figs/plotsView.jpg")) %>%
  magick::image_ggplot()
#plotDesign----
design <- magick::image_read(here::here("figs/design.jpg")) %>%
  magick::image_ggplot()

siteImgs <- ggpubr::ggarrange(map, soil, design, plotsView,
                              labels = c("a","b","c","d"))
ggplot2::ggsave(here::here("figs/siteImgs.png"), siteImgs,
                height = 3, width = 3, units = "in")
