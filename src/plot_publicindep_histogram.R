# author: Group 304 (Robert Pimentel)
# date: 2020-01-23

"This script produces 3 histogram comparing FSA average scores (Numeracy, Reading, and Writing) for students in Public schools vs Independent Schools
 Histograms include lines depicting the average and a 95% confidence interval

Usage: plot_publicindep_histogram.R <arg1> --arg2=<arg2> --arg3=<arg3> --arg4=<arg4> --arg5=<arg5>

Options:
<arg1>            File path (and filename) to the data (required positional argument); example: 'data/clean_data.csv'
--arg2=<arg2>     Output Directory for plots (required positional argument); example: '/img/'
--arg3=<arg3>     File path (and filename) of output Numeracy score histogram (required positional argument); example: 'fig_pi_numeracy.png'
--arg4=<arg4>     File path (and filename) of output Reading score histogram (required positional argument); example: 'fig_pi_reading.png'
--arg5=<arg5>     File path (and filename) of output Writing score histogram (required positional argument); example: 'fig_pi_writing.png'

" -> doc

# Example:
# Rscript src/plot_publicindep_histogram.R 'data/clean_data.csv' --arg2='img/' --arg3='fig_pi_histogram_numeracy.png' --arg4='fig_pi_histogram_reading.png' --arg5='fig_pi_histogram_writing.png'


# Load require Libraries to write the script.

library(docopt)
library(readr)
library(tidyverse)
library(infer)
library(repr)

opt <- docopt(doc)


# READ CLEAN DATA
#df <- read_csv('../data/clean_data.csv')
df = read_csv(opt$arg1)

# DATA WRANGLING
pub_ind_num <- df %>%
  filter(fsa_skill_code == "Numeracy", sub_population == "ALL STUDENTS")

pub_ind_read <- df %>%
  filter(fsa_skill_code == "Reading", sub_population == "ALL STUDENTS")

pub_ind_write <- df %>%
  filter(fsa_skill_code == "Writing", sub_population == "ALL STUDENTS")

pub_ind_num$public_or_independent <- factor(pub_ind_num$public_or_independent, 
                                            levels = c('BC Independent School', 'BC Public School'))
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
ci_ind <- function(df, skill, ind, size=50){
  one_sample <- df %>%
    filter(fsa_skill_code == skill & public_or_independent == ind) %>%
    rep_sample_n(size) %>%
    ungroup() %>%
    select(score)
  one_sample %>%
    rep_sample_n(size, reps = 5000, replace = TRUE) %>%
    summarize(stat = mean(score)) %>%
    get_ci()
}


######---------- NUMERACY RESULTS------------#########

#CALCULATE AVERAGES
pub_ind_numeracy <- df %>%
  filter(fsa_skill_code == "Numeracy") %>%
  group_by(sub_population, public_or_independent) %>%
  summarise(avg = mean(score))

#CALCULATE CONFIDENCE INTERVALS

low <- c(ci_ind(aboriginal, "Numeracy", "BC Independent School")[[1]], 
         ci_ind(aboriginal, "Numeracy", "BC Public School")[[1]],
         ci_ind(all_students, "Numeracy", "BC Independent School")[[1]], 
         ci_ind(all_students, "Numeracy", "BC Public School")[[1]],
         ci_ind(eng_lang_learner, "Numeracy", "BC Independent School")[[1]], 
         ci_ind(eng_lang_learner, "Numeracy", "BC Public School")[[1]],
         ci_ind(female, "Numeracy", "BC Independent School")[[1]], 
         ci_ind(female, "Numeracy", "BC Public School")[[1]],
         ci_ind(male, "Numeracy", "BC Independent School")[[1]], 
         ci_ind(male, "Numeracy", "BC Public School")[[1]],
         ci_ind(non_aboriginal, "Numeracy", "BC Independent School")[[1]], 
         ci_ind(non_aboriginal, "Numeracy", "BC Public School")[[1]],
         ci_ind(non_eng_lang_learner, "Numeracy", "BC Independent School")[[1]], 
         ci_ind(non_eng_lang_learner, "Numeracy", "BC Public School")[[1]],
         ci_ind(special, "Numeracy", "BC Independent School", 30)[[1]], 
         ci_ind(special, "Numeracy", "BC Public School", 30)[[1]])

high <- c(ci_ind(aboriginal, "Numeracy", "BC Independent School")[[2]], 
          ci_ind(aboriginal, "Numeracy", "BC Public School")[[2]],
          ci_ind(all_students, "Numeracy", "BC Independent School")[[2]], 
          ci_ind(all_students, "Numeracy", "BC Public School")[[2]],
          ci_ind(eng_lang_learner, "Numeracy", "BC Independent School")[[2]], 
          ci_ind(eng_lang_learner, "Numeracy", "BC Public School")[[2]],
          ci_ind(female, "Numeracy", "BC Independent School")[[2]], 
          ci_ind(female, "Numeracy", "BC Public School")[[2]],
          ci_ind(male, "Numeracy", "BC Independent School")[[2]], 
          ci_ind(male, "Numeracy", "BC Public School")[[2]],
          ci_ind(non_aboriginal, "Numeracy", "BC Independent School")[[2]], 
          ci_ind(non_aboriginal, "Numeracy", "BC Public School")[[2]],
          ci_ind(non_eng_lang_learner, "Numeracy", "BC Independent School")[[2]], 
          ci_ind(non_eng_lang_learner, "Numeracy", "BC Public School")[[2]],
          ci_ind(special, "Numeracy", "BC Independent School", 30)[[2]], 
          ci_ind(special, "Numeracy", "BC Public School", 30)[[2]])


sum_num <- tibble("sub_population" = pub_ind_numeracy$sub_population,
                  "public_or_independent" = pub_ind_numeracy$public_or_independent,
                  "avg" = pub_ind_numeracy$avg,
                  "2.5%" = low,
                  "97.5%" = high)

# FILTER by ALL-STUDENTS and Generate Histogram for Numeracy
pub_ind_num_stat <- sum_num %>% filter(sub_population == "ALL STUDENTS")

pi_hist_num <- pub_ind_num %>%
  ggplot( aes(x=score, fill=reorder(public_or_independent, score))) +
  geom_histogram( color="#e9ecef", alpha=0.7, position = 'identity', bins = 50) +
  geom_vline(xintercept = pub_ind_num_stat [[1,3]], color = "blue") +
  geom_vline(xintercept = pub_ind_num_stat [[2,3]], color = "red") +
  geom_vline(xintercept = c(pub_ind_num_stat [[1,4]], pub_ind_num_stat [[1,5]]),
             color = "blue", lty = 2) + 
  geom_vline(xintercept = c(pub_ind_num_stat [[2,4]], pub_ind_num_stat [[2,5]]),
             color = "red", lty = 2) +
  scale_fill_manual(values=c("#69b3a2", "#404080")) +
  labs(y = "Counts",
       x = "Average Score",
       fill = "School Type",
       title = "FSA Numeracy Test Scores\n(2007/08 - 2018/19)") +
  labs(fill="") +
  theme_bw()

pi_hist_num + theme(legend.position = "bottom")

# Create subdirectory folder if it does not exist
try({
  dir.create(opt$arg2)
})

# Save FSA numerical histogram plot
ggsave(paste0(opt$arg2, opt$arg3), width = 6, height = 4)


######---------- READING RESULTS------------#########

#CALCULATE AVERAGES
pub_ind_reading <- df %>%
  filter(fsa_skill_code == "Reading") %>%
  group_by(sub_population, public_or_independent) %>%
  summarise(avg = mean(score))

#CALCULATE CONFIDENCE INTERVALS

low <- c(ci_ind(aboriginal, "Reading", "BC Independent School")[[1]], 
         ci_ind(aboriginal, "Reading", "BC Public School")[[1]],
         ci_ind(all_students, "Reading", "BC Independent School")[[1]], 
         ci_ind(all_students, "Reading", "BC Public School")[[1]],
         ci_ind(eng_lang_learner, "Reading", "BC Independent School")[[1]], 
         ci_ind(eng_lang_learner, "Reading", "BC Public School")[[1]],
         ci_ind(female, "Reading", "BC Independent School")[[1]], 
         ci_ind(female, "Reading", "BC Public School")[[1]],
         ci_ind(male, "Reading", "BC Independent School")[[1]], 
         ci_ind(male, "Reading", "BC Public School")[[1]],
         ci_ind(non_aboriginal, "Reading", "BC Independent School")[[1]], 
         ci_ind(non_aboriginal, "Reading", "BC Public School")[[1]],
         ci_ind(non_eng_lang_learner, "Reading", "BC Independent School")[[1]], 
         ci_ind(non_eng_lang_learner, "Reading", "BC Public School")[[1]],
         ci_ind(special, "Reading", "BC Independent School",30)[[1]], 
         ci_ind(special, "Reading", "BC Public School",30)[[1]])

high <- c(ci_ind(aboriginal, "Reading", "BC Independent School")[[2]], 
          ci_ind(aboriginal, "Reading", "BC Public School")[[2]],
          ci_ind(all_students, "Reading", "BC Independent School")[[2]], 
          ci_ind(all_students, "Reading", "BC Public School")[[2]],
          ci_ind(eng_lang_learner, "Reading", "BC Independent School")[[2]], 
          ci_ind(eng_lang_learner, "Reading", "BC Public School")[[2]],
          ci_ind(female, "Reading", "BC Independent School")[[2]], 
          ci_ind(female, "Reading", "BC Public School")[[2]],
          ci_ind(male, "Reading", "BC Independent School")[[2]], 
          ci_ind(male, "Reading", "BC Public School")[[2]],
          ci_ind(non_aboriginal, "Reading", "BC Independent School")[[2]], 
          ci_ind(non_aboriginal, "Reading", "BC Public School")[[2]],
          ci_ind(non_eng_lang_learner, "Reading", "BC Independent School")[[2]], 
          ci_ind(non_eng_lang_learner, "Reading", "BC Public School")[[2]],
          ci_ind(special, "Reading", "BC Independent School",30)[[2]], 
          ci_ind(special, "Reading", "BC Public School",30)[[2]])


sum_read <- tibble("sub_population" = pub_ind_reading$sub_population,
                   "public_or_independent" = pub_ind_reading$public_or_independent,
                   "avg" = pub_ind_reading$avg,
                   "2.5%" = low,
                   "97.5%" = high)

# FILTER by ALL-STUDENTS and Generate Histogram for Reading
pub_ind_read_stat <- sum_read %>% filter(sub_population == "ALL STUDENTS")

pi_hist_read <- pub_ind_read %>%
  ggplot( aes(x=score, fill=reorder(public_or_independent, score))) +
  geom_histogram( color="#e9ecef", alpha=0.7, position = 'identity', bins = 50) +
  geom_vline(xintercept = pub_ind_read_stat [[1,3]], color = "blue") +
  geom_vline(xintercept = pub_ind_read_stat [[2,3]], color = "red") +
  geom_vline(xintercept = c(pub_ind_read_stat [[1,4]], pub_ind_read_stat [[1,5]]),
             color = "blue", lty = 2) + 
  geom_vline(xintercept = c(pub_ind_read_stat [[2,4]], pub_ind_read_stat [[2,5]]),
             color = "red", lty = 2) +
  scale_fill_manual(values=c("#69b3a2", "#404080")) +
  labs(y = "Counts",
       x = "Average Score",
       fill = "School Type",
       title = "FSA Reading Test Scores\n(2007/08 - 2018/19)") +
  labs(fill="") +
  theme_bw()

pi_hist_read + theme(legend.position = "bottom")

# Create subdirectory folder if it does not exist
try({
  dir.create(opt$arg2)
})

# Save FSA reading histogram plot
ggsave(paste0(opt$arg2, opt$arg4), width = 6, height = 4)


######---------- WRITING RESULTS------------#########

#CALCULATE AVERAGES
pub_ind_writing <- df %>%
  filter(fsa_skill_code == "Writing") %>%
  group_by(sub_population, public_or_independent) %>%
  summarise(avg = mean(score))

#CALCULATE CONFIDENCE INTERVALS

low <- c(ci_ind(aboriginal, "Writing", "BC Independent School")[[1]], 
         ci_ind(aboriginal, "Writing", "BC Public School")[[1]],
         ci_ind(all_students, "Writing", "BC Independent School")[[1]], 
         ci_ind(all_students, "Writing", "BC Public School")[[1]],
         ci_ind(eng_lang_learner, "Writing", "BC Independent School")[[1]], 
         ci_ind(eng_lang_learner, "Writing", "BC Public School")[[1]],
         ci_ind(female, "Writing", "BC Independent School")[[1]], 
         ci_ind(female, "Writing", "BC Public School")[[1]],
         ci_ind(male, "Writing", "BC Independent School")[[1]], 
         ci_ind(male, "Writing", "BC Public School")[[1]],
         ci_ind(non_aboriginal, "Writing", "BC Independent School")[[1]], 
         ci_ind(non_aboriginal, "Writing", "BC Public School")[[1]],
         ci_ind(non_eng_lang_learner, "Writing", "BC Independent School")[[1]], 
         ci_ind(non_eng_lang_learner, "Writing", "BC Public School")[[1]],
         ci_ind(special, "Writing", "BC Independent School", 30)[[1]], 
         ci_ind(special, "Writing", "BC Public School", 30)[[1]])

high <- c(ci_ind(aboriginal, "Writing", "BC Independent School")[[2]], 
          ci_ind(aboriginal, "Writing", "BC Public School")[[2]],
          ci_ind(all_students, "Writing", "BC Independent School")[[2]], 
          ci_ind(all_students, "Writing", "BC Public School")[[2]],
          ci_ind(eng_lang_learner, "Writing", "BC Independent School")[[2]], 
          ci_ind(eng_lang_learner, "Writing", "BC Public School")[[2]],
          ci_ind(female, "Writing", "BC Independent School")[[2]], 
          ci_ind(female, "Writing", "BC Public School")[[2]],
          ci_ind(male, "Writing", "BC Independent School")[[2]], 
          ci_ind(male, "Writing", "BC Public School")[[2]],
          ci_ind(non_aboriginal, "Writing", "BC Independent School")[[2]], 
          ci_ind(non_aboriginal, "Writing", "BC Public School")[[2]],
          ci_ind(non_eng_lang_learner, "Writing", "BC Independent School")[[2]], 
          ci_ind(non_eng_lang_learner, "Writing", "BC Public School")[[2]],
          ci_ind(special, "Writing", "BC Independent School",30)[[2]], 
          ci_ind(special, "Writing", "BC Public School",30)[[2]])


sum_write <- tibble("sub_population" = pub_ind_writing$sub_population,
                    "public_or_independent" = pub_ind_writing$public_or_independent,
                    "avg" = pub_ind_writing$avg,
                    "2.5%" = low,
                    "97.5%" = high)

# FILTER by ALL-STUDENTS and Generate Histogram for Writing
pub_ind_write_stat <- sum_write %>% filter(sub_population == "ALL STUDENTS")

pi_hist_write <- pub_ind_write %>%
  ggplot( aes(x=score, fill=reorder(public_or_independent, score))) +
  geom_histogram( color="#e9ecef", alpha=0.7, position = 'identity', bins = 50) +
  geom_vline(xintercept = pub_ind_write_stat [[1,3]], color = "blue") +
  geom_vline(xintercept = pub_ind_write_stat [[2,3]], color = "red") +
  geom_vline(xintercept = c(pub_ind_write_stat [[1,4]], pub_ind_write_stat [[1,5]]),
             color = "blue", lty = 2) + 
  geom_vline(xintercept = c(pub_ind_write_stat [[2,4]], pub_ind_write_stat [[2,5]]),
             color = "red", lty = 2) +
  scale_fill_manual(values=c("#69b3a2", "#404080")) +
  labs(y = "Counts",
       x = "Average Score",
       fill = "School Type",
       title = "FSA Writing Test Scores\n(2007/08 - 2018/19)") +
  labs(fill="") +
  theme_bw()

pi_hist_write + theme(legend.position = "bottom")

# Create subdirectory folder if it does not exist
try({
  dir.create(opt$arg2)
})

# Save FSA writing histogram plot
ggsave(paste0(opt$arg2, opt$arg5), width = 6, height = 4)
