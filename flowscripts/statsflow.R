#1=glanceplot;2=statassumptions,3=lowestglmerAIC


#general

#require(fansi) #needsXcode
library(ggstatsplot) #grouped_ggbetweenstats()
#library(ggstatsverse) #bug
library(rstatix)


#findnormality
findNormality <- function(Model) {

  normalresid <- F
  normaltest <- Model %>%
    residuals() %>% shapiro_test()
  if (normaltest$p.value > 0.05) {
    normalresid <- T
  }

  return(normal)
}


library(rstatix) #"_tests"
library(onewaytests) #bf.test() #iffailshapiro


#variancetest
variancetest <- function(result,
                         ..tbl,
                         ...formula) {
  test <- NULL
  if (result$normal == T) {
    test <- ..tbl %>%
      levene_test(formula = ...formula)
  } else {
    test <- bf.test(formula = ...formula,
                    data = ..tbl)
  }

  #checkvariance
  if (test$p > 0.05) {
    result$homoscedastic <- T
  }
}


#myflow

library(lmerTest); library(lme4)


CheckLmer <- function(..tbl, ..formula) {
  Model <- ..tbl %>% lmer(formula = ..formula)

  #setupreturn
  result <- data.frame(normalresid = F,
                       homoscedastic = F)

  y <- ..formula
  simpleModel <- y ~ x

  findNormality(simpleModel)

  #variancemodel
  formula2 <- paste(Args$...y, Fixed1, sep = " ~ ")
  variancemodel <- variancetest(...tbl,
                                formula2)


  print(result)
  return(Model)
}


#checkmyfunction
CheckLmer(...tbl... = Compact,
          ...y... = median,
          ...x... = MIX,
          ...x2... = TIL,
          interaction = T,
          ...random... = COL,
          ...randomgroup... = SAMPL_TIME)



library(emmeans) #pairwise
