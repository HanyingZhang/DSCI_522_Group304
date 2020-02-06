# author: Group 304 (Robert Pimentel)
# date: 2020-01-23

"This script produces 3 histogram comparing FSA average scores (Numeracy, Reading, and Writing) for Aboriginal and Non Aboriginal students
 Histograms include lines depicting the average and a 95% confidence interval

Usage: plot_subgroup_histogram.R <arg1> --arg2=<arg2> --arg3=<arg3> --arg4=<arg4> --arg5=<arg5>

Options:
<arg1>            File path (and filename) to the data (required positional argument); example: 'data/clean_data.csv'
--arg2=<arg2>     Output Directory for plots (required positional argument); example: '/img/'
--arg3=<arg3>     File path (and filename) of output Numeracy score histogram (required positional argument); example: 'fig_ana_numeracy.png'
--arg4=<arg4>     File path (and filename) of output Reading score histogram (required positional argument); example: 'fig_ana_reading.png'
--arg5=<arg5>     File path (and filename) of output Writing score histogram (required positional argument); example: 'fig_ana_writing.png'

" -> doc

# Example:
# Rscript src/plot_subgroup_histogram.R 'data/clean_data.csv' --arg2='img/' --arg3='fig_ana_histogram_numeracy.png' --arg4='fig_ana_histogram_reading.png' --arg5='fig_ana_histogram_writing.png'

# Load require Libraries to write the script.

library(docopt)
library(readr)
library(tidyverse)
library(infer)
library(repr)
library(testthat)
library(cowplot)

opt <- docopt(doc)

#########################

# Tests that the input link is a link to a csv file
test_input <- function(){
  test_that("The clean_data file_path/file_name should be a .csv file.",{
    expect_match(opt$arg1, ".csv")
  })
}
test_input()

# Tests that the outputs are all png files
test_output <- function(){
  test_that("The output should all be .png files.",{
    expect_match(opt$arg2, "img")
    expect_match(opt$arg3, ".png")
    expect_match(opt$arg4, ".png")
    expect_match(opt$arg5, ".png")
  })
}
test_output()

# READ CLEAN DATA
#df <- read_csv('../data/clean_data.csv')
df = read_csv(opt$arg1)

# DATA WRANGLING
# Filters data for only the subgroups of interest
filtered_data = df %>%
  filter(sub_population == 'ABORIGINAL' | sub_population == 'NON ABORIGINAL')

filtered_data$sub_population <- factor(filtered_data$sub_population,
                                       levels = c('ABORIGINAL', 'NON ABORIGINAL'))

# Creates subsets of the data for each of the 3 FSA Skill Codes: Numeracy, Reading, and Writing
filtered_data_numeracy <- filtered_data %>%
  filter(fsa_skill_code == 'Numeracy')

filtered_data_reading <- filtered_data %>%
  filter(fsa_skill_code == 'Reading')

filtered_data_writing <- filtered_data %>%
  filter(fsa_skill_code == 'Writing')


# DEFINE SUBGROUPS
subgroup <- function(group){
  sub_group <- df %>%
    filter(sub_population == group)
}

all_students <- subgroup('ALL STUDENTS') 
female <- subgroup('FEMALE') 
male <- subgroup('MALE')
aboriginal <- subgroup('ABORIGINAL')
non_aboriginal <- subgroup('NON ABORIGINAL') 
eng_lang_learner <- subgroup('ENGLISH LANGUAGE LEARNER') 
non_eng_lang_learner<- subgroup('NON ENGLISH LANGUAGE LEARNER') 
special <- subgroup('SPECIAL NEEDS NO GIFTED')

#CONFINDENCE INTERVAL FUNCTION
set.seed(1234)
ci <- function(df, skill){
  one_sample <- df %>%
    filter(fsa_skill_code == skill) %>%
    rep_sample_n(size = 50) %>%
    ungroup() %>%
    select(score)
  one_sample %>%
    rep_sample_n(size = 50, reps = 5000, replace = TRUE) %>%
    summarize(stat = mean(score)) %>%
    get_ci()
}

######---------- NUMERACY RESULTS------------#########

#CALCULATE AVERAGE & CONFIDENCE INTERVALS
non_ab_numeracy <- filtered_data_numeracy %>%
  group_by(sub_population) %>%
  summarise(avg = mean(score))

sum_ab_num <- tibble("sub_population" = non_ab_numeracy$sub_population,
                     "avg" = non_ab_numeracy$avg,
                     "2.5%" = c(ci(aboriginal, "Numeracy")[[1]], ci(non_aboriginal, "Numeracy")[[1]]),
                     "97.5%" = c(ci(aboriginal, "Numeracy")[[2]], ci(non_aboriginal, "Numeracy")[[2]]))

# Generate Plot
ana_hist_num <- filtered_data_numeracy %>%
  ggplot( aes(x=score, fill=reorder(sub_population, score))) +
  geom_histogram( color="#e9ecef", alpha=0.5, position = 'identity', bins = 50) +
  geom_vline(xintercept = sum_ab_num  [[1,2]], color = "black", size = .9) +
  geom_vline(xintercept = sum_ab_num  [[2,2]], color = "blue", size = .9) +
  geom_vline(xintercept = c(sum_ab_num  [[1,3]], sum_ab_num  [[1,4]]),
             color = "black", lty = 2, size = .7) + 
  geom_vline(xintercept = c(sum_ab_num  [[2,3]], sum_ab_num  [[2,4]]),
             color = "blue", lty = 2, size = .7) +
  scale_fill_manual(values=c("#69b3a2", "#404080")) +
  annotate("text", x = 250, y = 1200, color = 'black', size=6, label = paste("mean = ", round(sum_ab_num  [[1,2]], 2))) +
  annotate("text", x = 625, y = 1200, color = 'blue', size=6, label = paste("mean = ", round(sum_ab_num  [[2,2]], 2))) +
  annotate("text", x = 280, y = 1050, color = 'black', size=6, label = paste(95,"% CI = [",
                                                                    round(sum_ab_num  [[1,3]], 2),",",round(sum_ab_num  [[1,4]], 2),"]")) +
  annotate("text", x = 675, y = 1050, color = 'blue', size=6, label = paste(95,"% CI = [",
                                                                   round(sum_ab_num  [[2,3]], 2),",",round(sum_ab_num  [[2,4]], 2),"]")) +
  labs(y = "Count",
       x = "Average Score",
       fill = "Subgroup",
       title = "FSA Numeracy Test Scores\n(2007/08 - 2018/19)") +
  labs(fill="") +
  theme_bw(base_size=17) +
  theme(plot.title = element_text(size = 24),
        axis.text.x = element_text(size =14),
        axis.title.x = element_text(size = 18))

ana_hist_num <- ana_hist_num + theme(legend.position = c(.30, .98),
                     legend.justification = c("right", "top"))

# Create subdirectory folder if it does not exist
try({
  dir.create(opt$arg2)
})

# Save FSA numerical histogram plot
ggsave(paste0(opt$arg2, opt$arg3), width = 8, height = 5)

######---------- READING RESULTS------------#########

#CALCULATE AVERAGE & CONFIDENCE INTERVALS
non_ab_reading <- filtered_data_reading %>%
  group_by(sub_population) %>%
  summarise(avg = mean(score))

sum_ab_read <- tibble("sub_population" = non_ab_reading$sub_population,
                      "avg" = non_ab_reading$avg,
                      "2.5%" = c(ci(aboriginal, 'Reading')[[1]], ci(non_aboriginal, 'Reading')[[1]]),
                      "97.5%" = c(ci(aboriginal, 'Reading')[[2]], ci(non_aboriginal, 'Reading')[[2]]))

# Generate Plot
ana_hist_read <- filtered_data_reading %>%
  ggplot( aes(x=score, fill=reorder(sub_population, score))) +
  geom_histogram( color="#e9ecef", alpha=0.5, position = 'identity', bins = 50) +
  geom_vline(xintercept = sum_ab_read  [[1,2]], color = "black", size = .9) +
  geom_vline(xintercept = sum_ab_read  [[2,2]], color = "blue", size = .9) +
  geom_vline(xintercept = c(sum_ab_read  [[1,3]], sum_ab_read  [[1,4]]),
             color = "black", lty = 2, size = .7) + 
  geom_vline(xintercept = c(sum_ab_read  [[2,3]], sum_ab_read  [[2,4]]),
             color = "blue", lty = 2, size = .7) +
  scale_fill_manual(values=c("#69b3a2", "#404080")) +
  annotate("text", x = 250, y = 1300, color = 'black', size=6, label = paste("mean = ", round(sum_ab_read  [[1,2]], 2))) +
  annotate("text", x = 600, y = 1300, color = 'blue', size=6, label = paste("mean = ", round(sum_ab_read  [[2,2]], 2))) +
  annotate("text", x = 280, y = 1150, color = 'black', size=6, label = paste(95,"% CI = [",
                                                                    round(sum_ab_read  [[1,3]], 2),",",round(sum_ab_read  [[1,4]], 2),"]")) +
  annotate("text", x = 650, y = 1150, color = 'blue', size=6, label = paste(95,"% CI = [",
                                                                   round(sum_ab_read  [[2,3]], 2),",",round(sum_ab_read  [[2,4]], 2),"]")) +
  labs(y = "Count",
       x = "Average Score",
       fill = "Subgroup",
       title = "FSA Reading Test Scores\n(2007/08 - 2018/19)") +
  labs(fill="") +
  theme_bw(base_size=17) +
  theme(plot.title = element_text(size = 24),
        axis.text.x = element_text(size =14),
        axis.title.x = element_text(size = 18))

ana_hist_read <- ana_hist_read + theme(legend.position = c(.30, .98),
                                     legend.justification = c("right", "top"))

# Create subdirectory folder if it does not exist
try({
  dir.create(opt$arg2)
})

# Save FSA reading histogram plot
ggsave(paste0(opt$arg2, opt$arg4), width = 8, height = 5)

######--------NUMERACY/READING ONE PLOT----#########

theme_set(theme_cowplot())
plot <- plot_grid(ana_hist_num, ana_hist_read)

#Save plot in subdirectory folder resutls
try({
  dir.create(opt$arg2)
})
# Save FSA numeracy and reading histogram in a single plot
ggsave(paste0(opt$arg2, "fig_ana_histograms_join_num_read.png"), width = 20, height = 7)


######---------- WRITING RESULTS------------#########

#CALCULATE AVERAGE & CONFIDENCE INTERVALS
non_ab_writing <- filtered_data_writing %>%
  group_by(sub_population) %>%
  summarise(avg = mean(score))

sum_ab_write <- tibble("sub_population" = non_ab_writing$sub_population,
                       "avg" = non_ab_writing$avg,
                       "2.5%" = c(ci(aboriginal, 'Writing')[[1]], ci(non_aboriginal, 'Writing')[[1]]),
                       "97.5%" = c(ci(aboriginal, 'Writing')[[2]], ci(non_aboriginal, 'Writing')[[2]]))

# Generate Plot
ana_hist_write <- filtered_data_writing %>%
  ggplot( aes(x=score, fill=reorder(sub_population, score))) +
  geom_histogram( color="#e9ecef", alpha=0.5, position = 'identity', bins = 50) +
  geom_vline(xintercept = sum_ab_write  [[1,2]], color = "black", size = .9) +
  geom_vline(xintercept = sum_ab_write  [[2,2]], color = "blue", size = .9) +
  geom_vline(xintercept = c(sum_ab_write  [[1,3]], sum_ab_write  [[1,4]]),
             color = "black", lty = 2, size = .7) + 
  geom_vline(xintercept = c(sum_ab_write  [[2,3]], sum_ab_write  [[2,4]]),
             color = "blue", lty = 2, size = .7) +
  scale_fill_manual(values=c("#69b3a2", "#404080")) +
  # annotate("text", x = 600, y = 1300, color = 'blue', label = paste("mean = ", round(sum_ab_write  [[1,2]], 2))) +
  # annotate("text", x = 600, y = 1800, color = 'red', label = paste("mean = ", round(sum_ab_write  [[2,2]], 2))) +
  # annotate("text", x = 650, y = 1150, color = 'blue', label = paste(95,"% CI = [",
  #                                     round(sum_ab_write  [[1,3]], 2),",",round(sum_ab_write  [[1,4]], 2),"]")) +
  # annotate("text", x = 650, y = 1650, color = 'red', label = paste(95,"% CI = [",
  #                                     round(sum_ab_write  [[2,3]], 2),",",round(sum_ab_write  [[2,4]], 2),"]")) +
  labs(y = "Count",
       x = "Average Score",
       fill = "Subgroup",
       title = "FSA Writing Test Scores\n(2007/08 - 2018/19)") +
  labs(fill="") +
  theme_bw(base_size=17) +
  theme(plot.title = element_text(size = 24),
        axis.text.x = element_text(size =14),
        axis.title.x = element_text(size = 14))

ana_hist_write + theme(legend.position = "bottom")

# Create subdirectory folder if it does not exist
try({
  dir.create(opt$arg2)
})

# Save FSA writing histogram plot
ggsave(paste0(opt$arg2, opt$arg5), width = 6, height = 4)
