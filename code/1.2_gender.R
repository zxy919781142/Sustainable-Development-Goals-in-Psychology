require(tidyverse)
require(httr2)
#source("2_code/_helpers.R")


articles = read_csv("/data/articles_meta.csv")


firsts = articles$author_first_names %>% 
  str_replace_all("\\b[A-Z][:punct:]","") %>% 
  str_replace_all("\\b[a-z][:punct:]","") %>% 
  str_split(";") %>% 
  lapply(function(x) str_extract(x, "[A-Z][:alpha:]+") %>% str_squish())

firsts_uni = firsts %>% unlist() %>% unique() %>% na.omit()

#write_csv(tibble(first_name = firsts_uni), "1_data/gender/names.csv")

genderize <- read_csv("/data/genderize.csv")%>% 
  rename("gender" = "Gender", 
         "gender_probability" = "Gender Probability" , 
         "gender_count" ="Gender Count")


genderapi <-read_csv("/data/genderapi.csv") %>%  slice(-1) %>% rename("first_name" = "Col 1") %>%  
  rename(gender_probability = probability)

gender <- tibble(firsts_uni)%>% rename(first_name = firsts_uni)%>%  
  left_join(genderize, by = "first_name") %>%  
  left_join(genderapi[,c('first_name', 'gender', 'gender_probability')], by = "first_name", 
            suffix = c("_gz","_ga"))

gender_dict_gz = gender %>% pull(gender_gz, first_name)
gender_dict_ga = gender%>% pull(gender_ga, first_name)

firsts_gz = lapply(firsts, function(x) gender_dict_gz[x])
firsts_ga = lapply(firsts, function(x) gender_dict_ga[x])

sum(sapply(firsts_gz, function(x) any(!is.na(x))))

gender_articles <-articles %>%
  select(id) %>% 
  mutate(female_first = sapply(firsts_gz, function(x) x[1] == "female"),
         female_last = sapply(firsts_gz, function(x) x[length(x)] == "female"),
         female_percent = sapply(firsts_gz, function(x) mean(x == "female")),
         n_authors = lengths(firsts_gz))

write_csv(gender_articles, "1_data/results/gender.csv")

gender_articles %>%
  summarise(
    prop_female_first = mean(female_first, na.rm = TRUE),
    prop_female_last  = mean(female_last, na.rm = TRUE),
    avg_female_percent = mean(female_percent, na.rm = TRUE),
    avg_author = mean(n_authors, na.rm = TRUE)
  )
  

