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

## Creating a function that turns data into edgelists and then into interaction matrices
func_mount_mat <- function(all_data, behav) {
                  all_data <- all_data %>% 
                              filter(behaviour == behav) %>% 
                              select(c(focal_ID, partner_ID)) %>% 
                              mutate(edge_weight = 1)
                  mount_edgelist <- aggregate(data = all_data, edge_weight ~ focal_ID + partner_ID, FUN = sum)
                  mount_matrix <- edgelist_to_adjmat(mount_edgelist[1:2], w = mount_edgelist$edge_weight, 
                                                     undirected = FALSE)
return(as.matrix(mount_matrix))
}

## Applying function to all replicates and storing matrices as a list object
rep_list <- split(all_data, all_data$network)
mount_matrices <- lapply(rep_list, func_mount_mat, "mount") # Creates list of mounting matrices
mating_matrices <- lapply(rep_list, func_mount_mat, "mating") # Creates list of mating matrices

mount_matrices[[1]] <- mount_matrices[[1]][-17, -17]
mating_matrices[[1]] <- mating_matrices[[1]][-17, -17]

saveRDS(mount_matrices, "mount_matrices.rds")
saveRDS(mating_matrices, "mating_matrices.rds")






