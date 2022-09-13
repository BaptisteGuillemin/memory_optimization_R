compte_impair_vectoriel <- function(x) {sum(x %% 2 == 1)}

compte_impair_boucle <- function(x) {
  k <- 0
  for (n in x) {
    if (n %% 2 == 1) { k <- k + 1}
  }
  k
}

obs <- round(runif(1000000, -10, 10))

library(bench)

sortie_mark <- mark(
  vectoriel = compte_impair_vectoriel(obs), 
  boucle = compte_impair_boucle(obs)
)

#' @title Impression simplifiée d'une sortie de bench::mark
#' @description Conserve six éléments et imprime sous forme de data frame
#' @param x sortie produite par bench::mark

print_bench_mark <- function(x){
  if (!inherits(x, what = "bench_mark")) {
    stop("'x' n'est pas une sortie de bench::mark")
  }
  df <- data.frame(
    expression = as.character(x$expression),
    n_itr = x$n_itr,
    min = if (inherits(x$min, "bench_time")) as.character(x$min) else x$min,
    median = if (inherits(x$min, "bench_time")) as.character(x$median) else x$median,
    mem_alloc = as.character(x$mem_alloc),
    n_gc = x$n_gc,
    stringsAsFactors = FALSE
  )
  print(df)
  invisible(df)
}

print_bench_mark(sortie_mark)