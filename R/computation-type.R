#' @export
set_computation_type <- function(type = "lazy") {

  if (!(type %in% c("lazy", "eager"))) {
    abort(paste0("`type` must be either `'lazy'` or `'eager'` not: ", type))
  }

  options(nodegraph.computation_type = type)
}

#' @export
get_computation_type <- function() {
  getOption("nodegraph.computation_type", default = "lazy")
}
