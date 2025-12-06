require(tidyverse)
require(text2sdg)

library(dplyr)
library(text2sdg)
library(parallel)



#setwd("//mpib-berlin.mpg.de/FB-AR/Users/ZhaoXinyi/1_Project/4_apa_SDG/PsychSDG")
articles = read_csv("/data/articles_meta.csv") 

articles_texts = articles %>% 
  filter(!is.na(title),!is.na(abstract)) %>% 
  mutate(text = paste0(title, ". ", abstract))
articles_texts<-sample_n(articles_texts,1000)
# setup parqllel -----

set.seed(100)
ids = split(sample(articles_texts$id), floor(seq(1,100.999, length = nrow(articles_texts))))

run_sdgs <- function(i,articles_texts,ids){
  
  print(i)
  
  articles_texts_sel = articles_texts %>% filter(id %in% ids[[i]]) 
  hits = text2sdg::detect_sdg(articles_texts_sel$text)
  hits = hits %>% mutate(id = articles_texts_sel$id[as.numeric(as.character(document))],
                         sdg = as.character(sdg))
  
  write_csv(hits, paste0("1_data/sdgs_test/sdgs_",i,".csv"))
  }

# run parqllel and gather -----
# Number of cores to use
num_cores <- detectCores() - 1  # Use all but one core

# Create a PSOCK cluster
cl <- makeCluster(10, type = "PSOCK")

# Load `dplyr` on each worker
clusterEvalQ(cl, library(dplyr))
clusterEvalQ(cl, library(text2sdg))
clusterEvalQ(cl, library(readr))
clusterExport(cl, varlist = c("run_sdgs", "articles_texts", "ids"))
res <- parLapply(cl, 1:length(ids), function(x) run_sdgs(x, articles_texts,ids))

#cl = parallel::makeForkCluster(nnodes = 40)
#res = parallel::clusterApplyLB(cl, 1:length(ids), run_sdgs)
parallel::stopCluster(cl)

files = list.files("1_data/sdgs_test/", pattern = "*.csv", full.names = TRUE)
file_list_data  <- lapply(files, function(file) {
  data <- read.csv(file, stringsAsFactors = FALSE)  # Read each file
  data$sdg <- as.character(data$sdg)               # Ensure `sdg` column is character
  return(data)                                     # Return the processed file
})

file_list_data <- file_list_data[sapply(file_list_data, function(x) !is.null(x) && nrow(x) > 0)]
sdgs<-bind_rows(file_list_data)

write_csv(sdgs, "/results/sdgs.csv")
sdgs<- read_csv("/results/sdgs.csv")




