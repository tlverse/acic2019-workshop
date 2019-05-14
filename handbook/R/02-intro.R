## ---- echo=F, eval=T-----------------------------------------------------
library(visNetwork)
nodes <- data.frame(id=c("W","A","Y"))
nodes$label <- nodes$id
edges <- data.frame(from=c("W","W","A"),to=c("A","Y","Y"))
network <- visNetwork(nodes,edges, height="300px",width="200px") %>%
  visEdges(arrows=list(to=TRUE))  %>%
  visLayout(randomSeed=25)
network


## ----nature_slides, fig.show="hold"--------------------------------------
knitr::include_graphics("img/misc/NatureSlides.pdf")


## ----cv_fig, fig.show="hold"---------------------------------------------
knitr::include_graphics("img/misc/vs.pdf")


## ----nature_slides_3, fig.show="hold"------------------------------------
knitr::include_graphics("img/misc/NatureSlides_3.pdf")

## ----nature_slides_4, fig.show="hold"------------------------------------
knitr::include_graphics("img/misc/NatureSlides_4.pdf")

## ----nature_slides_5, fig.show="hold"------------------------------------
knitr::include_graphics("img/misc/NatureSlides_5.pdf")


## ----load_washb_data_intro, message=FALSE, warning=FALSE-----------------
library(here)
library(tidyverse)

# read in data
dat <- read_csv(here("data", "washb_data.csv"))
dat


## ----skim_washb_data, message=FALSE, warning=FALSE-----------------------
library(skimr)
skim(dat)

