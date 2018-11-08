UnaryOperationNode <- R6Class(
  "UnaryOperationNode",
  inherit = ValueNode,

  public = list(

    # --------------------------------------------------------------------------
    # Initializer

    # `argument` could already be a ValueNode or it could be a new R matrix/array

    initialize = function(operation, argument, extra_arguments = list(), name = NULL) {

      if (!is_scalar_character(operation)) {
        abort("`operation` must be a length 1 character")
      }

      if (!is_list(extra_arguments) & !is_named(extra_arguments)) {
        abort("`extra_arguments` must be a named list.")
      }

      argument <- nodify(argument)

      # Dim of value is dim of the argument for unary operations
      dim <- argument$get_dim()

      self$set_argument(argument)
      private$operation <- operation
      private$extra_arguments <- private$extra_arguments

      # Unknown value, but we know the shape
      super$initialize(dim = dim, name = name)
    },

    # --------------------------------------------------------------------------
    # Operation
    get_operation = function() {
      private$operation
    },

    get_argument = function() {
      private$argument
    },

    set_argument = function(argument) {
      self$add_child(argument)
    },

    get_extra_arguments = function() {
      private$extra_arguments
    }

  ),

  private = list(

    operation = NA_character_,
    extra_arguments = list()

  )
)
