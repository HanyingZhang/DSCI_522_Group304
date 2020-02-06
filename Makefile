all: data/filtered_schools_both_subgroups.csv doc/report.md

# Load the 2017/2018 - 2018/2019 data from the Internet
data/fsa_2017-2018.csv : src/load_data.R
	Rscript src/load_data.R 'https://catalogue.data.gov.bc.ca/dataset/5554165d-e365-422f-bf85-4f6e4c9167dc/resource/bcb547f0-8ba7-451f-9e11-10524f4d57a0/download/foundation-skills-assessment-2017-18_to_2018-19.csv' --arg2='data/fsa_2017-2018.csv'

# Load the 2007/2008 - 2016/2017 data from the Internet
data/fsa_2007-2016.csv : src/load_data.R
	Rscript src/load_data.R 'https://catalogue.data.gov.bc.ca/dataset/5554165d-e365-422f-bf85-4f6e4c9167dc/resource/97c6cbf7-f529-464a-b771-9719855b86f6/download/fsa.csv' --arg2='data/fsa_2007-2016.csv'

# Clean the data
data/clean_data.csv : data/fsa_2017-2018.csv data/fsa_2007-2016.csv src/clean_data.py
	python src/clean_data.py --raw_data1='data/fsa_2007-2016.csv' --raw_data2='data/fsa_2017-2018.csv' --local_path='data/clean_data.csv'

# Make a data file that includes only schools with both Aboriginal and Non Aboriginal students
data/filtered_schools_both_subgroups.csv : data/clean_data.csv src/filter_schools_both_subgroups.py
	python src/filter_schools_both_subgroups.py --clean_data='data/clean_data.csv' --new_data='data/filtered_schools_both_subgroups.csv'

# Generate EDA line and bar charts
img/lines_and_bars : data/clean_data.csv src/data_viz_tab.R
	Rscript src/data_viz_tab.R --data='data/clean_data.csv' --out_dir='img'

# Generate Boxplots comparing BC Public and Independent School Mean Aggregate FSA Scores
img/pis : data/clean_data.csv src/plot_publicindep_boxplots.R 
	Rscript src/plot_publicindep_boxplots.R 'data/clean_data.csv' --arg2='img/boxplot_pi.png'

# Generate Boxplots comparing Aboriginal and Non Aboriginal Student Mean Aggregate FSA Scores
img/boxplots : data/clean_data.csv src/plot_subgroup_boxplots.R
	Rscript src/plot_subgroup_boxplots.R 'data/clean_data.csv' --arg2='img/boxplot_ana.png'

# Generate Histogram comparing BC Public and Independent School Mean Aggregate FSA Scores 
img/hist1 : data/clean_data.csv src/plot_publicindep_histogram.R
	Rscript src/plot_publicindep_histogram.R 'data/clean_data.csv' --arg2='img/' --arg3='fig_pi_histogram_numeracy.png' --arg4='fig_pi_histogram_reading.png' --arg5='fig_pi_histogram_writing.png'

# Generate Histogram comparing Aboriginal and Non Aboriginal student Mean Aggregate FSA Scores
img/hist2 : data/clean_data.csv src/plot_subgroup_histogram.R
	Rscript src/plot_subgroup_histogram.R 'data/clean_data.csv' --arg2='img/' --arg3='fig_ana_histogram_numeracy.png' --arg4='fig_ana_histogram_reading.png' --arg5='fig_ana_histogram_writing.png'

# Render the Final Report
doc/report.md : doc/report.Rmd img/lines_and_bars img/pis img/boxplots img/hist1 img/hist2
	Rscript -e "rmarkdown::render('doc/report.Rmd')"

clean:
	rm -f data/*.csv
	rm -f img/*.png
	rm -f doc/report.md
	
