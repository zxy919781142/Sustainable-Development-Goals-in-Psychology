# Sustainable Development Goals in Psychology: A Century of Progress in Publications

![R](https://img.shields.io/badge/R-4.x-blue)
![License: MIT](https://img.shields.io/badge/License-MIT-green)
![PRs welcome](https://img.shields.io/badge/PRs-welcome-brightgreen)

---
**Maintainer** Xinyi Zhao.

**Date of the last update**: 2025-12

**ORCID**: 0000-0002-2552-7795

**Institution1**: Max Planck Institute for Human Development, Berlin, Germany

**Email**: zhao@demogr.mpg.de


---

## Overview

This repository contains data processing, analysis, and figure-generation code for the project **Sustainable Development Goals in Psychology: A Century of Progress in Publications.**

This project offers the first systematic, long-run analysis of psychology’s contributions to the United Nations Sustainable Development Goals (SDGs) through a social- and behavioral-sciences lens, drawing on an unprecedented dataset of 233,061 APA-indexed publications spanning 1894–2022.


## Requirements

- **R version ≥ 4.2**
- Recommended packages:  
  `tidyverse`, `dplyr`, `text2sdg`, `parallel`, `httr2`, `openai`, `rvest`, `rjson`, `lubridate'
  `ggplot2`, `patchwork`

## Description of the files

### 1. code
+ **1.1_sdgs.R**: 
    This script performs parallel SDG detection on psychology article texts using the text2sdg classifier and compiles all batch results into a single dataset for analysis.
  
+ **1.2_gender.R**: 
    This script infers author gender from first names using combined Genderize and GenderAPI data, constructs article-level gender indicators (female first/last author, female share, team size), and saves the results for downstream analysis.
  
+ **1.3_journals.R**:
    This script scrapes APA’s journal subject categories from the web and then maps each journal in articles_meta.csv to an APA subject category—using direct matches, alternative titles, and GPT-based classification as a fallback—before saving the final journal–category lookup to /results/journals.csv.

+ **1.4_citations.R**:
    This script queries the OpenCitations API for each article DOI to retrieve citing DOIs and their creation dates, saves intermediate citation batches, and then combines them into a single citations.csv file for downstream citation analysis.
