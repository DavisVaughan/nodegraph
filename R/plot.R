plot.delay_array <- function(x, ...) {

  if (!requireNamespace("DiagrammeR", quietly = TRUE)) {
    abort("The DiagrammeR package is required for plotting.")
  }

  x_node <- get_node(x)
  x_dag <- DAG$new(x_node)

  adj_mat <- x_dag$adjacency_matrix()

  graph <- DiagrammeR::from_adj_matrix(adj_mat, mode = "directed")

  # magic formula for getting these in the right order
  graph$global_attrs$value[graph$global_attrs$attr == "layout"] <- "dot"
  graph$global_attrs <- rbind(
    graph$global_attrs,
    data.frame(attr = "rankdir", value = "LR", attr_type = "graph")
  )

  DiagrammeR::render_graph(graph)
}
