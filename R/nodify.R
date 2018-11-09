#' @export
nodify <- function(x) {
  UseMethod("nodify")
}

#' @export
nodify.default <- function(x) {
  cls <- class(x)[[1]]
  abort(paste0("Cannot create a node from `x` of class `", cls, "`."))
}

#' @export
nodify.Node <- function(x) {
  x
}

#' @export
nodify.numeric <- function(x) {
  ValueNode$new(value = x)
}
