EDA
================
DSCI\_522\_Group304
1/16/2020

### 1\. Dataset Description

**Dataset: BC Schools - Foundational Skills Assessment(FSA)**

**License:** Open Government License - BC

**Source:** Published by the [Ministry of Education - Education
Analytics](https://catalogue.data.gov.bc.ca/dataset/bc-schools-foundation-skills-assessment-fsa-)

**Content:** The results of the Grades 4 and 7 BC Foundation Skills
Assessments in Numeracy, Reading and Writing from 2007/2008 to
2018/2019.

**Dataset Last Modified:** 2019-02-08

### 2\. Load the dataset

``` r
rawdata_2007_2016 <- read_csv('../data/fsa_2007-2016.csv')
```

    ## Parsed with column specification:
    ## cols(
    ##   SCHOOL_YEAR = col_character(),
    ##   DATA_LEVEL = col_character(),
    ##   PUBLIC_OR_INDEPENDENT = col_character(),
    ##   DISTRICT_NUMBER = col_character(),
    ##   DISTRICT_NAME = col_character(),
    ##   SCHOOL_NUMBER = col_logical(),
    ##   SCHOOL_NAME = col_logical(),
    ##   SUB_POPULATION = col_character(),
    ##   FSA_SKILL_CODE = col_character(),
    ##   GRADE = col_character(),
    ##   NUMBER_EXPECTED_WRITERS = col_character(),
    ##   NUMBER_WRITERS = col_character(),
    ##   NUMBER_UNKNOWN = col_character(),
    ##   NUMBER_BELOW = col_character(),
    ##   NUMBER_MEETING = col_character(),
    ##   NUMBER_EXCEEDING = col_character(),
    ##   SCORE = col_character()
    ## )

    ## Warning: 1021388 parsing failures.
    ##  row           col           expected                    actual                        file
    ## 4972 SCHOOL_NUMBER 1/0/T/F/TRUE/FALSE 00501007                  '../data/fsa_2007-2016.csv'
    ## 4972 SCHOOL_NAME   1/0/T/F/TRUE/FALSE Jaffray Elem-Jr Secondary '../data/fsa_2007-2016.csv'
    ## 4973 SCHOOL_NUMBER 1/0/T/F/TRUE/FALSE 00501007                  '../data/fsa_2007-2016.csv'
    ## 4973 SCHOOL_NAME   1/0/T/F/TRUE/FALSE Jaffray Elem-Jr Secondary '../data/fsa_2007-2016.csv'
    ## 4974 SCHOOL_NUMBER 1/0/T/F/TRUE/FALSE 00501007                  '../data/fsa_2007-2016.csv'
    ## .... ............. .................. ......................... ...........................
    ## See problems(...) for more details.

``` r
rawdata_2017_2018 <- read_csv('../data/fsa_2017-2018.csv')
```

    ## Parsed with column specification:
    ## cols(
    ##   SCHOOL_YEAR = col_character(),
    ##   DATA_LEVEL = col_character(),
    ##   PUBLIC_OR_INDEPENDENT = col_character(),
    ##   DISTRICT_NUMBER = col_character(),
    ##   DISTRICT_NAME = col_character(),
    ##   SCHOOL_NUMBER = col_character(),
    ##   SCHOOL_NAME = col_character(),
    ##   SUB_POPULATION = col_character(),
    ##   GRADE = col_character(),
    ##   FSA_SKILL_CODE = col_character(),
    ##   NUMBER_EXPECTED_WRITERS = col_character(),
    ##   NUMBER_WRITERS = col_character(),
    ##   NUMBER_UNKNOWN = col_character(),
    ##   NUMBER_EMERGING = col_character(),
    ##   NUMBER_ONTRACK = col_character(),
    ##   NUMBER_EXTENDING = col_character(),
    ##   SCORE = col_character()
    ## )

``` r
head(rawdata_2007_2016)
```

    ## # A tibble: 6 x 17
    ##   SCHOOL_YEAR DATA_LEVEL PUBLIC_OR_INDEP… DISTRICT_NUMBER DISTRICT_NAME
    ##   <chr>       <chr>      <chr>            <chr>           <chr>        
    ## 1 2007/2008   PROVINCE … PROVINCE - TOTAL <NA>            <NA>         
    ## 2 2007/2008   PROVINCE … PROVINCE - TOTAL <NA>            <NA>         
    ## 3 2007/2008   PROVINCE … PROVINCE - TOTAL <NA>            <NA>         
    ## 4 2007/2008   PROVINCE … PROVINCE - TOTAL <NA>            <NA>         
    ## 5 2007/2008   PROVINCE … PROVINCE - TOTAL <NA>            <NA>         
    ## 6 2007/2008   PROVINCE … PROVINCE - TOTAL <NA>            <NA>         
    ## # … with 12 more variables: SCHOOL_NUMBER <lgl>, SCHOOL_NAME <lgl>,
    ## #   SUB_POPULATION <chr>, FSA_SKILL_CODE <chr>, GRADE <chr>,
    ## #   NUMBER_EXPECTED_WRITERS <chr>, NUMBER_WRITERS <chr>, NUMBER_UNKNOWN <chr>,
    ## #   NUMBER_BELOW <chr>, NUMBER_MEETING <chr>, NUMBER_EXCEEDING <chr>,
    ## #   SCORE <chr>

``` r
df_07_16 <- rawdata_2007_2016 %>%
  clean_names() %>%
  filter(score != 'Msk') %>%
  select(school_year, data_level, public_or_independent, sub_population, fsa_skill_code, grade, number_expected_writers, number_writers, score) %>%
  mutate(score = as.numeric(score),
         number_expected_writers = as.numeric(number_expected_writers),
         number_writers = as.numeric(number_writers))

df_17_18 <- rawdata_2017_2018 %>%
  clean_names() %>%
  filter(score != 'Msk') %>%
  select(school_year, data_level, public_or_independent, sub_population, fsa_skill_code, grade, number_expected_writers, number_writers, score) %>%
  mutate(score = as.numeric(score),
         number_expected_writers = as.numeric(number_expected_writers),
         number_writers = as.numeric(number_writers),
         public_or_independent = case_when(public_or_independent == "BC PUBLIC SCHOOL" ~ "BC Public School",
                                           public_or_independent == "BC INDEPENDENT SCHOOL" ~ "BC Independent School",
                                           public_or_independent == "PROVINCE-TOTAL" ~ "PROVINCE - TOTAL",
                                           TRUE ~ public_or_independent))
         
df <- bind_rows(df_07_16, df_17_18)

head(df)
```

    ## # A tibble: 6 x 9
    ##   school_year data_level public_or_indep… sub_population fsa_skill_code grade
    ##   <chr>       <chr>      <chr>            <chr>          <chr>          <chr>
    ## 1 2007/2008   PROVINCE … PROVINCE - TOTAL ALL STUDENTS   Numeracy       04   
    ## 2 2007/2008   PROVINCE … PROVINCE - TOTAL FEMALE         Numeracy       04   
    ## 3 2007/2008   PROVINCE … PROVINCE - TOTAL MALE           Numeracy       04   
    ## 4 2007/2008   PROVINCE … PROVINCE - TOTAL ABORIGINAL     Numeracy       04   
    ## 5 2007/2008   PROVINCE … PROVINCE - TOTAL NON ABORIGINAL Numeracy       04   
    ## 6 2007/2008   PROVINCE … PROVINCE - TOTAL ENGLISH LANGU… Numeracy       04   
    ## # … with 3 more variables: number_expected_writers <dbl>, number_writers <dbl>,
    ## #   score <dbl>

### 3\. Explore the dataset

``` r
str(df)
```

    ## Classes 'spec_tbl_df', 'tbl_df', 'tbl' and 'data.frame': 361902 obs. of  9 variables:
    ##  $ school_year            : chr  "2007/2008" "2007/2008" "2007/2008" "2007/2008" ...
    ##  $ data_level             : chr  "PROVINCE LEVEL" "PROVINCE LEVEL" "PROVINCE LEVEL" "PROVINCE LEVEL" ...
    ##  $ public_or_independent  : chr  "PROVINCE - TOTAL" "PROVINCE - TOTAL" "PROVINCE - TOTAL" "PROVINCE - TOTAL" ...
    ##  $ sub_population         : chr  "ALL STUDENTS" "FEMALE" "MALE" "ABORIGINAL" ...
    ##  $ fsa_skill_code         : chr  "Numeracy" "Numeracy" "Numeracy" "Numeracy" ...
    ##  $ grade                  : chr  "04" "04" "04" "04" ...
    ##  $ number_expected_writers: num  44500 21884 22616 5549 38951 ...
    ##  $ number_writers         : num  40336 20108 20228 4819 35517 ...
    ##  $ score                  : num  487 483 491 440 493 ...

``` r
cat("The dataframe columns in dataframe for 2007-2016 are", colnames(df), "\n\n")
```

    ## The dataframe columns in dataframe for 2007-2016 are school_year data_level public_or_independent sub_population fsa_skill_code grade number_expected_writers number_writers score

``` r
cat("The SCHOOL_YEAR contains", unique(df$school_year), "\n\n")
```

    ## The SCHOOL_YEAR contains 2007/2008 2008/2009 2009/2010 2010/2011 2011/2012 2012/2013 2013/2014 2014/2015 2015/2016 2016/2017 2017/2018 2018/2019

``` r
cat("The DATA_LEVEL contains", unique(df$data_level), "\n\n")
```

    ## The DATA_LEVEL contains PROVINCE LEVEL DISTRICT LEVEL SCHOOL LEVEL

``` r
cat("The PUBLIC_OR_INDEPENDENT contains", unique(df$public_or_independent), "\n\n")
```

    ## The PUBLIC_OR_INDEPENDENT contains PROVINCE - TOTAL BC Public School BC Independent School

``` r
cat("The SUB_POPULATION contains", length(unique(df$sub_population)), "subgroups, and they are", unique(df$sub_population), "\n\n")
```

    ## The SUB_POPULATION contains 8 subgroups, and they are ALL STUDENTS FEMALE MALE ABORIGINAL NON ABORIGINAL ENGLISH LANGUAGE LEARNER NON ENGLISH LANGUAGE LEARNER SPECIAL NEEDS NO GIFTED

``` r
cat("The FSA_SKILL_CODE contains", unique(df$fsa_skill_code), "\n\n")
```

    ## The FSA_SKILL_CODE contains Numeracy Reading Writing

``` r
cat("The GRADE contains", unique(df$grade), "\n\n")
```

    ## The GRADE contains 04 07

``` r
cat("The SCORE ranges from", min(df$score), "to", max(df$score), "and the average is", mean(df$score), "\n\n")
```

    ## The SCORE ranges from 0 to 1420.7 and the average is 326.4003

### 4\. Initial thoughts

The dataset includes mean FSA scores for many different subgroups which
can be compared. Possible comparisons include: - Female vs Male -
Aboriginal vs Non Aboriginal - English Language Learner vs Non English
Language Learner - Grade 4 vs Grade 7 - Public School vs Independent
School

FSA scores can also be compared across different school districts and by
FSA Skill Code (Numeracy, Reading, or Writing components of the exam).

  - **Potential Research Questions:**

There are many questions we could ask about this dataset, including (but
no limited to) the following:

Main Questions: 1. (Inferential) Is there a difference in how well BC
Public School vs Independent School students perform on the FSA exam? 2.
(Inferential) Is there a difference in how well Aboriginal vs Non
Aboriginal students perform on the FSA exam? 3. (Predictive) Can we
predict how well a student will perform on a Numeracy component of the
FSA exam based on their school district, gender, how many special needs
students are in the school, and the student’s scores on the other exam
components?

Subquestions: 4. (Descriptive) Which school type (Public / Independent)
has a higher average FSA score across all school years? 5. (Descriptive)
Which group of students (Aboriginal / Non Aboriginal) has a higher
average FSA score across all school years? 6. (Exploratory) Are there
trends in average FSA scores for Public or Independent School students
between 2007/08 - 2018/19 school years? 7. (Exploratory) Are there
trends in average FSA scores for Aboriginal or Non Aboriginal students
between 2007/08 - 2018/19 school years?

### 5\. Wrangling

``` r
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
```

``` r
# Stacks the Aboriginal and Non Aboriginal subgroups into one dataframe
sub_data <- bind_rows(aboriginal, non_aboriginal)

# Filters the dataframe for 'Province - Total' since we don't want to double-count data
sub_data <- sub_data %>%
  filter(public_or_independent == 'PROVINCE - TOTAL')
```

### 6\. Research Questions

This project will attempt to answer two main inferential research
questions:

1.  Is there a difference in how well BC Public School vs Independent
    School students perform on the FSA exam?  
2.  Is there a difference in how well Aboriginal vs Non Aboriginal
    students perform on the FSA exam?

*Note:* Though the project assignment requires only one
inferential/predictive research question, since these are relatively
simple questions we’ve chosen two.

**Subquestions to the main research questions include:**

1.  (Descriptive) Which school type (Public / Independent) has a higher
    average FSA score across all school years?  
2.  (Descriptive) Which group of students (Aboriginal / Non Aboriginal)
    has a higher average FSA score across all school years?  
3.  (Exploratory) Are there trends in average FSA scores for Public or
    Independent School students between 2007/08 - 2018/19 school
    years?  
4.  (Exploratory) Are there trends in average FSA scores for Aboriginal
    or Non Aboriginal students between 2007/08 - 2018/19 school years?

**Analysis Plan** To analyze the data, we will produce the following for
each of the two main inferential research questions:

1.  Hypothesis Test for Difference in Means (t-test):
      - \(H_0\): There is no difference between the mean FSA scores
        between groups  
      - \(H_A\): There exists a difference between the mean FSA scores
        between groups  
2.  Estimate and Confidence Intervals of mean FSA scores for each group

These analysis methods will be used to look at mean scores for FSA Skill
types separately (Numeracy, Reading, Writing) for the different groups.

In addition to the methods above, we will also be comparing means of FSA
scores for each group to answer subquestions.

### 7\. Data Analysis & Visualizations

    ## # A tibble: 16 x 5
    ##    sub_population               public_or_independent   avg `2.5%` `97.5%`
    ##    <chr>                        <chr>                 <dbl>  <dbl>   <dbl>
    ##  1 ABORIGINAL                   BC Independent School  387.   361.    447.
    ##  2 ABORIGINAL                   BC Public School       415.   407.    428.
    ##  3 ALL STUDENTS                 BC Independent School  531.   504.    553.
    ##  4 ALL STUDENTS                 BC Public School       475.   467.    470.
    ##  5 ENGLISH LANGUAGE LEARNER     BC Independent School  551.   555.    568.
    ##  6 ENGLISH LANGUAGE LEARNER     BC Public School       473.   462.    474.
    ##  7 FEMALE                       BC Independent School  543.   553.    557.
    ##  8 FEMALE                       BC Public School       474.   460.    494.
    ##  9 MALE                         BC Independent School  551.   514.    572.
    ## 10 MALE                         BC Public School       482.   470.    496.
    ## 11 NON ABORIGINAL               BC Independent School  542.   494.    570.
    ## 12 NON ABORIGINAL               BC Public School       482.   459.    502.
    ## 13 NON ENGLISH LANGUAGE LEARNER BC Independent School  531.   496.    541.
    ## 14 NON ENGLISH LANGUAGE LEARNER BC Public School       478.   466.    482.
    ## 15 SPECIAL NEEDS NO GIFTED      BC Independent School  425.   385.    473.
    ## 16 SPECIAL NEEDS NO GIFTED      BC Public School       385.   399.    408.

``` r
bar_plot_numeracy <- ggplot(sum_num, aes(x = sub_population, y = avg))+
      geom_col(aes(fill = public_or_independent), width = 0.7 , alpha=0.9 , size=0.3, colour="black",position = "dodge") +
      labs(y = "Average Score",
           x = "Sub_Group",
           fill = "School Type",
           title = "FSA Numeracy Test Scores\n(2007/08 - 2018/19)") +
      theme(legend.position = "bot") +
      coord_flip() +
      theme_bw()

bar_plot_numeracy
```

![](EDA_files/figure-gfm/7.2.1%20Public%20vs%20Independent%20Bar%20Chart%20-%20Numeracy%20Test%20Results-1.png)<!-- -->

``` r
pub_ind_num <- df %>%
  filter(fsa_skill_code == "Numeracy" & public_or_independent != 'PROVINCE - TOTAL' & data_level == 'SCHOOL LEVEL')

# Makes a boxplot showing the distribution of average Numeracy test scores for each subgroup
pi_boxplot_numeracy <- ggplot(pub_ind_num, aes(x = public_or_independent, y = score))+
      geom_boxplot(width = 0.7 , alpha=0.9 , size=0.3, colour="black") +
      labs(y = "Average Score",
           x = "Sub Group",
           title = "FSA Numeracy Test Scores (2007/08 - 2018/19)") +
      stat_summary(fun.y = mean,
                   geom = 'point',
                   aes(shape = 'mean'),
                   color = 'blue',
                   size = 3) +
      scale_shape_manual('', values = c('mean' = 'triangle')) +
      theme_bw()

pi_boxplot_numeracy
```

![](EDA_files/figure-gfm/7.2.2.1%20Public%20vs%20Independent%20Boxplot%20Chart%20-%20Numeracy%20Test%20Results-1.png)<!-- -->

``` r
#pub_ind_numeracy

ridge_data <- df %>%
  filter(data_level == 'SCHOOL LEVEL' & public_or_independent != 'PROVINCE - TOTAL' )

ridge_plot <- ggplot(ridge_data, aes(x = score, y = sub_population, fill = sub_population)) +  
           geom_density_ridges(size = 0.5, alpha = 0.7, color = "black", 
                               scale = 2.0, rel_min_height = 0.01, quantile_lines = TRUE, quantiles = 4) +
           coord_cartesian(clip = "off") + # Required to plot top distribution completely
           labs(title ="FSA Test Scores By Subgroup\n(2007/08 - 2018/19)", 
                #subtitle = "(Source: Gapminder Dataset)", 
           x = "Score") +
           #scale_x_continuous(breaks = seq(30, 100, 5)) +
           theme_ridges() + 
           theme(legend.position = "none") +
           theme(axis.text.x = element_text(angle = 70, hjust = 1, size = 10, face = "bold"),
                 axis.text.y = element_text(angle = 0, hjust = 1, size = 10, face = "bold"))


#options(tidyverse.quiet = TRUE, repr.plot.width = 10, repr.plot.height = 5)

ridge_plot + facet_grid(cols = vars(fsa_skill_code))
```

    ## Picking joint bandwidth of 7.73

    ## Picking joint bandwidth of 6.49

    ## Picking joint bandwidth of 0.247

![](EDA_files/figure-gfm/7.2.2%20Public%20vs%20Independent%20Ridge%20Plot%20-%20FSA%20Scores%20by%20Skill%20and%20Subgroup-1.png)<!-- -->

    ## # A tibble: 16 x 5
    ##    sub_population               public_or_independent   avg `2.5%` `97.5%`
    ##    <chr>                        <chr>                 <dbl>  <dbl>   <dbl>
    ##  1 ABORIGINAL                   BC Independent School  398.   391.    433.
    ##  2 ABORIGINAL                   BC Public School       435.   420.    452.
    ##  3 ALL STUDENTS                 BC Independent School  530.   519.    532.
    ##  4 ALL STUDENTS                 BC Public School       482.   470.    489.
    ##  5 ENGLISH LANGUAGE LEARNER     BC Independent School  510.   493.    533.
    ##  6 ENGLISH LANGUAGE LEARNER     BC Public School       453.   429.    466.
    ##  7 FEMALE                       BC Independent School  550.   527.    573.
    ##  8 FEMALE                       BC Public School       493.   470.    511.
    ##  9 MALE                         BC Independent School  532.   522.    551.
    ## 10 MALE                         BC Public School       474.   463.    471.
    ## 11 NON ABORIGINAL               BC Independent School  539.   534.    557.
    ## 12 NON ABORIGINAL               BC Public School       488.   479.    500.
    ## 13 NON ENGLISH LANGUAGE LEARNER BC Independent School  531.   524.    551.
    ## 14 NON ENGLISH LANGUAGE LEARNER BC Public School       488.   478.    500.
    ## 15 SPECIAL NEEDS NO GIFTED      BC Independent School  461.   421.    502.
    ## 16 SPECIAL NEEDS NO GIFTED      BC Public School       409.   387.    425.

``` r
bar_plot_reading <- ggplot(sum_read, aes(x = sub_population, y = avg))+
      geom_col(aes(fill = public_or_independent), width = 0.7 , alpha=0.9 , size=0.3, colour="black",position = "dodge") +
      labs(y = "Average Score",
           x = "Sub_Group",
           fill = "School Type",
           title = "FSA Reading Test Scores\n(2007/08 - 2018/19)") +
      theme(legend.position = "bot") +
      coord_flip() +
      theme_bw()

bar_plot_reading
```

![](EDA_files/figure-gfm/7.2.1%20Public%20vs%20Independent%20Bar%20Chart%20-%20Reading%20Test%20Results-1.png)<!-- -->

``` r
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
```

![](EDA_files/figure-gfm/7.2.2%20Public%20vs%20Independent%20Boxplot%20Chart%20-%20Reading%20Test%20Results-1.png)<!-- -->

    ## # A tibble: 16 x 5
    ##    sub_population               public_or_independent   avg `2.5%` `97.5%`
    ##    <chr>                        <chr>                 <dbl>  <dbl>   <dbl>
    ##  1 ABORIGINAL                   BC Independent School  4.04   3.63    4.96
    ##  2 ABORIGINAL                   BC Public School       4.91   4.94    5.66
    ##  3 ALL STUDENTS                 BC Independent School  6.98   6.02    7.62
    ##  4 ALL STUDENTS                 BC Public School       5.92   5.16    7.06
    ##  5 ENGLISH LANGUAGE LEARNER     BC Independent School  6.78   6.69    7.36
    ##  6 ENGLISH LANGUAGE LEARNER     BC Public School       5.45   4.87    5.82
    ##  7 FEMALE                       BC Independent School  7.46   6.24    8.56
    ##  8 FEMALE                       BC Public School       6.28   5.34    7.27
    ##  9 MALE                         BC Independent School  6.70   5.58    7.35
    ## 10 MALE                         BC Public School       5.55   5.10    6.48
    ## 11 NON ABORIGINAL               BC Independent School  7.12   6.77    7.96
    ## 12 NON ABORIGINAL               BC Public School       6.02   5.23    6.51
    ## 13 NON ENGLISH LANGUAGE LEARNER BC Independent School  6.98   6.81    8.06
    ## 14 NON ENGLISH LANGUAGE LEARNER BC Public School       5.97   5.64    6.89
    ## 15 SPECIAL NEEDS NO GIFTED      BC Independent School  4.24   3.56    5.23
    ## 16 SPECIAL NEEDS NO GIFTED      BC Public School       4.21   4.09    4.89

``` r
bar_plot_writing <- ggplot(sum_write, aes(x = sub_population, y = avg))+
      geom_col(aes(fill = public_or_independent), width = 0.7 , alpha=0.9 , size=0.3, colour="black",position = "dodge") +
      labs(y = "Average Score",
           x = "Sub_Group",
           fill = "School Type",
           title = "FSA Writing Test Scores\n(2007/08 - 2018/19)") +
      theme(legend.position = "bot") +
      coord_flip() +
      theme_bw()

bar_plot_writing
```

![](EDA_files/figure-gfm/7.3.1%20Public%20vs%20Independent%20Bar%20Chart%20-%20Writing%20Test%20Results-1.png)<!-- -->

``` r
pub_ind_write <- df %>%
  filter(fsa_skill_code == "Writing" & public_or_independent != 'PROVINCE - TOTAL' & data_level == 'SCHOOL LEVEL')

# Makes a boxplot showing the distribution of average writing test scores for each subgroup
pi_boxplot_writing <- ggplot(pub_ind_write, aes(x = public_or_independent, y = score))+
      geom_boxplot(width = 0.7 , alpha=0.9 , size=0.3, colour="black") +
      labs(y = "Average Score",
           x = "Sub Group",
           title = "FSA Writing Test Scores (2007/08 - 2018/19)") +
      stat_summary(fun.y = mean,
                   geom = 'point',
                   aes(shape = 'mean'),
                   color = 'blue',
                   size = 3) +
      scale_shape_manual('', values = c('mean' = 'triangle')) +
      theme_bw()

pi_boxplot_writing
```

![](EDA_files/figure-gfm/7.3.2%20Public%20vs%20Independent%20Boxplot%20Chart%20-%20Writing%20Test%20Results-1.png)<!-- -->

``` r
non_ab_numeracy <- df %>%
  filter(fsa_skill_code == "Numeracy" & public_or_independent == 'PROVINCE - TOTAL') %>%
  filter(sub_population == "ABORIGINAL" | sub_population == "NON ABORIGINAL") %>%
  group_by(sub_population) %>%
  summarise(avg = mean(score))

sum_ab_num <- tibble("sub_population" = non_ab_numeracy$sub_population,
                  "avg" = non_ab_numeracy$avg,
                  "2.5%" = c(ci(aboriginal, "Numeracy")[[1]], ci(non_aboriginal, "Numeracy")[[1]]),
                  "97.5%" = c(ci(aboriginal, "Numeracy")[[2]], ci(non_aboriginal, "Numeracy")[[2]]))
sum_ab_num
```

    ## # A tibble: 2 x 4
    ##   sub_population   avg `2.5%` `97.5%`
    ##   <chr>          <dbl>  <dbl>   <dbl>
    ## 1 ABORIGINAL      427.   408.    425.
    ## 2 NON ABORIGINAL  494.   461.    512.

``` r
ab_bar_plot_numeracy <- ggplot(sum_ab_num, aes(x = sub_population, y = avg))+
      geom_col(width = 0.7 , alpha=0.9 , size=0.3, colour="black",position = "dodge") +
      labs(y = "Average Score",
           x = "Sub Group",
           title = "FSA Numeracy Test Scores (2007/08 - 2018/19)") +
      theme(legend.position = "bot") +
      theme_bw()

ab_bar_plot_numeracy
```

![](EDA_files/figure-gfm/7.4.1%20aboriginal%20vs%20non-aboriginal%20Bar%20Chart%20-%20Numeracy%20Test%20Results-1.png)<!-- -->

``` r
# Filters the Aboriginal and Non Aboriginal data subset for only Numeracy test scores
sub_num <- sub_data %>%
  filter(fsa_skill_code == 'Numeracy')

# Makes a boxplot showing the distribution of average Numeracy test scores for each subgroup
ab_boxplot_numeracy <- ggplot(sub_num, aes(x = sub_population, y = score))+
      geom_boxplot(width = 0.7 , alpha=0.9 , size=0.3, colour="black") +
      labs(y = "Average Score",
           x = "Sub Group",
           title = "FSA Numeracy Test Scores (2007/08 - 2018/19)") +
      stat_summary(fun.y = mean,
                   geom = 'point',
                   aes(shape = 'mean'),
                   color = 'blue',
                   size = 3) +
      scale_shape_manual('', values = c('mean' = 'triangle')) +
      theme_bw()

ab_boxplot_numeracy
```

![](EDA_files/figure-gfm/7.4.2%20aboriginal%20vs%20non-aboriginal%20Boxplot%20Chart%20-%20Numeracy%20Test%20Results-1.png)<!-- -->

``` r
non_ab_reading <- df %>%
  filter(fsa_skill_code == "Reading" & public_or_independent == 'PROVINCE - TOTAL') %>%
  filter(sub_population == "ABORIGINAL" | sub_population == "NON ABORIGINAL") %>%
  group_by(sub_population) %>%
  summarise(avg = mean(score))

sum_ab_read <- tibble("sub_population" = non_ab_reading$sub_population,
                  "avg" = non_ab_reading$avg,
                  "2.5%" = c(ci(aboriginal, "Reading")[[1]], ci(non_aboriginal, "Reading")[[1]]),
                  "97.5%" = c(ci(aboriginal, "Reading")[[2]], ci(non_aboriginal, "Reading")[[2]]))
sum_ab_read
```

    ## # A tibble: 2 x 4
    ##   sub_population   avg `2.5%` `97.5%`
    ##   <chr>          <dbl>  <dbl>   <dbl>
    ## 1 ABORIGINAL      445.   434.    451.
    ## 2 NON ABORIGINAL  498.   491.    506.

``` r
ab_bar_plot_numeracy <- ggplot(sum_ab_read, aes(x = sub_population, y = avg))+
      geom_col(width = 0.7 , alpha=0.9 , size=0.3, colour="black",position = "dodge") +
      labs(y = "Average Score",
           x = "Sub Group",
           title = "FSA Reading Test Scores (2007/08 - 2018/19)") +
      theme(legend.position = "bot") +
      theme_bw()

ab_bar_plot_numeracy
```

![](EDA_files/figure-gfm/7.5.1%20aboriginal%20vs%20non-aboriginal%20Bar%20Chart%20-%20Reading%20Test%20Results-1.png)<!-- -->

``` r
# Filters the Aboriginal and Non Aboriginal data subset for only Reading test scores
sub_read <- sub_data %>%
  filter(fsa_skill_code == 'Reading')

# Makes a boxplot showing the distribution of average Reading test scores for each subgroup
ab_boxplot_reading <- ggplot(sub_read, aes(x = sub_population, y = score))+
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

ab_boxplot_reading
```

![](EDA_files/figure-gfm/7.5.2%20aboriginal%20vs%20non-aboriginal%20Boxplot%20Chart%20-%20Reading%20Test%20Results-1.png)<!-- -->

``` r
non_ab_writing <- df %>%
  filter(fsa_skill_code == "Writing" & public_or_independent == 'PROVINCE - TOTAL') %>%
  filter(sub_population == "ABORIGINAL" | sub_population == "NON ABORIGINAL") %>%
  group_by(sub_population) %>%
  summarise(avg = mean(score))

sum_ab_write <- tibble("sub_population" = non_ab_writing$sub_population,
                  "avg" = non_ab_writing$avg,
                  "2.5%" = c(ci(aboriginal, "Writing")[[1]], ci(non_aboriginal, "Writing")[[1]]),
                  "97.5%" = c(ci(aboriginal, "Writing")[[2]], ci(non_aboriginal, "Writing")[[2]]))
sum_ab_write
```

    ## # A tibble: 2 x 4
    ##   sub_population   avg `2.5%` `97.5%`
    ##   <chr>          <dbl>  <dbl>   <dbl>
    ## 1 ABORIGINAL      5.32   4.27    5.67
    ## 2 NON ABORIGINAL  6.29   5.33    7.10

``` r
ab_bar_plot_numeracy <- ggplot(sum_ab_write, aes(x = sub_population, y = avg))+
      geom_col(width = 0.7 , alpha=0.9 , size=0.3, colour="black",position = "dodge") +
      labs(y = "Average Score",
           x = "Sub_Group",
           title = "BC Schools 2007-2018 FSA - Reading Test ") +
      theme(legend.position = "bot") +
      theme_bw()

ab_bar_plot_numeracy
```

![](EDA_files/figure-gfm/7.6.1%20aboriginal%20vs%20non-aboriginal%20Bar%20Chart%20-%20Writing%20Test%20Results-1.png)<!-- -->

``` r
# Filters the Aboriginal and Non Aboriginal data subset for only Writing test scores
sub_write <- sub_data %>%
  filter(fsa_skill_code == 'Writing')

# Makes a boxplot showing the distribution of average Writing test scores for each subgroup
ab_boxplot_writing <- ggplot(sub_write, aes(x = sub_population, y = score))+
      geom_boxplot(width = 0.7 , alpha=0.9 , size=0.3, colour="black") +
      labs(y = "Average Score",
           x = "Sub Group",
           title = "FSA Writing Test Scores (2007/08 - 2018/19)") +
      stat_summary(fun.y = mean,
                   geom = 'point',
                   aes(shape = 'mean'),
                   color = 'blue',
                   size = 3) +
      scale_shape_manual('', values = c('mean' = 'triangle')) +
      theme_bw()

ab_boxplot_writing
```

![](EDA_files/figure-gfm/7.6.2%20aboriginal%20vs%20non-aboriginal%20Boxplot%20Chart%20-%20Writing%20Test%20Results-1.png)<!-- -->

### 8\. Summary & Conclusion

Initial findings include: \* There appears to be significant differences
in the FSA test scores between Aboriginal and Non Aboriginal students
across all tested skills. \* There are a lot of outlier points when
comparing the differences in the FSA test scores between Public and
Independent schools.

A full summary and conclusion will be written during the reporting stage
of this project.
