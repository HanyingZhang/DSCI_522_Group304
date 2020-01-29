all: doc/report.md 

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
	rm -f doc/report.md
	rm -f img/*.png
	
