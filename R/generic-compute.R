#' @export
compute <- function(x) {
  x_node <- get_node(x)
  x_node$compute_chain(x, x_node)
  x
}

#' @export
compute_engine.delay_array <- function(x, self) {
  children_values <- map_R6(self$get_children(), get_value)
  op_fun <- getExportedValue("base", self$get_operation())
  res <- do.call(op_fun, c(children_values, self$get_extra_arguments()))
  res
}
