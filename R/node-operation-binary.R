BinaryOperationNode <- R6Class(
  "BinaryOperationNode",
  inherit = OperationNode,

  public = list(

    # --------------------------------------------------------------------------
    # Initializer

    # `x` could already be a ValueNode or it could be a new R matrix/array
    initialize = function(operation, x, y, extra_arguments = list(), name = NULL) {

      if (is_missing(x)) {
        abort("`x` must be supplied for a binary operation.")
      }

      if (is_missing(y)) {
        abort("`y` must be supplied for a binary operation.")
      }

      super$initialize(
        operation = operation,
        x,
        y,
        extra_arguments = extra_arguments,
        name = name
      )
    }

  )

)

