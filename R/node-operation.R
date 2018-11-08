OperationNode <- R6Class(
  "OperationNode",
  inherit = ValueNode,

  public = list(

    # --------------------------------------------------------------------------
    # Initializer

    # `...` could already be a ValueNode or it could be a new R matrix/array

    initialize = function(operation, ..., extra_arguments = list(), name = NULL) {

      if (!is_scalar_character(operation)) {
        abort("`operation` must be a length 1 character")
      }

      if (!is_list(extra_arguments) & !is_named(extra_arguments)) {
        abort("`extra_arguments` must be a named list.")
      }

      # Capture args, make them all nodes, compute result dimension
      arguments <- list2(...)
      arguments <- map(arguments, nodify)

      # We don't know the result, but we can predict the shape
      dim <- compute_common_dim(arguments)

      map(arguments, self$set_argument)

      private$operation <- operation
      private$extra_arguments <- private$extra_arguments

      super$initialize(dim = dim, name = name)
    },

    # --------------------------------------------------------------------------
    # Initializer
    print = function(...) {
      inject <- paste0("Operation: ", self$get_operation())
      super$print(node_type = "OperationNode", inject = inject)
    },

    # --------------------------------------------------------------------------
    # Operation
    get_operation = function() {
      private$operation
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
