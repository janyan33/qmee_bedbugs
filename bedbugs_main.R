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

## Using func_igraph on the list of igraph objects - 1 per replicate
igraph_objects <- lapply(rep_list_groups, func_igraph)

## Need to assign a few more attributes to the nodes (size, treatment)
#func_attr(igraph_objects)

## Trying the permute function
random_igraphs <- lapply(rep_list_groups, func_permute_igraph)

## Plotting networks
lapply(X = random_igraphs, FUN = func_plot_network)
lapply(X = igraph_objects, FUN = func_plot_network)

## Visualizing strength of males vs. females and the two treatments
ggplot(data = new_attr, aes(y = strength, x = treatment, fill = sex)) + geom_boxplot() 

## Prediction 1 GLM
p1.1 <- glm(prox_strength~sex+thorax.mm, data=attr, family = Gamma(link="log"))
plot(p1.1) # residuals vs fitted and scale-location not straight
