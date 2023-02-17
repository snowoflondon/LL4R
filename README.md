# LL4R
This repository contains the source code for the Shiny web app hosted here: https://brianjmpark.shinyapps.io/ll4r/.
The goal of this web app is to quickly visualize and obtain statistics for dose-response curve fitting performed by the R package `drc` - https://cran.r-project.org/web/packages/drc/index.html.

## Quick Run-through
The app currently supports `Single analysis` and `Batch analysis` - for the former, the identifier column must contain one unique ID (i.e., one sample) while the latter supports multiple IDs in the same column with corresponding dose-response values.

The web app accepts text delimited files containing three fields: 
* the identifier 
* the concentration of drug
* the viability/inhibition readout (often obtained via cell plate assays). 

The header (i.e., column names) for each of the three fields must be entered in the three text fields. Response type (i.e., viability or inhibition - inverses of one another) can be specified in the drop-down. If the response values are in percentages (i.e., between 1-100), the checkbox for *Response as percentage? Check for yes* must be ticked. Otherwise (i.e., if values are in decimals), leave this box unticked. Finally, the app provides the option to set the lower limit constraint to zero. This corresponds to setting the `lowerl` argument within `drc::drm` to `c(-Inf, 0, -Inf, -Inf)`. Leaving this box unticked will fit the model in default settings (i.e., all lower bound constraints are negative infinity).

Once run, the app will provide a table containing model parameters and their estimate errors. This is equivalent to running `broom::tidy` on the model object provided by `drc::drm`. The residual standard error is provided in the rightmost column, and this singular value corresponds to the `rseMat` value in the object returned by `summary()` function on the `drc::drm` model. The dose-response curve, returned by `plot.drc` is provided for single analysis.

## R dependencies
Core:
* `dplyr`
* `drc`
* `broom`

Shiny interface:
* `DT`
* `shinythemes`
* `shinycssloaders`

## R sessionInfo

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
