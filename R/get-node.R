#' @export
get_node <- function(x) {
  UseMethod("get_node")
}

#' @export
get_node.delay_array <- function(x) {
  attr(x, "node")
}

#' @export
get_node.Node <- function(x) {
  x
}
