Node <- R6Class(
  "Node",

  # Public
  public = list(

    # --------------------------------------------------------------------------
    # Initializer
    initialize = function(name = NULL) {

      if (is.null(name)) {
        name <- private$generate_unique_name()
      }

      self$set_name(name)
    },

    # --------------------------------------------------------------------------
    # Name
    get_name = function() {
      private$name
    },

    set_name = function(name) {
      private$validate_name(name)
      private$name <- name
    },

    # --------------------------------------------------------------------------
    # Parents
    get_parents = function() {
      private$parents
    },

    get_parent = function(id) {
      private$parents[[id]]
    },

    add_parent = function(node) {
      validate_Node(node)
      private$parents <- c(private$parents, node)
      invisible(self)
    },

    # --------------------------------------------------------------------------
    # Children
    get_children = function() {
      private$children
    },

    get_child = function(id) {
      private$children[[id]]
    },

    add_child = function(node) {
      validate_Node(node)
      private$children <- c(private$children, node)
      node$add_parent(self)
      invisible(self)
    }

  ),

  # Private
  private = list(

    # --------------------------------------------------------------------------
    # Private variables
    name = "",
    parents = list(),
    children = list(),

    # --------------------------------------------------------------------------
    # Private helpers
    generate_unique_name = function() {
      paste0("node_", rhex())
    },

    validate_name = function(name) {
      if (! is_scalar_character(name)) {
        abort("`name` must be a length 1 character.")
      }
    }

  )
)

is_Node <- function(x) {
  inherits(x, "Node")
}

validate_Node = function(node) {
  if (! is_Node(node)) {
    abort("`node` must be a Node object.")
  }
}
