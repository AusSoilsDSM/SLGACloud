# drillRasters
#
#' Extract values from COGS files at a location
#' @description Drill SLGA rasters at a location.
#' @param Products Dataframe of product records returned from the getProductMetaData() function
#' @param Longitude Longitude value - needs to be with Australia
#' @param Latitude Latitude value - needs to be with Australia
#' @param Verbose return all metadata or just the name and value
#' @return data.frame
#' @examples  prods <- getProductMetaData(Detail = 'Low',  Attribute='Parent_Material', Resolution = '90m')
#' drillRasters(Products = prods[1:3,], Longitude = 151, Latitude = -26, Verbose = F)


#' @details Drill the Cloud Optimised GeoTIFF rasters in the SLGA data store at a given location and return values for that location.
#' @author Ross Searle
#' @export



drillRasters <- function(Products, Longitude, Latitude, Verbose=T){

  if(!pointsInAustralia(Lon=Longitude, Lat = Latitude) ){

    stop('The supplied location is not within Australia')
  }

  pt <- as.matrix(data.frame(x=c(Longitude), y=c(Latitude)))

  odf <- data.frame()

  for (i in 1:nrow(Products)) {

    print(paste0('Drilling raster ', i, ' of ', nrow(Products)))
    rec <- Products[i,]
    #if(!http_error(rec$COGsPath)){
    rl <- terra::rast(paste0('/vsicurl/',rec$COGsPath))
    val <- terra::extract(rl, pt)
    v = as.numeric(val[1,1])
    if(Verbose){
      rdf <- data.frame(rec, Value= v )
    }else{
      rdf <- data.frame(rec$Name, Value= v )
      colnames(rdf) <- c( 'Name', 'Value')
    }

    odf <- rbind(odf, rdf)
    # }else{
    #    print(paste0('URL does not exist - ', rec$COGsPath))
    # }
  }
  return(odf)
}




pointsInAustralia <- function(Lon, Lat){

  outdf <- if(Lon > 112.9211 &  Lon < 153.6386 &  Lat > -43.64309 &  Lat < -9.229727){
    return(T)
  }else{
    return(F)
  }

  # odf <- data.frame(Longitude=lon, Latitude=Lat)
  # pts <- st_as_sf(odf, coords = c("Longitude", "Latitude"), crs = 4326)
  # pt1 = st_sfc(st_point(c(Longitude,Latitude)))
  # sfPt = st_sf(geom = pt1)
  #
  # st_crs(pt1) = 4326
  #
  # da <- convertMetersToArcSecs(Latitude, Radius)
  #
  # buff <- st_buffer( pt1, da)
  # idxs <- which(lengths(st_within(pts, buff)) > 0)
  # op <- pts[idxs,]
}


