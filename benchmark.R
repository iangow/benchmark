## ----include=FALSE--------------------------------------------------------------------


## ----libraries, include=FALSE---------------------------------------------------------
# Load packages and connect to server
library(dplyr, warn.conflicts = FALSE)
library(tidyr, warn.conflicts = FALSE)
library(xtable)
library(lfe)


## ----get_data, include=FALSE, cache=TRUE----------------------------------------------
# This script performs analyses on fund-level voting for diversity. 
# Creates table of sorted aggregate results across funds.
merged_voting_dt <- readRDS("merged_voting_dt.Rdata")


## ----reg_function, include=FALSE, cache=TRUE------------------------------------------
# https://stackoverflow.com/questions/33218469/boldify-the-contents-of-bottom-row-in-xtable
bold_somerows <- function(x) {
  x <- gsub('^BOLD(.*)$', '\\\\textbf{\\1}', x)
  x <- gsub('&', '\\\\&', x)
  x
}

fix_names <- function(df) {
  # Rename columns
  colnames(df) <- c('Fund family', 'Base', 'Diversity')
  df
}

get_results <- function(variable = "diverse_i") {
  # Run regressions
  fm1_fe <- 
    merged_voting_dt %>%
    rename("diversity" = variable) %>%
    # Create fund-diversity fixed effect
    mutate(fund_diversity_effect_i = paste(institutionname, 
                                           diversity, sep = '_D')) %>%
    felm(I(100*maj_votes_for_i) ~ 
                  # Director level controls
                  attendance_problems_i + I(log(tenure_n)) +
                  I(log(age_n)) + insider_i + I(log(1+total_boards_n))
                | fund_diversity_effect_i | 0 | 0, data = ., 
         keepX = FALSE, keepCX = FALSE) %>%
    # Adding standard errors (below) slows this down tremendously
    getfe() %>% #, se = T) 
    tibble() %>%
    mutate(idx = as.character(idx)) %>%
    separate(idx, into = c('institution', 'diversity_fe'), sep = '_') 
  
  top_funds <- 
    fm1_fe %>% 
    filter(diversity_fe=="D1") %>% 
    select(obs, institution) %>%
    distinct() %>%
    arrange(desc(obs)) %>% 
    filter(row_number() <= 100) %>%
    select(institution)
    
  # Change data set to allow for differences between FE coefficients.
  # These differences are the institutional-level fixed effect
  diversity_fe <- 
    fm1_fe %>%
    select(institution, effect, diversity_fe) %>%
    spread(diversity_fe, effect) %>%
    mutate(baseline = D0, 
           institution_fe = D1-D0) %>%
    select(institution, baseline, institution_fe) %>%
    inner_join(top_funds, by = "institution") %>%
    mutate(institution = substr(institution, 1, 32)) %>%
    fix_names() 
  
  bold_value <- function(x, predicate) {
    if_else(predicate, gsub("^(.*)$", "BOLD\\1", x), x)
  }
    
  bold_df <- function(df) {
    df %>%
      mutate_at(vars(Base, Diversity), ~ sprintf( "%.02f", .)) %>%
      mutate(predicate = grepl("^(BlackRock|Vanguard|State Street)", 
                               `Fund family`)) %>%
      mutate_at(vars(`Fund family`, Base, Diversity), 
                function(x) bold_value(x, .$predicate)) %>%
      select(-predicate)
  }
  
  # Sort on coefficient size and create tables of top 50 and bottom 50
  table_top <- 
    diversity_fe %>%
    arrange(desc(Diversity)) %>%
    slice(1:50) %>%
    bold_df()
  
  table_bottom <- 
    diversity_fe %>%
    arrange(Diversity) %>%
    slice(1:50) %>%
    arrange(desc(Diversity)) %>%
    bold_df()
  
  return(list(table_top, table_bottom))
}


## ----reg_1, dependson=c("reg_function", "get_data"), cache=TRUE, include=FALSE--------
temp <- get_results("diverse_i")
table_top <- temp[[1]]
table_bottom <- temp[[2]]


## ----table_1a, dependson="reg_1", results="asis"--------------------------------------
xtable(table_top, align = "llrr")

## ----table_1b, dependson="reg_1", results="asis"--------------------------------------
xtable(table_bottom, align = "llrr")

## ----reg_2, dependson=c("reg_function", "get_data"), cache=TRUE, include=FALSE--------
temp <- get_results("female_i")
table_top <- temp[[1]]
table_bottom <- temp[[2]]

## ----table_2a, dependson="reg_2", results="asis"--------------------------------------
xtable(table_top, align = "llrr")

## ----table_2b, dependson=c("reg_function", "get_data"), results="asis"----------------
xtable(table_bottom, align = "llrr")

## ----reg_3, dependson=c("reg_function", "get_data"), cache=TRUE, include=FALSE--------
temp <- get_results("ethnically_diverse_i")
table_top <- temp[[1]]
table_bottom <- temp[[2]]

## ----table_3a, dependson="reg_3", results="asis"--------------------------------------
xtable(table_top, align = "llrr")

## ----table_3b, dependson="reg_3", results="asis"--------------------------------------
xtable(table_bottom, align = "llrr")

## ----reg_4, dependson=c("reg_function", "get_data"), cache=TRUE, include=FALSE--------
temp <- get_results("any_gender_diversity_i")
table_top <- temp[[1]]
table_bottom <- temp[[2]]

## ----table_4a, dependson="reg_4", cache=TRUE, results="asis"--------------------------
xtable(table_top, align = "llrr")

## ----table_4b, dependson="reg_4", results="asis"--------------------------------------
xtable(table_bottom, align = "llrr")

## ----reg_5, dependson=c("reg_function", "get_data"), cache=TRUE, include=FALSE--------
temp <- get_results("any_ethnic_diversity_i")
table_top <- temp[[1]]
table_bottom <- temp[[2]]

## ----table_5a, dependson="reg_5", results="asis"--------------------------------------
xtable(table_top, align = "llrr")

## ----table_5b, dependson="reg_5", results="asis"--------------------------------------
xtable(table_bottom, align = "llrr")
