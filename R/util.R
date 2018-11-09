# generate a random 8-digit hexadecimal string
rhex <- function() {
  paste(as.raw(sample.int(256L, 4, TRUE) - 1L), collapse = "")
}
