% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/SpecPrior-generators.R
\name{Damp}
\alias{Damp}
\title{Specify the amount of damping in a DLM prior.}
\usage{
Damp(coef = NULL, shape1 = 2, shape2 = 2, min = 0.8, max = 1)
}
\arguments{
\item{coef}{A number between 0 and 1.}

\item{shape1}{A positive number. Defaults to 2.}

\item{shape2}{A positive number. Defaults to 2.}

\item{min}{A number between 0 and 1.}

\item{max}{A number between \code{min} and 1.}
}
\value{
An object of class \code{\linkS4class{Damp}}.
}
\description{
By default, the level term in a local level model and the trend term in a
linear trend model are 'damped'.  The level term or trend term are pulled
towards 0.  The amount of damping can be specified by the user, or can
be estimated from the data.
}
\details{
With a prior for a main effect, in a local level model, the level term has
the form

\code{level[j] ~ damp * level[j-1] + errorLevel[j]},

and in a linear trend model, the trend term has the form

\code{trend[j] ~ damp * trend[j-1] + errorTrend[j]}.

With a prior for an interaction, in a local level model, the level term
has the form

\code{level[k,l] ~ damp * level[k-1,l] + errorLevel[k,l]}.

and in linear trend model, the trend term has the form

\code{trend[k,l] ~ damp * trend[k-1,l] + errorTrend[k,l]}

(See the documentation for function \code{\link{DLM}} for
an explanation of the \code{k,l} subscripts.)

Values of for \code{damp} are restricted to the range \code{0 <= damp <= 1}.
In linear trend models, including a damping term with a value near 1
typically results in more accurate forecasts (Hyndman et al 2008).  There
are exceptions, however: for instance, damping of the trend for the time
effect is probably not appropriate in mortality forecasts for developed
countries (Oeppen and Vaupel 2002).  Damping is also not necessary
appropriate in local level models.

The user can set the level of damping by providing a value for the
\code{coef} argument.  Alternatively, an appropriate value can be inferred
from the data, using a beta prior on the transformed parameter
\code{(damp - min)/(max - min)}.  The beta prior is specified
using parameters \code{shape1} and \code{shape1}.  The default
values give a boundary-avoiding prior, confined to the range \code{(min, max)},
with \code{min} defaulting to 0.8 and \code{max} defaulting to \code{1}.
(See Gelman et al 2014, pp313-318, for a definition
of boundary-avoiding priors.) Setting \code{shape1 = 1} and \code{shape2 = 1}
gives a uniform prior on the range \code{(min, max)}.

Setting the \code{damp} argument to \code{NULL} in function
\code{\link{DLM}} turns off damping.
}
\examples{
## default
Damp()

## known value
Damp(coef = 0.95)

## estimate, but restrict to values between 0.85 and 0.95
Damp(min = 0.85, max = 0.95)

## uniform prior on the range (0, 1)
Damp(min = 0, max = 1, shape1 = 1, shape2 = 1)

## informative prior favouring high values, but
## not ruling out any value between 0 and 1
Damp(min = 0, max = 1, shape1 = 9, shape2 = 1)
}
\references{
Hyndman, R., Koehler, A. B., Ord, J. K., & Snyder, R. D. (2008).
\emph{Forecasting with' exponential smoothing: the state space approach}.
Springer.

Oeppen, J., & Vaupel, J. W. (2002). Broken limits to life expectancy.
\emph{Science}, 296(5570), 1029-1031.
}
\seealso{
\code{Damp} is used in calls to function \code{\link{DLM}}
}
