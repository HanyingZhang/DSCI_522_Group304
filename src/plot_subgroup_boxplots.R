# author: Group 304
# date: 2020-02-21

"This script produces a plot of boxplots comparing the distribution of average FSA scores 
by selected subgroups for the 3 FSA tested skills

Usage: plot_subgroup_boxplots.R <arg1> --arg2=<arg2> --arg3=<arg3> --arg4=<arg4> --arg5=<arg5> --arg6=<arg6>

Options:
<arg>             File path (and filename) to the data (required positional argument); example: 'data/clean_data.csv'
--arg2=<arg2>     First subgroup for comparison (required positional argument); example: 'ABORIGINAL'
--arg3=<arg3>     Corresponding second subgroup for comparison (required positional argument); example: 'NON ABORIGINAL'
--arg4=<arg4>     File path (and filename) of output Numeracy score boxplot (required positional argument); example: 'img/fig_ana_numeracy.png'
--arg5=<arg5>     File path (and filename) of output Reading score boxplot (required positional argument); example: 'img/fig_ana_reading.png'
--arg6=<arg6>     File path (and filename) of output Writing score boxplot (required positional argument); example: 'img/fig_ana_writing.png'

" -> doc

# Example:
# Rscript src/plot_subgroup_boxplots.R 'data/clean_data.csv' 
#                                       --arg2='ABORIGINAL' 
#                                       --arg3='NON ABORIGINAL' 
#                                       --arg4='img/fig_ana_numeracy.png' 
#                                       --arg5='img/fig_ana_reading.png' 
#                                       --arg6='img/fig_ana_writing.png' 
# Note: the img folder used in this example must already exist in your project repository for the command line script to work.

library(docopt)
library(readr)
library(tidyverse)

opt <- docopt(doc)

# Loads clean data
data = read_csv(opt$arg1)

# Filters data for only the subgroups selected
filtered_data = data %>%
  filter(sub_population == opt$arg2 | sub_population == opt$arg3)

# Creates subsets of the data for each of the 3 FSA Skill Codes: Numeracy, Reading, and Writing
filtered_data_numeracy <- filtered_data %>%
  filter(fsa_skill_code == 'Numeracy')

filtered_data_reading <- filtered_data %>%
  filter(fsa_skill_code == 'Reading')

filtered_data_writing <- filtered_data %>%
  filter(fsa_skill_code == 'Writing')

# Creates a boxplot for Numeracy
boxplot_numeracy <- ggplot(filtered_data_numeracy, aes(x = sub_population, y = score)) +
  geom_boxplot(width = 0.7 , alpha=0.9 , size=0.3, colour="black") +
  labs(x = 'Sub Group',
       y = 'Average Score',
       title = 'FSA Numeracy Test Scores (2007/08 - 2018/19)') +
  stat_summary(fun.y = mean,
               geom = 'point',
               aes(shape = 'mean'),
               color = 'blue',
               size = 3) +
  scale_shape_manual('', values = c('mean' = 'triangle')) +
  theme_bw()
ggsave(opt$arg4, width = 8, height = 10)

# Creates a boxplot for Reading
boxplot_reading <- ggplot(filtered_data_reading, aes(x = sub_population, y = score)) +
  geom_boxplot(width = 0.7 , alpha=0.9 , size=0.3, colour="black") +
  labs(x = 'Sub Group',
       y = 'Average Score',
       title = 'FSA Reading Test Scores (2007/08 - 2018/19)') +
  stat_summary(fun.y = mean,
               geom = 'point',
               aes(shape = 'mean'),
               color = 'blue',
               size = 3) +
  scale_shape_manual('', values = c('mean' = 'triangle')) +
  theme_bw()
ggsave(opt$arg5, width = 8, height = 10)

# Creates a boxplot for Writing
boxplot_writing <- ggplot(filtered_data_writing, aes(x = sub_population, y = score)) +
  geom_boxplot(width = 0.7 , alpha=0.9 , size=0.3, colour="black") +
  labs(x = 'Sub Group',
       y = 'Average Score',
       title = 'FSA Writing Test Scores (2007/08 - 2018/19)') +
  stat_summary(fun.y = mean,
               geom = 'point',
               aes(shape = 'mean'),
               color = 'blue',
               size = 3) +
  scale_shape_manual('', values = c('mean' = 'triangle')) +
  theme_bw()
ggsave(opt$arg6, width = 8, height = 10)
#ggsave('../../img/fig_test.png', width = 8, height = 10)