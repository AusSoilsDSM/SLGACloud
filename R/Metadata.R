
# getParameterValues
#
#' Get allowable query parameter values
#' @description Returns a tibble of allowable query parameter values
#' @param Parameter The allowable parameters that can be filtered on are 'Attribute', 'DataType', 'Product', 'Source', 'Component', 'Name' and  'Resolution'
#' @examples getParameterValues(Parameter = 'Product')
#' getParameterValues(Parameter = 'Source')


#' @details  This function provides the allowable values for filtering metadata records on.
#' @author Ross Searle
#' @return data.frame
#' @export

getParameterValues <- function(Parameter='Name'){
  res <- jsonlite::fromJSON(utils::URLencode(paste0(apiRoot, '/QueryParameterValues?format=json&parameter=',Parameter)))
  return(res)
}





# getProductMetaData
#
#' Get Product MetaData
#' @description Returns a tibble of available SLGA product metadata
#' @param Detail The amount of information to return. Options are 'Low' (Name &  COGsPath),'Moderate', (Name, COGsPath, UpperDepth_m, LowerDepth_m & Units) and High (All metadata)
#' @param Product Filter by Product ('SLGA', '30m_Covariate' or '90m_Covariate').
#' @param DataType Filter by DataType ('Soil' or 'DSM_Covariate').
#' @param Source Filter by Source - who generated the data.
#' @param Attribute Filter by Attribute.
#' @param Component Filter by Component (' Modelled-Value', 'Lower-CI', 'Upper-CI', 'Value').
#' @param Resolution Filter by spatial resolution ('90m' or '30m').
#' @param Name Filter by the data set name.
#' @param Version Filter by version number (current options are 1 or 2).
#' @param isCurrentVersion  return only the latest version of a product (1 for True and 0 for False).
#' @examples getProductMetaData(Detail = 'High', Product='SLGA', Attribute='Available Water Capacity')

#' @details The datastore can be queried to return filtered lists of metadata. The allowable values for filtering can be accessed using the getParameterValues() function
#' @author Ross Searle
#' @return data.frame
#' @export

getProductMetaData <- function(Detail='High', Product=NULL, DataType=NULL, Source=NULL, Attribute=NULL,	Component=NULL, Name=NULL, Resolution=NULL, Version=NULL, isCurrentVersion=NULL){

  p <- ''
  if(!is.null(Product)){p <- paste0(p, '&product=',Product)}
  if(!is.null(DataType)){p <- paste0(p, '&datatype=',DataType)}
  if(!is.null(Source)){p <- paste0(p, '&source=',Source)}
  if(!is.null(Attribute)){p <- paste0(p, '&attribute=',Attribute)}
  if(!is.null(Component)){p <- paste0(p, '&component=',Component)}
  if(!is.null(Name)){p <- paste0(p, '&name=',Name)}
  if(!is.null(Resolution)){p <- paste0(p, '&resolution=',Resolution)}
  if(!is.null(Version)){p <- paste0(p, '&version=',Version)}
  if(!is.null(isCurrentVersion)){p <- paste0(p, '&isCurrentVersion=',isCurrentVersion)}

  url <- utils::URLencode(paste0(apiRoot, '/ProductInfo?format=json', p))

  res <- jsonlite::fromJSON(url)

  if(Detail=='Low'){
   odf <- data.frame(Name= res$Name, COGsPath=res$COGsPath,  StagingPath=res$StagingPath)
  }else if(Detail=='Moderate'){
    odf <- data.frame(Name= res$Name, COGsPath=res$COGsPath,  StagingPath=res$StagingPath, UpperDepth_m= res$UpperDepth_m, LowerDepth_m=res$LowerDepth_m, Units=res$Units)
  }else{
    odf <- res
  }

  return(odf)

}
