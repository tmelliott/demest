% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/AllGeneric.R, R/DemographicArray-methods.R
\name{decomposition}
\alias{decomposition}
\alias{decomposition,DemographicArray-method}
\title{Decompose a demographic array}
\usage{
decomposition(object, max = NULL)

\S4method{decomposition}{DemographicArray}(object, max = NULL)
}
\arguments{
\item{object}{An object of class
\code{\link[dembase:DemographicArray-class]{DemographicArray}}.}

\item{max}{An integer. Optional.}
}
\value{
A named list, the elements of which have class
\code{\link[dembase]{Values}}.
}
\description{
Decompose a
\code{\link[dembase:DemographicArray-class]{DemographicArray}}
into terms
made up of component dimensions, plus an error.
\code{decomposition} is typically used to obtain
initial estimates of main effects and interactions,
as part of model building.
}
\details{
When building a Poisson model, the decomposition is usually
carried out on log-rates, and when building a binomial model,
it is usually carried out on logit-proportions, though in both
cases other transformations (or no transformation) may be
appropriate if there are lots of zeros (and also lots of ones
in the case of binomial models).

The final element in the return value is an 'error'
array. This equals the observed value for \code{object} minus the
sum of the terms in the decomposition.

The \code{max} argument controls the maximum order of
the interactions included in decomposition. For instance,
if \code{max} is \code{2}, then only main effects and second-order
interactions are included in the decomposition.  By default,
all interactions are included.

Internally, \code{decomposition} calls function
\code{\link[dembase]{pairToState}} on \code{object},
to cope with origin-destination or parent-child dimensions.
}
\examples{
deaths <- Counts(demdata::VADeaths2)
popn <- Counts(demdata::VAPopn)
rates <- deaths/popn
log.rates <- log(rates)
ans <- decomposition(log.rates)
names(ans)
ans[1:3]
ans[["age:residence"]]
mean(log.rates)
round(sapply(ans, sum), 5)
all.equal(Reduce("+", ans), log.rates)
## main effects only
decomposition(log.rates, max = 1)
}
\references{
Chapter 12 of Bryant and Zhang,
\emph{Bayesian Demographic Estimation and Forecasting}.
}
