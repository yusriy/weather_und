
## To run the Rmarkdown script

# 1. Load needed libraries
library(knitr) # To use the function `knit2html`
library(markdown) # To use the function `rpubsUpload`
library(RCurl)
library(RSelenium) # To download and submit online forms

# 2. Process the knitr file
knit2html('R/website_code.Rmd')

# 3. Upload the generated file, need to copy the 'continueURL' and paste in a 
# browser to complete the upload
result <- rpubsUpload(title='IPULAUPI4',htmlFile = 'R/website_code.html',
                      method = getOption("rpubs.upload.method", "internal"))
form <- getForm(result$continueUrl, btnG = 'Continue')


browseURL(result$continueUrl)
