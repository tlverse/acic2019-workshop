## ----setup, message=FALSE, warning=FALSE---------------------------------
library(kableExtra)
library(here)
library(tidyverse)
library(data.table)
library(sl3)
library(SuperLearner)
library(origami)
library(knitr)

set.seed(7194)

# load data set and take a peek
washb_data <- fread(here("data", "washb_data.csv"), stringsAsFactors = TRUE)
head(washb_data, 3) %>%
  kable(digits = 3) %>%
  kable_styling(fixed_thead = T) %>%
  scroll_box(width = "100%", height = "300px")


## ----task----------------------------------------------------------------
# specify the outcome and covariates
outcome <- "whz"
covars <- colnames(washb_data)[-which(names(washb_data) == outcome)]

# create the sl3 task
washb_task <- make_sl3_Task(
  data = washb_data,
  covariates = covars,
  outcome = outcome
)

# examine it
washb_task


## ----list-properties-----------------------------------------------------
sl3_list_properties()


## ----list-learners-------------------------------------------------------
sl3_list_learners(c("continuous"))


## ----baselearners--------------------------------------------------------
# choose base learners
lrnr_glm <- make_learner(Lrnr_glm)
lrnr_mean <- make_learner(Lrnr_mean)
lrnr_ranger <- make_learner(Lrnr_ranger)
lrnr_glmnet <- make_learner(Lrnr_glmnet)


## ----stack---------------------------------------------------------------
stack <- make_learner(
  Stack,
  lrnr_glm, lrnr_mean, lrnr_ranger, lrnr_glmnet
)


## ----metalearner---------------------------------------------------------
metalearner <- make_learner(Lrnr_nnls)


## ----make-sl-------------------------------------------------------------
sl <- make_learner(Lrnr_sl,
  learners = stack,
  metalearner = metalearner
)
dt <- delayed_learner_train(sl, washb_task)
plot(dt, color = FALSE, height = "400px", width = "100%")


## ----sl-basic------------------------------------------------------------
sl_fit <- sl$train(washb_task)


## ----sl-basic-summary----------------------------------------------------
sl_preds <- sl_fit$predict()
head(sl_preds)
sl_fit$print() %>%
  kable(digits = 3) %>%
  kable_styling(fixed_thead = T) %>%
  scroll_box(width = "100%", height = "300px")


## ----extra-lrnr----------------------------------------------------------
lrnr_ranger100 <- make_learner(Lrnr_ranger, num.trees = 100)
lrnr_gam <- Lrnr_pkg_SuperLearner$new("SL.gam")
lrnr_bayesglm <- Lrnr_pkg_SuperLearner$new("SL.bayesglm")


## ----new-stack-----------------------------------------------------------
new_stack <- make_learner(
  Stack,
  lrnr_glm, lrnr_mean, lrnr_glmnet, lrnr_ranger100,
  lrnr_gam, lrnr_bayesglm
)


## ----screeners-----------------------------------------------------------
screen_cor <- Lrnr_pkg_SuperLearner_screener$new("screen.corP")


## ----screeners-pipe------------------------------------------------------
cor_pipeline <- make_learner(Pipeline, screen_cor, new_stack)


## ----screeners-stack-----------------------------------------------------
fancy_stack <- make_learner(Stack, cor_pipeline, new_stack)
dt_new <- delayed_learner_train(fancy_stack, washb_task)
plot(dt_new, color = FALSE, height = "400px", width = "100%")


## ----sl-fancy------------------------------------------------------------
sl_fancy <- Lrnr_sl$new(learners = fancy_stack, metalearner = metalearner)
sl_fit_fancy<- sl_fancy$train(washb_task)
sl_fit_fancy$print() %>%
  kable(digits = 3) %>%
  kable_styling(fixed_thead = T) %>%
  scroll_box(width = "100%", height = "300px")


## ----CVsl----------------------------------------------------------------
washb_task_new <- make_sl3_Task(
  data = washb_data,
  covariates = covars,
  outcome = outcome,
  folds = make_folds(washb_data, fold_fun = folds_vfold, V = 2)
)
CVsl <- CV_lrnr_sl(sl_fit, washb_task_new, loss_squared_error)
CVsl %>%
  kable(digits = 3) %>%
  kable_styling(fixed_thead = T) %>%
  scroll_box(width = "100%", height = "300px")


## ----varimp--------------------------------------------------------------
washb_varimp <- varimp(sl_fit_fancy, loss_squared_error)
washb_varimp %>%
  kable(digits = 3) %>%
  kable_styling(fixed_thead = T) %>%
  scroll_box(width = "100%", height = "300px")


## ---- ex-setup-----------------------------------------------------------
# load the data set
db_data <-
  url("https://raw.githubusercontent.com/benkeser/sllecture/master/chspred.csv")
chspred <- read_csv(file = db_data, col_names = TRUE)
# take a quick peek
head(chspred, 3) %>%
  kable(digits = 3) %>%
  kable_styling(fixed_thead = T) %>%
  scroll_box(width = "100%", height = "300px")

