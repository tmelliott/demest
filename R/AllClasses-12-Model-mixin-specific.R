

## NO_TESTS
setClass("ASigmaMixin",
         slots = c(ASigma = "Scale"),
         contains = "VIRTUAL")


## NO_TESTS
setClass("ASDLogNuCMPMixin",
         slots = c(ASDLogNuCMP = "Scale"),
         contains = "VIRTUAL")

## NO_TESTS
setClass("AVarsigmaMixin",
         slots = c(AVarsigma = "Scale"),
         contains = "VIRTUAL")

## HAS_TESTS
setClass("AcceptSigma",
         slots = c(acceptSigma = "integer"),
         contains = "VIRTUAL",
         validity = function(object) {
             acceptSigma <- object@acceptSigma
             ## 'acceptSigma' is 0 or 1
             if (!identical(acceptSigma, 0L) && !identical(acceptSigma, 1L))
                 return(gettextf("'%s' is not 0 or 1", "acceptSigma"))
             TRUE
         })

## HAS_TESTS
setClass("BetaIsPredicted",
         slots = c(betaIsPredicted = "logical"),
         contains = "VIRTUAL",
         validity = function(object) {
             betaIsPredicted <- object@betaIsPredicted
             betas <- object@betas
             ## 'betaIsPredicted' has no missing values
             if (any(is.na(betaIsPredicted)))
                 return(gettextf("'%s' has missing values",
                                 "betaIsPredicted"))
             ## 'betaIsPredicted' does not have names
             if (!is.null(names(betaIsPredicted)))
                 return(gettextf("'%s' has names",
                                 "betaIsPredicted"))
             ## 'betaIsPredicted' and 'betas' have same length
             if (!identical(length(betaIsPredicted), length(betas)))
                 return(gettextf("'%s' and '%s' have different lengths",
                                 "betaIsPredicted", "betas"))
             ## first element of 'betaIsPredicted' is FALSE
             if (betaIsPredicted[1L])
                 return(gettextf("first element of '%s' is %s",
                                 "betaIsPredicted", "TRUE"))
             TRUE
         })

## NO TESTS
setClass("BoxCoxParamMixin",
         slots = c(boxCoxParam = "numeric"),
         prototype = prototype(boxCoxParam = 0),
         contains = "VIRTUAL",
         validity = function(object) {
             boxCoxParam <- object@boxCoxParam@.Data
             ## 'boxCoxParam' has length 1
             if (!identical(length(boxCoxParam), 1L))
                 return(gettextf("'%s' does not have length %d",
                                 "boxCoxParam", 1L))
             ## 'boxCoxParam' is not missing
             if (is.na(boxCoxParam))
                 return(gettextf("'%s' is missing",
                                 "boxCoxParam"))
             ## 'boxCoxParam' is double
             if (!is.double(boxCoxParam))
                 return(gettextf("'%s' does not have type \"%s\"",
                                 "boxCoxParam", "double"))
             ## 'boxCoxParam' less than or equal to 1
             if (boxCoxParam > 1)
                 return(gettextf("'%s' is greater than %d",
                                 "boxCoxParam", 1L))
             ## 'boxCoxParam' is greater than or equal to 0
             if (boxCoxParam < 0)
                 return(gettextf("'%s' is less than %d",
                                 "boxCoxParam", 0L))
             ## TEMPORARILY CHECK THAT NOT AGGREGATE
             if ((boxCoxParam > 0) && methods::is(object, "Aggregate"))
                 return("have not yet implemented Box-Cox transforms with aggregate values")
             TRUE
         })         

## HAS_TESTS
setClass("Margins",
         slots = c(margins = "list"),
         contains = "VIRTUAL",
         validity = function(object) {
             margins <- object@margins
             hasMissing <- function(x) any(is.na(x))
             hasNonPositive <- function(x) any(x <= 0L)
             ## all elements of 'margins' are integer
             if (!all(sapply(margins, is.integer)))
                 return(gettextf("'%s' has elements not of type \"%s\"",
                                 "margins", "integer"))
             ## 'margins' has no missing values
             if (any(sapply(margins, hasMissing)))
                 return(gettextf("'%s' has missing values",
                                 "margins"))
             ## first element of margins is 0L
             if (!identical(margins[[1L]], 0L))
                 return(gettextf("first element of '%s' is not %s",
                                 "margins", "0L"))
             ## all other elements of margins at least 1
             if (any(sapply(margins[-1L], hasNonPositive)))
                 return(gettextf("'%s' has non-positive elements",
                                 "margins"))
             TRUE
         })


## HAS_TESTS
setClass("Betas",
         slots = c(betas = "list",
                   meansBetas = "list",
                   variancesBetas = "list",
                   namesBetas = "character",
                   priorsBetas = "list",
                   betaEqualsMean = "logical",
                   iteratorBetas = "BetaIterator",
                   dims = "list",
                   logPostBetas = "Parameter",
                   logPostPriorsBetas = "Parameter",
                   mu = "numeric"),
         contains = c("VIRTUAL", "Margins"),
         validity = function(object) {
             betas <- object@betas
             names <- object@namesBetas
             margins <- object@margins
             priors <- object@priorsBetas
             betaEqualsMean <- object@betaEqualsMean
             iteratorBetas <- object@iteratorBetas
             dims <- object@dims
             mu <- object@mu
             theta <- object@theta
             hasNonPositive <- function(x) any(x <= 0L)
             hasMissing <- function(x) any(is.na(x))
             I <- length(object@theta)
             ## 'betas' has at least one element
             if (identical(length(betas), 0L))
                 return(gettextf("'%s' has length %d", "betas", 0L))
             ## all elements of 'betas' have type "double"
             if (!all(sapply(betas, is.double)))
                 return(gettextf("'%s' has elements not of type \"%s\"",
                                 "betas", "double"))
             ## 'betas' does not have names
             if (!is.null(names(betas)))
                 return(gettextf("'%s' has names", "betas"))
             ## first element of 'betas' has length 1
             if (!identical(length(betas[[1L]]), 1L))
                 return(gettextf("first element of '%s' does not have length 1", "betas"))
             ## meansBetas, variancesBetas
             for (name in c("meansBetas", "variancesBetas")) {
                 value <- methods::slot(object, name)
                 ## all elements have type "double"
                 if (!all(sapply(value, is.double)))
                     return(gettextf("'%s' has elements not of type \"%s\"",
                                     name, "double"))
                 ## does not have names
                 if (!is.null(names(value)))
                     return(gettextf("'%s' has names",
                                     name))
             }
             ## 'namesBetas' has no missing values
             if (any(is.na(names)))
                 return(gettextf("'%s' has missing values", "namesBetas"))
             ## 'namesBetas' has no zero-length names
             if (!all(nzchar(names)))
                 return(gettextf("'%s' has zero-length names", "namesBetas"))
             ## 'namesBetas' has no duplicated names
             if (any(duplicated(names)))
                 return(gettextf("'%s' has duplicates", "namesBetas"))
             ## first element of 'namesBetas' is "(Intercept)"
             if (!identical(names[1L], "(Intercept)"))
                 return(gettextf("first element of '%s' is not \"%s\"",
                                 "namesBetas", "(Intercept)"))
             ## all elements of 'priorsBetas' have class "Prior"
             if (!all(sapply(priors, is, "Prior")))
                 return(gettextf("'%s' has elements not of class \"%s\"",
                                 "priorsBetas", "Prior"))
             ## 'priorsBetas' has no names
             if (!is.null(names(priors)))
                 return(gettextf("'%s' has names", "priorsBetas"))
             ## first element of 'priorsBetas' has class "ExchFixed" or "TimeInvariant"
             if (!(methods::is(priors[[1L]], "ExchFixed") || methods::is(priors[[1L]], "TimeInvariant")))
                 return(gettextf("first element of '%s' has class \"%s\"",
                                 "priorsBetas", class(priors[[1L]])))
             ## 'betaEqualsMean' has no missing values
             if (any(is.na(betaEqualsMean)))
                 return(gettextf("'%s' has missing values",
                                 "betaEqualsMean"))
             ## all elements of 'dims' are integer
             if (!all(sapply(dims, is.integer)))
                 return(gettextf("'%s' has elements not of type \"%s\"",
                                 "dims", "integer"))
             ## 'dims' does not have missing values
             if (any(sapply(dims, hasMissing)))
                 return(gettextf("'%s' has missing values",
                                 "dims"))
             ## 'dims' is non-negative
             if (!all(sapply(dims, function(x) !any(x < 0))))
                 return(gettextf("'%s' has negative values",
                                 "dims"))
             ## 'dims' does not have names
             if (!is.null(names(dims)))
                 return(gettextf("'%s' has names",
                                 "dims"))
             ## first element of 'dims' is 0L
             if (!identical(dims[[1L]], 0L))
                 return(gettextf("first element of '%s' is not %d",
                                 "dims", 0L))
             ## 'mu' has type "double"
             if (!is.double(mu))
                 return(gettextf("'%s' does not have type \"%s\"",
                                 "mu", "double"))
             ## meansBetas, variancesBetas:
             for (name in c("meansBetas", "variancesBetas")) {
                 value <- methods::slot(object, name)
                 ## 'betas' and slot have same length
                 if (!identical(length(betas), length(value)))
                     return(gettextf("'%s' and '%s' have different lengths",
                                     "betas", name))
                 ## corresponding elements of slot and 'betas' have same length
                 for (i in seq_along(value))
                     if (!identical(length(value[[i]]), length(betas[[i]])))
                         return(gettextf("element %d of '%s' and element %d of '%s' have different lengths",
                                         i, name, i, "betas"))
                 ## slot has missing values iff beta has missing values
                 for (i in seq_along(value))
                     if (!identical(is.na(value[[i]]), is.na(betas[[i]]))) {
                         return(gettextf("element %d of '%s' and element %d of '%s' have different patterns of missingness",
                                         i, name, i, "betas"))
                     }
             }
             ## 'betas' and 'betaEqualsMean' have same length
             if (!identical(length(betas), length(betaEqualsMean)))
                 return(gettextf("'%s' and '%s' have different lengths",
                                 "betas", "betaEqualsMean"))
             ## 'betas' and 'namesBetas' have same length
             if (!identical(length(betas), length(names)))
                 return(gettextf("'%s' and '%s' have different lengths",
                                 "betas", "namesBetas"))
             ## 'betas' and 'margins' have same length
             if (!identical(length(betas), length(margins)))
                 return(gettextf("'%s' and '%s' have different lengths",
                                 "betas", "margins"))
             ## 'betas' and 'priorsBetas' have same length
             if (!identical(length(betas), length(priors)))
                 return(gettextf("'%s' and '%s' have different lengths",
                                 "betas", "priorsBetas"))
             ## 'betas' and 'dims' have same length
             if (!identical(length(betas), length(dims)))
                 return(gettextf("'%s' and '%s' have different lengths",
                                 "betas", "dims"))
             ## all elements of 'betas' have valid length for corresponding element of 'priorsBetas'
             for (i in seq_along(betas)) {
                 if (!identical(length(betas[[i]]), priors[[i]]@J@.Data))
                     return(gettextf("\"%s\" element of '%s' has invalid length [%d] for corresponding prior of class \"%s\"",
                                     names[i], "betas", length(betas[[i]]),
                                     class(priors[[i]])))
             }
             ## length of 'indices' from iteratorBetas equals length of 'betas'
             if (!identical(length(iteratorBetas@indices), length(betas)))
                 return(gettextf("length of '%s' from '%s' not equal to length of '%s'",
                                 "indices", "iteratorBetas", "betas"))
             ## 'mu' and 'theta' have same length
             if (!identical(length(mu), length(theta)))
                 return(gettextf("'%s' and '%s' have different lengths",
                                 "mu", "theta"))
             TRUE
         })

## HAS_TESTS
setClass("CellInLikMixin",
         slots = c(cellInLik = "logical"),
         contains = "VIRTUAL",
         validity = function(object) {
             cellInLik <- object@cellInLik
             ## if object has 'theta', then 'cellInLik' same length as 'theta'
             if (methods::.hasSlot(object, "theta")) {
                 if (!identical(length(cellInLik), length(object@theta)))
                     return(gettextf("'%s' and '%s' have different lengths",
                                     "cellInLik", "theta"))
             }
             ## 'cellInLik' has no missing values
             if (any(is.na(cellInLik)))
                 return(gettextf("'%s' has missing values",
                                 "cellInLik"))
             TRUE
         })

## NO_TESTS
setClass("FormulaMuMixin",
         slots = c(formulaMu = "formula"),
         contains = "VIRTUAL",
         validity = function(object) {
             formulaMu <- object@formulaMu
             ## 'formulaMu' has a response
             if (!hasResponse(formulaMu))
                 return(gettextf("formula '%s' does not have a response",
                                 deparse(formulaMu)))
             ## response from 'formulaMu' is "mean"
             if (!identical(extractResponse(formulaMu), "mean"))
                 return(gettextf("response for formula '%s' is not '%s'",
                                 deparse(formulaMu), "mean"))
             TRUE
         }) 

## HAS_TESTS
setClass("IMethodModel",
         slots = c(iMethodModel = "integer"),
         contains = "VIRTUAL")

## HAS_TESTS
setClass("LowerUpperMixin",
         slots = c(lower = "numeric",
                   upper = "numeric",
                   tolerance = "numeric"),
         prototype = prototype(tolerance = 1e-5),
         contains = "VIRTUAL",
         validity = function(object) {
             lower <- object@lower
             upper <- object@upper
             tolerance <- object@tolerance
             maxAttempt <- object@maxAttempt
             for (name in c("lower", "upper", "tolerance")) {
                 value <- methods::slot(object, name)
                 ## 'lower', 'upper', 'tolerance' have length 1
                 if (!identical(length(value), 1L))
                     return(gettextf("'%s' does not have length %d",
                                     name, 1L))
                 ## 'lower', 'upper', 'tolerance' is double
                 if (!is.double(value))
                     return(gettextf("'%s' does not have type \"%s\"",
                                     name, "double"))
                 ## 'lower', 'upper', tolerance is not missing
                 if (is.na(value))
                     return(gettextf("'%s' is missing",
                                     name))
             }
             ## 'lower' is less than 'upper'
             if (lower >= upper)
                 return(gettextf("'%s' not less than '%s'",
                                 "lower", "upper"))
             ## 'tolerance' is non-negative
             if (tolerance < 0)
                 return(gettextf("'%s' is negative",
                                 "tolerance"))
             ## 'maxAttempt' has length 1
             if (!identical(length(maxAttempt), 1L))
                 return(gettextf("'%s' does not have length %d",
                                 "maxAttempt", 1L))
             ## 'maxAttempt' is not missing
             if (is.na(maxAttempt))
                 return(gettextf("'%s' is missing",
                                 "maxAttempt"))
             ## 'maxAttempt' is positive
             if (maxAttempt < 1L)
                 return(gettextf("'%s' is less than %d",
                                 "maxAttempt", 1L))
             TRUE
         })

## HAS_TESTS
setClass("MaxAttemptMixin",
         slots = c(maxAttempt = "integer"),
         prototype = prototype(maxAttempt = 1000L),
         contains = "VIRTUAL",
         validity = function(object) {
             maxAttempt <- object@maxAttempt
             ## 'maxAttempt' has length 1
             if (!identical(length(maxAttempt), 1L))
                 return(gettextf("'%s' does not have length %d",
                                 "maxAttempt", 1L))
             ## 'maxAttempt' is not missing
             if (is.na(maxAttempt))
                 return(gettextf("'%s' is missing",
                                 "maxAttempt"))
             ## 'maxAttempt' is positive
             if (maxAttempt < 1L)
                 return(gettextf("'%s' is less than %d",
                                 "maxAttempt", 1L))
             TRUE
         })

## NO_TESTS
setClass("MeanMeanLogNuCMPMixin",
         slots = c(meanMeanLogNuCMP = "Parameter"),
         prototype = prototype(meanMeanLogNuCMP = methods::new("Parameter", 0)),
         contains = "VIRTUAL")

## NO_TESTS
setClass("MeanLogNuCMPMixin",
         slots = c(meanLogNuCMP = "Parameter"),
         prototype = prototype(meanLogNuCMP = methods::new("Parameter", 0)),
         contains = "VIRTUAL")

## HAS_TESTS
setClass("MeanSDMixin",
         slots = c(mean = "ParameterVector",
                   sd = "ScaleVec"),
         contains = "VIRTUAL",
         validity = function(object) {
             mean <- object@mean@.Data
             sd <- object@sd@.Data
             ## 'mean' and 'sd' have the same length
             if (!identical(length(mean), length(sd)))
                 return(gettextf("'%s' and '%s' have different lengths",
                                 "mean", "sd"))
             TRUE
         })

## HAS_TESTS
setClass("MeanSDMetadataMixin",
         slots = c(metadata = "MetaData"),
         contains = c("VIRTUAL", "MeanSDMixin"),
         validity = function(object) {
             mean <- object@mean@.Data
             sd <- object@sd@.Data
             metadata <- object@metadata
             ## 'metadata' does not have any dimensions with dimtype "iteration"
             if ("iteration" %in% dimtypes(metadata))
                 return(gettextf("dimension with dimtype \"%s\"",
                                 "iteration"))
             ## 'metadata' does not have any dimensions with dimtype "quantile"
             if ("quantile" %in% dimtypes(metadata))
                 return(gettextf("dimension with dimtype \"%s\"",
                                 "quantile"))
             ## 'metadata' and 'mean' consistent
             if (!identical(length(mean), as.integer(prod(dim(metadata)))))
                 return(gettextf("'%s' and '%s' inconsistent",
                                 "mean", "metadata"))
             TRUE
         })

## HAS_TESTS
setClass("MeanSDMetadataAllMixin",
         slots = c(meanAll = "ParameterVector",
                   sdAll = "ScaleVec",
                   metadataAll = "MetaData"),
         contains = "VIRTUAL",
         validity = function(object) {
             meanAll <- object@meanAll@.Data
             sdAll <- object@sdAll@.Data
             metadataAll <- object@metadataAll
             ## 'metadataAll' does not have any dimensions with dimtype "iteration"
             if ("iteration" %in% dimtypes(metadataAll))
                 return(gettextf("dimension with dimtype \"%s\"",
                                 "iteration"))
             ## 'metadataAll' does not have any dimensions with dimtype "quantile"
             if ("quantile" %in% dimtypes(metadataAll))
                 return(gettextf("dimension with dimtype \"%s\"",
                                 "quantile"))
             ## 'meanAll' and 'sdAll' have the same length
             if (!identical(length(meanAll), length(sdAll)))
                 return(gettextf("'%s' and '%s' have different lengths",
                                 "meanAll", "sdAll"))
             ## 'metadataAll' and 'meanAll' consistent
             if (!identical(length(meanAll), as.integer(prod(dim(metadataAll)))))
                 return(gettextf("'%s' and '%s' inconsistent",
                                 "meanAll", "metadataAll"))
             TRUE
         })

## HAS_TESTS
setClass("MetadataY",
         slots = c(metadataY = "MetaData"),
         contains = "VIRTUAL",
         validity = function(object) {
             metadataY <- object@metadataY
             dimtypes <- dembase::dimtypes(metadataY, use.names = FALSE)
             ## 'metadataY' does not have any dimensions with dimtype "iteration"
             if ("iteration" %in% dimtypes)
                 return(gettextf("dimension with dimtype \"%s\"",
                                 "iteration"))
             ## 'metadataY' does not have any dimensions with dimtype "quantile"
             if ("quantile" %in% dimtypes)
                 return(gettextf("dimension with dimtype \"%s\"",
                                 "quantile"))
             TRUE
         })

## NO_TESTS
setClass("MultSigmaMixin",
         slots = c(multSigma = "Scale"),
         contains = "VIRTUAL")

## NO_TESTS
setClass("MultVarsigmaMixin",
         slots = c(multVarsigma = "Scale"),
         contains = "VIRTUAL")

## HAS_TESTS
setClass("NAcceptThetaMixin",
         slots = c(nAcceptTheta = "Counter"),
         contains = "VIRTUAL",
         validity = function(object) {
             theta <- object@theta
             nAcceptTheta <- object@nAcceptTheta@.Data
             ## 'nAcceptTheta' no larger than length of 'theta'
             if (nAcceptTheta > length(theta))
                 return(gettextf("'%s' is larger than the length of '%s'",
                                 "nAcceptTheta", "theta"))
             TRUE
         })

setClass("NFailedPropThetaMixin",
         slots = c(nFailedPropTheta = "Counter"),
         contains = "VIRTUAL")

setClass("NFailedPropYStarMixin",
         slots = c(nFailedPropYStar = "Counter"),
         contains = "VIRTUAL")

## NO_TESTS
setClass("NameYMixin",
         slots = c(nameY = "Name"),
         contains = "VIRTUAL")

## NO_TESTS
setClass("NuCMPMixin",
         slots = c(nuCMP = "ParameterVector"),
         contains = "VIRTUAL",
         validity = function(object) {
             nuCMP <- object@nuCMP@.Data
             theta <- object@theta
             ## 'nuCMP' has same length as 'theta'
             if (!identical(length(nuCMP), length(theta)))
                 return(gettextf("'%s' and '%s' have different lengths",
                                 "nuCMP", "theta"))
             ## 'nuCMP' non-negative
             if (any(nuCMP < 0))
                 return(gettextf("'%s' has negative values",
                                 "nuCMP"))
             TRUE
         })

## NO_TESTS
setClass("NuSigmaMixin",
         slots = c(nuSigma = "DegreesFreedom"),
         contains = "VIRTUAL")

## NO_TESTS
setClass("NuSDLogNuCMPMixin",
         slots = c(nuSDLogNuCMP = "DegreesFreedom"),
         contains = "VIRTUAL")

## NO_TESTS
setClass("NuVarsigmaMixin",
         slots = c(nuVarsigma = "DegreesFreedom"),
         contains = "VIRTUAL")

## NO_TESTS
setClass("OffsetsAlphaLN2",
         slots = c(offsetsAlphaLN2 = "Offsets"),
         contains = "VIRTUAL",
         validity = function(object) {
             offsetsAlphaLN2 <- object@offsetsAlphaLN2
             alphaLN2 <- object@alphaLN2@.Data
             first <- offsetsAlphaLN2[[1L]]
             last <- offsetsAlphaLN2[[2L]]
             if (!identical(last - first + 1L, length(alphaLN2)))
                 return(gettextf("'%s' and '%s' inconsistent",
                                 "offsetsAlphaLN2", "alphaLN2"))
             TRUE
         })

## HAS_TESTS
setClass("OffsetsBetas",
         slots = c(offsetsBetas = "list"),
         contains = "VIRTUAL",
         validity = function(object) {
             offsetsBetas <- object@offsetsBetas
             betas <- object@betas
             ## all elements of 'offsetsBetas' have class "Offsets"
             if (!all(sapply(offsetsBetas, is, "Offsets")))
                 return(gettextf("'%s' has elements not of class \"%s\"",
                                 "offsetsBetas", "Offsets"))
             ## 'offsetsBetas' has same length as 'betas'
             if (!identical(length(offsetsBetas), length(betas)))
                 return(gettextf("'%s' and '%s' have different lengths",
                                 "offsetsBetas", "betas"))
             TRUE
         })

## HAS_TESTS
setClass("OffsetsPriorsBetas",
         slots = c(offsetsPriorsBetas = "list"),
         contains = "VIRTUAL",
         validity = function(object) {
             offsetsPriorsBetas <- object@offsetsPriorsBetas
             betas <- object@betas
             ## all elements of 'offsetsPriorsBetas' have class "NULL" or "Offsets"
             if (!all(sapply(offsetsPriorsBetas, is, "OffsetsOrNULL")))
                 return(gettextf("'%s' has elements not of class \"%s\" or \"%s\"",
                                 "offsetsPriorsBetas", "Offsets", "NULL"))
             ## 'offsetsPriorsBetas' has same length as 'betas'
             if (!identical(length(offsetsPriorsBetas), length(betas)))
                 return(gettextf("'%s' and '%s' have different lengths",
                                 "offsetsPriorsBetas", "betas"))
             TRUE
         })

## HAS_TESTS
setClass("OffsetsSigma",
         slots = c(offsetsSigma = "OffsetsOrNULL"),
         contains = "VIRTUAL",
         validity = function(object) {
             offsetsSigma <- object@offsetsSigma
             if (!is.null(offsetsSigma)) {
                 ## if offsetsSigma is non-NULL, first element equals second
                 first <- offsetsSigma[1L]
                 last <- offsetsSigma[2L]
                 if (!identical(first, last))
                     return(gettextf("first and second elements of '%s' are not equal",
                                     "offsetsSigma"))
             }
             TRUE
         })

## HAS_TESTS
setClass("OffsetsVarsigma",
         slots = c(offsetsVarsigma = "OffsetsOrNULL"),
         contains = "VIRTUAL",
         validity = function(object) {
             offsetsVarsigma <- object@offsetsVarsigma
             if (!is.null(offsetsVarsigma)) {
                 ## if offsetsVarsigma is non-NULL, first element equals second
                 first <- offsetsVarsigma[1L]
                 last <- offsetsVarsigma[2L]
                 if (!identical(first, last))
                     return(gettextf("first and second elements of '%s' are not equal",
                                     "offsetsVarsigma"))
             }
             TRUE
         })

## HAS_TESTS
setClass("Prob",
         slots = c(prob = "numeric"),
         contains = "VIRTUAL",
         validity = function(object) {
             prob <- object@prob
             ## 'prob' has length 1
             if (!identical(length(prob), 1L))
                 return(gettextf("'%s' does not have length %d",
                                 "prob", 1L))
             ## 'prob' is not missing
             if (is.na(prob))
                 return(gettextf("'%s' is missing",
                                 "prob"))
             ## 'prob' is double
             if (!is.double(prob))
                 return(gettextf("'%s' does not have type \"%s\"",
                                 "prob", "double"))
             ## 'prob' is between 0 and 1
             if ((prob < 0) || (prob > 1))
                 return(gettextf("'%s' is not between %d and %d",
                                 "prob", 0L, 1L))
             TRUE
         })

## HAS_TESTS
setClass("ScaleThetaMixin",
         slots = c(scaleTheta = "Scale"),
         contains = "VIRTUAL")

## NO_TESTS
setClass("ScaleThetaMultiplierMixin",
         slots = c(scaleThetaMultiplier = "Scale"),
         contains = "VIRTUAL")

## NO_TESTS
setClass("SDLogNuCMPMixin",
         slots = c(sdLogNuCMP = "Scale"),
         contains = "VIRTUAL")

## NO_TESTS
setClass("SDMeanLogNuCMPMixin",
         slots = c(sdMeanLogNuCMP = "Scale"),
         contains = "VIRTUAL")

## NO_TESTS
setClass("SDMaxLogNuCMPMixin",
         slots = c(sdLogNuMaxCMP = "Scale"),
         contains = "VIRTUAL")

## NO_TESTS
setClass("SigmaMaxMixin",
         slots = c(sigmaMax = "Scale"),
         contains = "VIRTUAL",
         validity = function(object) {
             sigma <- object@sigma@.Data
             sigmaMax <- object@sigmaMax@.Data
             if (sigma > sigmaMax)
                 return(gettextf("'%s' is greater than '%s'",
                                 "sigma", "sigmaMax"))
             TRUE
         })

## NO_TESTS
setClass("SigmaMixin",
         slots = c(sigma = "Scale",
                   logPostSigma = "Parameter"),
         contains = "VIRTUAL")

## HAS_TESTS
setClass("SlotsToExtract",
         slots = c(slotsToExtract = "character"),
         contains = "VIRTUAL")


## NO_TESTS
setClass("SpecASigmaMixin",
         slots = c(ASigma = "SpecScale"),
         contains = "VIRTUAL")

## NO_TESTS
setClass("SpecAVarsigmaMixin",
         slots = c(AVarsigma = "SpecScale"),
         contains = "VIRTUAL")

## NO_TESTS
setClass("SpecAgNotPoissonMixin",
         contains = "VIRTUAL",
         validity = function(object) {
             aggregate <- object@aggregate
             if (methods::is(aggregate, "SpecAgPoisson"))
                 stop(gettextf("'%s' has class \"%s\"",
                               "aggregate", class(aggregate)))
             TRUE
         })

## NO_TESTS
setClass("SpecAggregateMixin",
         slots = c(aggregate = "SpecAggregate"),
         contains = "VIRTUAL")


## HAS_TESTS
setClass("SpecSeriesMixin",
         slots = c(series = "SpecName"),
         contains = "VIRTUAL")

## HAS_TESTS
setClass("SpecsPriorsMixin",
         slots = c(specsPriors = "list",
                   namesSpecsPriors = "character"),
         contains = "VIRTUAL",
         validity = function(object) {
             formulaMu <- object@formulaMu
             specsPriors <- object@specsPriors
             namesSpecsPriors <- object@namesSpecsPriors
             ## 'specsPriors' all have class "SpecPrior"
             if (!all(sapply(specsPriors, is, "SpecPrior")))
                 return(gettextf("'%s' has elements not of class \"%s\"",
                                 "specsPriors", "SpecPrior"))
             ## 'namesSpecsPriors' has no missing values
             if (any(is.na(namesSpecsPriors)))
                 return(gettextf("'%s' has missing values",
                                 "namesSpecsPriors"))
             ## 'namesSpecsPriors' has no blanks
             if (any(!nzchar(namesSpecsPriors)))
                 return(gettextf("'%s' has blanks",
                                 "namesSpecsPriors"))
             ## 'namesSpecsPriors' has no duplicates
             if (any(duplicated(namesSpecsPriors)))
                 return(gettextf("'%s' has duplicates",
                                 "namesSpecsPriors"))
             ## 'specsPriors' and 'namesSpecsPriors' have same length
             if (!identical(length(specsPriors), length(namesSpecsPriors)))
                 return(gettextf("'%s' and '%s' have different lengths",
                                 "specsPriors", "namesSpecsPriors"))
             ## 'namesSpecsPriors' refers to terms from 'formulaMu'
             term.labels <- attr(stats::terms(formulaMu), "term.labels")
             term.labels <- c(term.labels, "(Intercept)")
             not.in.labels <- !(namesSpecsPriors %in% term.labels)
             n.not.in.labels <- sum(not.in.labels)
             if (n.not.in.labels > 0L) {
                 names.not.in.labels <- namesSpecsPriors[not.in.labels]
                 names.not.in.labels <- paste(dQuote(names.not.in.labels), collapse = ", ")
                 return(sprintf(ngettext(n.not.in.labels,
                                         "%s from '%s' is not a term from formula '%s'",
                                         "%s from '%s' are not terms from formula '%s'"),
                                names.not.in.labels, "namesSpecsPriors", deparse(formulaMu)))
             }
             TRUE
         })

## NO_TESTS
setClass("SpecSigmaMaxMixin",
         slots = c(sigmaMax = "SpecScale"),
         contains = "VIRTUAL")


## NO_TESTS
setClass("SpecVarsigmaMaxMixin",
         slots = c(varsigmaMax = "SpecScale"),
         contains = "VIRTUAL")

## NO_TESTS
setClass("StructuralZerosMixin",
         slots = c(structuralZeros = "ValuesOrNULL"),
         contains = "VIRTUAL",
         validity = function(object) {
             structuralZeros <- object@structuralZeros
             if (is.null(structuralZeros))
                 TRUE
             else if (identical(structuralZeros, methods::new("Values")))
                 TRUE
             else {
                 if (any(is.na(structuralZeros)))
                     stop(gettextf("'%s' has missing values",
                                   "structuralZeros"))
                 if (all(structuralZeros@.Data == 0L))
                     stop(gettextf("'%s' consists entirely of zeros",
                                   "structuralZeros"))
                 TRUE
             }
         })

## NO_TESTS
setClass("StrucZeroArrayMixin",
         slots = c(strucZeroArray = "Counts"),
         contains = "VIRTUAL",
         validity = function(object) {
             strucZeroArray <- object@strucZeroArray
             ## 'strucZeroArray' is integer
             if (!is.integer(strucZeroArray))
                 return(gettextf("'%s' does not have type \"%s\"",
                                 "strucZeroArray", "integer"))
             ## 'strucZeroArray' has no missing values
             if (any(is.na(strucZeroArray)))
                 return(gettextf("'%s' has missing values",
                                 "strucZeroArray"))
             ## 'strucZeroArray' composed entirely of 1s and 0s
             if (!all(strucZeroArray@.Data %in% 0:1))
                 return(gettextf("'%s' has values other than 0 and 1",
                                 "strucZeroArray"))
             ## 'strucZeroArray' not all 0s
             if (all(strucZeroArray@.Data == 0L))
                 return(gettextf("'%s' consists entirely of zeros",
                                 "strucZeroArray"))
             TRUE
         })

## HAS_TESTS
setClass("Theta",
         slots = c(theta = "numeric",
                   thetaTransformed = "numeric",
                   logPostTheta = "Parameter"),
         contains = "VIRTUAL",
         validity = function(object) {
             theta <- object@theta
             thetaTransformed <- object@thetaTransformed
             logPostTheta <- object@logPostTheta
             metadataY <- object@metadataY
             ## 'theta' is double
             if (!is.double(theta))
                 return(gettextf("'%s' does not have type \"%s\"",
                                 "theta", "double"))
             ## 'thetaTransformed' is double
             if (!is.double(thetaTransformed))
                 return(gettextf("'%s' does not have type \"%s\"",
                                 "thetaTransformed", "double"))
             ## 'thetaTransformed' and 'theta' have same length
             if (!identical(length(theta), length(thetaTransformed)))
                 return(gettextf("'%s' and '%s' have different lengths",
                                 "theta", "thetaTransformed"))
             ## dimensions of 'metadataY' consistent with length of 'theta'
             if (!identical(as.integer(prod(dim(metadataY))), length(theta)))
                 return(gettextf("dimensions of '%s' inconsistent with length of '%s'",
                                 "metadataY", "theta"))
             TRUE
         })

setClass("UseExposeMixin",
         slots = c(useExpose = "LogicalFlag"),
         contains = "VIRTUAL")

## NO_TESTS
setClass("VarsigmaMixin",
         slots = c(varsigma = "Scale",
                   logPostVarsigma = "Parameter"),
         contains = "VIRTUAL")

## NO_TESTS
setClass("VarsigmaMaxMixin",
         slots = c(varsigmaMax = "Scale"),
         contains = "VIRTUAL",
         validity = function(object) {
             varsigma <- object@varsigma@.Data
             varsigmaMax <- object@varsigmaMax@.Data
             if (varsigma > varsigmaMax)
                 return(gettextf("'%s' is greater than '%s'",
                                 "varsigma", "varsigmaMax"))
             TRUE
         })

## HAS_TESTS
setClass("VarsigmaSetToZeroMixin",
         slots = c(varsigmaSetToZero = "LogicalFlag"),
         contains = "VIRTUAL")


## HAS_TESTS
setClass("WNormalMixin",
         slots = c(w = "numeric"),
         contains = "VIRTUAL",
         validity = function(object) {
             theta <- object@theta
             w <- object@w
             ## 'w' is all positive values
             if (any(w <= 0, na.rm = TRUE))
                 return(gettextf("'%s' has non-positive values", "w"))
             ## 'w' same length as 'theta'
             if (!identical(length(w), length(theta)))
                 return(gettextf("'%s' and '%s' have different lengths", "w", "theta"))
             TRUE
         })
