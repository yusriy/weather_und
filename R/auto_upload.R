
## To run the Rmarkdown script
library(knitr)
library(markdown)
library(RCurl)


knit2html('R/website_code.Rmd')

rpubsUpload(title='IPULAUPI4',htmlFile = 'website_code.html',
            method = getOption("rpubs.upload.method", "auto"))
