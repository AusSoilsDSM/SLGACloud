
# openCogsWebsites
#
#' Open the various web pages in the TERN Landscapes COGs Data Store
#' @param product Which website to open. Options are 'SLGA', 'COGsMainPage', '90mCovariates', '30mCovariates'
#' @param type Go to the nicely formatted web page or the raw http file listing. Options are 'Formatted' & 'Raw'

#' @examples
#' openCogsWebsites('COGsMainPage')
#' openCogsWebsites('90mCovariates', type='Formatted')
#' openCogsWebsites('30mCovariates', type='Raw')
#' openCogsWebsites('SLGA')
#' @export
openCogsWebsites <- function(product='COGsMainPage', type='Formatted'){

  if(product=='SLGA'){
    browseURL(paste0(slgaWebPath))
  }else if(product=='COGsMainPage'){
    browseURL(paste0(webRoot, '/Pages/COGs/index.html'))
  }
  else if(product=='90mCovariates'){

    if(type=='Formatted'){
      browseURL(paste0(webRoot, '/Pages/COGs/90m_Covariates.html'))
    }else{
      browseURL(paste0(webRoot, '/Products/TERN/Covariates/Mosaics/90m/'))
    }

  }else if(product=='30mCovariates'){

    if(type=='Formatted'){
      browseURL(paste0(webRoot, '/Pages/COGs/30m_Covariates.html'))
    }else{
      browseURL(paste0(webRoot, '/Products/TERN/Covariates/Mosaics/30m/'))
    }

  }


}

