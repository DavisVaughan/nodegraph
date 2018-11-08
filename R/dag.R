DAG <- R6Class("DAG",
  public = list(

    # --------------------------------------------------------------------------
    # Initializer
    initialize = function(...) {

      nodes <- list(...)
      lapply(nodes, validate_Node)

      private$construct_dag(nodes)

    },

    # --------------------------------------------------------------------------
    # Node getters
    get_nodes = function() {
      private$nodes
    },

    get_node = function(name) {
      private$nodes[[name]]
    },

    # --------------------------------------------------------------------------
    # Node adders
    add_node = function(node) {

      # Only add node if it does not exist
      nm <- node$get_name()
      already_exists <- nm %in% names(self$nodes)

      # Add as a named element to the list
      if (! already_exists) {
        private$nodes[[nm]] <- node
      }

      invisible(self)
    },

    # adds nodes recursively to add entire family
    add_family = function(node) {

      nm <- node$get_name()
      already_exists <- nm %in% names(private$nodes)

      if (!already_exists) {

        # add node to dag
        self$add_node(node)

        # find immediate family (not including node itself)
        family <- c(node$get_parents(), node$get_children())

        # get and assign their names
        family_names <- map_chr_R6(family, get_name)
        names(family) <- family_names

        # find the unregistered ones (not required but results in less loops)
        registered_lgl <- family_names %in% names(private$nodes)
        unregistered <- family[!registered_lgl]

        # add them to the node list
        for (relative in unregistered)
          self$add_family(relative)
      }

      invisible(self)
    },

    # --------------------------------------------------------------------------
    # Node utilities
    count_nodes = function() {
      length(private$nodes)
    },

    # --------------------------------------------------------------------------
    # Adjacency matrix builder
    adjacency_matrix = function() {

      nodes <- private$nodes

      n_nodes <- length(nodes)
      node_names <- names(nodes)

      dag_mat <- matrix(
        data = 0L,
        nrow = n_nodes,
        ncol = n_nodes,
        dimnames = list(node_names, node_names)
      )

      # Children are in the top left
      # Directed adjacency matrix - build by stepping through children
      # and marking any children of the current node with a 1 in that row
      # Row = from, Col = to
      for(node in nodes) {

        node_nm <- node$get_name()
        children <- node$get_children()
        children_nms <- map_R6(children, get_name)

        for(child_nm in children_nms) {
          dag_mat[[node_nm, child_nm]] <- 1L
        }

      }

      dag_mat
    }

  ),

  private = list(

    # --------------------------------------------------------------------------
    # Private members
    nodes = list(),

    # --------------------------------------------------------------------------
    # Private helpers
    construct_dag = function(nodes) {
      lapply(nodes, self$add_family)
    }

  )
)
