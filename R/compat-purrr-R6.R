R6_mold <- function(.x, .f_nm, map_nm, ...) {
  map_fn <- get(map_nm)
  map_fn(.x, function(x) {
    fn <- get(.f_nm, envir = x)
    fn(...)
  })
}

map_R6 <- function(.x, .f, ...) {
  .f <- expr_name(ensym(.f))
  R6_mold(.x, .f, "map", ...)
}

map_chr_R6 <- function(.x, .f, ...) {
  .f <- expr_name(ensym(.f))
  R6_mold(.x, .f, "map_chr", ...)
}
