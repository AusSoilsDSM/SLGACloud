#' Precompute Spline Matrix Structures for Soil Profile Modeling
#'
#' Builds the matrix structures needed to fit a mass-preserving spline model, based on a given set of soil depth intervals and a smoothing parameter. These matrices are reused across all soil profiles or raster cells for efficient evaluation.
#'
#' @param dIn Numeric vector of input soil depth boundaries (e.g., \code{c(0,5,15,30,60,100,200)}).
#' @param lam Numeric; spline smoothing parameter (\eqn{\lambda}). Smaller values produce smoother splines.
#'
#' @return A \code{list} containing precomputed matrix components used in mass-preserving spline fitting:
#' \describe{
#'   \item{\code{z}}{Coefficient matrix used to solve for spline coefficients.}
#'   \item{\code{rinv}}{Inverse of spline smoothness matrix.}
#'   \item{\code{q}}{Difference matrix for first derivatives.}
#'   \item{\code{u}}{Upper depths of each interval.}
#'   \item{\code{v}}{Lower depths of each interval.}
#'   \item{\code{delta}}{Thickness of each interval.}
#' }
#'
#' @author Brendan Malone
#'
#' @examples
#' dIn <- c(0,5,15,30,60,100,200)
#'
#' spline_info <- precompute_spline_structures(dIn = dIn, lam = 0.1)
#'
#' str(spline_info)
#'
#' @seealso \code{\link{fit_mpspline_optimized}}, \code{\link{ea_rasSp_fast}}
#' @keywords methods
#' @export
precompute_spline_structures <- function(dIn, lam = 0.1) {

  # Extract upper and lower bounds of each depth interval
  u <- dIn[-length(dIn)]
  v <- dIn[-1]
  n <- length(u)  # number of layers

  # Compute thicknesses of each layer
  delta <- v - u

  # Compute differences between subsequent layers for curvature constraint
  del <- c(u[-1], u[n]) - v

  nm1 <- n - 1  # one fewer than number of layers

  # Construct the r matrix for smoothness penalties
  r <- matrix(0, nm1, nm1)
  diag(r) <- 1
  r[row(r) == col(r) - 1] <- 1  # upper diagonal of 1s
  d2 <- diag(delta[-1], nrow = nm1, ncol = nm1)
  r <- d2 %*% r + t(d2 %*% r)                         # symmetric smoothing matrix
  r <- r + 2 * diag(delta[1:nm1]) + 6 * diag(del[1:nm1])

  # Construct the q matrix (difference matrix for first derivatives)
  q <- matrix(0, n, n)
  diag(q) <- -1
  q[row(q) == col(q) - 1] <- 1
  q <- q[1:nm1, , drop = FALSE]

  # Invert r (can fail for pathological depth configurations)
  rinv <- try(solve(r), silent = TRUE)
  if (!is.matrix(rinv)) return(NULL)  # return NULL if singular

  # Compute the z matrix used in spline solution
  z <- 6 * n * lam * t(q) %*% rinv %*% q + diag(n)

  # Return all structures needed for spline fitting
  return(list(
    z = z,
    rinv = rinv,
    q = q,
    u = u,
    v = v,
    delta = delta
  ))
}
