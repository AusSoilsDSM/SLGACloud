webRoot <- 'https://esoil.io/TERNLandscapes/Public'
slgaWebPath <- 'https://www.clw.csiro.au/aclep/soilandlandscapegrid/index.html'

storeRoot='https://esoil.io/TERNLandscapes/Public/Products/TERN'
covariateRoot <- paste0(storeRoot, '/Covariates')

covMetaPath <- paste0(covariateRoot,'/Metadata/CovariateMetaData - 01-12-2020.csv')

slgacodes <-  c("AWC" ,  "BDW"  ,  "CLY",  "DER" ,  "DES" ,  "ECE"  ,  "NTO",   "pHc",  "PTO" ,  "SLT" ,  "SND" ,  "SOC")
slganames <-  c("Avaliable Water Capacity (%)",
                "Bulk Density - Whole Earth (g/cm3)",
                "Clay Content (%)",
                "Depth to Regolith (m)",
                "Depth of Soil (m)",
                "Effective Cation Exchange Capacity (meq/100g)",
                "Total Nitrogen (%)",
                "pH - Calcium Carbonate",
                "Total Phosphorous (%)",
                "Silt Content (%)",
                "Sand Content (%)",
                "Soil Organic Carbon Conetent (%)"
)
SLGAAttributes <- data.frame(code=slgacodes, Desc=slganames)



.onLoad <- function(libname, pkgname) {
  covMeta <<- read.csv(covMetaPath)
}

