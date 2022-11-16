library(jsonlite)


webRoot <- 'https://esoil.io/TERNLandscapes/Public'
slgaWebPath <- 'https://esoil.io/TERNLandscapes/Public/Pages/SLGA'
apiRoot <- 'https://esoil.io/TERNLandscapes/RasterProductsAPI'

storeRoot='https://esoil.io/TERNLandscapes/Public/Products/TERN'
covariateRoot <- paste0(storeRoot, '/Covariates')


.onLoad <- function(libname, pkgname) {

  url <- paste0(apiRoot, '/QueryParameterValues?format=json&parameter=DataType')
#  print(url)
  r <- httr::GET(url)

  packageStartupMessage(crayon::cyan (paste0('\n\nThis package relies on a web API located at ', apiRoot, '\n\n')))

  if(r$status_code == 200){
        paste0(packageStartupMessage(crayon::green('We are connected to the Web API and are good to go....')))
      }else{
        paste0(packageStartupMessage(crayon::red('Oops!!!! There is a problem talking to the data store at - ', apiRoot, '. \n\nThis package will not function properly without this connection.')))
  }
return('')
}


