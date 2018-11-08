UnaryOperationNode <- R6Class(
  "UnaryOperationNode",
  inherit = OperationNode,

  public = list(

    # --------------------------------------------------------------------------
    # Initializer

    # `x` could already be a ValueNode or it could be a new R matrix/array
    initialize = function(operation, x, extra_arguments = list(), name = NULL) {

      if (is_missing(x)) {
        abort("`x` must be supplied for a unary operation.")
      }

      super$initialize(operation = operation, x, extra_arguments = extra_arguments, name = name)
    }

  )

)
