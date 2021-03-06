## setwd("C:/Users/jy33/OneDrive/Desktop/R/bedbugs")
## par(mar=c(4,4,4,4)) # margins too large

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
          filter(Network != "N/A")

rep_list_groups <- split(groups, groups$Network) # creates a list of replicates

## Attribute data
attr <- read.csv("data/bbsna_attributes.csv") %>% 
        filter(network != "N/A") %>% 
        filter(notes != "died")

## Mating matrices 
mating_matrices <- readRDS("mating_matrices.rds") # matrices created in data_cleaning.R
#mating_matrices <- list(mating_matrices[[1]], mating_matrices[[2]])

################# CREATING OBSERVED AGGREGATION NETWORKS ####################

# Using func_igraph on rep_list_groups to create a list of igraph objects (1 per replicate)
igraph_objects <- lapply(rep_list_groups, func_igraph)

## Creates a data frame of node attributes from all networks (will use this for our model)
attr_observed <- func_attr(igraph_objects)
print(attr_observed)

## Visualizing the observed networks
lapply(X = igraph_objects, FUN = func_plot_network)

######################## PREDICTION 1 GLM ##########################
predict1 <- glm(strength~sex + size + treatment + network + block, data=attr_observed, family = Gamma(link="log"))
plot(predict1) 

######################## PREDICTION 1 PERMUTATION ##########################
n_sim_1 <- 999
set.seed(33)
sim_coefs_1 <- numeric(n_sim_1)

for (i in 1:n_sim_1){
  # Creates new igraph objects where the nodes are shuffled
  random_igraphs <- lapply(rep_list_groups, func_permute_igraph)
  # Runs the glm on the new shuffled igraph objects; save coefs
  sim_coefs_1[i] <- func_random_model_p1(random_igraphs) 
}
# Plot histogram 
sim_coefs_1 <- c(sim_coefs_1, coef(predict1)[2])
hist(sim_coefs_1, main = "Prediction 1", xlab = "Coefficient value for sexMale", col = "azure2")
lines(x = c(coef(predict1)[2], coef(predict1)[2]), y = c(0, 270), col = "red", lty = "dashed", lwd = 2) 

# Obtain p-value
if (coef(predict1)[2] >= mean(sim_coefs_1)) {
    pred1_p <- 2*mean(sim_coefs_1 >= coef(predict1)[2]) } else {
    pred1_p <- 2*mean(sim_coefs_1 <= coef(predict1)[2])
}
# Add p-value to histogram
text(x = 0.25, y = 100, "p = 0.05")

################### VISUALIZING MALE VS. FEMALE STRENGTH #################
ggplot(data = attr_observed, aes(y = strength, x = sex, fill = sex)) + geom_boxplot() + 
       theme(text = element_text(size = 20)) + geom_jitter(position=position_jitter(width=.1, height=0)) + 
       scale_fill_manual(values=c("#f0553a", "#4A75D2"))

################# PREDICTION 2: ASSORTATIVITY OF INDIVIDUAL NETWORKS #####################
# Creates the observed ibi matrices for aggregation networks
ibi_matrices <- lapply(X = rep_list_groups, FUN = func_ibi)
# Runs the permutation test (see function 7 in functions.R for more info)
lapply(X = ibi_matrices, FUN = func_permute_assort)

#################### PREDICTION 3 GLM ###################################################
igraphs_mating <- lapply(X = mating_matrices, FUN = func_matrix_to_igraph)
mating_attr <- func_attr(igraphs_mating)
attr_observed_p3 <- attr_observed %>%  # Adds # of matings to our main dataframe
                 left_join(mating_attr, by = c("name", "network", "size", "treatment", "sex", "block")) %>% 
                 filter(sex == "Female")

predict3 <- glm(matings~strength + size + network + treatment + block, data=attr_observed_p3, family = Gamma(link="log"))
plot(predict3) 

##################### PREDICTION 3 PERMUTATION #############################################
n_sim_2 <- 999
set.seed(33)
sim_coefs_3 <- numeric(n_sim_2)

for (i in 1:n_sim_2){
  # Creates new igraph objects where the nodes are shuffled
  random_mating_igraphs <- lapply(mating_matrices, func_permute_igraph_females)
  # Runs the glm on the new shuffled igraph objects; save coefs
  sim_coefs_3[i] <- func_random_model_p3(random_mating_igraphs)
}
# Plot histogram 
sim_coefs_3 <- c(sim_coefs_3, coef(predict3)[2])
hist(sim_coefs_3, main = "Prediction 3", xlab = "Coefficient value for strength", 
     ylim = c(0, 150), breaks = 25, col = "azure2")
lines(x = c(coef(predict3)[2], coef(predict3)[2]), y = c(0, 220), col = "red", lty = "dashed", lwd = 2) 

# Obtain p-value
if (coef(predict3)[2] >= mean(sim_coefs_3)) {
  pred3_p <- 2*mean(sim_coefs_3 >= coef(predict3)[2]) } else {
    pred3_p <- 2*mean(sim_coefs_3 <= coef(predict3)[2])
  }
# Add p-value to histogram
text(x = 0.15, y = 100, "p = 0.87")

################### VISUALIZING MATINGS ~ STRENGTH #################
ggplot(data = attr_observed_p3, aes(y = matings, x = strength, col = treatment)) + geom_smooth(method = "lm", se = FALSE) + 
  theme(text = element_text(size = 20)) + geom_point() + facet_grid(rows = vars(treatment)) + 
  scale_color_manual(values = c("navyblue", "darkorange"))

##################### PREDICTION 4 GLM ##########################

predict4.p1 <- glm(strength~sex*treatment + size + network + block, data=attr_observed, family = Gamma(link="log"))
plot(predict4.p1)


predict4.p3 <- glm(matings~strength*treatment + size + network + block, data=attr_observed_p3, family = Gamma(link="log"))
plot(predict4.p3)

