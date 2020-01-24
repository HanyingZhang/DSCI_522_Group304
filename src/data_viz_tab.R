# author: Group 304
# date: 2020-01-22

"Creates exploratory data visualization(s) and table(s) for the cleaned data
Saves the plots as png files.

Usage: src/data_viz_tab.r --data=<input> --out_dir=<out_dir>
  
Options:
--data=<input>       Path (including filename) to cleaned data (which needs to be saved as a csv file).
--out_dir=<out_dir>   Path to directory where the plots should be saved
" -> doc

# Example of how to run this script:
# Rscript src/data_viz_tab.R --data="data/clean_data.csv" --out_dir="img"


library(docopt)
library(tidyverse)
library(dplyr)
library(repr)

opt <- docopt(doc)

main <- function(data, out_dir){
  # load data
  df <- read_csv(data) 
  
  theme_set(theme_bw())
  options(repr.plot.width = 8, repr.plot.height = 8)
  
  pub_ind_numeracy <- df %>%
    filter(fsa_skill_code == "Numeracy" & public_or_independent != 'PROVINCE - TOTAL') %>%
    group_by(sub_population, public_or_independent) %>%
    summarise(avg = mean(score))
  
  # Plot bar chart for numeracy
  bar_plot_numeracy <-
    ggplot(pub_ind_numeracy, aes(x = sub_population, y = avg))+
    geom_bar(aes(fill = public_or_independent), alpha=0.9 , width=0.7, position = "dodge", stat="identity") +
    labs(y = "Average Score",
         x = "Subroup",
         fill = "School Type",
         title = "FSA Numeracy Test Scores (2007/08 - 2018/19)") +
    theme(plot.title = element_text(size=12), 
          axis.text = element_text(size=6), 
          axis.title = element_text(size=8)) +
    coord_flip()
  # Save bar chart for numeracy
  ggsave(plot = bar_plot_numeracy,
         filename = "bar_plot_numeracy.png",
         path = out_dir
        )
  
  pub_ind_reading <- df %>%
    filter(fsa_skill_code == "Reading" & public_or_independent != 'PROVINCE - TOTAL' & data_level == 'SCHOOL LEVEL') %>%
    group_by(sub_population, public_or_independent) %>%
    summarise(avg = mean(score))
  
  # Plot bar chart for reading
  bar_plot_reading <- ggplot(pub_ind_reading, aes(x = sub_population, y = avg))+
    geom_bar(aes(fill = public_or_independent), alpha=0.9 , width=0.7, position = "dodge", stat="identity") +
    labs(y = "Average Score",
         x = "Subgroup",
         fill = "School Type",
         title = "FSA Reading Test Scores (2007/08 - 2018/19)") +
    theme(plot.title = element_text(size=12), 
          axis.text = element_text(size=6), 
          axis.title = element_text(size=8)) +
    coord_flip()
  #Save bar chart for reading
  ggsave(plot = bar_plot_reading,
         filename = "bar_plot_reading.png",
         path = out_dir
  )
  
  
  pub_ind_writing <- df %>%
    filter(fsa_skill_code == "Writing" & public_or_independent != 'PROVINCE - TOTAL' & data_level == 'SCHOOL LEVEL') %>%
    group_by(sub_population, public_or_independent) %>%
    summarise(avg = mean(score))
  
  # Plot bar chart for writing
  bar_plot_writing <- ggplot(pub_ind_writing, aes(x = sub_population, y = avg))+
    geom_bar(aes(fill = public_or_independent), alpha=0.9 , width=0.7, position = "dodge", stat="identity") +
    labs(y = "Average Score",
         x = "Subgroup",
         fill = "School Type",
         title = "FSA Writing Test Scores (2007/08 - 2018/19)") +
    theme(plot.title = element_text(size=12), 
          axis.text = element_text(size=6), 
          axis.title = element_text(size=8)) +
    coord_flip()
  
  ggsave(plot = bar_plot_writing,
         filename = "bar_plot_writing.png",
         path = out_dir
  )
  
  # Summary statistic table for non-ab vs ab in numeracy
  non_ab_numeracy <- df %>%
    filter(fsa_skill_code == "Numeracy") %>%
    filter(sub_population == "ABORIGINAL" | sub_population == "NON ABORIGINAL") %>%
    group_by(sub_population) %>%
    summarise(avg = mean(score))
    
  # Plot bar chart
  ab_bar_plot_numeracy <- ggplot(non_ab_numeracy, aes(x = sub_population, y = avg))+
    geom_bar(width = 0.3 , alpha=0.9 , size=0.3, position = "dodge", stat = 'identity', fill="#759ed1") +
    labs(y = "Average Score",
         x = "Subgroup",
         title = "FSA Numeracy Test Scores (2007/08 - 2018/19)") +
    theme(legend.position = "bot")
  ggsave(plot = ab_bar_plot_numeracy,
         filename = "bar_plot_ab_numeracy.png",
         path = out_dir
  )

  # Summary statistic table for non-ab vs ab in reading
  non_ab_read <- df %>%
    filter(fsa_skill_code == "Reading") %>%
    filter(sub_population == "ABORIGINAL" | sub_population == "NON ABORIGINAL") %>%
    group_by(sub_population) %>%
    summarise(avg = mean(score))
  
  # Plot bar chart
  ab_bar_plot_read <- ggplot(non_ab_read, aes(x = sub_population, y = avg))+
    geom_bar(width = 0.3 , alpha=0.9 , size=0.3, position = "dodge", stat = 'identity', fill="#759ed1") +
    labs(y = "Average Score",
         x = "Subroup",
         title = "FSA Reading Test Scores (2007/08 - 2018/19)") +
    theme(legend.position = "bot")
  ggsave(plot = ab_bar_plot_read,
         filename = "bar_plot_ab_read.png",
         path = out_dir
  )

  
  # Summary statistic table for non-ab vs ab in writing
  non_ab_write <- df %>%
    filter(fsa_skill_code == "Writing") %>%
    filter(sub_population == "ABORIGINAL" | sub_population == "NON ABORIGINAL") %>%
    group_by(sub_population) %>%
    summarise(avg = mean(score))
  
  # Plot bar chart
  ab_bar_plot_write <- ggplot(non_ab_write, aes(x = sub_population, y = avg))+
    geom_bar(width = 0.3 , alpha=0.9 , size=0.3, position = "dodge", stat = 'identity', fill="#759ed1") +
    labs(y = "Average Score",
         x = "Subroup",
         title = "FSA Writing Test Scores (2007/08 - 2018/19)") +
    theme(legend.position = "bot")
  
  ggsave(plot = ab_bar_plot_write,
         filename = "ab_bar_plot_write.png",
         path = out_dir
  )
  
  #Plot line chart for public vs independent in numeracy
  pub_ind_numeracy_year <- df %>%
    filter(fsa_skill_code == "Numeracy") %>%
    group_by(year_start, public_or_independent) %>%
    summarise("avg" = mean(score))
  
  line_plot_numeracy <- pub_ind_numeracy_year %>%
    ggplot(aes(x = year_start, y = avg)) +
    geom_line(aes(color = public_or_independent)) +
    labs(x = "School Year Start", y = "Average Score", title = "FSA Numeracy Test Scores (2007/08 - 2018/19) by Subgroup") +
    theme(plot.title = element_text(size=12), 
          axis.text = element_text(size=6), 
          axis.title = element_text(size=8), 
          legend.text = element_text(size=7), 
          legend.title = element_text(size=7)) +
    scale_x_continuous(breaks = seq(2007, 2018, 1))

  ggsave(plot = line_plot_numeracy,
         filename = "line_ind_numeracy.png",
         path = out_dir)
  
  #Plot line chart for public vs independent in reading
  pub_ind_read_year <- df %>%
    filter(fsa_skill_code == "Reading") %>%
    group_by(year_start, public_or_independent) %>%
    summarise(avg = mean(score))
  
  line_plot_read <- pub_ind_read_year %>%
    ggplot(aes(x = year_start, y = avg)) +
    geom_line(aes(color = public_or_independent)) +
    labs(x = "School Year Start", 
         y = "Average Score", 
         title = "FSA Reading Test Scores (2007/08 - 2018/19) by Subgroup") +
    theme(plot.title = element_text(size=12), 
          axis.text = element_text(size=6), 
          axis.title = element_text(size=8), 
          legend.text = element_text(size=7), 
          legend.title = element_text(size=7)) +
    scale_x_continuous(breaks = seq(2007, 2018, 1))
  
  ggsave(plot = line_plot_read,
         filename = "line_ind_read.png",
         path = out_dir)
  
  #Plot line chart for public vs independent in writing
  pub_ind_write_year <- df %>%
    filter(fsa_skill_code == "Writing") %>%
    group_by(year_start, public_or_independent) %>%
    summarise(avg = mean(score))
  
  line_plot_write <- pub_ind_write_year %>%
    ggplot(aes(x = year_start, y = avg)) +
    geom_line(aes(color = public_or_independent)) +
    labs(x = "School Year Start", y = "Average Score", title = "FSA Writing Test Scores (2007/08 - 2018/19) by Subgroup") +
    theme(plot.title = element_text(size=12), 
          axis.text = element_text(size=6), 
          axis.title = element_text(size=8), 
          legend.text = element_text(size=7), 
          legend.title = element_text(size=7)) +
    scale_x_continuous(breaks = seq(2007, 2018, 1))
  
  ggsave(plot = line_plot_write,
         filename = "line_ind_write.png",
         path = out_dir)
  
  #Plot line chart for na vs ab in numeracy
  ab_numeracy_year <- df %>%
    filter(fsa_skill_code == "Numeracy" ) %>%
    filter(sub_population == "ABORIGINAL" | sub_population == "NON ABORIGINAL") %>%
    group_by(year_start, sub_population) %>%
    summarise(avg = mean(score))
  
  line_plot_numeracy <- ab_numeracy_year %>%
    ggplot(aes(x = year_start, y = avg)) +
    geom_line(aes(color = sub_population)) +
    labs(x = "School Year Start", 
         y = "Average Score", 
         title = "FSA Numeracy Test Scores (2007/08 - 2018/19) by Subgroup",
         color = "Subgroup") +
    theme(plot.title = element_text(size=12), 
          axis.text = element_text(size=6), 
          axis.title = element_text(size=8), 
          legend.text = element_text(size=7), 
          legend.title = element_text(size=7)) +
    scale_x_continuous(breaks = seq(2007, 2018, 1))
  
  ggsave(plot = line_plot_numeracy,
         filename = "line_ab_numeracy.png",
         path = out_dir)
  
  #Plot line chart for na vs ab in numeracy
  ab_reading_year <- df %>%
    filter(fsa_skill_code == "Reading") %>%
    filter(sub_population == "ABORIGINAL" | sub_population == "NON ABORIGINAL") %>%
    group_by(year_start, sub_population) %>%
    summarise(avg = mean(score))
  
  line_plot_reading <- ab_reading_year %>%
    ggplot(aes(x = year_start, y = avg)) +
    geom_line(aes(color = sub_population)) +
    labs(x = "School Year Start", 
         y = "Average Score", 
         color = "Subgroup",
         title = "FSA Reading Test Scores (2007/08 - 2018/19) by Subgroup") +
    theme(plot.title = element_text(size=12), 
          axis.text = element_text(size=6), 
          axis.title = element_text(size=8), 
          legend.text = element_text(size=7), 
          legend.title = element_text(size=7)) +
    scale_x_continuous(breaks = seq(2007, 2018, 1))
  
  ggsave(plot = line_plot_reading,
         filename = "line_ab_reading.png",
         path = out_dir)
  
  #Plot line chart for na vs ab in writing
  ab_write_year <- df %>%
    filter(fsa_skill_code == "Writing" ) %>%
    filter(sub_population == "ABORIGINAL" | sub_population == "NON ABORIGINAL") %>%
    group_by(year_start, sub_population) %>%
    summarise(avg = mean(score))
  
  line_plot_write <- ab_write_year %>%
    ggplot(aes(x = year_start, y = avg)) +
    geom_line(aes(color = sub_population)) +
    labs(x = "School Year Start", 
         y = "Average Score", 
         color = "Subgroup",
         title = "FSA Writing Test Scores (2007/08 - 2018/19) by Subgroup") +
    theme(plot.title = element_text(size=12), 
          axis.text = element_text(size=6), 
          axis.title = element_text(size=8), 
          legend.text = element_text(size=7), 
          legend.title = element_text(size=7)) +
    scale_x_continuous(breaks = seq(2007, 2018, 1))
  
  ggsave(plot = line_plot_write,
         filename = "line_ab_write.png",
         path = out_dir)
}  

main(opt[["--data"]], opt[["--out_dir"]])


