## setwd("C:/Users/jy33/OneDrive/Desktop/R/bedbugs")

library(tidyverse)
library(asnipe)
library(igraph)
library(ggplot2); theme_set(theme_classic())
library(lme4)
library(glmmTMB)
library(assortnet)
source("scripts/functions.R")

###################### INPUTTING AND ORGANIZING DATA ########################
## Data for aggregation-based networks
groups <- read.csv("data/bbsna_aggregations.csv") %>% 
          filter(Replicate != "prelim")

rep_list_groups <- split(groups, groups$Replicate) # creates a list of replicates

## Attribute data
attr <- read.csv("data/bbsna_attributes.csv") %>% 
        filter(replicate == 1 | replicate == 2) %>% 
        filter(notes != "died")

################# CREATING OBSERVED AGGREGATION NETWORKS ####################
# Using func_igraph on rep_list_groups to create a list of igraph objects (1 per replicate)
igraph_objects <- lapply(rep_list_groups, func_igraph)

## Creates a data frame of node attributes from all networks (will use this for our model)
attr_observed <- func_attr(igraph_objects)
print(attr_observed)

## Visualizing the observed networks
lapply(X = igraph_objects, FUN = func_plot_network)

######################### PREDICTION 1 GLM ##################################
predict1.1 <- glm(prox_strength~sex + thorax.mm, data=attr, family = Gamma(link="log"))
plot(predict1.1) 
# residuals vs fitted and scale-location not straight
predict1.2 <- glm(prox_strength~sex + thorax.mm + replicate, data=attr, family = Gamma(link="log"))
plot(predict1.2) 
# residuals vs fitted and scale-location look better but still not straight
thorax.q <- attr$thorax.mm^2
predict1.3 <- glm(prox_strength~sex + thorax.mm + thorax.q + replicate, data=attr, family = Gamma(link="log"))
plot(predict1.3) 

#quadratic plots look good # use this?

######################### PREDICTION 1 PERMUTATION ##########################
n_sim_1 <- 99
set.seed(33)
sim_coefs <- numeric(n_sim_1)

for (i in 1:n_sim_1){
  # Creates new igraph objects where the nodes are shuffled
  random_igraphs <- lapply(rep_list_groups, func_permute_igraph)
  # Runs the glm on the new shuffled igraph objects; save coefs
  sim_coefs[i] <- func_random_model(random_igraphs) 
}
# Plot histogram 
sim_coefs <- c(sim_coefs, coef(predict1.3)[2])
hist(sim_coefs, main = "Prediction 1", xlab = "Coefficient value for sexMale")
lines(x = c(coef(predict1.3)[2], coef(predict1.3)[2]), y = c(0, 270), col = "red", lty = "dashed", lwd = 2) 

# Obtain p-value
if (coef(predict1.3)[2] >= mean(sim_coefs)) {
    pred1_p <- 2*mean(sim_coefs >= coef(predict1.3)[2]) } else {
    pred1_p <- 2*mean(sim_coefs <= coef(predict1.3)[2])
}
# Add p-value to histogram
text(x = 0.4, y = 100, "p = 0.32")

################# PREDICTION 2: ASSORTATIVITY OF INDIVIDUAL NETWORKS #####################
# Creates the observed ibi matrices for aggregation networks
ibi_matrices <- lapply(X = rep_list_groups, FUN = func_ibi)
# Runs the permutation test (see function 7 in functions.R for more info)
lapply(X = ibi_matrices, FUN = func_permute_assort)

################# PREDICTION 3 GLM ##########################
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


