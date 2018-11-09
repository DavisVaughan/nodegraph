#' @export
vec_restore.delay_array <- function(x, to) {
  as_delay_array(x)
}

# vec_type2 boilerplate --------------------------------------------------------

#' @export
#' @method vec_type2 delay_array
#' @export vec_type2.delay_array
vec_type2.delay_array <- function(x, y) UseMethod("vec_type2.delay_array")

#' @method vec_type2.delay_array default
#' @export
vec_type2.delay_array.default <- function(x, y) stop_incompatible_type(x, y)

#' @method vec_type2.delay_array vctrs_unspecified
#' @export
vec_type2.delay_array.vctrs_unspecified <- function(x, y) x

# vec_type2 delay_array <-> delay_array ------------------------------------------

#' @method vec_type2.delay_array delay_array
#' @export
vec_type2.delay_array.delay_array <- function(x, y) {
  new_delay_array()
}

# vec_type2 delay_array <-> double/matrix/array ---------------------------------

#' @method vec_type2.delay_array double
#' @export
vec_type2.delay_array.double <- vec_type2.delay_array.delay_array

#' @method vec_type2.double delay_array
#' @export
vec_type2.double.delay_array <- vec_type2.delay_array.delay_array

# vec_type2 delay_array <-> integer/matrix/array --------------------------------

#' @method vec_type2.delay_array integer
#' @export
vec_type2.delay_array.integer <- vec_type2.delay_array.delay_array

#' @method vec_type2.integer delay_array
#' @export
vec_type2.integer.delay_array <- vec_type2.delay_array.delay_array
