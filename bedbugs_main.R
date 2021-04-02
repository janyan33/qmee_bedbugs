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

## Attribute data
attr <- read.csv("data/bbsna_attributes.csv") %>% 
        filter(replicate != "prelim") %>% 
        filter(notes != "died") %>% 
        filter(replicate != 3)

rep_list_groups <- split(groups, groups$Replicate) # creates a list of replicates
attr_list <- split(attr, attr$replicate)

## Using func_igraph on the list of replicates
igraph_objects <- lapply(rep_list_groups, func_igraph)

## Plotting one of the replicates, not very detailed(missing attributes); don't have time to code this rn
plot(igraph_objects[[1]], edge.curved = 0, edge.color = "black", weighted = TRUE,
    layout = layout_nicely(igraph_objects[[1]])) 

plot(igraph_objects[[2]], edge.curved = 0, edge.color = "black", weighted = TRUE,
     layout = layout_nicely(igraph_objects[[1]])) 

## Permutation using igraph function?
attributes <- lapply(igraph_objects, vertex_attr)



## Visualizing strength of males vs. females and the two treatments
ggplot(data = attr, aes(y = prox_strength, x = treatment, fill = sex)) + geom_boxplot() 


## Prediction 1 GLM
p1.1 <- glm(prox_strength~sex+thorax.mm, data=attr, family = Gamma(link="log"))
plot(p1.1) # residuals vs fitted and scale-location not straight
