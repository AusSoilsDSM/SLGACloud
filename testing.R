

head( getProductMetaData(Detail = 'High', Product='SLGA', isCurrentVersion = 1))

getProductMetaData(Detail = 'High', Product='SLGA', isCurrentVersion = 1)$Version
#
# getParameterValues(Parameter = 'Product')
#
#
#
print(getParameterValues(Parameter = "Attribute"), n=100)
# print(t, n=100)
#
#
d <- getProductMetaData(Detail = 'High', Product='SLGA', Attribute='Available Water Capacity')
#cogs <- getProductMetaData(Detail = 'Low', Product='SLGA', Attribute='Clay', Component = 'Modelled-Value')
#
# COGSDataStoreURLs()
#
#
# SLGACloud::COGSDataStoreURLs()



# cogDownload(url = cogs$COGsPath[1], dest='c:/temp/demoCOG.tif')
#
# prods <- getProductMetaData(Detail = 'High',  Attribute='Parent_Material', Resolution = '90m')
 drillRaster(COGPath = 'https://esoil.io/TERNLandscapes/Public/Products/TERN/SLGA/AWC/AWC_000_005_EV_N_P_AU_TRN_N_20210614.tif', Longitude = 151, Latitude = -26)
#
#
# cogPreview(urls = cogs$COGsPath[1:6])


# SLGAWebsites()
# SLGAWebsites('TERN Landscapes COGs Datastore Main Page')
