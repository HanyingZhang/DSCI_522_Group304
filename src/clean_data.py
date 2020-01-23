# author: Group 304
# date: 2020-01-21

"""This script takes in 2 .csv files of FSA scores, 
cleans the data, 
merges the files into one,
and writes the cleaned output into a specified location.

Usage: clean_data.py --raw_data1=<raw_data1> --raw_data2=<raw_data2> --local_path=<local_path>

Options:
--raw_data1=<raw_data_file1> local path and file name of the first file you want to clean and include in the final data file
--raw_data2=<raw_data_file2> local path and file name of the second file you want to clean and include in the final data file
--local_path=<local_path> local path and file name of the cleaned output dataset 
"""
# Example of how to run this script:
# python src/clean_data.py --raw_data1="data/fsa_2007-2016.csv" --raw_data2="data/fsa_2017-2018.csv" --local_path="data/clean_data.csv"

import pandas as pd

from docopt import docopt
opt = docopt(__doc__)

def main(raw_data1, raw_data2, local_path):
  # read in data
  data1 = pd.read_csv(raw_data1, usecols = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 16])
  data2 = pd.read_csv(raw_data2, usecols = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 16])

  # Specifies the order the columns should appear in
  column_order = ['SCHOOL_YEAR',
                 'DATA_LEVEL',
                 'PUBLIC_OR_INDEPENDENT',
                 'DISTRICT_NUMBER',
                 'DISTRICT_NAME',
                 'SCHOOL_NUMBER',
                 'SCHOOL_NAME',
                 'SUB_POPULATION',
                 'FSA_SKILL_CODE',
                 'GRADE',
                 'NUMBER_EXPECTED_WRITERS',
                 'NUMBER_WRITERS',
                 'SCORE']
  
  # Reorders the columns in the dataframes so that they're in the same order
  data1 = data1.reindex(columns = column_order)
  data2 = data2.reindex(columns = column_order)
  
  # Stack the dataframes to make one master data file
  raw_data = pd.concat([data1, data2])
  
  # Tidies the column names so that they're all lowercase
  raw_data.columns = map(str.lower, raw_data.columns)
  
  # Splits the school_year into year_start and year_end
  years = raw_data['school_year'].str.split("/", n = 1, expand = True)
  raw_data['year_start'] = years[0]
  raw_data['year_end'] = years[1]
  raw_data.drop(columns = ['school_year'], inplace = True)

  # Removes all rows without FSA score data ('Msk' / NaN)
  clean_data = raw_data[raw_data.score != 'Msk']
  clean_data = clean_data.dropna(subset=['score'])
  
  # Reformats the columns to the right datatypes
  clean_data.score = pd.to_numeric(clean_data.score)
  clean_data.year_start = pd.to_numeric(clean_data.year_start)
  clean_data.year_end = pd.to_numeric(clean_data.year_end)
  clean_data.number_expected_writers = pd.to_numeric(clean_data.number_expected_writers)
  clean_data.number_writers = pd.to_numeric(clean_data.number_writers)

  # Removes all rows where there were no test writers (i.e. also no score data)
  clean_data = clean_data[clean_data.number_writers != 0]
  
  # Keep only the school-level data (remove Provincial and District summary rows)
  clean_data = clean_data[clean_data.data_level == 'SCHOOL LEVEL']
  
  # Reset the index numbers
  clean_data = clean_data.reset_index()
  
  # Save final cleaned data file to specified local filepath
  clean_data.to_csv(local_path)
  
if __name__ == "__main__":
  main(opt["--raw_data1"], opt["--raw_data2"], opt["--local_path"])
