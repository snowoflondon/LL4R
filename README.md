# LL4R
This repository contains the source code for the Shiny web app hosted here: https://brianjmpark.shinyapps.io/ll4r/.
The goal of this web app is to quickly visualize and obtain statistics for dose-response curve fitting performed by the R package `drc` (on [CRAN](https://cran.r-project.org/web/packages/drc/index.html))

## Tutorial

Tl;dr: User input a delimited text file containing dose-response relationship data for a particular drug/treatment. Three unique columns are needed, which correspond to the unique `identifier`, the `dose` of drug, and the `response` (usually cell viability or inhibition conferred by treatment). 

Opening the Shiny app via a web browser will show the following interface:

![Screen Shot 2023-03-30 at 3 46 00 PM](https://user-images.githubusercontent.com/76887483/228948171-d8a41e42-5415-4ecb-a00c-82707ceff9cc.png)
The program supports two types of analyses based on the number of unique sample identifiers user wish to analyze. `Single analysis` will fit the `drc::drm` model (using `LL4` curve) on a single drug/treatment (i.e., one unique identifier under the `identifier` column). `Batch analysis` will fit the `LL4` model on multiple identifiers. 

* **A**: Tab selection for `Single analysis` or `Batch analysis`
* **B**: File browser for user input; currently supports .csv and .tsv file formats
* **C**: Column header name for the column containing the `identifier` in the user input file
* **D**: Column header name for the column containing the `response` in the user input file
* **E**: Column header name for the column containing the `dose` in the user input file
* **F**: User selectinon for the type of `response` in the input data; either viability or inhibition
* **G**: Checkbox for the `response` data format; check if the `response` values are in percentages (i.e., values between 0-100); leave unchecked if decimals (i.e., values between 0-1); default is unchecked
* **H**: Checkbox for forcing the lower bound of the `lower limit` parameter of the LL4 model to zero; this is equivalent to setting the `lowerl` parameter within `drc::drm` to `c(-Inf, 0, -Inf, -Inf)`; default is `-Inf`; default is unchecked
* **I**: Running the analysis provides program output

## R dependencies
Core:
* `dplyr`, `tidyr`, `purrr`
* `drc`
* `broom`

Shiny interface:
* `DT`
* `shinycssloaders`
* `htmltools`
* `bslib`

## R sessionInfo
```{r}
R version 4.0.5 (2021-03-31)
Platform: x86_64-apple-darwin17.0 (64-bit)
Running under: macOS Big Sur 11.2.3

Matrix products: default
LAPACK: /Library/Frameworks/R.framework/Versions/4.0/Resources/lib/libRlapack.dylib

locale:
[1] en_CA.UTF-8/en_CA.UTF-8/en_CA.UTF-8/C/en_CA.UTF-8/en_CA.UTF-8

attached base packages:
[1] stats     graphics  grDevices utils     datasets  methods   base     

other attached packages:
 [1] rsconnect_0.8.25      DT_0.26               drc_3.0-1             MASS_7.3-55          
 [5] broom_0.7.12          shinycssloaders_1.0.0 shinythemes_1.2.0     forcats_0.5.1        
 [9] stringr_1.4.0         dplyr_1.0.5           purrr_0.3.4           readr_1.4.0          
[13] tidyr_1.1.3           tibble_3.1.1          ggplot2_3.3.3         tidyverse_1.3.1      
[17] shiny_1.6.0          

loaded via a namespace (and not attached):
 [1] fs_1.5.0            lubridate_1.7.10    httr_1.4.2          tools_4.0.5        
 [5] backports_1.2.1     bslib_0.4.0         utf8_1.2.1          R6_2.5.0           
 [9] DBI_1.1.1           colorspace_2.0-0    withr_2.4.2         tidyselect_1.1.0   
[13] curl_4.3            compiler_4.0.5      cli_3.1.0           rvest_1.0.3        
[17] xml2_1.3.3          sandwich_3.0-0      sass_0.4.2          scales_1.1.1       
[21] mvtnorm_1.1-1       askpass_1.1         digest_0.6.27       foreign_0.8-81     
[25] rio_0.5.26          pkgconfig_2.0.3     htmltools_0.5.3     sourcetools_0.1.7  
[29] plotrix_3.8-1       dbplyr_2.1.1        fastmap_1.1.0       htmlwidgets_1.5.4  
[33] rlang_1.0.6         readxl_1.3.1        rstudioapi_0.13     jquerylib_0.1.4    
[37] generics_0.1.0      zoo_1.8-9           jsonlite_1.7.2      crosstalk_1.1.1    
[41] gtools_3.8.2        zip_2.1.1           car_3.0-10          magrittr_2.0.1     
[45] Matrix_1.3-2        Rcpp_1.0.6          munsell_0.5.0       fansi_0.4.2        
[49] abind_1.4-5         lifecycle_1.0.0     stringi_1.5.3       multcomp_1.4-16    
[53] yaml_2.2.1          carData_3.0-4       grid_4.0.5          promises_1.2.0.1   
[57] crayon_1.4.1        lattice_0.20-41     haven_2.4.1         splines_4.0.5      
[61] hms_1.0.0           pillar_1.6.0        codetools_0.2-18    reprex_2.0.0       
[65] glue_1.4.2          packrat_0.7.0       BiocManager_1.30.12 data.table_1.14.0  
[69] modelr_0.1.8        vctrs_0.3.7         httpuv_1.6.0        cellranger_1.1.0   
[73] gtable_0.3.0        openssl_1.4.3       assertthat_0.2.1    cachem_1.0.4       
[77] openxlsx_4.2.3      mime_0.10           xtable_1.8-4        later_1.2.0        
[81] survival_3.2-13     memoise_2.0.0       TH.data_1.0-10      ellipsis_0.3.1
```
