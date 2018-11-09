OperationNode <- R6Class(
  "OperationNode",
  inherit = ValueNode,

  public = list(

    # --------------------------------------------------------------------------
    # Initializer

    # `...` could already be a ValueNode or it could be a new R matrix/array

    initialize = function(operation, ..., dim, extra_arguments = list(), name = NULL) {

      if (!is_scalar_character(operation)) {
        abort("`operation` must be a length 1 character")
      }

      if (!is_list(extra_arguments) & !is_named(extra_arguments)) {
        abort("`extra_arguments` must be a named list.")
      }

      # Capture args, make them all nodes, compute result dimension
      arguments <- list2(...)
      arguments <- map(arguments, nodify)

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
    # Compute

    # Recursively perform computation, finalizing values as we go if possible
    # Pass through `self` so we can also pass in `child` later. This is a
    # different "self" and is necessary so compute_engine() is able to work
    # with the correct node

    compute_chain = function(x, self) {

      # Escape
      self_value <- self$get_value()
      if (!is_unknowns(self_value)) {
        return(self_value)
      }

      children <- self$get_children()

      # Compute all children so I can compute myself
      for(child in children) {
        child_value <- child$get_value()
        if (is_unknowns(child_value)) {
          child$compute_chain(x, child)
        }
      }

      # Generic computation engine
      res <- self$compute_engine(x, self)

      # I know myself!
      self$set_value(res)

      invisible(self)
    },

    # External parties define methods for this
    compute_engine = function(x, self) {
      UseMethod("compute_engine")
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
