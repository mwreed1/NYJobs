source("C:/Users/12737/Desktop/Udemy/Data Visualization R and ggplot2/dependencies.R")

jobs <- read_csv("C:/Users/12737/Desktop/NYJobs-main/data/NYC_Jobs.csv")
jobs <- jobs %>%
  clean_names() %>%
  mutate(
    category_simple = case_when(
      str_detect(job_category, "Human Resources") ~ "Human Resources",
      str_detect(job_category, "Building Operations") ~ "Building Operations",
      str_detect(job_category, "Administrative Support") ~ "Administrative Support",
      str_detect(job_category, "Communications") ~ "Communications",
      str_detect(job_category, "Constituent Services") ~ "Constituent Services",
      str_detect(job_category, "Engineering") ~ "Engineering",
      str_detect(job_category, "Finance") ~ "Finance",
      str_detect(job_category, "Health") ~ "Health",
      str_detect(job_category, "Legal") ~ "Legal",
      str_detect(job_category, "Policy") ~ "Policy, Research & Analysis",
      str_detect(job_category, "Public Safety") ~ "Public Safety",
      str_detect(job_category, "Social Services") ~ "Social Services",
      str_detect(job_category, "Technology") ~ "Technology & Data",
      TRUE ~ "Other"
    ),
    agency_simple = str_to_title(agency),
    agency_simple = case_when(
      str_detect(agency_simple, "District Attorney") ~ "District Attorney",
      str_detect(agency_simple, "Community Board") ~ "Community Board",
      TRUE ~ agency_simple
    ),
    posting_date = as.Date(posting_date, "%m/%d/%Y"),
    posting_updated = as.Date(posting_updated, "%m/%d/%Y"),
    level_simple = case_when(
      startsWith(level, "0") ~ "0",
      startsWith(level, "M") ~ "M",
      TRUE ~ "1"
    )
  )
jobs <- jobs %>% select(salary_range_from, category_simple, posting_date)
jobs <- jobs[order(as.Date(jobs$posting_date, format="%m/%d/%Y")),]
jobs <- jobs[jobs$salary_range_from >= 500,] # Remove rows with annual salary lower than 500
jobs <- jobs[-(1:146),] # only keep the data starting from 2021 since the data set is insufficient in previous years
setDT(jobs)[, posting_date := format(as.Date(posting_date), "%Y-%m") ] # Only keep the month and year
jobs <- jobs %>%  # Find the mean salaries of jobs under the same category, posted in the same month
  group_by(category_simple, posting_date)%>%
  summarize(mean_starting_salary = mean(salary_range_from))

