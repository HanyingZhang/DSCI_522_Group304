# When run, this script will run all scripts to generate the necessary files for this project.

# Loads Data
Rscript src/load_data.R 'https://catalogue.data.gov.bc.ca/dataset/5554165d-e365-422f-bf85-4f6e4c9167dc/resource/bcb547f0-8ba7-451f-9e11-10524f4d57a0/download/foundation-skills-assessment-2017-18_to_2018-19.csv' --arg2='data/fsa_2017_2018_test.csv'

# Cleans Data
python src/clean_data.py --raw_data1="data/fsa_2007-2016.csv" --raw_data2="data/fsa_2017-2018.csv" --local_path="data/clean_data.csv"

# Produces EDA Bar and Line Charts
Rscript src/data_viz_tab.R --data="data/clean_data.csv" --out_dir="img"

# Produces Boxplots for Inferential Question 1: Difference Between Aboriginal and Non Aboriginal Scores
Rscript src/plot_subgroup_boxplots.R 'data/clean_data.csv' --arg2='img/fig_ana_numeracy.png' --arg3='img/fig_ana_reading.png' --arg4='img/fig_ana_writing.png'

# Produces Boxplots for Inferential Question 2: Difference Between Public and Independent School Scores
Rscript src/plot_publicindep_boxplots.R 'data/clean_data.csv' --arg2='img/fig_pi_numeracy.png' --arg3='img/fig_pi_reading.png' --arg4='img/fig_pi_writing.png'

# Produces Histograms for Inferential Question 1: Difference Between Aboriginal and Non Aboriginal Scores


# Produces Historgrams for Inferential Question 2: Difference Between Public and Independent School Scores


# Renders Report
Rscript -e "rmarkdown::render('doc/report.Rmd')"
