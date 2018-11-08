#' @export
compute_common_dim <- function(...) {
  UseMethod("compute_common_dim")
}

# Base R dim computation is just the pmax of all the input dims

#' @export
compute_common_dim.default <- function(arguments) {
  dim_lst <- map_R6(arguments, get_dim)
  eval_bare(expr(pmax(!!!dim_lst)))
}

# register other ways to compute common dimension here
# i.e. broadcasting! different result than base R
