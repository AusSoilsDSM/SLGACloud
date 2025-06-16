#' Fit Mass-Preserving Spline to a Single Soil Profile
#'
#' Applies the mass-preserving spline algorithm to a numeric vector of soil profile values and returns averaged values over specified output depth intervals. It uses precomputed matrix structures for efficiency.
#'
#' @param vals Numeric vector of input values across input soil depth intervals (e.g., from one raster pixel).
#' @param spline_info List output from \code{\link{precompute_spline_structures}} that contains spline matrix components.
#' @param dOut Numeric vector defining output depth intervals (e.g., \code{c(0,30,60)}).
#' @param vlow Minimum bound to truncate spline predictions (e.g., 0).
#' @param vhigh Maximum bound to truncate spline predictions (e.g., 100).
#' @param depth_res Numeric; resolution for interpolating spline (e.g., 1 = 1cm steps).
#'
#' @return A numeric vector of spline-averaged values for each specified output depth interval.
#'
#' @author Brendan Malone
#'
#' @examples
#' \dontrun{
#' library(terra)
#'
#' clay_urls <- c(
#'   '/vsicurl/https://esoil.io/TERNLandscapes/Public/Products/TERN/SLGA/CLY/CLY_000_005_EV_N_P_AU_TRN_N_20210902.tif',
#'   '/vsicurl/https://esoil.io/TERNLandscapes/Public/Products/TERN/SLGA/CLY/CLY_005_015_EV_N_P_AU_TRN_N_20210902.tif',
#'   '/vsicurl/https://esoil.io/TERNLandscapes/Public/Products/TERN/SLGA/CLY/CLY_015_030_EV_N_P_AU_TRN_N_20210902.tif',
#'   '/vsicurl/https://esoil.io/TERNLandscapes/Public/Products/TERN/SLGA/CLY/CLY_030_060_EV_N_P_AU_TRN_N_20210902.tif',
#'   '/vsicurl/https://esoil.io/TERNLandscapes/Public/Products/TERN/SLGA/CLY/CLY_060_100_EV_N_P_AU_TRN_N_20210902.tif',
#'   '/vsicurl/https://esoil.io/TERNLandscapes/Public/Products/TERN/SLGA/CLY/CLY_100_200_EV_N_P_AU_TRN_N_20210902.tif'
#' )
#'
#' clay_stack <- terra::rast(clay_urls)
#' aoi <- terra::ext(149.00, 149.10, -36.00, -35.90)
#' clay_crop <- terra::crop(clay_stack, aoi)
#'
#' vals <- terra::extract(clay_crop, cbind(149.05, -35.95))[1, -1]
#'
#' dIn <- c(0, 5, 15, 30, 60, 100, 200)
#' spline_info <- precompute_spline_structures(dIn, lam = 0.1)
#'
#' fit <- fit_mpspline_optimized(
#'   vals = vals,
#'   spline_info = spline_info,
#'   dOut = c(0, 30, 60),
#'   vlow = 0,
#'   vhigh = 100,
#'   depth_res = 1
#' )
#'
#' fit
#' }
#'
#' @seealso \code{\link{precompute_spline_structures}}, \code{\link{ea_rasSp_fast}}
#' @keywords methods
#' @export
#'
fit_mpspline_optimized <- function(vals, spline_info, dOut, vlow, vhigh, depth_res = 1) {

  # Return NA vector if input is all NA or does not match expected length
  if (all(is.na(vals)) || length(vals) != length(spline_info$u)) {
    return(rep(NA, length(dOut) - 1))
  }

  # Unpack spline structures from precomputed info
  u <- spline_info$u
  v <- spline_info$v
  delta <- spline_info$delta
  z <- spline_info$z
  rinv <- spline_info$rinv
  q <- spline_info$q
  y <- vals
  n <- length(y)

  # Solve spline system to estimate average values for each layer
  sbar <- solve(z, y)

  # Calculate second derivative component and curvature adjustments
  b <- 6 * rinv %*% q %*% sbar
  b0 <- c(0, b)
  b1 <- c(b, 0)
  gamma <- (b1 - b0) / (2 * delta)
  alfa <- sbar - b0 * delta / 2 - gamma * delta^2 / 3

  # Interpolate spline across entire depth profile at specified resolution
  mxd <- max(v)
  xfit <- seq(1, mxd, by = depth_res)
  yfit <- rep(NA, length(xfit))

  for (k in seq_along(xfit)) {
    xd <- xfit[k]

    # Extrapolate above top layer
    if (xd < u[1]) {
      yfit[k] <- alfa[1]
    } else {
      for (i in 1:n) {
        tf2 <- if (i < n) xd > v[i] & xd < u[i + 1] else FALSE

        # Fit within layer
        if (xd >= u[i] & xd <= v[i]) {
          yfit[k] <- alfa[i] + b0[i] * (xd - u[i]) + gamma[i] * (xd - u[i])^2
          break

          # Handle transition between layers
        } else if (tf2) {
          phi <- alfa[i + 1] - b1[i] * (u[i + 1] - v[i])
          yfit[k] <- phi + b1[i] * (xd - v[i])
          break
        }
      }
    }
  }

  # Clip predictions to specified bounds
  yfit[yfit > vhigh] <- vhigh
  yfit[yfit < vlow]  <- vlow

  # Warn if output depth range exceeds available interpolation range
  if (max(dOut) > max(xfit)) {
    warning("Some dOut intervals extend beyond the interpolation range. Averaging only over available depths.")
  }

  # Average spline predictions over requested output depth intervals
  dl <- dOut + 1  # shift to 1-based indexing
  output <- sapply(1:(length(dl) - 1), function(j) {
    start_idx <- min(dl[j], length(yfit))
    end_idx <- min(dl[j + 1] - 1, length(yfit))
    if (start_idx > end_idx) {
      NA
    } else {
      mean(yfit[start_idx:end_idx], na.rm = TRUE)
    }
  })

  return(output)
}
