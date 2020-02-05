# author: Group 304 (Anny Chih)
# date: 2020-02-21

"This script produces 3 boxplots comparing FSA scores (Numeracy, Reading, and Writing) for students in Public schools vs Independent Schools

Usage: plot_subgroup_boxplots.R <arg1> --arg2=<arg2> --arg3=<arg3> --arg4=<arg4>

Options:
<arg>             File path (and filename) to the data (required positional argument); example: 'data/clean_data.csv'
--arg2=<arg2>     File path (and filename) of output Numeracy score boxplot (required positional argument); example: 'img/fig_pi_numeracy.png'
--arg3=<arg3>     File path (and filename) of output Reading score boxplot (required positional argument); example: 'img/fig_pi_reading.png'
--arg4=<arg4>     File path (and filename) of output Writing score boxplot (required positional argument); example: 'img/fig_pi_writing.png'

" -> doc

# Example:
# Rscript src/plot_publicindep_boxplots.R 'data/clean_data.csv' --arg2='img/fig_pi_numeracy.png' --arg3='img/fig_pi_reading.png' --arg4='img/fig_pi_writing.png'
# Note: the img folder used in this example must already exist in your project repository for the command line script to work.

library(docopt)
library(readr)
library(tidyverse)
library(testthat)

opt <- docopt(doc)

# Tests that the input link is a link to a csv file
test_input <- function(){
  test_that("The link should be a link to a .csv file.",{
    expect_match(opt$arg1, ".csv")
  })
}
test_input()

# Tests that the outputs are all png files
test_output <- function(){
  test_that("The output files should all be .png files.",{
    expect_match(opt$arg2, ".png")
    expect_match(opt$arg3, ".png")
    expect_match(opt$arg4, ".png")
  })
}
test_output()

# Loads clean data
data = read_csv(opt$arg1)

# Creates subsets of the data for each of the 3 FSA Skill Codes: Numeracy, Reading, and Writing
filtered_data_numeracy <- data %>%
  filter(fsa_skill_code == 'Numeracy')

filtered_data_reading <- data %>%
  filter(fsa_skill_code == 'Reading')

filtered_data_writing <- data %>%
  filter(fsa_skill_code == 'Writing')

# Creates a boxplot for Numeracy
boxplot_pi_numeracy <- ggplot(filtered_data_numeracy, aes(x = public_or_independent, y = score)) +
  geom_boxplot(width = 0.7 , alpha=0.9 , size=0.3, colour="black") +
  labs(x = 'Subgroup',
       y = 'Average Score',
       title = 'FSA Numeracy Test Scores (2007/08 - 2018/19)') +
  stat_summary(fun.y = mean,
               geom = 'point',
               aes(shape = 'mean'),
               colour = '#20A9B9',
               size = 3) +
  scale_shape_manual('', values = c('mean' = 'triangle')) +
  theme_bw(base_size = 17)
ggsave(opt$arg2, width = 8, height = 10)

# Creates a boxplot for Reading
boxplot_pi_reading <- ggplot(filtered_data_reading, aes(x = public_or_independent, y = score)) +
  geom_boxplot(width = 0.7 , alpha=0.9 , size=0.3, colour="black") +
  labs(x = 'Subgroup',
       y = 'Average Score',
       title = 'FSA Reading Test Scores (2007/08 - 2018/19)') +
  stat_summary(fun.y = mean,
               geom = 'point',
               aes(shape = 'mean'),
               colour = '#20A9B9',
               size = 3) +
  scale_shape_manual('', values = c('mean' = 'triangle')) +
  theme_bw(base_size = 17)
ggsave(opt$arg3, width = 8, height = 10)

# Creates a boxplot for Writing
boxplot_pi_writing <- ggplot(filtered_data_writing, aes(x = public_or_independent, y = score)) +
  geom_boxplot(width = 0.7 , alpha=0.9 , size=0.3, colour="black") +
  labs(x = 'Subgroup',
       y = 'Average Score',
       title = 'FSA Writing Test Scores (2007/08 - 2018/19)') +
  stat_summary(fun.y = mean,
               geom = 'point',
               aes(shape = 'mean'),
               colour = '#20A9B9',
               size = 3) +
  scale_shape_manual('', values = c('mean' = 'triangle')) +
  theme_bw(base_size = 17)
ggsave(opt$arg4, width = 8, height = 10)
