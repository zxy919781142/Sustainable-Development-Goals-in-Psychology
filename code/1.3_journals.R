libraries <- c("tidyverse", "rvest", "openai")  # Add any other libraries here

# Function to check and install missing libraries
install_if_missing <- function(pkg) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    install.packages(pkg)
  }
}

# Apply the function to each library
invisible(lapply(libraries, install_if_missing))

library(tidyverse)
library(rvest)
library(openai)


#articles = read_csv("1_data/articles_meta.csv")
articles<-read_csv("/data/articles_meta.csv")
url = "https://www.apa.org/pubs/journals/browse?query=subject&type=journal"

html = read_html(url)

links = html %>% 
  html_element(xpath="//section[@class = 'sbluebg']") %>% 
  html_elements(xpath=".//a")  %>%  
  html_attr("href")


journal_list = list()
for(i in 1:length(links)){
  print(i)
  suffix = "&pageSize=50"
  link_url = paste0(url |> str_remove("\\?query=subject&type=journal"), links[i], suffix)
  html = read_html(link_url)
  
  category = str_remove(links[i], "\\?query=subject:") |> str_replace_all("\\+"," ") %>%  
    str_remove("&type=journal") %>%  str_replace_all("%2c", ",")
  journal_list[[category]] = html%>%  
    html_elements(xpath="//ol") %>%  
    html_elements(xpath=".//p[@class='title']")%>%  
    #html_text("href")
    html_text(TRUE)
  }

journals = tibble(category = rep(names(journal_list), lengths(journal_list)), 
                  journal = unlist(journal_list))%>% 
  mutate(journal = str_replace_all(journal, "&", "&amp;"))
journals =journals%>% pull(category, journal)

article_journals = articles %>% 
  select(journal, journal_other_title) %>%
  distinct() %>% 
  mutate(journal_other_title = str_split(journal_other_title, ";")) 
other_names = article_journals %>% pull(journal_other_title, journal)
  

get_category = function(JOURNAL){
  instruct = paste0(glue::glue("Consider the academic journal '{JOURNAL}'. Which of the following categories separated by semicolon fits the journal best?\n\nCategories: "), paste0(names(journal_list), collapse="; "), "\n\nSelect one of the categories. Only return the category.")
  message = list(list("role" = "user", "content" = instruct))
  out = openai::create_chat_completion(message,
                                       model = "gpt-4o", 
                                       openai_api_key = "OPENAI_TOKEN")
  out$choices$message.content
}

categories = c()
for(i in 1:nrow(article_journals)){
  categories[i] = journals[article_journals$journal[i]]
  if(is.na(categories[i])){
    cand = journals[other_names[[i]]] |> na.omit() |> unique()
    if(length(cand) > 0) {
      categories[i] = cand
    } else {
      categories[i] = get_category(article_journals$journal[i])
      }
    }  
  }


article_journals = article_journals |> mutate(category = categories) |> 
  select(-journal_other_title)

write_csv(article_journals |> filter(!duplicated(journal)), "/results/journals.csv")



