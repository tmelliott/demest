% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/query-functions.R
\name{listContents}
\alias{listContents}
\title{List of output from estimate function.}
\usage{
listContents(filename, where = character(), max = NULL)
}
\arguments{
\item{filename}{The name of the file where the output from the
\code{estimate} function is kept.}

\item{where}{A character vector used to select a single parameter or batch
of parameters.  See below for details.}

\item{max}{Maximum depth of hierarchical structure to show.}
}
\description{
Calling \code{\link{listContents}} on a the filenmame used by
\code{\link{estimateModel}}, \code{\link{estimateCounts}},
or \code{\link{estimateAccount}} shows the items available to be
fetched, in a hierarchical structure.
}
