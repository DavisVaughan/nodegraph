#' @export
#' @method vec_arith delay_array
#' @export vec_arith.delay_array
vec_arith.delay_array <- function(op, x, y) {
  UseMethod("vec_arith.delay_array", y)
}

#' @method vec_arith.delay_array default
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
    "*" = op_binary(op, x, y)
  )
}

#' @method vec_arith.delay_array numeric
#' @export
vec_arith.delay_array.numeric <- function(op, x, y) {
  y <- as_delay_array(y)
  vec_arith(op, x, y)
}

#' @method vec_arith.numeric delay_array
#' @export
vec_arith.numeric.delay_array <- function(op, x, y) {
  x <- as_delay_array(x)
  vec_arith(op, x, y)
}

#' @method vec_arith.delay_array MISSING
#' @export
vec_arith.delay_array.MISSING <- function(op, x, y) {
  switch(op,
         `-` = ,
         `+` = op_unary(op, x),
         stop_incompatible_op(op, x, y)
  )
}

op_binary <- function(operation, x, y) {
  restore_type <- vec_type2(x, y)

  # We don't know the result, but we can predict the shape
  dim <- compute_common_dim(operation, x, y)

  res <- BinaryOperationNode$new(
    operation = operation,
    x = get_node(x),
    y = get_node(y),
    dim = dim
  )

  vec_restore(res, restore_type)
}

op_unary <- function(operation, x) {
  res <- UnaryOperationNode$new(operation = operation, x = get_node(x))
  vec_restore(res, x)
}
