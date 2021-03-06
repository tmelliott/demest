% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/SpecModel-generators.R
\name{Dispersion}
\alias{Dispersion}
\title{Specify the prior for the dispersion parameter in a CMP model.}
\usage{
Dispersion(mean = 0, sd = 1)
}
\arguments{
\item{mean}{A scalar, defaulting to 0.}

\item{sd}{A scalar, defaulting to 1.}
}
\value{
An object of class \code{\linkS4class{Dispersion}}.
}
\description{
Specify the prior for the dispersion parameter (often denoted
'nu') in a CMP or COM-Poisson model. The dispersion parameter
is assumed to have a distribution
\deqn{log \nu_i \sim N(\mu, \sigma^2)}
}
\examples{
Dispersion()
Dispersion(mean = 1, sd = 0.3)
}
\seealso{
CMP models are specified with function \code{\link{CMP}}.
}
