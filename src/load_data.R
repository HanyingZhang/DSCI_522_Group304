# author: Group 304
# date: 2020-01-16

"This script downloads a csv file from a provided link into a specified folder

Usage: load_data.R <arg1> --arg2=<arg2>

Options:
<arg>             Takes in a link to the data (this is a required positional argument); example: 'https://testpage.com/test.csv'
--arg2=<arg2>     Takes in a file path and name (this is a required option); example: 'data/test.csv'

" -> doc

library(readr)
library(docopt)

opt <- docopt(doc)

data = read_csv(opt$arg1)
write_csv(data, opt$arg2)

# Alternative way to do this using commandArgs:
# args = commandArgs(trailingOnly=TRUE)
# data = read.csv(args[1])
# write_csv(data, args[2])

# Example:
# Rscript src/load_data.R 'https://catalogue.data.gov.bc.ca/dataset/5554165d-e365-422f-bf85-4f6e4c9167dc/resource/bcb547f0-8ba7-451f-9e11-10524f4d57a0/download/foundation-skills-assessment-2017-18_to_2018-19.csv' --arg2='data/fsa_2017_2018_test.csv'
# Note: the data folder used in this example must already exist in your project repository for the command line script to work.