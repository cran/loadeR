########################### echarts4r #########################################

get_data <- function (e, serie, i = 1) {
  e$x$data[[i]][, 2] |> unname()
}

get_outliers <- function (e, serie, i) {
  x <- get_data(e, serie, i)
  boxplot.stats(x)$out
}

build_boxplot <- function (e, serie, i) {
  x <- get_data(e, serie, i)
  boxplot.stats(x)$stats
}

name_it <- function (e, serie, name, i) {
  if (is.null(name)) {
    if (!is.null(names(e$x$data)[i])) {
      nm <- names(e$x$data)[i]
    } else {
      nm <- serie
    }
  } else {
    nm <- name
  }
  return(nm)
}
