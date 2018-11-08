#' @export
#' @method vec_arith delay_array
#' @export vec_arith.delay_array
vec_arith.delay_array <- function(op, x, y) {
  UseMethod("vec_arith.delay_array", y)
}

#' @method vec_arith.delay_array double
#' @export
vec_arith.delay_array.default <- function(op, x, y) {
  stop_incompatible_op(op, x, y)
}

#' @method vec_arith.delay_array delay_array
#' @export
vec_arith.delay_array.delay_array <- function(op, x, y) {
  switch(
    op,
    "+" = ,
    "-" = ,
    "/" = ,
    "*" = op_binary(op, get_node(x), get_node(y))
  )
}

op_binary <- function(operation, x, y) {
  res <- BinaryOperationNode$new(operation = operation, x = x, y = y)
  delay_array(res)
}

op_unary <- function(operation, x, y) {
  res <- UnaryOperationNode$new(operation = operation, x = x)
  delay_array(res)
}
