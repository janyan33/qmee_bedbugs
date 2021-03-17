## setwd("C:/Users/jy33/OneDrive/Desktop/R/bedbugs")

library(tidyverse)
library(data.table)
library(netdiffuseR)

all_data <- read.csv("data/bbsna_raw_combined.csv")

# sort(unique(all_data$behaviour)) ## Use to get misspelled behaviours to update patch_table.csv

## Fixing mispelled behaviours
patch_table <- read.csv("extra/patch_table.csv")

patch <- all_data %>% 
          left_join(patch_table, by = "behaviour")

all_data <- patch %>% 
        mutate(behaviour = ifelse(is.na(patch_behaviour), behaviour, as.character(patch_behaviour))) %>% 
        select(-patch_behaviour)

## Adding columns that convert the numeric IDs to letter based IDs 
id_key_focal <- read.csv("extra/ID_key_focal.csv")
id_key_partner <- read.csv("extra/ID_key_partner.csv")

all_data <- all_data %>% 
            left_join(id_key_focal, by = "focal_individual") %>% 
            left_join(id_key_partner, by = "social_partner")

## Getting edgelists from my combined dataset
mount_1_edgelist <- all_data %>% 
                    filter(replicate == 1) %>% 
                    filter(behaviour == "mount") %>% 
                    select(c(focal_ID, partner_ID)) %>% 
                    mutate(edge_weight = 1)
mount_1_edgelist <- aggregate(data = mount_1_edgelist, edge_weight ~ focal_ID + partner_ID, FUN = sum)

mount_mat_1 <- as.matrix(edgelist_to_adjmat(mount_1_edgelist[1:2], 
                                  w = mount_1_edgelist$edge_weight, undirected = FALSE))





