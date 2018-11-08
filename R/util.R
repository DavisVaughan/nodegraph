# generate a random 8-digit hexadecimal string
rhex <- function() {
  paste(as.raw(sample.int(256L, 4, TRUE) - 1L), collapse = "")
}

nodify <- function(x) {
  UseMethod("nodify")
}

nodify.default <- function(x) {
  cls <- class(x)[[1]]
  abort(paste0("Cannot create a node from `x` of class `", cls, "`."))
}

nodify.Node <- function(x) {
  x
}

nodify.numeric <- function(x) {
  ValueNode$new(value = x)
}

get_node <- function(x) {
  attr(x, "node")
}
