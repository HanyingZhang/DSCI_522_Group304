# author: Group_304
# date: 2020-01-16
#
"This script downloads files from public repository and reads into a csv files for the project.

Usage: load_data.R --url_path=<url> --file_path_name=<file_path_name>
" -> doc

library(readr)
library(docopt)

opt <- docopt(doc)

main <- function(url, file_path_name){
  
  # read in data
  file_name <- read.csv(url)
  
  # write data to folder
  write.csv(file_name, file_path_name)

}

main(opt$url, opt$file_path_name)

#rawdata_2007_2016 <- read.csv("https://catalogue.data.gov.bc.ca/dataset/5554165d-e365-422f-bf85-4f6e4c9167dc/resource/97c6cbf7-f529-464a-b771-9719855b86f6/download/fsa.csv")
#rawdata_2017_2018 <- read.csv("https://catalogue.data.gov.bc.ca/dataset/5554165d-e365-422f-bf85-4f6e4c9167dc/resource/bcb547f0-8ba7-451f-9e11-10524f4d57a0/download/foundation-skills-assessment-2017-18_to_2018-19.csv")

#write.csv(data_2007_2016, '/data/rawdata_2007_2016.csv')
#write.csv(data_2017_2018, '/data/rawdata_2017_2018.csv')

