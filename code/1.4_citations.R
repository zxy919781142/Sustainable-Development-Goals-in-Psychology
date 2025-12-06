library(tidyverse)
library(lubridate)
library(rjson)

articles = read_csv("/data/articles_meta.csv")

dois = rev(articles$DOI[!is.na(articles$DOI)])

token = "..." # the token for opencitations

api = "https://opencitations.net/index/api/v1/citations/"


for(i in 1:length(dois)){
  
  print(i)
  
  if(i %% 1000 == 1){
    citations = list()
    }
  
  if(i %% 1000 == 0 | i == length(dois)){
    cat("Processed", i, "\n")
    citations_tbl = do.call(bind_rows, citations)
    write_csv(citations_tbl, paste0("/result/citations_date/citations_",i,".csv"))
    }
  
  query = paste0(api, dois[i], "?authorization=", token) %>% str_replace_all("[:blank:]", "%20")
  
  result = rjson::fromJSON(file = query) %>% try()
  
  if(class(result) == "try-error") next
  
  if(length(result) == 0) next
  
  #print("found")
  
  citations[[i]] = sapply(result, function(x) c(citing = x$citing, date = x$creation)) %>% 
    t() %>% as_tibble() %>% 
    mutate_all(function(x) str_remove(x, "coci => ")) %>% 
    mutate(cited = dois[i]) %>% 
    select(cited, everything())
  
  }

files = list.files("1_data/citations_date/", full.names = T)
citations = lapply(files, read_csv) |> do.call(what = rbind)

write_csv(citations, "/result/citations.csv")


