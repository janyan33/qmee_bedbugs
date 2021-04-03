library(tidyverse)
library(asnipe)
library(igraph)
library(ggplot2); theme_set(theme_classic())
library(lme4)
library(glmmTMB)
source("scripts/functions.R")

### INPUTTING AND ORGANIZING DATA ###

## Data for aggregation-based networks
groups <- read.csv("data/bbsna_aggregations.csv") %>% 
          filter(Replicate != "prelim")

rep_list_groups <- split(groups, groups$Replicate) # creates a list of replicates

## Attribute data
attr <- read.csv("data/bbsna_attributes.csv") %>% 
        filter(replicate == 1 | replicate == 2) %>% 
        filter(notes != "died")

## CREATING iGRAPH OBJECTS
## Using func_igraph on the list of igraph objects - 1 per replicate
igraph_objects <- lapply(rep_list_groups, func_igraph)

## Output attributes
attr_observed <- func_attr(igraph_objects)

## Visualizing networks networks
lapply(X = igraph_objects, FUN = func_plot_network)

## PREDICTION 1 PERMUTATION
n_sim <- 999
set.seed(33)
sim_coefs <- numeric(n_sim)

for (i in 1:n_sim){
  random_igraphs <- lapply(rep_list_groups, func_permute_igraph)
  sim_coefs[i] <- func_sim_attr(random_igraphs)
}
hist(sim_coefs)
abline(v = coef(predict1.3)[2])


## Visualizing strength of males vs. females and the two treatments
ggplot(data = new_attr, aes(y = strength, x = treatment, fill = sex)) + geom_boxplot() 


### STATISTICS ###

## Prediction 1 GLM
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

## Prediction 3 GLM 
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


