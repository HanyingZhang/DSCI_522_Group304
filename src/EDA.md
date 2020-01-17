EDA
================
DSCI\_522\_Group304
1/16/2020

``` r
rawdata_2007_2016 <- read.csv("https://catalogue.data.gov.bc.ca/dataset/5554165d-e365-422f-bf85-4f6e4c9167dc/resource/97c6cbf7-f529-464a-b771-9719855b86f6/download/fsa.csv")

rawdata_2017_2018 <- read.csv("https://catalogue.data.gov.bc.ca/dataset/5554165d-e365-422f-bf85-4f6e4c9167dc/resource/bcb547f0-8ba7-451f-9e11-10524f4d57a0/download/foundation-skills-assessment-2017-18_to_2018-19.csv")
```

``` r
df_07_16 <- rawdata_2007_2016 %>%
  clean_names() %>%
  select(-data_level, -district_name, -district_number, -school_name, -school_number) %>%
  mutate(score = as.numeric(score),
         number_expected_writers = as.numeric(number_expected_writers),
         number_writers = as.numeric(number_writers),
         number_unknown = as.numeric(number_unknown),
         number_below = as.numeric(number_below),
         number_meeting = as.numeric(number_meeting))
head(df_07_16)
```

    ##   school_year public_or_independent           sub_population
    ## 1   2007/2008      PROVINCE - TOTAL             ALL STUDENTS
    ## 2   2007/2008      PROVINCE - TOTAL                   FEMALE
    ## 3   2007/2008      PROVINCE - TOTAL                     MALE
    ## 4   2007/2008      PROVINCE - TOTAL               ABORIGINAL
    ## 5   2007/2008      PROVINCE - TOTAL           NON ABORIGINAL
    ## 6   2007/2008      PROVINCE - TOTAL ENGLISH LANGUAGE LEARNER
    ##   fsa_skill_code grade number_expected_writers number_writers
    ## 1       Numeracy     4                    1260           2041
    ## 2       Numeracy     4                     658            989
    ## 3       Numeracy     4                     696           1001
    ## 4       Numeracy     4                    1502           2298
    ## 5       Numeracy     4                    1140           1825
    ## 6       Numeracy     4                    1777           2683
    ##   number_unknown number_below number_meeting number_exceeding score
    ## 1            849         1471           1397             4790 46069
    ## 2            368          923            442             2097 43421
    ## 3            478          902            403             2693 48651
    ## 4           1427          332           1462              202 17745
    ## 5            676         1334           1228             4588 50356
    ## 6            207          402           1858              637 32490

``` r
df_17_18 <- rawdata_2017_2018 %>%
  clean_names() %>%
  select(-data_level, -district_name, -district_number, -school_name, -school_number) %>%
  mutate(score = as.numeric(score),
         number_expected_writers = as.numeric(number_expected_writers),
         number_writers = as.numeric(number_writers),
         number_unknown = as.numeric(number_unknown),
         number_emerging = as.numeric(number_emerging),
         number_ontrack = as.numeric(number_ontrack),
         number_extending = as.numeric(number_extending))

head(df_17_18)
```

    ##   school_year public_or_independent           sub_population grade
    ## 1   2017/2018        PROVINCE-TOTAL             ALL STUDENTS     4
    ## 2   2017/2018        PROVINCE-TOTAL                   FEMALE     4
    ## 3   2017/2018        PROVINCE-TOTAL                     MALE     4
    ## 4   2017/2018        PROVINCE-TOTAL               ABORIGINAL     4
    ## 5   2017/2018        PROVINCE-TOTAL           NON ABORIGINAL     4
    ## 6   2017/2018        PROVINCE-TOTAL ENGLISH LANGUAGE LEARNER     4
    ##   fsa_skill_code number_expected_writers number_writers number_unknown
    ## 1       Numeracy                     581            739             48
    ## 2       Numeracy                     297            355            573
    ## 3       Numeracy                     324            386            648
    ## 4       Numeracy                     659            811            148
    ## 5       Numeracy                     536            648            829
    ## 6       Numeracy                     814           1029            362
    ##   number_emerging number_ontrack number_extending score
    ## 1              35            375              280 17879
    ## 2             489             36              102 17137
    ## 3             477             69              161 18606
    ## 4             205            287                9  7414
    ## 5             612            330              275 19439
    ## 6             235            556              336 14088

``` r
df_07_16 %>%
  group_by(public_or_independent) %>%
  summarise(avg = mean(score))
```

    ## # A tibble: 3 x 2
    ##   public_or_independent    avg
    ##   <fct>                  <dbl>
    ## 1 BC Independent School 79042.
    ## 2 BC Public School      68050.
    ## 3 PROVINCE - TOTAL      54552.
