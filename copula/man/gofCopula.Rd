\name{gofCopula}
\title{Goodness-of-fit Tests for Copulas}
\alias{gofCopula}
\alias{gofMB}
\alias{gofPB}
\description{
  Goodness-of-fit tests for copulas based on the empirical process
  comparing the empirical copula with a parametric estimate of the
  copula derived under the null hypothesis.
  Approximate p-values for the test statistic can be obtained either
  using the \emph{parametric bootstrap} (see the two first
  references) or by means of a fast \emph{multiplier} approach
  (see references three and four).

  The default test statistic, "Sn", is the Cramer-von Mises functional
  \eqn{\mathrm{S_n}}{S[n]} defined
  in Equation (2) of Genest, Remillard and Beaudoin (2009).

  The prinicipal function is \code{gofCopula()} which, depending on
  \code{simulation} either calls \code{gofPB()} or \code{gofMB()}.
}
\usage{
gofCopula(copula, x, N = 1000,
          method = "Sn",
          estim.method = eval(formals(fitCopula)$method),
          simulation = c("pb", "mult"),
	  verbose = TRUE, print.every = NULL, \dots)

gofPB(copula, x, N, method = eval(formals(gofTstat)$method),
      estim.method = eval(formals(fitCopula)$method),
      trafo.method = c("none", "rtrafo", "htrafo"),
      trafoArgs = list(), verbose = TRUE, \dots)

gofMB(copula, x, N, method = c("Sn", "Rn"),
      estim.method = eval(formals(fitCopula)$method), verbose = TRUE,
      useR = FALSE, m = 1/2, zeta.m = 0, b = 0.05, \dots)
}
\arguments{
  \item{copula}{object of class \code{"\linkS4class{copula}"} representing the
    hypothesized copula family.}
  \item{x}{a data matrix that will be transformed to pseudo-observations. }
  \item{N}{number of bootstrap or multiplier replications to be used to
    simulate realizations of the test statistic under the null
    hypothesis.}
  \item{method}{a \code{\link{character}} string specifying the
    goodness-of-fit test statistic to be used.  For \code{simulation = "pb"},
    one of "Sn", "SnB", "SnC", "AnChisq", or "AnGamma", see
    \code{\link{gofTstat}()}.  For \code{simulation = "mult"}, one of
    \code{"Sn"} or \code{"Rn"}, where the latter is \eqn{R_n} from
    Genest et al. (2013).}
  \item{estim.method}{a character string specifying the estimation method to
    be used to estimate the dependence parameter(s); see \code{\link{fitCopula}()}.}
  \item{simulation}{a string specifying the simulation method for
    generating realizations of the test statistic under the null
    hypothesis; can be either \code{"pb"} (parametric bootstrap) or
    \code{"mult"} (multiplier).}
  \item{print.every}{is deprecated in favor of \code{verbose}.}
  \item{verbose}{a logical specifying if progress of the bootstrap
    should be displayed via \code{\link[utils]{txtProgressBar}}.}
  \item{\dots}{for \code{gofCopula}, additional arguments passed to
    \code{gofPB()} or \code{gofMB()};

    for \code{gofPB()} and \code{gofMB()}: additional arguments passed
    to \code{\link{fitCopula}()}.  These may notably contain
    \code{optim.method}, \code{optim.control}, \code{lower},
    or \code{upper} depending on the \code{optim.method}.}
  \item{trafo.method}{string specifying the transformation to
    \eqn{U[0,1]^d}; either \code{"none"} or one of \code{"rtrafo"},
    see \code{\link{rtrafo}}, or \code{"htrafo"}, see \code{\link{htrafo}}.}
  \item{trafoArgs}{a \code{\link{list}} of optional arguments passed
    to the transformation method (see \code{trafo.method} above).}
  \item{useR}{logical indicating whether an R or the C implementation is used.}
  \item{m, zeta.m, b}{only for method \code{"Rn"} in \dQuote{MB}, the
    multiplier bootstrap. \code{m} is the power, \code{zeta.m} the adjustment
    parameter \eqn{\zeta_m}{zeta.m} for the denominator of the test
    statistic, and \code{b} is the bandwidth required for the estimation
    of the first-order partial derivatives based on the empirical copula.}
}
\details{
  If the parametric bootstrap is used, the dependence parameters of
  the hypothesized copula family can be estimated either by maximizing
  the pseudo-likelihood, by inverting Kendall's tau, or by inverting
  Spearman's rho.  If the multiplier is used, any estimation method
  can be used in the bivariate case, but only maximum pseudo-likelihood
  estimation can be used in the multivariate (multiparameter) case.

  For the normal and t copulas, several dependence structures can be
  hypothesized: \code{"ex"} for exchangeable, \code{"ar1"} for AR(1),
  \code{"toep"} for Toeplitz, and \code{"un"} for unstructured (see
  \code{\link{ellipCopula}()}). For the t copula, \code{"df.fixed"} has to
  be set to \code{TRUE}, which implies that the degrees of freedom are
  not considered as a parameter to be estimated.

  Thus far, the multiplier approach is implemented for six copula
  families: the Clayton, Gumbel, Frank, Plackett, normal and t.

  Although the processes involved in the multiplier and the parametric
  bootstrap-based test are asymptotically equivalent under the null,
  note that the finite-sample behavior of the two tests might differ
  significantly.

  Also note that in the case of the parametric and multiplier bootstraps,
  the approximate p-value is computed as
  \deqn{(0.5 +\sum_{b=1}^N\mathbf{1}_{\{T_b\ge T\}})/(N+1),}{%
        (0.5 + sum(T[b] >= T, b=1, .., N)) / (N+1),}
  where \eqn{T} and \eqn{T_b}{T[b]} denote the test statistic and
  the bootstrapped test statistc, respectively. This ensures that the
  approximate p-value is a number strictly between 0 and 1, which is
  sometimes necessary for further treatments. See Pesarin (2001) for
  more details.
}
\value{
  An object of \code{\link{class}} \code{htest} which is a list,
  some of the components of which are
  \item{statistic}{value of the test statistic.}
  \item{p.value}{corresponding approximate p-value.}
  \item{parameter}{estimates of the parameters for the hypothesized
    copula family.}
}
\references{
  Genest, C., Huang, W., and Dufour, J.-M. (2013).
  A regularized goodness-of-fit test for copulas.
  \emph{Journal de la Soci\enc{é}{e}t\enc{é}{e} fran\enc{ç}{c}aise de statistique}
  \bold{154}, 64--77.

  Genest, C. and R\enc{é}{e}millard, B. (2008). Validity of the parametric
  bootstrap for goodness-of-fit testing in semiparametric models.
  \emph{Annales de l'Institut Henri Poincare: Probabilites et Statistiques}
  \bold{44}, 1096--1127.

  Genest, C., R\enc{é}{e}millard, B., and Beaudoin, D. (2009).
  Goodness-of-fit tests for copulas: A review and a power study.
  \emph{Insurance: Mathematics and Economics} \bold{44}, 199--214.

  Kojadinovic, I., Yan, J., and Holmes M. (2011).
  Fast large-sample goodness-of-fit tests for copulas.
  \emph{Statistica Sinica} \bold{21}, 841--871.

  Kojadinovic, I. and Yan, J. (2011). A goodness-of-fit test for
  multivariate multiparameter copulas based on multiplier central limit
  theorems. \emph{Statistics and Computing} \bold{21}, 17--30.

  Kojadinovic, I. and Yan, J. (2010).
  Modeling Multivariate Distributions with Continuous Margins Using the
  copula R Package.
  \emph{Journal of Statistical Software} \bold{34}(9), 1--20.
  \url{http://www.jstatsoft.org/v34/i09/}.

  Pesarin, F. (2001).
  \emph{Multivariate Permutation Tests: With Applications in Biostatistics}.
  Wiley.
}
\note{
  These tests were derived under the assumption of continuous margins,
  which implies that ties occur with probability zero. The
  presence of ties in the data might substantially affect the
  approximate p-values. One way of dealing with ties was suggested in the
  Journal of Statistical Software reference.

  Since \R is widely used by practitioners, a word of warning concerning
  goodness-of-fit tests \emph{in general} is also advisable.
  Goodness-of-fit tests are often (ab)used in practice to
  \dQuote{justify} an assumption under which one then continues to work
  (carelessly).  From a mathematical point of view, this is not correct.
}
\seealso{
  \code{\link{fitCopula}()} for the underlying estimation procedure and
  \code{\link{gofTstat}()} for the available test statistics.
}
\examples{
## the following example is available in batch through
## demo(gofCopula)% == ../demo/gofCopula.R __keep >> EXACTLY << in sync!__
%% Note that  ../tests/gof-ex.R (at the end) has "proof-of-concept" tests
\dontrun{
## A two-dimensional data example ----------------------------------
x <- rCopula(200, claytonCopula(3))

(tau. <- cor(x, method="kendall")[1,2]) # around 0.5 -- 0.6
## Does the Gumbel family seem to be a good choice?
(thG <- iTau(gumbelCopula(), tau.)) # 3.02
gofCopula(gumbelCopula(thG), x)
# SnC: really s..l..o..w.. --- SnB is *EVEN* slower
gofCopula(gumbelCopula(thG), x, method = "SnC")
## What about the Clayton family?
(thC <- iTau(claytonCopula(), tau.)) # 4.05
gofCopula(claytonCopula(thC), x)
gofCopula(claytonCopula(thC), x, method = "AnChisq")

## The same with a different estimation method
gofCopula(gumbelCopula (thG), x, estim.method="itau")
gofCopula(claytonCopula(thC), x, estim.method="itau")


## A three-dimensional example  ------------------------------------
x <- rCopula(200, tCopula(c(0.5, 0.6, 0.7), dim = 3, dispstr = "un"))

## Does the Clayton family seem to be a good choice?
## here starting with the "same" as indepCopula(3) :
(gCi3 <- gumbelCopula(1, dim = 3, use.indepC="FALSE"))
gofCopula(gCi3, x)
## What about the t copula?
t.copula <- tCopula(rep(0, 3), dim = 3, dispstr = "un", df.fixed=TRUE)
## this is *VERY* slow currently %% FIXME ??
gofCopula(t.copula, x)

## The same with a different estimation method
gofCopula(gCi3,     x, estim.method="itau")
gofCopula(t.copula, x, estim.method="itau")

## The same using the multiplier approach
gofCopula(gCi3,     x, simulation="mult")
gofCopula(t.copula, x, simulation="mult")
}% dontrun
}
\keyword{htest}
\keyword{models}
\keyword{goodness-of-fit}
\keyword{multivariate}
