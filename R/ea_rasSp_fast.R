#' Fits a mass-preserving spline model to a multi-layer soil property
#' \code{SpatRaster} and returns raster layers containing spline-averaged values
#' over user-defined depth intervals. This function uses precomputed spline matrices
#' for efficiency and applies the spline cell-wise using \code{terra::app()}.
#'
#' @param obj Object of class \code{SpatRaster} with one layer per input depth interval.
#' @param lam Spline stiffness parameter (\eqn{\lambda}); smaller values = smoother splines.
#' @param dIn Numeric vector of input depth boundaries (e.g. \code{c(0,5,15,...)}).
#' @param dOut Numeric vector defining output depth intervals (e.g. \code{c(0,30,60)}).
#' @param vlow Minimum bound to truncate spline predictions (default = 0).
#' @param vhigh Maximum bound to truncate spline predictions (default = 100).
#' @param depth_res Numeric; depth interpolation resolution (e.g. 1 = 1cm, 5 = 5cm).
#'
#' @return A \code{SpatRaster} with one layer per output depth interval.
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
#' aoi <- ext(149.00, 149.10, -36.00, -35.90)
#' clay_crop <- terra::crop(clay_stack, aoi)
#'
#' out <- ea_rasSp_fast(
#'   obj = clay_crop,
#'   lam = 0.1,
#'   dIn = c(0, 5, 15, 30, 60, 100, 200),
#'   dOut = c(0, 30, 60),
#'   depth_res = 2
#' )
#'
#' plot(out)
#' }
#'
#' @keywords methods
#' @export
ea_rasSp_fast <- function(obj,
                          lam = 0.1,
                          dIn = c(0,5,15,30,60,100,200),
                          dOut = c(0,30,60),
                          vlow = 0,
                          vhigh = 100,
                          depth_res = 1) {

  # Precompute the spline matrix components to be reused across all cells
  spline_info <- precompute_spline_structures(dIn = dIn, lam = lam)

  # Stop if the system matrix could not be inverted
  if (is.null(spline_info)) {
    stop("Spline matrix could not be inverted. Check depth intervals or smoothing parameter.")
  }

  # Define a wrapper function that will be applied to each raster cell (profile)
  spline_apply <- function(x) {
    fit_mpspline_optimized(
      vals = x,
      spline_info = spline_info,
      dOut = dOut,
      vlow = vlow,
      vhigh = vhigh,
      depth_res = depth_res
    )
  }

  # Apply the spline function to each cell in the raster
  out_rast <- terra::app(obj, fun = spline_apply, filename = "")

  # Name output layers based on output depth intervals
  names(out_rast) <- paste0(dOut[-length(dOut)], "_", dOut[-1], "cm")

  # Return the final SpatRaster with spline-fitted averages
  return(out_rast)
}
