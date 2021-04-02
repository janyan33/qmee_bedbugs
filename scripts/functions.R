## R-script for all functions created

## FUNCTION 1: Turns raw data from bbsna_aggregations into igraph objects (one per replicate)
#JY: I tried very hard to avoid listing all the letters using stuff like LETTERS[A:L] but couldn't get it to work :(
func_igraph <- function(rep_groups){
  group_list <- strsplit(rep_groups$Members, " ")
  gbi_matrix <- get_group_by_individual(group_list, data_format = "groups")
  ibi_matrix <- get_network(gbi_matrix, data_format = "GBI")
  ibi_matrix <- ibi_matrix[order(rownames(ibi_matrix)) , order(colnames(ibi_matrix))] # alphabetical order
  igraph <- graph_from_adjacency_matrix(ibi_matrix, diag = FALSE, weighted = TRUE, mode = "undirected")
  igraph <- set_vertex_attr(igraph, "sex", 
                            value = ifelse(V(igraph)$name == c("A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L"), "Male", "Female"))
  V(igraph)$color <- ifelse(V(igraph)$sex == "Female", "red", "blue")
  V(igraph)$label.color <- "white"
  return(igraph)
}

## FUNCTION 2: Runs permutations for effect of strength 
func_permute_strength <- function(igraph_object){
  ## Calculating observed coef for effect of strength
  observed_strength <- as.data.frame(cbind(strength = strength(igraph_object, v = V(igraph_object), mode = c("all"), loops = FALSE), 
                                           sex = V(igraph_object)$sex))
  obs_model <- lm(data = observed_strength, strength ~ sex)
  obs_coef <- coef(obs_model)[2]
  ## Setting up for permutations
  nsim <- 999
  sim_coefs <- numeric(nsim)
  ## Shuffle network 999 times
  for(i in 1:nsim){
  sim_igraph <- permute(igraph_object, sample(vcount(igraph_object)))
  new_strength <- as.data.frame(cbind(strength = strength(sim_igraph, v = V(sim_igraph), mode = c("all"), loops = FALSE), 
                                                           sex = V(sim_igraph)$sex))
    
  new_model <- lm(data = new_strength, strength ~ sex)
  sim_coef <- coef(new_model)[2]
  
  sim_coefs[i] <- sim_coef
  }
  strength_results <- c(obs_coef, sim_coefs)
  strength_results
}