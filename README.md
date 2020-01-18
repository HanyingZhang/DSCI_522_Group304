# Are There Differences in FSA Scores Between Subgroups?
**DSCI 522 Group 304 Members:** Anny Chih, Robert Pimentel, and Wenjiao Zou  
  
This project repository contains scripts and data for analyzing the results of British Columbia's Foundation Skills Assessment (FSA) exams from school years 2007/08-2018/19. 

## Project Proposal
### DATA DESCRIPTION
[BC Schools - Foundation Skills Assssment (FSA)](https://catalogue.data.gov.bc.ca/dataset/bc-schools-foundation-skills-assessment-fsa-)  
Published by the [Ministry of Education](https://catalogue.data.gov.bc.ca/organization/ministry-of-education) - [Education Analytics](https://catalogue.data.gov.bc.ca/organization/education-analytics)  
Licensed under an [Open Government Licence - British Columbia](https://www2.gov.bc.ca/gov/content/data/open-data/open-government-licence-bc)  

This project uses two data files from the BC Ministry of Education that contain FSA scores from BC students in Grades 4 and 7. The data in the two files have some differences in score summary columns (see FSA field definitions for more info), so only the following common fields from these data files are included in this project's analysis.

* SCHOOL_YEAR: Ranges from 2007/08 - 2018/19
* DATA_LEVEL: (Province / District / School Level)
* PUBLIC_OR_INDEPENDENT: (BC Public School / BC Independent School / Province Total)
* DISTRICT_NUMBER: Number of the school district (3-digit string)
* DISTRICT_NAME: Name of the school district (61 districts)
* SCHOOL_NUMBER: 8-digit numerical school identifier
* SCHOOL_NAME: Name of the school (1,875 schools)
* SUB_POPULATION: (All Students / Female / Male / Aboriginal / Non Aboriginal / English Language Learner / Non English Language Learner / Special Needs No Gifted)*
* GRADE: Grade level of the FSA test (4 or 7)
* FSA_SKILL_CODE: Subject of the FSA exam (Numeracy / Reading / Writing)
* NUMBER_EXPECTED_WRITERS: Number of students expected to participate in the FSA
* NUMBER_WRITERS: Number of students who wrote the FSA
* SCORE: Mean score for the school, district, or province. This score only counts students who wrote and is rounded up to 5 decimal points.**

*Note: Students can be part of several sub populations (ex. a Female Aboriginal Non English Language Learner would be part of All Students, Female, Aboriginal, and Non English Language Learner subgroups)

**Note: Based on the technical notes outlined about the FSA, the Numeracy, Reading, and Writing components of the exam each include a different number of multiple-choice and written-response answers, with each section graded for a total of between 12 and 48 marks. The Reading and Numeracy component scores are scaled and standardized to be between 200 and 800, with a mean of 500. The Writing component scores are not scaled, and are out of 12 marks. 

**Links to Preview Data:**  
- [Foundation Skills Assessment 2017/18 - 2018/19](https://catalogue.data.gov.bc.ca/dataset/bc-schools-foundation-skills-assessment-fsa-/resource/bcb547f0-8ba7-451f-9e11-10524f4d57a0)  
- [Foundation Skills Assessment 2007/08 - 2016/17](https://catalogue.data.gov.bc.ca/dataset/bc-schools-foundation-skills-assessment-fsa-/resource/97c6cbf7-f529-464a-b771-9719855b86f6)

**Links to Preview Data Field Definitions:**  
- [FSA Field Definitions 2017/18 - 2018/19](https://catalogue.data.gov.bc.ca/dataset/bc-schools-foundation-skills-assessment-fsa-/resource/ccc5ae0c-922a-4c11-ad44-908d6ec8a873)  
- [FSA Field Definitions 2007/08 - 2016/17](https://catalogue.data.gov.bc.ca/dataset/bc-schools-foundation-skills-assessment-fsa-/resource/5f6d7594-5645-4cda-980b-87195d1c1c16)

### INFERENTIAL RESEARCH QUESTIONS
This project will attempt to answer two main inferential research questions:  

1. Is there a difference in how well BC Public School vs Independent School students perform on the FSA exam?  
2. Is there a difference in how well Aboriginal vs Non Aboriginal students perform on the FSA exam?

*Note:* Though the project assignment requires only one inferential/predictive research question, since these are relatively simple questions we've chosen two.

**Subquestions to the main research questions include:**  

1. (Descriptive) Which school type (Public / Independent) has a higher average FSA score across all school years?  
2. (Descriptive) Which group of students (Aboriginal / Non Aboriginal) has a higher average FSA score across all school years?  
3. (Exploratory) Are there trends in average FSA scores for Public or Independent School students between 2007/08 - 2018/19 school years?  
4. (Exploratory) Are there trends in average FSA scores for Aboriginal or Non Aboriginal students between 2007/08 - 2018/19 school years?  

### ANALYSIS PLAN
To analyze the data, we will produce the following for each of the two main inferential research questions:  

1. Hypothesis Test for Difference in Means (t-test):  
    * $H_0$: There is no difference between the mean FSA scores between groups  
    * $H_A$: There exists a difference between the mean FSA scores between groups  
2. Estimate and Confidence Intervals of mean FSA scores for each group

These analysis methods will be used to look at mean scores for all FSA Skill types together as well as separately (Numeracy, Reading, Writing) for the different groups.

In addition to the methods above, we will also be comparing means of FSA scores for each group to answer subquestions.

### EXPLORATORY TABLES AND FIGURES
To explore the data, we will use the following tables and figures for each of the two main inferential research questions:  

1. Summary Statistics Tables: based on mean FSA scores by subgroup  
2. Bar Chart: showing mean scores by subgroup  
3. Overlapping Histograms: showing mean FSA score distributions, color-coded by subgroup  
4. Time-series Scatterplots: showing mean FSA scores (y-axis) over school years (x-axis) with a dot   representing each school (color-coded by subgroup) and a possible linear regression line  

### REPORTING 
To report project findings, we will share the results of the analyses using the following visual aids:

1. Boxplots of mean FSA scores by group  
2. Overlapping Histograms of mean FSA score distributions with confidence intervals clearly marked