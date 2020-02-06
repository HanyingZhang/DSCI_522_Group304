# author: Group 304 (Wenjiao Zou)
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
library(testthat)
library(cowplot)

opt <- docopt(doc)

#########################

# Tests that the input link is a link to a csv file
test_input <- function(){
  test_that("The link should be a link to a .csv file.",{
    expect_match(opt$data, ".csv")
  })
}
test_input()

# Tests that the output lies in the `img` file
test_output <- function(){
  test_that("The output should be in the img directory.",{
    expect_match(opt$out_dir, "img")
  })
}
test_output()


main <- function(data, out_dir){
  # load data
  df <- read_csv(data) 
  
  theme_set(theme_bw())
  options(repr.plot.width = 8, repr.plot.height = 8)
  
  pub_ind_numeracy <- df %>%
    filter(fsa_skill_code != "Writing" & public_or_independent != 'PROVINCE - TOTAL') %>%
    group_by(sub_population, public_or_independent, fsa_skill_code) %>%
    summarise(avg = mean(score))
  
  # Plot bar chart for numeracy
  bar_plot_numeracy <-
    ggplot(pub_ind_numeracy, aes(x = sub_population, y = avg))+
    geom_bar(aes(fill = public_or_independent), alpha=0.9 , width=0.7, position = "dodge", stat="identity") +
    labs(y = "Average Score",
         x = "Subroup",
         title = "FSA Test Scores (2007/08 - 2018/19)",
         fill = 'School Type') +
    facet_grid(. ~fsa_skill_code) +
    theme(plot.title = element_text(size=12), 
          axis.text.x = element_text(size=10), 
          axis.title.x = element_text(size=10)
    ) +
    coord_flip()
  ggsave(plot = bar_plot_numeracy,
         filename = "bar_plots.png",
         path = out_dir,
         width = 12,
         height = 8
  )
  
  
  # Summary statistic table for non-ab vs ab in numeracy
  non_ab_numeracy <- df %>%
    filter(fsa_skill_code != "Writing") %>%
    filter(sub_population == "ABORIGINAL" | sub_population == "NON ABORIGINAL") %>%
    group_by(sub_population, fsa_skill_code) %>%
    summarise(avg = mean(score))
  
  # Plot bar chart
  ab_bar_plot_numeracy <- ggplot(non_ab_numeracy, aes(x = sub_population, y = avg))+
    geom_bar(width = 0.3 , alpha=0.9 , size=0.3, position = "dodge", stat = 'identity', fill="#759ed1") +
    labs(y = "Average Score",
         x = "Subgroup",
         title = "FSA Numeracy Test Scores (2007/08 - 2018/19)") +
    theme(plot.title = element_text(size=12), 
          axis.text = element_text(size=10), 
          axis.title = element_text(size=10),) +
    facet_grid(. ~fsa_skill_code)
    coord_flip()
    
  ggsave(plot = ab_bar_plot_numeracy,
          filename = "plots_ab.png",
          path = out_dir,
          width = 12,
          height = 8
    )

  
  #Plot line chart for public vs independent in numeracy
  pub_ind_numeracy_year <- df %>%
    filter(fsa_skill_code != "Writing") %>%
    group_by(year_start, public_or_independent, fsa_skill_code) %>%
    summarise("avg" = mean(score)) %>%
    mutate(group = paste(public_or_independent, fsa_skill_code))
  
  
  p1 <- pub_ind_numeracy_year %>%
    ggplot(aes(x = year_start, y = avg)) +
    geom_line(aes(color = group)) +
    labs(x = "School Year Start", 
         y = "Average Score", 
         title = "FSA Test Scores (2007/08 - 2018/19) by Subgroup",
         color = "Subgroup") +
    theme(plot.title = element_text(size=12), 
          axis.text = element_text(size=6), 
          axis.title = element_text(size=8), 
          legend.text = element_text(size=7), 
          legend.title = element_text(size=7)) +
    scale_x_continuous(breaks = seq(2007, 2018, 1)) +
    scale_color_manual(values=c("#f0970a", "#314782",
                                "#f0e0ad", "#8ca2de")) +
    scale_y_continuous(limits=c(450, 550))
  
  ggsave(plot = p1,
         filename = "line_pub_ind.png",
         path = out_dir,
         width = 7,
         height = 7)
  
  
  
  #Plot line chart for na vs ab in numeracy
  ab_numeracy_year <- df %>%
    filter(fsa_skill_code != "Writing" ) %>%
    filter(sub_population == "ABORIGINAL" | sub_population == "NON ABORIGINAL") %>%
    group_by(year_start, sub_population, fsa_skill_code) %>%
    summarise(avg = mean(score))%>%
    mutate(group = paste(sub_population, fsa_skill_code))
  
  line_plot_numeracy <- ab_numeracy_year %>%
    ggplot(aes(x = year_start, y = avg)) +
    geom_line(aes(color = group)) +
    labs(x = "School Year Start", 
         y = "Average Score", 
         title = "FSA Test Scores (2007/08 - 2018/19) by Subgroup",
         color = "Subgroup") +
    theme(plot.title = element_text(size=12), 
          axis.text = element_text(size=6), 
          axis.title = element_text(size=8), 
          legend.text = element_text(size=7), 
          legend.title = element_text(size=7)) +
    scale_x_continuous(breaks = seq(2007, 2018, 1)) +
    scale_color_manual(values=c("#f0e0ad", "#8ca2de",
                                "#f0970a", "#314782"
                                ))+
    scale_y_continuous(limits=c(400, 525))
  
  ggsave(plot = line_plot_numeracy,
         filename = "line_ab.png",
         path = out_dir,
         width = 7,
         height = 7)
}  

main(opt[["--data"]], opt[["--out_dir"]])
