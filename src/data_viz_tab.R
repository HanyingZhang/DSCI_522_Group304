# author: Group 304
# date: 2020-01-22

"Creates exploratory data visualization(s) and table(s) for the cleaned data
Saves the plots as png files.

Usage: src/data_viz_tab.r --input=<input> --out_dir=<out_dir>
  
Options:
--input=<input>       Path (including filename) to cleaned data (which needs to be saved as a csv file).
--out_dir=<out_dir>   Path to directory where the plots should be saved
" -> doc

library(docopt)
library(dplyr)
library(janitor)
library(infer)
library(repr)
library(gridExtra)
library(ggridges)

opt <- docopt(doc)

main <- function(data, out_dir){
  # load data
  df <- read_csv(data) 
  
  ci <- function(df, skill){
    one_sample <- df %>%
      filter(fsa_skill_code == skill) %>%
      rep_sample_n(size = 40) %>%
      ungroup() %>%
      select(score)
    one_sample %>%
      rep_sample_n(size = 40, reps = 1000, replace = TRUE) %>%
      summarize(stat = mean(score)) %>%
      get_ci()
  }
  ci_ind <- function(df, skill, ind){
    one_sample <- df %>%
      filter(fsa_skill_code == skill & public_or_independent == ind) %>%
      rep_sample_n(size = 40) %>%
      ungroup() %>%
      select(score)
    one_sample %>%
      rep_sample_n(size = 40, reps = 1000, replace = TRUE) %>%
      summarize(stat = mean(score)) %>%
      get_ci()
  }
  
  pub_ind_numeracy <- df %>%
    filter(fsa_skill_code == "Numeracy" & public_or_independent != 'PROVINCE - TOTAL') %>%
    group_by(sub_population, public_or_independent) %>%
    summarise(avg = mean(score))
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
           ci_ind(special, "Numeracy", "BC Independent School")[[1]], 
           ci_ind(special, "Numeracy", "BC Public School")[[1]])
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
            ci_ind(special, "Numeracy", "BC Independent School")[[2]], 
            ci_ind(special, "Numeracy", "BC Public School")[[2]])
  
  # Plot summary statistic table for numeracy
  sum_num <- tibble("sub_population" = pub_ind_numeracy$sub_population,
                    "public_or_independent" = pub_ind_numeracy$public_or_independent,
                    "avg" = pub_ind_numeracy$avg,
                    "2.5%" = low,
                    "97.5%" = high)
  p1 <- ggpairs(sum_num)
  
  # Save summary statistic table for numeracy
  ggsave(plot = p1,
         filename = paste0(out_dir, "sum_stat_numeracy.png"),
         width = 10,
         height = 10)
  
  # Plot bar chart for numeracy
  bar_plot_numeracy <- ggplot(sum_num, aes(x = sub_population, y = avg))+
    geom_col(aes(fill = public_or_independent), width = 0.7 , alpha=0.9 , size=0.3, colour="black",position = "dodge") +
    labs(y = "Average Score",
         x = "Sub_Group",
         fill = "School Type",
         title = "2007-2018 FSA - Numeracy Test ") +
    theme(legend.position = "bot") +
    coord_flip() +
    theme_bw()
  ggsave(plot = bar_plot_numeracy,
         filename = paste0(out_dir, "bar_plot_numeracy.png"),
        )
  
  pub_ind_reading <- df %>%
    filter(fsa_skill_code == "Reading" & public_or_independent != 'PROVINCE - TOTAL' & data_level == 'SCHOOL LEVEL') %>%
    group_by(sub_population, public_or_independent) %>%
    summarise(avg = mean(score))
  
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
           ci_ind(special, "Reading", "BC Independent School")[[1]], 
           ci_ind(special, "Reading", "BC Public School")[[1]])
  
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
            ci_ind(special, "Reading", "BC Independent School")[[2]], 
            ci_ind(special, "Reading", "BC Public School")[[2]])
  
  # Plot summary statistic table for reading
  sum_read <- tibble("sub_population" = pub_ind_reading$sub_population,
                     "public_or_independent" = pub_ind_reading$public_or_independent,
                     "avg" = pub_ind_reading$avg,
                     "2.5%" = low,
                     "97.5%" = high)
  p2 <- ggpairs(sum_read)
  
  # Save summary statistic table for reading
  ggsave(plot = p2,
         filename = paste0(out_dir, "sum_stat_reading.png"),
         width = 10,
         height = 10)
  
  # Plot bar chart for reading
  bar_plot_reading <- ggplot(sum_read, aes(x = sub_population, y = avg))+
    geom_col(aes(fill = public_or_independent), width = 0.7 , alpha=0.9 , size=0.3, colour="black",position = "dodge") +
    labs(y = "Average Score",
         x = "Sub_Group",
         fill = "School Type",
         title = "2007-2018 FSA - Reading Test ") +
    theme(legend.position = "bot") +
    coord_flip() +
    theme_bw()
  
  ggsave(plot = bar_plot_reading,
         filename = paste0(out_dir, "bar_plot_reading.png"),
  )
  
  
  pub_ind_writing <- df %>%
    filter(fsa_skill_code == "Writing" & public_or_independent != 'PROVINCE - TOTAL' & data_level == 'SCHOOL LEVEL') %>%
    group_by(sub_population, public_or_independent) %>%
    summarise(avg = mean(score))
  
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
           ci_ind(special, "Writing", "BC Independent School")[[1]], 
           ci_ind(special, "Writing", "BC Public School")[[1]])
  
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
            ci_ind(special, "Writing", "BC Independent School")[[2]], 
            ci_ind(special, "Writing", "BC Public School")[[2]])
  
  # Plot summary statistic table for writing
  sum_write <- tibble("sub_population" = pub_ind_writing$sub_population,
                      "public_or_independent" = pub_ind_writing$public_or_independent,
                      "avg" = pub_ind_writing$avg,
                      "2.5%" = low,
                      "97.5%" = high)
  p3 <- ggpairs(sum_write)
  
  # Save summary statistic table for reading
  ggsave(plot = p3,
         filename = paste0(out_dir, "sum_stat_writing.png"),
         width = 10,
         height = 10)
  
  # Plot bar chart for writing
  bar_plot_writing <- ggplot(sum_write, aes(x = sub_population, y = avg))+
    geom_col(aes(fill = public_or_independent), width = 0.7 , alpha=0.9 , size=0.3, colour="black",position = "dodge") +
    labs(y = "Average Score",
         x = "Sub_Group",
         fill = "School Type",
         title = "2007-2018 FSA - Writing Test ") +
    theme(legend.position = "bot") +
    coord_flip() +
    theme_bw()
  
  ggsave(plot = bar_plot_writing,
         filename = paste0(out_dir, "bar_plot_writing.png"),
  )
  
  # Plot summary statistic table for non-ab vs ab in numeracy
  non_ab_numeracy <- df %>%
    filter(fsa_skill_code == "Numeracy" & public_or_independent == 'PROVINCE - TOTAL') %>%
    filter(sub_population == "ABORIGINAL" | sub_population == "NON ABORIGINAL") %>%
    group_by(sub_population) %>%
    summarise(avg = mean(score))
  
  sum_ab_num <- tibble("sub_population" = non_ab_numeracy$sub_population,
                       "avg" = non_ab_numeracy$avg,
                       "2.5%" = c(ci(aboriginal, "Numeracy")[[1]], ci(non_aboriginal, "Numeracy")[[1]]),
                       "97.5%" = c(ci(aboriginal, "Numeracy")[[2]], ci(non_aboriginal, "Numeracy")[[2]]))
  p4 <- ggpairs(sum_ab_num)
  
  # Save summary statistic table for na vs ab in numeracy
  ggsave(plot = p4,
         filename = paste0(out_dir, "sum_stat_ab_numeracy.png"),
         width = 10,
         height = 10)
  
  # Plot bar chart
  ab_bar_plot_numeracy <- ggplot(sum_ab_num, aes(x = sub_population, y = avg))+
    geom_col(width = 0.7 , alpha=0.9 , size=0.3, colour="black",position = "dodge") +
    labs(y = "Average Score",
         x = "Sub_Group",
         title = "BC Schols 2007-2018 FSA - Numeracy Test ") +
    theme(legend.position = "bot") +
    theme_bw()
  ggsave(plot = ab_bar_plot_numeracy,
         filename = paste0(out_dir, "bar_plot_ab_numeracy.png"),
  )
  
  # Plot summary statistic table for na vs ab in reading
  non_ab_reading <- df %>%
    filter(fsa_skill_code == "Reading" & public_or_independent == 'PROVINCE - TOTAL') %>%
    filter(sub_population == "ABORIGINAL" | sub_population == "NON ABORIGINAL") %>%
    group_by(sub_population) %>%
    summarise(avg = mean(score))
  
  sum_ab_read <- tibble("sub_population" = non_ab_reading$sub_population,
                        "avg" = non_ab_reading$avg,
                        "2.5%" = c(ci(aboriginal, "Reading")[[1]], ci(non_aboriginal, "Reading")[[1]]),
                        "97.5%" = c(ci(aboriginal, "Reading")[[2]], ci(non_aboriginal, "Reading")[[2]]))
  
  p5 <- ggpairs(sum_ab_read)
  
  # Save summary statistic table for na vs ab in reading
  ggsave(plot = p5,
         filename = paste0(out_dir, "sum_stat_ab_reading.png"),
         width = 10,
         height = 10)
  
  # Plot bar chart
  ab_bar_plot_read <- ggplot(sum_ab_read, aes(x = sub_population, y = avg))+
    geom_col(width = 0.7 , alpha=0.9 , size=0.3, colour="black",position = "dodge") +
    labs(y = "Average Score",
         x = "Sub_Group",
         title = "BC Schools 2007-2018 FSA - Reading Test ") +
    theme(legend.position = "bot") +
    theme_bw()
  ggsave(plot = ab_bar_plot_read,
         filename = paste0(out_dir, "bar_plot_ab_reading.png"),
  )
  
  # Plot summary statistic table for na vs ab in writing
  non_ab_writing <- df %>%
    filter(fsa_skill_code == "Writing" & public_or_independent == 'PROVINCE - TOTAL') %>%
    filter(sub_population == "ABORIGINAL" | sub_population == "NON ABORIGINAL") %>%
    group_by(sub_population) %>%
    summarise(avg = mean(score))
  
  sum_ab_write <- tibble("sub_population" = non_ab_writing$sub_population,
                         "avg" = non_ab_writing$avg,
                         "2.5%" = c(ci(aboriginal, "Writing")[[1]], ci(non_aboriginal, "Writing")[[1]]),
                         "97.5%" = c(ci(aboriginal, "Writing")[[2]], ci(non_aboriginal, "Writing")[[2]]))
  p6 <- ggpairs(sum_ab_write)
  
  # Save summary statistic table for na vs ab in reading
  ggsave(plot = p6,
         filename = paste0(out_dir, "sum_stat_ab_writing.png"),
         width = 10,
         height = 10)
  
  # Plot bar chart
  ab_bar_plot_write <- ggplot(sum_ab_write, aes(x = sub_population, y = avg))+
    geom_col(width = 0.7 , alpha=0.9 , size=0.3, colour="black",position = "dodge") +
    labs(y = "Average Score",
         x = "Sub_Group",
         title = "BC Schools 2007-2018 FSA - Reading Test ") +
    theme(legend.position = "bot") +
    theme_bw()
  ggsave(plot = ab_bar_plot_write,
         filename = paste0(out_dir, "bar_plot_ab_writing.png")
  ) 
  
  #Plot scatterplot for public vs independent in numeracy
  pub_ind_numeracy_year <- df %>%
    filter(fsa_skill_code == "Numeracy" & public_or_independent != 'PROVINCE - TOTAL') %>%
    group_by(year_start, public_or_independent) %>%
    summarise(avg = mean(score))
  
  scatter_plot_numeracy <- pub_ind_numeracy_year %>%
    ggplot(aes(x = year_start, y = avg)) +
    geom_point(color = public_or_independent) +
    labs(x = "School year start", y = "Mean FSA score", title = "BC Schools 2007-2018 FSA - Numeracy Test ") +
    theme_bw()
  ggsave(plot = scatter_plot_numeracy,
         filename = paste0(out_dir, "scatter_ind_numeracy.png"))
  
  #Plot scatterplot for public vs independent in reading
  pub_ind_read_year <- df %>%
    filter(fsa_skill_code == "Reading" & public_or_independent != 'PROVINCE - TOTAL') %>%
    group_by(year_start, public_or_independent) %>%
    summarise(avg = mean(score))
  
  scatter_plot_read <- pub_ind_read_year %>%
    ggplot(aes(x = year_start, y = avg)) +
    geom_point(color = public_or_independent) +
    labs(x = "School year start", y = "Mean FSA score", title = "BC Schools 2007-2018 FSA - Reading Test ") +
    theme_bw()
  ggsave(plot = scatter_plot_read,
         filename = paste0(out_dir, "scatter_ind_read.png"))
  
  #Plot scatterplot for public vs independent in writing
  pub_ind_write_year <- df %>%
    filter(fsa_skill_code == "Writing" & public_or_independent != 'PROVINCE - TOTAL') %>%
    group_by(year_start, public_or_independent) %>%
    summarise(avg = mean(score))
  
  scatter_plot_write <- pub_ind_read_write %>%
    ggplot(aes(x = year_start, y = avg)) +
    geom_point(color = public_or_independent) +
    labs(x = "School year start", y = "Mean FSA score", title = "BC Schools 2007-2018 FSA - Writing Test ") +
    theme_bw()
  ggsave(plot = scatter_plot_write,
         filename = paste0(out_dir, "scatter_ind_write.png"))
  
  #Plot scatterplot for na vs ab in numeracy
  ab_numeracy_year <- df %>%
    filter(fsa_skill_code == "Numeracy" & public_or_independent == 'PROVINCE - TOTAL') %>%
    filter(sub_population == "ABORIGINAL" | sub_population == "NON ABORIGINAL") %>%
    group_by(year_start, sub_population) %>%
    summarise(avg = mean(score))
  
  scatter_plot_numeracy <- ab_numeracy_year %>%
    ggplot(aes(x = year_start, y = avg)) +
    geom_point(color = subgroup) +
    labs(x = "School year start", y = "Mean FSA score", title = "BC Schools 2007-2018 FSA - Numeracy Test ") +
    theme_bw()
  ggsave(plot = scatter_plot_numeracy,
         filename = paste0(out_dir, "scatter_ab_numeracy.png"))
  
  #Plot scatterplot for na vs ab in numeracy
  ab_reading_year <- df %>%
    filter(fsa_skill_code == "Reading" & public_or_independent == 'PROVINCE - TOTAL') %>%
    filter(sub_population == "ABORIGINAL" | sub_population == "NON ABORIGINAL") %>%
    group_by(year_start, sub_population) %>%
    summarise(avg = mean(score))
  
  scatter_plot_reading <- ab_reading_year %>%
    ggplot(aes(x = year_start, y = avg)) +
    geom_point(color = subgroup) +
    labs(x = "School year start", y = "Mean FSA score", title = "BC Schools 2007-2018 FSA - Numeracy Test ") +
    theme_bw()
  ggsave(plot = scatter_plot_reading,
         filename = paste0(out_dir, "scatter_ab_reading.png"))
  
  #Plot scatterplot for na vs ab in writing
  ab_write_year <- df %>%
    filter(fsa_skill_code == "Writing" & public_or_independent == 'PROVINCE - TOTAL') %>%
    filter(sub_population == "ABORIGINAL" | sub_population == "NON ABORIGINAL") %>%
    group_by(year_start, sub_population) %>%
    summarise(avg = mean(score))
  
  scatter_plot_write <- ab_write_year %>%
    ggplot(aes(x = year_start, y = avg)) +
    geom_point(color = subgroup) +
    labs(x = "School year start", y = "Mean FSA score", title = "BC Schools 2007-2018 FSA - Numeracy Test ") +
    theme_bw()
  ggsave(plot = scatter_plot_write,
         filename = paste0(out_dir, "scatter_ab_write.png"),)
}  

main(opt[["--train"]], opt[["--out_dir"]])


