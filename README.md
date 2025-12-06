# Leaky Pipeline in Psychology

![R](https://img.shields.io/badge/R-4.x-blue)
![License: MIT](https://img.shields.io/badge/License-MIT-green)
![PRs welcome](https://img.shields.io/badge/PRs-welcome-brightgreen)

---
**Maintainer** Xinyi Zhao.

**Date of the last update**: 2025-10

**ORCID**: 0000-0002-2552-7795

**Institution1**: Max Planck Institute for Human Development, Berlin, Germany

**Email**: zhao@demogr.mpg.de


---

## Overview

This repository contains data processing, analysis, and figure-generation code for the project **“Failing in retention, not recruitment: Gender differences in academic progression in psychology.”**

The project investigates gender differences in academic progression within the field of psychology, focusing on *when* gaps emerge and *where* retention shortfalls occur. Using large-scale bibliometric data, it examines academic age trajectories, publication performance, and cohort-based gender disparities.


## Requirements

- **R version ≥ 4.2**
- Recommended packages:  
  `tidyverse`, `data.table`, `janitor`, `lubridate`, `readr`, `stringr`,  
  `ggplot2`, `patchwork`, `broom`, `scales`, and any modeling packages referenced in `R_code/`.

## Description of the files

### 1. data
+ **1_female_field_cohort.csv**: 
    Proportion of women among psychology entrants by subfield and cohort (2000-2014).
  
+ **2_earlycareer_character.csv**: 
    Processed variables for researchers by academic aga (main dataset for analysis).
  
+ **3_stage_trans_gap_yearly.csv**:
    Transfer rate (staying academic from previous year to the target year) among psychology entranst by academic age and cohort. 
