here::i_am("figs/plots.R"); library(tidyverse)
# ggplot2::theme_set(theme_bw())
#drone/Maps----
map <- magick::image_read(here::here("figs/site_SSURGO_short.jpg")) %>%
  magick::image_ggplot()
#soilProfile----
soil <- magick::image_read(here::here("figs/soilProfile.jpg")) %>%
  magick::image_ggplot()
#plotsDiag----
plotsViewN <- magick::image_read(here::here("figs/plotsViewN.jpg")) %>%
  magick::image_ggplot()
#plotDesign----
design <- magick::image_read(here::here("figs/design.jpg")) %>%
  magick::image_ggplot()
#history----
oldSite <- magick::image_read(here::here("figs/site81.png")) %>%
  magick::image_ggplot()

# magick::image_join(map, soil) %>% magick::image_montage() %>%
#   magick::image_ggplot()

siteImgs <- ggpubr::ggarrange(
  ggpubr::ggarrange(oldSite, soil, map, plotsViewN,
                    labels = c("a","c","b","e"), align = "hv"),
  design, nrow = 1, labels = c("", "d"), align = "hv"
                              # widths = c(1, 1), heights = c(1, 1)
                              )
# ggplot2::ggsave(here::here("figs/siteImgs.png"), siteImgs,
                # height = 3, width = 3, units = "in")
