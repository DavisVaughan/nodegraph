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

    # adds nodes recursively to add entire dependency chain
    add_node_and_dependencies = function(node) {

      nm <- node$get_name()
      already_exists <- nm %in% names(private$nodes)

      if (!already_exists) {

        # add node to dag
        self$add_node(node)

        # find immediate family (not including node itself)
        children <- node$get_children()

        # get and assign their names
        children_names <- map_chr_R6(children, get_name)
        names(children) <- children_names

        # find the unregistered ones (not required but results in less loops)
        registered_lgl <- children_names %in% names(private$nodes)
        unregistered <- children[!registered_lgl]

        # add them to the node list
        for (child in unregistered)
          self$add_node_and_dependencies(child)
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

      # Children are in the bottom left
      # Directed adjacency matrix - build by stepping through nodes
      # and marking any children of the current node with a 1 in that row
      # Row = from, Col = to
      # Arrows are drawn FROM child TO parent
      for(node in nodes) {

        node_nm <- node$get_name()

        children <- node$get_children()
        children_nms <- map_chr_R6(children, get_name)

        # FROM child TO parent
        # [FROM, TO]
        dag_mat[children_nms, node_nm] <- 1L

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
      lapply(nodes, self$add_node_and_dependencies)
    }

  )
)
