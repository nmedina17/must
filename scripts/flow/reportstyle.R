#tables,plots

library(tidyverse)


#tables

library(gtsummary); library(broom.mixed)
# library(sjPlot)

##theme
theme_gtsummary_compact()
#install.packages("gtsummary")  #oldversion
#theme_gtsummary_journal("jama")
#reset_gtsummary_theme()
tableStyle <- list(#"pkgwide-str:ci.sep" = " - ",
  #"tbl_summary-str:continuous_stat" = "{median} ({sd} / {N})",
  "tbl_regression-chr:tidy_columns" =
    c(#"std.error",
      "p.value"),
  "tbl_regression-fn:addnl-fn-to-run" = "bold_p",
  "tbl_regression-str:coef_header" = "Effect size")
set_gtsummary_theme(tableStyle)
# kableExtra for tables
# gt:: for tables

mySummaryMods <- function(...gt...) {
  ...gt... %>% add_n() #%>% bold_p()
  #modify_header(label ~ "**Variable**")
}

modelfit <- c("df.residual", "AIC", "BIC", "logLik")
myRegression <- function(..model) {
  mytable <- ..model %>%
    tbl_regression() %>%
    add_global_p(keep = T) %>%
    add_n(location = "level") %>%
    add_glance_source_note(include = modelfit)

  return(mytable)
}


#posthoc
myPHmods <- function(..myphtest) {
  posthoc <- ..myphtest %>%
    add_xy_position()
  #filter(p.adj < 0.15)
  posthoc$p.adj <- round(posthoc$p.adj,
                         digits = 3)

  return(posthoc)
}


#plots--close2nature

##theme
plotStyle <- theme_bw() +
  theme(axis.text = element_text(size = 10),
        #panel.grid = element_blank(),
        text = element_text(family = "Helvetica",
                            size = 12),
        legend.text.align = 0,
        axis.ticks = element_blank(),
        strip.background = element_rect(fill = "white"),
        legend.position = "top")
theme_set(plotStyle)


library(ggbeeswarm); library(ggpubr)
#require(ggpmisc)  #statlabels
#require(ggsignif)
#require(ggprism)  #statlabels

myPlot <- function(..mytbl, ..x, ..y,
                   ..myposthoc,
                   ..xlab = NULL,
                   ..ylab = NULL) {
  myplot <- ..mytbl %>%
    ggplot(aes(x = {{..x}}, y = {{..y}})) +
    ggbeeswarm::geom_quasirandom(color = "grey") +
    #statslayers

    #stat_compare_means(method = "emmeans",
    #                   comparisons = CompactPairs, #facetbug
    #                   symnum.args = cymbals) +  #bug
    labs(caption = get_pwc_label(..myposthoc),
         x = ..xlab, y = ..ylab) +
    ggpubr::stat_pvalue_manual(..myposthoc,
                       label = "p.adj")
  #hide.ns = T)
  #add_pvalue(CompactStatPost, hide.ns = T)
  #geom_signif(comparisons = CompactPairs, test = "emmeans")
  #stat_fit_glance() + stat_fit_tidy() +

  return(myplot)
}

#tryouts
#require(ggThemeAssist)
#require(esquisse)
#require(plot_ly)
