# When run, this script will run all scripts to generate the necessary files for this project.

# Loads Data
Rscript src/load_data.R 'https://catalogue.data.gov.bc.ca/dataset/5554165d-e365-422f-bf85-4f6e4c9167dc/resource/bcb547f0-8ba7-451f-9e11-10524f4d57a0/download/foundation-skills-assessment-2017-18_to_2018-19.csv' --arg2='data/fsa_2017-2018.csv'
Rscript src/load_data.R 'https://catalogue.data.gov.bc.ca/dataset/5554165d-e365-422f-bf85-4f6e4c9167dc/resource/97c6cbf7-f529-464a-b771-9719855b86f6/download/fsa.csv' --arg2='data/fsa_2007-2016.csv'

# Cleans Data
python src/clean_data.py --raw_data1='data/fsa_2007-2016.csv' --raw_data2='data/fsa_2017-2018.csv' --local_path='data/clean_data.csv'

# Creates Data Subset of only schools with both Aboriginal and Non Aboriginal students (based on data in 2018/2019 school year)
python src/filter_schools_both_subgroups.py --clean_data='data/clean_data.csv' --new_data='data/filtered_schools_both_subgroups.csv'

# Appends a column to the clean_data file with info about whether the school has both Aboriginal and Non Aboriginal students
python src/add_subgroup_info.py --clean_data="data/clean_data.csv" --new_data="data/new_clean_data.csv"

# Produces EDA Bar and Line Charts
Rscript src/data_viz_tab.R --data='data/clean_data.csv' --out_dir='img'

# Produces Boxplots for Inferential Question 1: Difference Between Public and Independent School Scores
Rscript src/plot_publicindep_boxplots.R 'data/clean_data.csv' --arg2='img/boxplot_pi.png'

# Produces Boxplots for Inferential Question 2: Difference Between Aboriginal and Non Aboriginal Scores
Rscript src/plot_subgroup_boxplots.R 'data/clean_data.csv' --arg2='img/boxplot_ana.png'

# Produces Histograms for Inferential Question 1: Difference Between Public and Independent School Scores
Rscript src/plot_publicindep_histogram.R 'data/clean_data.csv' --arg2='img/' --arg3='fig_pi_histogram_numeracy.png' --arg4='fig_pi_histogram_reading.png' --arg5='fig_pi_histogram_writing.png'

# Produces Histograms for Inferential Question 2: Difference Between Aboriginal and Non Aboriginal Scores
Rscript src/plot_subgroup_histogram.R 'data/clean_data.csv' --arg2='img/' --arg3='fig_ana_histogram_numeracy.png' --arg4='fig_ana_histogram_reading.png' --arg5='fig_ana_histogram_writing.png'

# Renders Report
Rscript -e "rmarkdown::render('doc/report.Rmd')"