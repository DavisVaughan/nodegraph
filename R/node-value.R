ValueNode <- R6Class(
  "ValueNode",
  inherit = Node,

  # Public
  public = list(

    # --------------------------------------------------------------------------
    # Initializer
    initialize = function(value = NULL, dim = NULL, name = NULL) {

      if (!is.null(value)) {
        value <- private$validate_at_least_2D(value)
      }

      if (is.null(dim)) {
        if (is.null(value)) {
          dim <- c(1L, 1L)
        } else {
          dim <- vec_dim(value)
        }
      }

      dim <- private$validate_integer_dim(dim)

      if (is.null(value)) {
        value <- unknowns(dim = dim)
      }

      private$validate_dim_value_structure(dim, value)

      self$set_value(value)
      super$initialize(name)
    },

    # --------------------------------------------------------------------------
    # Printing
    print = function(node_type, inject, ...) {

      if (is_missing(node_type)) {
        node_type <- "ValueNode"
      }

      node_type <- paste0("<", node_type, ">")
      cat(node_type, "\n")

      if (!is_missing(inject)) {
        cat(inject)
        cat("\n")
      }

      print(self$get_value())
    },

    # --------------------------------------------------------------------------
    # Compute

    # Value nodes already know their result

    compute_chain = function(x, self) {
      x
    },

    # --------------------------------------------------------------------------
    # Dim getter / setter
    get_dim = function() {
      vec_dim(private$value)
    },

    # no need for set_dim(), it is intertwined with value and can be computed
    # but never set

    # --------------------------------------------------------------------------
    # Value getter / setter
    get_value = function() {
      private$value
    },

    set_value = function(value) {
      value <- private$validate_at_least_2D(value)
      private$value <- value
      invisible(self)
    }

  ),

  # Private
  private = list(

    # --------------------------------------------------------------------------
    # Private variables
    value = NULL,

    # --------------------------------------------------------------------------
    # Private validation helpers
    validate_dim_value_structure = function(dim, value) {
      value_dim <- dim(value)
      if (!identical(value_dim, dim)) {
        abort("`dim` and `value` must have the same dimensions.")
      }
    },

    validate_integer_dim = function(dim) {
      if (is_integerish(dim)) {
        dim <- as_integer(dim)
      } else {
        abort("`dim` must be an integer-ish vector")
      }
      dim
    },

    validate_at_least_2D = function(value) {
      value <- as.array(value)

      if (vec_dims(value) == 1L) {
        dim(value) <- c(dim(value), 1L)
      }

      value
    }

  )
)
