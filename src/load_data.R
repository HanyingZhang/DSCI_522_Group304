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

data = read.csv(opt$arg1)
write_csv(data, opt$arg2)

# Alternative way to do this using commandArgs:
# args = commandArgs(trailingOnly=TRUE)
# data = read.csv(args[1])
# write_csv(data, args[2])
