# author: Group 304
# date: 2020-01-22

"""This script takes in a cleaned datafile and 
adds a column of values indicating if the school has BOTH Aboriginal and Non Aboriginal Students

Usage: add_subgroup_info.py --clean_data=<clean_data> --new_data=<new_data> 

Options:
--clean_data=<clean_data> local path and file name of the clean datafile
--new_data=<new_data> local path and file name of the output dataset that contains only schools with both Aboriginal and Non Aboriginal students
"""
# Example of how to run this script:
# python src/add_subgroup_info.py --clean_data="data/clean_data.csv" --new_data="data/new_clean_data.csv"

import pandas as pd

from docopt import docopt
opt = docopt(__doc__)

def main(clean_data, new_data):
  
  # Reads in data
  data = pd.read_csv(clean_data)
  
  # Filters data to create a filter which will be used on the data
  filtered_data = data[data.year_start == 2018]
  filtered_data = filtered_data[filtered_data['sub_population'].isin(['ABORIGINAL', 'NON ABORIGINAL'])]
  filtered_data_num = filtered_data[filtered_data.fsa_skill_code == 'Numeracy']
  
  # Fills a list with the school numbers of schools with both Aboriginal and Non Aboriginal students
  num_filter = []
  for i in data.school_number.unique():
    if filtered_data_num[filtered_data_num.school_number == i].count()['score'] > 2:
      num_filter.append(i)
  
  # Creates an empty dataframe to store schools with both Aboriginal and Non Aboriginal students
  has_both = pd.DataFrame()
  
  # Adds the school numbers to the dataframe of schools with both Aboriginal and Non Aboriginal students
  has_both['school_number'] = num_filter
  has_both['has_both'] = 1
  
  # Adds the information from the 'has_both' table to the main dataset
  result = data.merge(has_both, how = 'left')
  
  # Fills 'has_both' with 0 if the school does not have both Aboriginal and Non Aboriginal students
  result[['has_both']] = result[['has_both']].fillna(value=0)
  
  # Saves final cleaned data file to specified local filepath
  result.to_csv(new_data)
  
if __name__ == "__main__":
  main(opt["--clean_data"], opt["--new_data"])
