library(tidyverse)
library(asnipe)
library(igraph)
library(ggplot2); theme_set(theme_classic())
source("scripts/functions.R")

### INPUTTING AND ORGANIZING DATA ###
## Data for aggregation-based networks
groups <- read.csv("data/bbsna_aggregations.csv") %>% 
          filter(Replicate != "prelim")

## Attribute data
attr <- read.csv("data/bbsna_attributes.csv") %>% 
        filter(replicate == 1:2) %>% 
        filter(notes != "died")

rep_list_groups <- split(groups, groups$Replicate) # creates a list of replicates
attr_list <- split(attr, attr$replicate)

## Using func_igraph on the list of replicates
igraph_objects <- lapply(rep_list_groups, func_igraph)

## Plotting one of the replicates, not very detailed(missing attributes); don't have time to code this rn
plot(igraph_objects[[1]], edge.curved = 0, edge.color = "black", weighted = TRUE,
    layout = layout_nicely(igraph_objects[[1]])) 

## Permutation using igraph function?
func_permute_strength(igraph_objects[[1]])


## Visualizing strength of males vs. females and the two treatments
ggplot(data = attr, aes(y = prox_strength, x = treatment, fill = sex)) + geom_boxplot() 

## Prediction 1 
lm.social <- lm(prox_strength~sex, data=attr)
plot(lm.social)

## Prediction 3 
lm.harass <- lm(matings~prox_strength, data=attr)
plot(lm.harass)


