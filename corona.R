library(rvest)
library(dplyr)
library(tidyverse)
library(stringr)

#declare date
month <- "03"
day <- 10

#prepare url for corresponding newspaper date
url <- paste("https://www.nytimes.com/issue/todayspaper/2020/", month, "/", day, "/todays-new-york-times", sep='')
url

#grab headlines and subheadlines
nytimes <- read_html(url)
nyt_headlines <- nytimes %>%
  html_nodes(".css-l2vidh.e4e4i5l1") %>%
  html_text
nyt_subheadlines <- nytimes %>%
  html_nodes(".css-195cszl.e1f68otr0") %>%
  html_text()

#rename columns and merge datasets
nyt_headlines <- as.data.frame(nyt_headlines) 
nyt_subheadlines <- as.data.frame(nyt_subheadlines)
names(nyt_subheadlines)[names(nyt_subheadlines) == "nyt_subheadlines"] <- "nyt_headlines"
headlines <- rbind(nyt_headlines, nyt_subheadlines)

#identify which articles are corona-related
corona <- grep("[cC]orona|[vV]irus|[pP]andemic|[lL]ockdown|[Oo]utbreak|[sS]hut", headlines$nyt_headlines, value=TRUE)
corona <- as.data.frame(corona)
names(corona)[names(corona) == "corona"] <- "headlines"

#calculate percentage of articles are corona-related for the day's paper
percentCorona <- round(as.numeric(nrow(corona))/as.numeric(nrow(headlines))*100, 2)
percentCoronaOutput <- paste(percentCorona,"%", sep="")

#identify topic areas for covid-related articles
topics_anxiety <- grep("([aA]nxiety|[sS]tress)", corona$headlines, value=TRUE)
topics_fear <- grep("([sS]hock|[mM]orality|[dD]ead|[dD]eath|[cC]haos|[bB]omb|[sS]cramble|[dD]rastic|[sS]ick|[iI]ll|[kK]ill|[wW]orst|[eE]xtreme)", corona$headlines, value=TRUE)
topics_positive <- grep("([kK]ind|[sS]upport|[Cc]ompassion|[hH]elp)", corona$headlines, value=TRUE)
