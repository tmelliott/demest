% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/SpecPrior-generators.R
\name{TDist}
\alias{TDist}
\title{Specify a vector of independent t-distributed variables}
\usage{
TDist(df = 7, mean = 0, scale = NULL, mult = 1)
}
\arguments{
\item{df}{Degrees of freedom. A vector with length equal to
1 or to the number of variables required. Defaults to 4.}

\item{mean}{Mean parameter. A vector with length equal to 1
or to the number of variables required. Defaults to 0.}

\item{scale}{Scale parameter.  A vector with length equal to
1 or to the number of variables required. Defaults to 1.}

\item{mult}{Multiplier applied to \code{scale}, if \code{sd}
is generated automatically.  Defaults to 1.}
}
\value{
Object of class \code{\linkS4class{TDist}}.
}
\description{
Specify a vector of \code{n} t-distributed variables, each
of which has degrees of freedom \code{df[i]},
mean \code{mean[i]}, and scale \code{scale[i]}.
}
\examples{
TDist()
TDist(mean = c(-1, 0, 0))
TDist(df = c(4, 4, 7),
      mean = c(-1, 0.2, 0.1),
      scale = c(1, 2, 1))
}
\seealso{
\code{\link{Covariates}}
}
