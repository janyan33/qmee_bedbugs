## R-script for all functions created

## FUNCTION 1: Turns raw data from bbsna_aggregations into igraph objects (one per replicate)
func_igraph <- function(rep_groups){
  group_list <- strsplit(rep_groups$Members, " ")
  gbi_matrix <- get_group_by_individual(group_list, data_format = "groups")
  ibi_matrix <- get_network(gbi_matrix, data_format = "GBI")
  ibi_matrix <- ibi_matrix[order(rownames(ibi_matrix)) , order(colnames(ibi_matrix))] # alphabetical order
  igraph <- graph_from_adjacency_matrix(ibi_matrix, diag = FALSE, weighted = TRUE, mode = "undirected")
  igraph <- set_vertex_attr(igraph, "sex", 
                            value = ifelse(V(igraph)$name %in% LETTERS[1:12], "Male", "Female"))
  strength <- strength(igraph)
  igraph <- set_vertex_attr(igraph, "strength", value = strength)
  return(igraph)
}

## FUNCTION 2: Assigns additional attributes (size, replicate, treatment) to each node on each igraph object
# Input: Takes a lists of igraph objects
# Ourput: Creates a dataframe of node attributes
func_attr <- function(igraph_objects){
  new_attr <- data.frame()
  for (i in 1:length(igraph_objects)){
    attr_i <- subset(attr, replicate == i & notes != "died")
    igraph_objects[[i]] <- set_vertex_attr(igraph_objects[[i]], "size", value = attr_i$thorax.mm)
    igraph_objects[[i]] <- set_vertex_attr(igraph_objects[[i]], "treatment", value = attr_i$treatment)
    igraph_objects[[i]] <- set_vertex_attr(igraph_objects[[i]], "replicate", value = attr_i$replicate)
    new_attr <- rbind(new_attr, vertex_attr(igraph_objects[[i]]))
  }
  return(new_attr)
}

## FUNCTION 3: Visualizing the social networks (this is useful for detecting errors in other parts of the code)
# Input: An igraph object
# Output: The SNA graph where size = strength*10
func_plot_network <- function(igraph_object){
  V(igraph_object)$color <- ifelse(V(igraph_object)$sex == "Female", "red", "blue")
  V(igraph_object)$size <- V(igraph_object)$strength*10
  V(igraph_object)$label.color <- "white"
  E(igraph_object)$width <- E(igraph_object)$weight
  plot(igraph_object, edge.color = "dimgrey")
}

## FUNCTION 4: Shuffle node labels
# Input: aggregations raw data
# Output: igraph objects with nodes randomized and sexes assigned
func_permute_igraph <- function(rep_list_group) { 
  group_list <- strsplit(rep_list_group$Members, " ")
  gbi_matrix <- get_group_by_individual(group_list, data_format = "groups")
  ibi_matrix <- get_network(gbi_matrix, data_format = "GBI")
  #shuffle names 
  new_names <- sample(colnames(ibi_matrix))
  colnames(ibi_matrix) <- new_names
  rownames(ibi_matrix) <- new_names
 
  igraph <- graph_from_adjacency_matrix(ibi_matrix, diag = FALSE, weighted = TRUE, mode = "undirected")
  igraph <- set_vertex_attr(igraph, "sex", 
                            value = ifelse(V(igraph)$name %in% LETTERS[1:12], "Male", "Female"))
  strength <- strength(igraph)
  igraph <- set_vertex_attr(igraph, "strength", value = strength)
  return(igraph)
}  

## FUNCTION 5: Assigns the rest of the node attributes to the randomized nodes using left_join; runs the glm
# Input: a list of randomized igraph objects
# Steps: creates a dataframe combining the attributes from the different igraph objects
       # then runs the glm using this new dataframe 
# Output: the coefficient from the glm for effect of sex on strength
func_sim_attr <- function(random_igraphs){
  sim_attr <- data.frame()
  for (i in 1:length(random_igraphs)){
      attr_i <- attr %>% 
      filter(replicate == i) %>% 
      rename("name" = "ID") %>% 
      select(c("name", "thorax.mm", "replicate", "treatment"))
      new_attr <- as.data.frame(vertex_attr(random_igraphs[[i]])) %>% 
      left_join(attr_i, by = "name")
      sim_attr <- rbind(sim_attr, new_attr)
  }
  sim_model <- glm(strength ~ sex + thorax.mm + (thorax.mm)^2 + replicate, data=sim_attr, family = Gamma(link="log"))
  return(coef(sim_model)[2])
}




