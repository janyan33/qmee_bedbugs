## setwd("C:/Users/jy33/OneDrive/Desktop/R/bedbugs")

library(tidyverse)
library(asnipe)
library(igraph)
library(ggplot2); theme_set(theme_classic())
library(lme4)
library(glmmTMB)
library(assortnet)
source("scripts/functions.R")

################# INPUTTING AND ORGANIZING DATA ####################
## Data for aggregation-based networks
groups <- read.csv("data/bbsna_aggregations.csv") %>% 
          filter(Replicate != "prelim")

rep_list_groups <- split(groups, groups$Replicate) # creates a list of replicates

## Attribute data
attr <- read.csv("data/bbsna_attributes.csv") %>% 
        filter(replicate == 1 | replicate == 2) %>% 
        filter(notes != "died")

#################### OBSERVED AGGREGATION NETWORKS ####################
# Using func_igraph on rep_list_groups to create a list of igraph objects (1 per replicate)
igraph_objects <- lapply(rep_list_groups, func_igraph)

## Creates a data frame of node attributes from all networks (will use this for our model)
attr_observed <- func_attr(igraph_objects)
print(attr_observed)

## Visualizing the observed networks
lapply(X = igraph_objects, FUN = func_plot_network)

######################## PREDICTION 1 GLM ##########################
predict1.1 <- glm(strength~sex + size, data=attr_observed, family = Gamma(link="log"))
plot(predict1.1) 
# residuals vs fitted and scale-location not straight
predict1.2 <- glm(strength~sex + size + replicate, data=attr_observed, family = Gamma(link="log"))
plot(predict1.2) 
# residuals vs fitted and scale-location look better but still not straight
size.q <- attr_observed$size^2
predict1.3 <- glm(strength~sex + size + size.q + replicate, data=attr_observed, family = Gamma(link="log"))
plot(predict1.3) 
obs_strength_coef <- coef(predict1.3)[2]
#quadratic plots look good # use this?

###################### PREDICTION 1 PERMUTATION ##########################
n_sim_1 <- 999
set.seed(33)
sim_coefs <- numeric(n_sim_1)

for (i in 1:n_sim_1){
  random_igraphs <- lapply(rep_list_groups, func_permute_igraph) # Creates igraph objects with shuffled nodes
  sim_coefs[i] <- func_random_model(random_igraphs) # Runs the glm on the shuffled igraph object; save coefs
}
hist(sim_coefs, main = "Prediction 1", xlab = "Coefficient value for sexMale")
lines(x = c(obs_strength_coef, obs_strength_coef), y = c(0, 270), col = "red", lty = "dashed", lwd = 2) 
# Need to run predict.1.3 code from below first (fix order later)
if (obs_strength_coef >= mean(sim_coefs)) {
  pred1_p <- 2*mean(sim_coefs >= obs_strength_coef) } else {
    pred1_p <- 2*mean(sim_coefs <= obs_strength_coef)
  }
text(x = 0.4, y = 100, "p = 0.32")

################### VISUALIZING MALE VS. FEMALE STRENGTH #################
ggplot(data = attr_observed, aes(y = strength, x = treatment, fill = sex)) + geom_boxplot() 

################# PREDICTION 2: ASSORTATIVITY OF INDIVIDUAL NETWORKS #####################
ibi_matrices <- lapply(X = rep_list_groups, FUN = func_ibi)
lapply(X = ibi_matrices, FUN = func_permute_assort)

##################### PREDICTION 3 GLM ##########################
social.low <- attr %>% group_by(treatment) %>% filter(treatment=="low") #low treatment data
social.high <- attr %>% group_by(treatment) %>% filter(treatment=="high") #high treatment data

predict3.low <- glm(matings~prox_strength + thorax.mm, data=social.low, family = Gamma(link="log"))
plot(predict3.low) 
# all good except residual vs fitted
# log or quadratic prox_strength made it worse

predict3.high <- glm(matings~prox_strength + thorax.mm, data=social.high, family = Gamma(link="log"))
plot(predict3.high) 
# plots are not good fit, try log
social.high.log <- log(social.high$prox_strength)
predict3.high2 <- glm(matings~prox_strength + social.high.log + thorax.mm, data=social.high, family = Gamma(link="log"))
plot(predict3.high2 ) 
# need everything log or just prox_strength?


