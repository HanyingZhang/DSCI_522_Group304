# author: Group 304
# date: 2020-01-22

"""This script takes in a cleaned datafile and 
outputs a datafile that contains only schools with both Aboriginal AND Non Aboriginal students

Usage: filter_schools_both_subgroups.py --clean_data=<clean_data> --new_data=<new_data> 

Options:
--clean_data=<clean_data> local path and file name of the clean datafile
--new_data=<new_data> local path and file name of the output dataset that contains only schools with both Aboriginal and Non Aboriginal students
"""
# Example of how to run this script:
# python src/filter_schools_both_subgroups.py --clean_data="data/clean_data.csv" --new_data="data/filtered_schools_both_subgroups.csv"

import pandas as pd

from docopt import docopt
opt = docopt(__doc__)

def main(clean_data, new_data):
  # read in data
  data = pd.read_csv(clean_data)
  
  # This chunk of code filters data to create a filter based on the 2018/2019 school year data
  filtered_data = data[data.year_start == 2018]
  filtered_data = filtered_data[filtered_data.grade == 4]
  filtered_data = filtered_data[filtered_data['sub_population'].isin(['ABORIGINAL', 'NON ABORIGINAL'])]
  filtered_data_num = filtered_data[filtered_data.fsa_skill_code == 'Numeracy']
  
  # Fill a list with the school numbers of schools with both Aboriginal and Non Aboriginal students
  num_filter = []
  for i in data.school_number.unique():
    if filtered_data_num[filtered_data_num.school_number == i].count()['score'] == 2:
      num_filter.append(i)
      
  # Apply the filter for schools with both Aboriginal and Non Aboriginal students
  schools_with_both = data[data.school_number.isin(num_filter)]    
      
  # Reset the index numbers
  schools_with_both = schools_with_both.reset_index()
  schools_with_both.drop(columns = ['Unnamed: 0'], inplace = True)
  
  # Save final cleaned data file to specified local filepath
  schools_with_both.to_csv(new_data)
  
if __name__ == "__main__":
  main(opt["--clean_data"], opt["--new_data"])
