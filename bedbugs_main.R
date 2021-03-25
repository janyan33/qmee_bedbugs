library(tidyverse)
library(asnipe)
library(igraph)
library(ggplot2); theme_set(theme_classic())

## Data for aggregation-based networks
groups <- read.csv("data/bbsna_aggregations.csv") %>% 
          filter(Replicate != "prelim")

## Attribute data
attr <- read.csv("data/bbsna_attributes.csv") %>% 
        filter(replicate != "prelim") %>% 
        filter(notes != "died")

## Creating a list of replicates
rep_list_groups <- split(groups, groups$Replicate)

## Creating a function that turns raw data into one igraph object per replicate
func_igraph <- function(rep_groups){
   group_list <- strsplit(rep_groups$Members, " ")
   gbi_matrix <- get_group_by_individual(group_list, data_format = "groups")
   ibi_matrix <- get_network(gbi_matrix, data_format = "GBI")
   ibi_matrix <- ibi_matrix[order(rownames(ibi_matrix)) , order(colnames(ibi_matrix))]
   igraph <- graph_from_adjacency_matrix(ibi_matrix, diag = FALSE, weighted = TRUE, mode = "undirected")
   return(igraph)
}

## Using func_igraph on the list of replicates
igraph_objects <- lapply(rep_list_groups, func_igraph)

## Plotting one of the replicates, not very detailed(missing attributes); don't have time to code this rn
plot(igraph_objects[[1]], edge.curved = 0, edge.color = "black", weighted = TRUE,
    layout = layout_nicely(igraph_objects[[1]])) #Not customized 

## Visualizing strength of males vs. females and the two treatments
ggplot(data = attr, aes(y = prox_strength, x = treatment, fill = sex)) + geom_boxplot() 

## Prediction 1 
lm.social <- lm(prox_strength~sex, data=attr)
plot(lm.social)

## Prediction 3 
lm.harass <- lm(matings~prox_strength, data=attr)
plot(lm.harass)


