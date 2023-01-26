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

siteImgs <- ggpubr::ggarrange(oldSite, map, soil, nrow=1,
                              labels = c("a","b","c"), align = "hv")
siteDesign <- ggpubr::ggarrange(design, plotsViewN, nrow = 1,
                                labels = c("a", "b"), align = "hv"
                              # widths = c(1, 1), heights = c(1, 1)
                              )
# ggplot2::ggsave(here::here("figs/siteImgs.png"), siteImgs,
                # height = 3, width = 3, units = "in")
