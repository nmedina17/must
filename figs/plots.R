here::i_am("figs/plots.R"); library(tidyverse)
#drone/Maps----
map <- magick::image_read(here::here("figs/site_SSURGO_short.jpg")) %>% magick::image_ggplot()
#soilProfile----
soil <- magick::image_read(here::here("figs/soilProfile.jpeg")) %>% magick::image_ggplot()
#plotsDiag----
plotsView <- magick::image_read(here::here("figs/plotsView.jpg")) %>% magick::image_ggplot()
#plotDesign----
# magick::image_read(here::here("figs/")) %>% magick::image_ggplot()

siteImgs <- ggpubr::ggarrange(map, soil, plotsView, labels = c("a","b","c"))
ggplot2::ggsave(here::here("figs/siteImgs.png"), siteImgs,
                height = 3, width = 3, units = "in")
