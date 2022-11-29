
# codeDemo
#
#' Code demonstration.
#' @description Run through a quick demonstration of the SLGACloud functions for accessing the SLGA COGs Datastore URLs

#' @author Ross Searle
#' @export


codeDemo <- function(){

cat(crayon::blue("\n\n######################################  Code Demo ############################################\n"))
cat(crayon::blue("\n\nThe SLGACloud package doesn't do that much really.\n"))

cat(crayon::blue("It is essentially just meant to ease access to the TERN Landscapes COGs DataStore URLS while you are \n"))
cat(crayon::blue("working in R, Without having to jump out to the website all the time to copy the required COGs URLs.\n"))
cat(crayon::blue("\nIt also has some utility functions for accessing the Cloud Optimised GeoTIFFs and functions to\n"))
cat(crayon::blue("access some web pages relevant to the Soil and Landscape Grid of Australia.\n"))

cat(crayon::blue("\nYou might also want to have a quick look at the demo about how to access and use COGs in R - codeDemoCOGs().\n"))

cat(crayon::blue('\n\nThis code demo will quickly run you through some of the functions in SLGACloud and show you \n'))
cat(crayon::blue('what information is returned.\n\n'))
invisible(readline(prompt="Press [enter] to start the demo"))


cat(crayon::green('\n\n\nTo find out the allowable metadata query parameters use the getParameterValues() function\n\n'))
invisible(readline(prompt="Press [enter] to get a list of allowable query parameters for the 'Name' field"))
nms <- getParameterValues(Parameter = "Name")
nsmstr <- paste0(nms[1:10,], collapse = ', ')
cat(crayon::red(paste0(nsmstr, '....')))

cat(crayon::green("\n\n\nTo return filtered metadata records - getProductMetaData(Detail = 'High', Product='SLGA', Attribute='Available Water Capacity')\n\n'"))
invisible(readline(prompt="Press [enter] return metadata records"))
print(tibble::as_tibble(getProductMetaData(Detail = 'High', Product='SLGA', Attribute='Available Water Capacity')))


cat(crayon::green('\n\n\nAnd finally to find out locations of relevant SLGA websites -  SLGAWebsites()\n\n'))
invisible(readline(prompt="Press [enter] to list the website URLs"))
print(SLGAWebsites())

cat(crayon::green('\n\nHere endeth the lesson.....\n\nBut we do recommend you have a look at codeDemoCOGs() to see how to use these uRLs in the "terra" package\n '))

}




# codeDemoCOGs
#
#' COGS code demonstration.
#'
#' @description Run through a quick demonstration of using COGS in R with the "terra" package.

#' @author Ross Searle
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
  cat(crayon::green("\nLets start by grabbing a COGs URL using - prods <- getProductMetaData(Detail = 'Low',  Attribute='Clay', Resolution = '90m', Version = 2, Component = 'Modelled-Value)\n\n"))

  invisible(readline(prompt="Press [enter] to get the URL"))
  rsp <- getProductMetaData(Detail = 'Low',  Attribute='Clay', Resolution = '90m', Version = 2, Component = 'Modelled-Value')
  rsp2 <- rsp[1:6,]
  print(rsp2)

  cat(crayon::green('\n\nNow lets load the raster data (5.3Gb) set using - cogLoad("https://esoil.io/TERNLandscapes/Public/Products/TERN/Covariates/Mosaics/90m/Veg_Landsat8Bare2.tif")\n\n'))
  invisible(readline(prompt="Press [enter] to load the raster data"))
  r <- cogLoad(rsp2$StagingPath[1])
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
   e <- terra::ext(145, 146, -25,-24)
   rc <- terra::crop(r, e)
   terra::plot(rc)

   cat(crayon::green('\n\nWow.... So lastly lets extract pixel values for a couple of locations using - \n'))
   cat(crayon::green('\nrl <- c("/vsicurl/https://esoil.io/TERNLandscapes/Public/Products/TERN/Covariates/Mosaics/30m/Other_HYDROXYL-2-PC2.tif",
        "/vsicurl/https://esoil.io/TERNLandscapes/Public/Products/TERN/Covariates/Mosaics/30m/Other_FERRIC-PC4.tif")\n'))
   cat(crayon::green('stk <- rast(rl)\n'))
   cat(crayon::green('pts <- as.matrix(data.frame(x=c(140, 143), y=c(-25, -30)))\n'))
   cat(crayon::green('extract(stk, pts)\n\n'))

   invisible(readline(prompt="Press [enter] to extract pixel values"))
   rl <- c('/vsicurl/https://esoil.io/TERNLandscapes/Public/Products/TERN/Covariates/Mosaics/30m/Other_HYDROXYL-2-PC2.tif',
           '/vsicurl/https://esoil.io/TERNLandscapes/Public/Products/TERN/Covariates/Mosaics/30m/Other_FERRIC-PC4.tif')

   stk <- terra::rast(rl)
   pts <- as.matrix(data.frame(x=c(140, 143), y=c(-25, -30)))
   vals <- terra::extract(stk, pts)
   print(vals)

   cat(crayon::green('\n\nor we could do the same thing using the drillRaster() function in this package\n'))
   cat(crayon::green("\n\nprods <- getProductMetaData(Detail = 'High',  Attribute='Sand', Resolution = '90m') \n"))
   cat(crayon::green("drillRaster(Path = prods$StagingPath[1], Longitude = 151, Latitude = -26) \n"))

   invisible(readline(prompt="Press [enter] to extract pixel values using the drillRasters() function"))
   prods <- getProductMetaData(Detail = 'Low',  Attribute='Sand', Resolution = '90m')
   vals <- drillRaster(COGPath = prods$StagingPath[1], Longitude = 151, Latitude = -26)
   print(vals)

   cat(crayon::green('\n\nOK.... Thats it. Enjoy using your COGs '))

}


