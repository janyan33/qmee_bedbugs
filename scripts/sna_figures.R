library(igraph)
library(assortnet)
library(tidyverse)
source("igraphhack/igraphplot2.R")
environment(plot.igraph2) <- asNamespace('igraph')
environment(igraph.Arrows2) <- asNamespace('igraph')

## Loading matrices in
mount_matrices <- readRDS("mount_matrices.rds")
mating_matrices <- readRDS("mating_matrices.rds")

## Loading attribute data in
attr_3 <- read.csv("data/bbsna_attributes.csv", stringsAsFactors = FALSE) %>% 
          filter(replicate == 3) %>% 
          filter(notes != "died")

## Create igraph object 
mating_3 <- graph_from_adjacency_matrix(mating_matrices[[3]], diag = FALSE, weighted = TRUE, mode = "directed")

## Assign attributes
mating_3 <- set_vertex_attr(mating_3, "sex", value = attr_3$sex)
strength_mating_3 <- strength(mating_3, v = V(mating_3), mode = c("all"), loops = F)
mating_3 <- set_vertex_attr(mating_3, "strength", value = (strength_mating_3))

V(mating_3)$size <- V(mating_3)$strength*3.5
E(mating_3)$width <- E(mating_3)$weight

V(mating_3)$color <- ifelse(V(mating_3)$sex == "Female", "red", "blue")
V(mating_3)$label.color <- "white"

## Plot network
plot(mating_3, edge.curved = 0, edge.color = "black", weighted = TRUE, layout = layout.lgl(mating_3), 
     edge.arrow.size = 0.5)

## MOUNTING NETWORK

## Create igraph object 
mount_3 <- graph_from_adjacency_matrix(mount_matrices[[3]], diag = FALSE, weighted = TRUE, mode = "directed")

## Assign attributes
mount_3 <- set_vertex_attr(mount_3, "sex", value = attr_3$sex)
strength_mount_3 <- strength(mount_3, v = V(mount_3), mode = c("all"), loops = F)
mount_3 <- set_vertex_attr(mount_3, "strength", value = (strength_mount_3))

V(mount_3)$size <- V(mount_3)$strength
E(mount_3)$width <- E(mount_3)$weight

V(mount_3)$color <- ifelse(V(mount_3)$sex == "Female", "red", "blue")
V(mount_3)$label.color <- "white"

## Plot network
plot(mount_3, edge.curved = 0, edge.color = "black", weighted = TRUE, layout = layout.lgl(mount_3), 
     edge.arrow.size = 0.5)


