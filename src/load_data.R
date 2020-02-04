# author: Group 304 (Anny Chih)
# date: 2020-02-04

"This script downloads a csv file from a provided link into a specified folder

Usage: load_data.R <arg1> --arg2=<arg2>

Options:
<arg>             Takes in a link to the data (this is a required positional argument); example: 'https://testpage.com/test.csv'
--arg2=<arg2>     Takes in a file path and name (this is a required option); example: 'data/test.csv'

" -> doc

# Examples:
# Rscript src/load_data.R 'https://catalogue.data.gov.bc.ca/dataset/5554165d-e365-422f-bf85-4f6e4c9167dc/resource/bcb547f0-8ba7-451f-9e11-10524f4d57a0/download/foundation-skills-assessment-2017-18_to_2018-19.csv' --arg2='data/fsa_2017-2018.csv'
# Rscript src/load_data.R 'https://catalogue.data.gov.bc.ca/dataset/5554165d-e365-422f-bf85-4f6e4c9167dc/resource/97c6cbf7-f529-464a-b771-9719855b86f6/download/fsa.csv' --arg2='data/fsa_2007-2016.csv'

library(readr)
library(docopt)
library(testthat)

opt <- docopt(doc)

######################

# Tests that the input link is a link to a csv file
test_input <- function(){
  test_that("The link should be a link to a .csv file.",{
    expect_match(opt$arg1, ".csv")
  })
}
test_input()

# Tests that the output is a csv file
test_output <- function(){
  test_that("The output file should be a .csv file.",{
    expect_match(opt$arg2, ".csv")
  })
}
test_output()

######################

# Reads the data only if the link is a link to a csv file
if (test_input() == TRUE) {
  data = read_csv(opt$arg1)
  } else {
    print("The url provided should be to a .csv file.")
  }

# Writes the data only if the output is a csv file
if (test_output() == TRUE){
  write_csv(data, opt$arg2)
  }else{
    print("The output file should be a .csv file.")
  }

######################

# Alternative way to do this using commandArgs:
# args = commandArgs(trailingOnly=TRUE)
# data = read.csv(args[1])
# write_csv(data, args[2])

