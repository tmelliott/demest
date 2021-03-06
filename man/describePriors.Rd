% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/query-functions.R
\name{describePriors}
\alias{describePriors}
\title{Text decription of priors}
\usage{
describePriors(filename)
}
\arguments{
\item{filename}{The filename used by the estimate function.}
}
\value{
If \code{filename} refers to the results from a
call to \code{\link{estimateModel}}, then \code{describePriors}
returns a single data.frame. Otherwise, it returns a named
list containing one or more data.frames.
}
\description{
Generate data.frames giving, for each main effect or
interaction in a model, a short description of the
associated prior. The data.frames are useful for
understanding a model, or for generating tables in
documents describing the analyses.
}
\details{
\code{describePriors} is applied to the databases
created by functions \code{\link{estimateModel}},
\code{\link{estimateCounts}} or \code{\link{estimateAccount}}.
}
\examples{
deaths <- demdata::VADeaths2
popn <- demdata::VAPopn
deaths <- round(deaths)
deaths <- Counts(deaths)
popn <- Counts(popn)
filename <- tempfile()
estimateModel(Model(y ~ Poisson(mean ~ age * sex)),
              y = deaths,
              exposure = popn,
              filename = filename,
              nBurnin = 0,
              nSim = 5,
              nChain = 2)
describePriors(filename)
}
\seealso{
\code{\link{showModel}} gives a semi-algebraic
description of an entire model, including the priors.
}
