compute_common_dim <- function(operation, ...) {
  delay_args <- list(...)
  common_type <- reduce(delay_args, vec_type2)
  compute_dim_engine(common_type, operation, ...)
}

#' @export
compute_dim_engine <- function(type, operation, ...) {
  UseMethod("compute_dim_engine")
}

# Default uses R semantics

#' @export
compute_dim_engine.delay_array <- function(type, operation, ...) {
  delay_args <- list(...)
  nodes <- map(delay_args, get_node)
  dim_lst <- map_R6(nodes, get_dim)

  # if broadcasting was allowed?
  #eval_bare(expr(pmax(!!!dim_lst)))

  # the only one this doesn't apply for is %*% with base R
  # that requires dim2[2]==dim1[1] for matrices
  ok <- all(map2_lgl(dim_lst[1], dim_lst, identical))

  if (!ok) {
    abort("All arguments must have the same dimensions.")
  }

  dim_lst[[1]]
}
