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
  strength <- strength(igraph)
  igraph <- set_vertex_attr(igraph, "strength", value = strength)
  V(igraph)$color <- ifelse(V(igraph)$sex == "Female", "red", "blue")
  V(igraph)$label.color <- "white"
  E(igraph)$width <- E(igraph)$weight
  return(igraph)
}

## FUNCTION 2: Runs permutations for effect of strength (prediction 1)
func_permute_strength <- function(igraph_objects){
  ## Calculating observed coef for effect of strength
  observed_strength <- as.data.frame(cbind(strength = strength(igraph_object, v = V(igraph_object), mode = c("all"), loops = FALSE), 
                                           sex = V(igraph_object)$sex))

  }




