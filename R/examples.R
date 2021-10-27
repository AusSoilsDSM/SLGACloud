
# codeDemo
#
#' Run through a quick demonstration of the SLGACloud functions
#' @description Run through a quick demonstration of the SLGACloud functions for accessing the TERN Landscapes COGs Datastore URLs
#' @examples
#' #'
#'### Datastore general
#'pingDataStore()
#'COGSDataStoreURLs()
#'
#'### Covariates
#'covariateMetaData(product = '90mCovariates')
#'covariateNames(product = '90mCovariates')
#'covariateCOGsURLs(product = '90mCovariates', layername = 'Veg_Landsat8Bare2')
#'covariateCOGsURLs(product = '30mCovariates', layername = NULL)
#'
#'### Websites
#'openCogsWebsites()
#'openCogsWebsites('90mCovariates', type='Raw')
#'openCogsWebsites('90mCovariates', type='Formatted')
#'
#'### SLGA
#'SLGACodes()
#'SLGANames(product='CLY')
#'slgaCOGsURLs(product = 'AWC', layername=NULL)
#'slgaCOGsURLs(product = 'AWC', layername='AWC_030_060_05_N_P_AU_NAT_C_20140801')
#'
#'####  COGs Utils
#'downloadcog(url='https://esoil.io/TERNLandscapes/Public/Products/TERN/Covariates/Mosaics/90m/Veg_Landsat8Bare2.tif', dest='c:/temp/demoCOG.tif')
#' @export


codeDemo <- function(){

cat(crayon::blue("\n\n######################################  Code Demo ############################################\n"))
cat(crayon::blue("\n\nThe SLGACloud package doesn't do that much really.\n"))

cat(crayon::blue("It is essentially just meant to ease access to the TERN Landscapes COGs DataStore URLS while you are \n"))
cat(crayon::blue("working in R, Without having to jump out to the website all the time to copy the required COGs URLs.\n"))
cat(crayon::blue("\nIt also has some functions for accessing the raster covariate stacks metadata and functions to\n"))
cat(crayon::blue("access the COGS Datastore web pages.\n"))

cat(crayon::blue("\nYou might also want to have a quick look at the demo about how to access and use COGs in R - codeDemoCOGs().\n"))

cat(crayon::blue('\n\nThis code demo will quickly run you through some of the functions in SLGACloud and show you \n'))
cat(crayon::blue('what information is returned.\n\n'))
invisible(readline(prompt="Press [enter] to start the demo"))

cat(crayon::green('\n\nTo check the HTTP COGS Datastore is online use - PingDataStore()\n\n'))
invisible(readline(prompt="Press [enter] see if the Datastore is alive"))
cat(crayon::red(pingDataStore()))

cat(crayon::green('\n\n\nTo get a list of covariate names use - covariateNames(product = "90mCovariates")\n\n'))
invisible(readline(prompt="Press [enter] to get a list of covariate names"))
nms <- covariateNames(product = "90mCovariates")
nsmstr <- paste0(nms[1:10], collapse = ', ')
cat(crayon::red(paste0(nsmstr, '....')))

cat(crayon::green('\n\n\nTo return COGs URLs - covariateCOGsURLs(product = "30mCovariates", layername = NULL)\n\n'))
invisible(readline(prompt="Press [enter] return COGs URLs"))
print(tibble::as_tibble(covariateCOGsURLs(product = '30mCovariates', layername = NULL)))

cat(crayon::green('\n\n\nTo get covariates metadata -  covariateMetaData(product = "90mCovariates")\n\n'))
invisible(readline(prompt="Press [enter] to get some metadata"))
print(tibble::as_tibble(covariateMetaData(product = '90mCovariates')))

cat(crayon::green('\n\n\nAnd finally to open the Datastore web sites -  covariateMetaData(product = "90mCovariates")\n\n'))
invisible(readline(prompt="Press [enter] to open the Datastore website"))
openCogsWebsites('90mCovariates', type='Formatted')

cat(crayon::green('\n\nHere endeth the lesson.....\n\nBut we do recommend you have a look atcodeDemoCOGs() to see how to use these uRLs in the "terra" package\n '))

}




# codeDemoCOGs()
#
#' Run through a quick demonstration of using COGS in R.
#'
#' @description Run through a quick demonstration of using COGS in R with the "terra" package.
#' @examples
#'
#' library(terra)
#'
#' r <- rast('/vsicurl/https://esoil.io/TERNLandscapes/Public/Products/TERN/Covariates/Mosaics/30m/Other_A_MOD_DAY_4dim_3ord_Spatial_Temporal_mean.tif')
#' plot(r)
#'
#' ##### Clip out a section  #######
#' e <- ext(145, 146, -25,-24)
#' rc <- crop(r, e)
#' plot(rc)
#'
#' #### drill pixels  ########
#' rl <- c('/vsicurl/https://esoil.io/TERNLandscapes/Public/Products/TERN/SLGA/CLY/CLY_100_200_EV_N_P_AU_NAT_C_20140801.tif', '/vsicurl/https://esoil.io/TERNLandscapes/Public/Products/TERN/SLGA/CLY/CLY_005_015_EV_N_P_AU_NAT_C_20140801.tif')
#'
#' stk <- rast(rl)
#' pts <- as.matrix(data.frame(x=c(140, 143), y=c(-25, -30)))
#'extract(stk, pts)

#' @export


codeDemoCOGs <- function(){

  cat(crayon::blue("\n\n######################################  Code Demo ############################################\n"))
  cat(crayon::blue("\n\nTo utilise COGs effectively you will need to install the R 'terra' package (the 'raster' package replacement.\n"))

  t <- require('terra')

  if(!t){
    cat(crayon::blue("\n\nIt looks like the 'terra' package is not installed. Lets try and install it now\n"))
    install.packages('terra')
    }


  cat(crayon::blue("\n\nWe will now demonstrate how to access and use some terra functions with COGs \n"))
  cat(crayon::green("\nLets start by grabbing a COGs URL using - covariateCOGsURLs(product = '90mCovariates', layername = 'Veg_Landsat8Bare2')\n\n"))

  invisible(readline(prompt="Press [enter] to get the URL"))
  rsp <- covariateCOGsURLs(product = '90mCovariates', layername = 'Veg_Landsat8Bare2')
  cat(crayon::red(rsp$url))

  cat(crayon::green('\n\nNow lets load the raster data (5.3Gb) set using - loadcog("https://esoil.io/TERNLandscapes/Public/Products/TERN/Covariates/Mosaics/90/Veg_Landsat8Bare2.tif")\n\n'))
  invisible(readline(prompt="Press [enter] to load the raster data"))
  r <- loadcog('https://esoil.io/TERNLandscapes/Public/Products/TERN/Covariates/Mosaics/90m/Relief_mrvbf_3s_mosaic.tif')
  print(r)

  cat(crayon::green('\n\nOK we have our raster, lets have a look at it - plot(r)\n\n'))
  cat(crayon::green('If you see some error messages after this just ignore - there not actual errors;\n\n'))
  invisible(readline(prompt="Press [enter] to plot the raster"))

  o <- try(terra::plot(r), silent=TRUE)

   cat(crayon::green('\n\nCool, now lets clip out a smaller subset area and plot it using\n'))
   cat(crayon::green('\ne <- ext(145, 146, -25,-24)\n'))
   cat(crayon::green('rc <- crop(r, e)\n'))
   cat(crayon::green('plot(rc)\n\n'))

   invisible(readline(prompt="Press [enter] to clip the raster and plot it"))
   e <- ext(145, 146, -25,-24)
   rc <- terra::crop(r, e)
   terra::plot(rc)

   cat(crayon::green('\n\nWow.... So lastly lets extract pixel values for a couple of locations using - \n'))
   cat(crayon::green('\nrl <- c("/vsicurl/https://esoil.io/TERNLandscapes/Public/Products/TERN/SLGA/CLY/CLY_100_200_EV_N_P_AU_NAT_C_20140801.tif",
        "/vsicurl/https://esoil.io/TERNLandscapes/Public/Products/TERN/SLGA/CLY/CLY_005_015_EV_N_P_AU_NAT_C_20140801.tif")\n'))
   cat(crayon::green('stk <- rast(rl)\n'))
   cat(crayon::green('pts <- as.matrix(data.frame(x=c(140, 143), y=c(-25, -30)))\n'))
   cat(crayon::green('extract(stk, pts)\n\n'))

   invisible(readline(prompt="Press [enter] to extract pixel values"))
   rl <- c('/vsicurl/https://esoil.io/TERNLandscapes/Public/Products/TERN/SLGA/CLY/CLY_100_200_EV_N_P_AU_NAT_C_20140801.tif',
           '/vsicurl/https://esoil.io/TERNLandscapes/Public/Products/TERN/SLGA/CLY/CLY_005_015_EV_N_P_AU_NAT_C_20140801.tif')

   stk <- rast(rl)
   pts <- as.matrix(data.frame(x=c(140, 143), y=c(-25, -30)))
   terra::extract(stk, pts)

   cat(crayon::green('\n\nOK.... Thats it. Enjoy using your COGs '))

}


