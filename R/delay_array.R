new_delay_array <- function(.data = numeric(), node, ..., subclass = character()) {

  if (is_missing(node)) {
    node <- ValueNode$new(.data)
  }

  new_vctr(.data = .data, node = node, ..., class = c(subclass, "delay_array"))
}

#' @export
delay_array <- function(x = numeric()) {
  as_delay_array(x)
}

#' @export
as_delay_array <- function(x) {
  UseMethod("as_delay_array")
}

#' @export
as_delay_array.default <- function(x) {
  abort("Unknown input type. Cannot coerce to a delay_array.")
}

#' @export
as_delay_array.delay_array <- function(x) {
  x
}

#' @export
as_delay_array.numeric <- function(x) {
  as_delay_array(ValueNode$new(value = x))
}

#' @export
as_delay_array.logical <- function(x) {
  as_delay_array(ValueNode$new(value = x))
}

#' @export
as_delay_array.ValueNode <- function(x) {
  new_delay_array(
    .data = NA, # mock something being here for vctrs
    node = x
  )
}

#' @export
print.delay_array <- function(x, ...) {
  node <- get_node(x)
  cat("<delay_array>")
  cat("\n")
  print(node$get_value(), ...)
}

