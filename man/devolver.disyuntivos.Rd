% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mod_carga_datos_utils.R
\name{devolver.disyuntivos}
\alias{devolver.disyuntivos}
\title{Back disjunctive column to original.}
\usage{
devolver.disyuntivos(data, var)
}
\arguments{
\item{data}{a data.frame object.}

\item{var}{the column name that is disyunctive.}
}
\value{
A data.frame object before apply disjunctive code.
}
\description{
Back disjunctive column to original.
}
\examples{
r <- datos.disyuntivos(iris, "Species")
devolver.disyuntivos(r, "Species")

}
\author{
Diego Jimenez <diego.jimenez@promidat.com>
}
