## setwd("C:/Users/jy33/OneDrive/Desktop/R/bedbugs")

library(tidyverse)
library(data.table)

all_data <- read.csv("data/raw/bbsna_raw_combined.csv")

# sort(unique(all_data$behaviour)) ## Use to get misspelled behaviours to update patch_table.csv

## Fixing mispelled behaviours
patch_table <- read.csv("patch_table.csv")

patch <- all_data %>% 
          left_join(patch_table, by = "behaviour")

all_data <- patch %>% 
        mutate(behaviour = ifelse(is.na(patch_behaviour), behaviour, as.character(patch_behaviour))) %>% 
        select(-patch_behaviour)

## Adding columns that convert the numeric IDs to letter based IDs 
id_key_focal <- read.csv("ID_key_focal.csv")
id_key_partner <- read.csv("ID_key_partner.csv")

all_data <- all_data %>% 
            left_join(id_key_focal, by = "focal_individual") %>% 
            left_join(id_key_partner, by = "social_partner")





