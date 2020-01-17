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

**Dataset Last Modified:**
2019-02-08

### 2\. Load the dataset

``` r
rawdata_2007_2016 <- read.csv("https://catalogue.data.gov.bc.ca/dataset/5554165d-e365-422f-bf85-4f6e4c9167dc/resource/97c6cbf7-f529-464a-b771-9719855b86f6/download/fsa.csv")

rawdata_2017_2018 <- read.csv("https://catalogue.data.gov.bc.ca/dataset/5554165d-e365-422f-bf85-4f6e4c9167dc/resource/bcb547f0-8ba7-451f-9e11-10524f4d57a0/download/foundation-skills-assessment-2017-18_to_2018-19.csv")
```

### 3\. Explore the dataset

``` r
str(rawdata_2007_2016)
```

    ## 'data.frame':    540451 obs. of  17 variables:
    ##  $ SCHOOL_YEAR            : Factor w/ 10 levels "2007/2008","2008/2009",..: 1 1 1 1 1 1 1 1 2 2 ...
    ##  $ DATA_LEVEL             : Factor w/ 3 levels "DISTRICT LEVEL",..: 2 2 2 2 2 2 2 2 2 2 ...
    ##  $ PUBLIC_OR_INDEPENDENT  : Factor w/ 3 levels "BC Independent School",..: 3 3 3 3 3 3 3 3 3 3 ...
    ##  $ DISTRICT_NUMBER        : int  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ DISTRICT_NAME          : Factor w/ 61 levels "","Abbotsford",..: 1 1 1 1 1 1 1 1 1 1 ...
    ##  $ SCHOOL_NUMBER          : int  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ SCHOOL_NAME            : Factor w/ 1875 levels "","?A'q'amnik Primary School",..: 1 1 1 1 1 1 1 1 1 1 ...
    ##  $ SUB_POPULATION         : Factor w/ 8 levels "ABORIGINAL","ALL STUDENTS",..: 2 4 5 1 6 3 7 8 2 4 ...
    ##  $ FSA_SKILL_CODE         : Factor w/ 3 levels "Numeracy","Reading",..: 1 1 1 1 1 1 1 1 1 1 ...
    ##  $ GRADE                  : int  4 4 4 4 4 4 4 4 4 4 ...
    ##  $ NUMBER_EXPECTED_WRITERS: Factor w/ 1962 levels "10","100","1001",..: 1260 658 696 1502 1140 1777 1078 661 1249 642 ...
    ##  $ NUMBER_WRITERS         : Factor w/ 3059 levels "-","1","10","100",..: 2041 989 1001 2298 1825 2683 1760 557 1909 844 ...
    ##  $ NUMBER_UNKNOWN         : Factor w/ 1685 levels "0","1","10","100",..: 849 368 478 1427 676 207 561 1271 1364 598 ...
    ##  $ NUMBER_BELOW           : Factor w/ 1506 levels "-","0","1","10",..: 1471 923 902 332 1334 402 1307 1269 1379 769 ...
    ##  $ NUMBER_MEETING         : Factor w/ 2615 levels "-","0","1","10",..: 1397 442 403 1462 1228 1858 1161 2369 1316 350 ...
    ##  $ NUMBER_EXCEEDING       : Factor w/ 1253 levels "-","0","1","10",..: 998 428 584 408 962 1123 897 1194 941 379 ...
    ##  $ SCORE                  : Factor w/ 99331 levels "",".09091",".55556",..: 46069 43421 48651 17745 50356 32490 48759 14261 48945 45897 ...

``` r
cat("The dataframe columns in dataframe for 2007-2016 are", colnames(rawdata_2007_2016), "\n\n")
```

    ## The dataframe columns in dataframe for 2007-2016 are SCHOOL_YEAR DATA_LEVEL PUBLIC_OR_INDEPENDENT DISTRICT_NUMBER DISTRICT_NAME SCHOOL_NUMBER SCHOOL_NAME SUB_POPULATION FSA_SKILL_CODE GRADE NUMBER_EXPECTED_WRITERS NUMBER_WRITERS NUMBER_UNKNOWN NUMBER_BELOW NUMBER_MEETING NUMBER_EXCEEDING SCORE

``` r
cat("The SCHOOL_YEAR contains", levels(rawdata_2007_2016$SCHOOL_YEAR), "\n\n")
```

    ## The SCHOOL_YEAR contains 2007/2008 2008/2009 2009/2010 2010/2011 2011/2012 2012/2013 2013/2014 2014/2015 2015/2016 2016/2017

``` r
cat("The DATA_LEVEL contains", levels(rawdata_2007_2016$DATA_LEVEL), "\n\n")
```

    ## The DATA_LEVEL contains DISTRICT LEVEL PROVINCE LEVEL SCHOOL LEVEL

``` r
cat("The PUBLIC_OR_INDEPENDENT contains", levels(rawdata_2007_2016$PUBLIC_OR_INDEPENDENT), "\n\n")
```

    ## The PUBLIC_OR_INDEPENDENT contains BC Independent School BC Public School PROVINCE - TOTAL

``` r
cat("The SUB_POPULATION contains", nlevels(rawdata_2007_2016$SUB_POPULATION), "subgroups, and they are", levels(rawdata_2007_2016$SUB_POPULATION), "\n\n")
```

    ## The SUB_POPULATION contains 8 subgroups, and they are ABORIGINAL ALL STUDENTS ENGLISH LANGUAGE LEARNER FEMALE MALE NON ABORIGINAL NON ENGLISH LANGUAGE LEARNER SPECIAL NEEDS NO GIFTED

``` r
cat("The FSA_SKILL_CODE contains", levels(rawdata_2007_2016$FSA_SKILL_CODE), "\n\n")
```

    ## The FSA_SKILL_CODE contains Numeracy Reading Writing

``` r
cat("The GRADE contains", unique(rawdata_2007_2016$GRADE), "\n\n")
```

    ## The GRADE contains 4 7

``` r
cat("The SCORE ranges from", min(as.numeric(rawdata_2007_2016$SCORE)), "to", max(as.numeric(rawdata_2007_2016$SCORE)), "and the average is", mean(as.numeric(rawdata_2007_2016$SCORE)), "\n\n")
```

    ## The SCORE ranges from 1 to 99331 and the average is 69829.58

``` r
str(rawdata_2017_2018)
```

    ## 'data.frame':    107992 obs. of  17 variables:
    ##  $ SCHOOL_YEAR            : Factor w/ 2 levels "2017/2018","2018/2019": 1 1 1 1 1 1 1 1 1 1 ...
    ##  $ DATA_LEVEL             : Factor w/ 3 levels "DISTRICT LEVEL",..: 2 2 2 2 2 2 2 2 2 2 ...
    ##  $ PUBLIC_OR_INDEPENDENT  : Factor w/ 3 levels "BC INDEPENDENT SCHOOL",..: 3 3 3 3 3 3 3 3 2 2 ...
    ##  $ DISTRICT_NUMBER        : int  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ DISTRICT_NAME          : Factor w/ 280 levels "","Abbotsford",..: 1 1 1 1 1 1 1 1 1 1 ...
    ##  $ SCHOOL_NUMBER          : int  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ SCHOOL_NAME            : Factor w/ 1509 levels "","?A'q'amnik Primary School",..: 1 1 1 1 1 1 1 1 1 1 ...
    ##  $ SUB_POPULATION         : Factor w/ 8 levels "ABORIGINAL","ALL STUDENTS",..: 2 4 5 1 6 3 7 8 2 4 ...
    ##  $ GRADE                  : int  4 4 4 4 4 4 4 4 4 4 ...
    ##  $ FSA_SKILL_CODE         : Factor w/ 3 levels "Numeracy","Reading",..: 1 1 1 1 1 1 1 1 1 1 ...
    ##  $ NUMBER_EXPECTED_WRITERS: Factor w/ 842 levels "10","100","1001",..: 581 297 324 659 536 814 504 317 522 239 ...
    ##  $ NUMBER_WRITERS         : Factor w/ 1283 levels "0","1","10","100",..: 739 355 386 811 648 1029 597 202 593 234 ...
    ##  $ NUMBER_UNKNOWN         : Factor w/ 856 levels "0","1","10","100",..: 48 573 648 148 829 362 780 22 14 548 ...
    ##  $ NUMBER_EMERGING        : Factor w/ 629 levels "0","1","10","100",..: 35 489 477 205 612 235 605 557 17 459 ...
    ##  $ NUMBER_ONTRACK         : Factor w/ 1113 levels "0","1","10","100",..: 375 36 69 287 330 556 294 859 276 1044 ...
    ##  $ NUMBER_EXTENDING       : Factor w/ 427 levels "0","1","10","100",..: 280 102 161 9 275 336 252 339 163 407 ...
    ##  $ SCORE                  : Factor w/ 29670 levels ".0667",".125",..: 17879 17137 18606 7414 19439 14088 18646 8175 15232 14524 ...

``` r
cat("The dataframe columns in dataframe for 2007-2016 are",   colnames(rawdata_2017_2018), "\n\n")
```

    ## The dataframe columns in dataframe for 2007-2016 are SCHOOL_YEAR DATA_LEVEL PUBLIC_OR_INDEPENDENT DISTRICT_NUMBER DISTRICT_NAME SCHOOL_NUMBER SCHOOL_NAME SUB_POPULATION GRADE FSA_SKILL_CODE NUMBER_EXPECTED_WRITERS NUMBER_WRITERS NUMBER_UNKNOWN NUMBER_EMERGING NUMBER_ONTRACK NUMBER_EXTENDING SCORE

``` r
cat("The SCHOOL_YEAR contains", levels(rawdata_2017_2018$SCHOOL_YEAR), "\n\n")
```

    ## The SCHOOL_YEAR contains 2017/2018 2018/2019

``` r
cat("The DATA_LEVEL contains", levels(rawdata_2017_2018$DATA_LEVEL), "\n\n")
```

    ## The DATA_LEVEL contains DISTRICT LEVEL PROVINCE LEVEL SCHOOL LEVEL

``` r
cat("The PUBLIC_OR_INDEPENDENT contains", levels(rawdata_2017_2018$PUBLIC_OR_INDEPENDENT), "\n\n")
```

    ## The PUBLIC_OR_INDEPENDENT contains BC INDEPENDENT SCHOOL BC PUBLIC SCHOOL PROVINCE-TOTAL

``` r
cat("The SUB_POPULATION contains", nlevels(rawdata_2017_2018$SUB_POPULATION), "subgroups, and they are", levels(rawdata_2017_2018$SUB_POPULATION), "\n\n")
```

    ## The SUB_POPULATION contains 8 subgroups, and they are ABORIGINAL ALL STUDENTS ENGLISH LANGUAGE LEARNER FEMALE MALE NON ABORIGINAL NON ENGLISH LANGUAGE LEARNER SPECIAL NEEDS NO GIFTED

``` r
cat("The FSA_SKILL_CODE contains", levels(rawdata_2017_2018$FSA_SKILL_CODE), "\n\n")
```

    ## The FSA_SKILL_CODE contains Numeracy Reading Writing

``` r
cat("The GRADE contains", unique(rawdata_2017_2018$GRADE), "\n\n")
```

    ## The GRADE contains 4 7

``` r
cat("The SCORE ranges from", min(as.numeric(rawdata_2017_2018$SCORE)), "to", max(as.numeric(rawdata_2017_2018$SCORE)), "and the average is", mean(as.numeric(rawdata_2017_2018$SCORE)), "\n\n")
```

    ## The SCORE ranges from 1 to 29670 and the average is 18548.81

### 4\. Initial thoughts

  - There are heaps of data that we can compare by population type (ex.
    Male / Female / Aboriginal / Non-aboriginal / Special Needs etc),
    Grade (for the 2007-2017 data), skill type(numeracy/ reading/
    writing), or school types(Public school/ Independent school)

  - **Potential Research Questions:**

<!-- end list -->

1.  Inferential: How do the scores for certain exams compare between
    different sub populations (ex. male / female, aboriginal /
    non-aboriginal, public / private school)? Ex. Do students in private
    school perform better than students in publicly funded schools on
    numeracy exams?
      - Null Hypothesis: there’s no difference in scores for the
        different groups
      - Alternative Hypothesis: there is a difference in scores for the
        different groups
2.  Predictive: What score on a specific exam type (ex. numeracy) will a
    child in a specific sub population (ex. aboriginal) get within a BC
    publicly funded school based on their:
      - school district,
      - gender,
      - how many special needs / non-English language learner are in the
        school (assuming here that this may influence scores because
        more funding may be used towards these other groups than to
        programs that support the aboriginal population specifically),
      - scores on other exams, and
      - number of exam writers from the sub population (i.e. number of
        students within the class that fall within this sub population
        group)?
3.  Predictive: Will the score from Grade 4 influence how they’ll
    perform in Grade 7?

### 5\. Wrangling

``` r
df_07_16 <- rawdata_2007_2016 %>%
  clean_names() %>%
  filter(score != 'Msk') %>%
  select(school_year, public_or_independent, sub_population, fsa_skill_code, grade, number_expected_writers, number_writers, score) %>%
  mutate(score = as.numeric(score),
         number_expected_writers = as.numeric(number_expected_writers),
         number_writers = as.numeric(number_writers),
         public_or_independent = as.character(public_or_independent),
         school_year = as.character(school_year))

df_17_18 <- rawdata_2017_2018 %>%
  clean_names() %>%
  filter(score != 'Msk') %>%
  select(school_year, public_or_independent, sub_population, fsa_skill_code, grade, number_expected_writers, number_writers, score) %>%
  mutate(score = as.numeric(score),
         number_expected_writers = as.numeric(number_expected_writers),
         number_writers = as.numeric(number_writers),
         public_or_independent = as.character(public_or_independent),
         school_year = as.character(school_year),
         public_or_independent = case_when(public_or_independent == "BC PUBLIC SCHOOL" ~ "BC Public School",
                                           public_or_independent == "BC INDEPENDENT SCHOOL" ~ "BC Independent School",
                                           public_or_independent == "PROVINCE-TOTAL" ~ "PROVINCE - TOTAL",
                                           TRUE ~ public_or_independent))
         
df <- bind_rows(df_07_16, df_17_18)
```

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

### 6\. Research Questions

  - **Selected Research Questions**

**Question 1**

(Inferential) Is there a difference in how well Public school students
vs Independent school students perform on the FSA?

  - 2 Group Hypothesis Test (mean scores for all tests together, and
    tests separately):
      - Null Hypothesis: No difference
      - Alternative Hypothesis: Difference
  - Estimate + Confidence intervals of the mean scores for the different
    groups

**Question 2**

(Inferential) Is there a difference in how well Aboriginal vs Non
aboriginal students perform on the FSA?

  - 2 Group Hypothesis Test (mean scores for all tests together, and
    tests separately):
      - Null Hypothesis: No difference
      - Alternative Hypothesis: Difference
  - Estimate + Confidence intervals of the mean scores for the different
    groups

SELECTED SUBQUESTIONS:

  - Comparing means

### 7\. Data Analysis & Visualizations

    ## # A tibble: 16 x 5
    ##    sub_population               public_or_independent    avg `2.5%` `97.5%`
    ##    <fct>                        <chr>                  <dbl>  <dbl>   <dbl>
    ##  1 ABORIGINAL                   BC Independent School  4111.  1355.   7808.
    ##  2 ABORIGINAL                   BC Public School       9888.  6576.  15149.
    ##  3 ALL STUDENTS                 BC Independent School 52211. 32016.  60773.
    ##  4 ALL STUDENTS                 BC Public School      34574. 21320.  46155.
    ##  5 ENGLISH LANGUAGE LEARNER     BC Independent School 34916. 20345.  37692.
    ##  6 ENGLISH LANGUAGE LEARNER     BC Public School      25940. 22233.  37508.
    ##  7 FEMALE                       BC Independent School 54328. 32705.  75608.
    ##  8 FEMALE                       BC Public School      33288. 27368.  43300.
    ##  9 MALE                         BC Independent School 54535. 44942.  60371.
    ## 10 MALE                         BC Public School      36428. 31240.  45602.
    ## 11 NON ABORIGINAL               BC Independent School 56484. 42588.  58972.
    ## 12 NON ABORIGINAL               BC Public School      37521. 30602.  38655.
    ## 13 NON ENGLISH LANGUAGE LEARNER BC Independent School 52127. 38048.  61368.
    ## 14 NON ENGLISH LANGUAGE LEARNER BC Public School      35575. 25243.  40598.
    ## 15 SPECIAL NEEDS NO GIFTED      BC Independent School  5677.  1313.   9102.
    ## 16 SPECIAL NEEDS NO GIFTED      BC Public School       3209.   524.   6553.

    ## # A tibble: 16 x 5
    ##    sub_population               public_or_independent    avg `2.5%` `97.5%`
    ##    <fct>                        <chr>                  <dbl>  <dbl>   <dbl>
    ##  1 ABORIGINAL                   BC Independent School  4805.  3694.   5732.
    ##  2 ABORIGINAL                   BC Public School      14107.  8332.  19024.
    ##  3 ALL STUDENTS                 BC Independent School 53487. 44408.  70392.
    ##  4 ALL STUDENTS                 BC Public School      38050. 32351.  47186.
    ##  5 ENGLISH LANGUAGE LEARNER     BC Independent School 26439. 18849.  34665.
    ##  6 ENGLISH LANGUAGE LEARNER     BC Public School      18402. 14214.  29685.
    ##  7 FEMALE                       BC Independent School 57497. 41523.  71191.
    ##  8 FEMALE                       BC Public School      42590. 35227.  55996.
    ##  9 MALE                         BC Independent School 50827. 29953.  56825.
    ## 10 MALE                         BC Public School      34108. 28297.  42301.
    ## 11 NON ABORIGINAL               BC Independent School 57381. 54830.  56691.
    ## 12 NON ABORIGINAL               BC Public School      41046. 35939.  47534.
    ## 13 NON ENGLISH LANGUAGE LEARNER BC Independent School 53749. 43162.  65651.
    ## 14 NON ENGLISH LANGUAGE LEARNER BC Public School      40736. 30499.  47578.
    ## 15 SPECIAL NEEDS NO GIFTED      BC Independent School  9470.  1821.  21338.
    ## 16 SPECIAL NEEDS NO GIFTED      BC Public School       4840.  2162.   8775.

    ## # A tibble: 16 x 5
    ##    sub_population               public_or_independent    avg `2.5%` `97.5%`
    ##    <fct>                        <chr>                  <dbl>  <dbl>   <dbl>
    ##  1 ABORIGINAL                   BC Independent School 12116.  4502.  24210.
    ##  2 ABORIGINAL                   BC Public School      34526. 25676.  49173.
    ##  3 ALL STUDENTS                 BC Independent School 63646. 51566.  80673.
    ##  4 ALL STUDENTS                 BC Public School      66365. 41179.  83311.
    ##  5 ENGLISH LANGUAGE LEARNER     BC Independent School 37102. 30750.  43965.
    ##  6 ENGLISH LANGUAGE LEARNER     BC Public School      45085. 38635.  56347.
    ##  7 FEMALE                       BC Independent School 60108. 54511.  70301.
    ##  8 FEMALE                       BC Public School      70420. 45608.  88640.
    ##  9 MALE                         BC Independent School 59733. 45971.  81156.
    ## 10 MALE                         BC Public School      59303. 43532.  77121.
    ## 11 NON ABORIGINAL               BC Independent School 66405. 41305.  77720.
    ## 12 NON ABORIGINAL               BC Public School      68661. 66672.  78733.
    ## 13 NON ENGLISH LANGUAGE LEARNER BC Independent School 63595. 34252.  75852.
    ## 14 NON ENGLISH LANGUAGE LEARNER BC Public School      67083. 51605.  81517.
    ## 15 SPECIAL NEEDS NO GIFTED      BC Independent School 11142.  2555.   9579.
    ## 16 SPECIAL NEEDS NO GIFTED      BC Public School      12117.  4601.  25101.

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
    ##   sub_population    avg `2.5%` `97.5%`
    ##   <fct>           <dbl>  <dbl>   <dbl>
    ## 1 ABORIGINAL     12544.  7017.  10669.
    ## 2 NON ABORIGINAL 46220. 33302.  50402.

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
    ##   sub_population    avg `2.5%` `97.5%`
    ##   <fct>           <dbl>  <dbl>   <dbl>
    ## 1 ABORIGINAL     19009.  9463.  14067.
    ## 2 NON ABORIGINAL 48978. 34315.  48213.

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
    ##   sub_population    avg `2.5%` `97.5%`
    ##   <fct>           <dbl>  <dbl>   <dbl>
    ## 1 ABORIGINAL     59970. 19284.  47819.
    ## 2 NON ABORIGINAL 78413. 51503.  70444.

### 8\. Summary & Conclusion
