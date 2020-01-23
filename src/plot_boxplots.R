# author: Group 304
# date: 2020-02-21

"This script produces a plot of boxplots comparing the distribution of average FSA scores 
by selected subgroups for the 3 FSA tested skills

Usage: make_boxplot.R <arg1> --arg2=<arg2> --arg3=<arg3> --arg4=<arg4>

Options:
<arg>             Takes in a file path to the data (this is a required positional argument); example: 'data/clean_data.csv'
--arg2=<arg2>     Takes in a file path to save the plot (this is a required positional argument); example: 'img/fig1.png'
--arg3=<arg3>     Takes in the first subgroup for comparison (this is a required positional argument); example: 'ABORIGINAL'
--arg4=<arg4>     Takes in the corresponding second subgroup for comparison (this is a required positional argument); example: 'NON ABORIGINAL'

" -> doc

library(readr)
library(docopt)

opt <- docopt(doc)

data = read_csv(opt$arg1)


filtered_data = data %>%
  filter(sub_population == opt$arg3 | sub_population == opt$arg4)

  









pub_ind_read <- df %>%
  filter(fsa_skill_code == "Reading" & public_or_independent != 'PROVINCE - TOTAL' & data_level == 'SCHOOL LEVEL')

# Makes a boxplot showing the distribution of average Reading test scores for each subgroup
pi_boxplot_reading <- ggplot(pub_ind_read, aes(x = public_or_independent, y = score))+
  geom_boxplot(width = 0.7 , alpha=0.9 , size=0.3, colour="black") +
  labs(y = "Average Score",
       x = "Sub Group",
       title = "FSA Reading Test Scores (2007/08 - 2018/19)") +
  stat_summary(fun.y = mean,
               geom = 'point',
               aes(shape = 'mean'),
               color = 'blue',
               size = 3) +
  scale_shape_manual('', values = c('mean' = 'triangle')) +
  theme_bw()

pi_boxplot_reading