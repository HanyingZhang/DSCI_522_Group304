all: data/filtered_schools_both_subgroups.csv doc/report.md

data/fsa_2017-2018.csv : src/load_data.R
	Rscript src/load_data.R 'https://catalogue.data.gov.bc.ca/dataset/5554165d-e365-422f-bf85-4f6e4c9167dc/resource/bcb547f0-8ba7-451f-9e11-10524f4d57a0/download/foundation-skills-assessment-2017-18_to_2018-19.csv' --arg2='data/fsa_2017-2018.csv'

data/fsa_2007-2016.csv : src/load_data.R
	Rscript src/load_data.R 'https://catalogue.data.gov.bc.ca/dataset/5554165d-e365-422f-bf85-4f6e4c9167dc/resource/97c6cbf7-f529-464a-b771-9719855b86f6/download/fsa.csv' --arg2='data/fsa_2007-2016.csv'

data/clean_data.csv : data/fsa_2017-2018.csv data/fsa_2007-2016.csv src/clean_data.py
	/opt/miniconda3/envs/mds/bin/python src/clean_data.py --raw_data1='data/fsa_2007-2016.csv' --raw_data2='data/fsa_2017-2018.csv' --local_path='data/clean_data.csv'

data/filtered_schools_both_subgroups.csv : data/clean_data.csv src/filter_schools_both_subgroups.py
	/opt/miniconda3/envs/mds/bin/python src/filter_schools_both_subgroups.py --clean_data='data/clean_data.csv' --new_data='data/filtered_schools_both_subgroups.csv'

img/lines_and_bars : data/clean_data.csv src/data_viz_tab.R
	Rscript src/data_viz_tab.R --data='data/clean_data.csv' --out_dir='img'

img/pis : data/clean_data.csv src/plot_publicindep_boxplots.R 
	Rscript src/plot_publicindep_boxplots.R 'data/clean_data.csv' --arg2='img/fig_pi_numeracy.png' --arg3='img/fig_pi_reading.png' --arg4='img/fig_pi_writing.png'

img/boxplots : data/clean_data.csv src/plot_subgroup_boxplots.R
	Rscript src/plot_subgroup_boxplots.R 'data/clean_data.csv' --arg2='img/fig_ana_numeracy.png' --arg3='img/fig_ana_reading.png' --arg4='img/fig_ana_writing.png'

img/hist1 : data/clean_data.csv src/plot_publicindep_histogram.R
	Rscript src/plot_publicindep_histogram.R 'data/clean_data.csv' --arg2='img/' --arg3='fig_pi_histogram_numeracy.png' --arg4='fig_pi_histogram_reading.png' --arg5='fig_pi_histogram_writing.png'

img/hist2 : data/clean_data.csv src/plot_subgroup_histogram.R
	Rscript src/plot_subgroup_histogram.R 'data/clean_data.csv' --arg2='img/' --arg3='fig_ana_histogram_numeracy.png' --arg4='fig_ana_histogram_reading.png' --arg5='fig_ana_histogram_writing.png'

doc/report.md : doc/report.Rmd img/lines_and_bars img/pis img/boxplots img/hist1 img/hist2
	Rscript -e "rmarkdown::render('doc/report.Rmd')"

clean:
	rm -f data/*.csv
	rm -f img/*.png
	rm -f doc/report.md
	
