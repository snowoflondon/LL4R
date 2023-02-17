library(tidyverse)
library(broom)
library(drc)
library(DT)

fit_model <- function(x, lc){
  if (lc == TRUE){
    model <- drc::drm(Response ~ Conc, data = x, 
                    fct = LL.4(names = c('Hill', 'LowerL', 'UpperL', 'EC50')),
                    lowerl = c(-Inf, 0, -Inf, -Inf))
  }
  if (lc == FALSE) {
    model <- drc::drm(Response ~ Conc, data = x,
                      fct = LL.4(names = c('Hill', 'LowerL', 'UpperL', 'EC50')))
  }
  t <- broom::tidy(model)
  s <- summary(model)
  t <- t %>% mutate(RSE = as.numeric(s$rseMat[1,1]))
  return(t)
}

fit_model_batch <- function(x, lc){
  if (lc == TRUE){
    model <- drc::drm(Response ~ Conc, data = x, 
                      fct = LL.4(names = c('Hill', 'LowerL', 'UpperL', 'EC50')),
                      lowerl = c(-Inf, 0, -Inf, -Inf))
  }
  if (lc == FALSE) {
    model <- drc::drm(Response ~ Conc, data = x,
                      fct = LL.4(names = c('Hill', 'LowerL', 'UpperL', 'EC50')))
  }
  t <- broom::tidy(model)
  s <- summary(model)
  out <- tibble(
    'ID' = unique(x$ID),
    'EC50' = as.numeric(t[4,3]),
    'EC50_SE' = as.numeric(t[4,4]),
    'EC50_pVal' = as.numeric(t[4,6]),
    'Hill' = as.numeric(t[1,3]),
    'Hill_SE' = as.numeric(t[1,4]),
    'Hill_pVal' = as.numeric(t[1,6]),
    'LowerLimit' = as.numeric(t[2,3]),
    'LowerLimit_SE' = as.numeric(t[2,4]),
    'LowerLimit_pVal' = as.numeric(t[2,6]),
    'UpperLimit' = as.numeric(t[3,3]),
    'UpperLimit_SE' = as.numeric(t[3,4]),
    'UpperLimit_pVal' = as.numeric(t[3,6]),
    'RSE' = as.numeric(s$rseMat[1,1])
  )
  return(out)
}

server <- function(input, output){
  react_data <- eventReactive(input$buttonSelect, {
    df <- read_csv(input$fileSelect$datapath)
    df <- df %>% rename(ID = UQ(sym(input$idSelect)),
                        Response = UQ(sym(input$resSelect)),
                        Conc = UQ(sym(input$concSelect)))
    if (input$rescheckSelect == TRUE){
      df <- df %>% mutate(Response = Response/100)
    }
    if (input$restypeSelect == 'Inhibition'){
      df <- df %>% mutate(Response = 1 - Response)
    }
    df <- df %>% dplyr::select(ID, Response, Conc)
    return(df)
  })
  
  output$tableOut <- DT::renderDataTable({
    if (input$lowerlimSelect == TRUE){
      fit_model(x = react_data(), lc = TRUE)
    } else {
      fit_model(x = react_data(), lc = FALSE)
    }
  })
  
  output$plotOut <- renderPlot({
    if (input$lowerlimSelect == TRUE){
      mod <- drc::drm(Response ~ Conc, data = react_data(),
                      fct = LL.4(names = c('Hill', 'LowerL', 'UpperL', 'EC50')),
                      lowerl = c(-Inf, 0, -Inf, -Inf))
    } else {
      mod <- drc::drm(Response ~ Conc, data = react_data(),
                      fct = LL.4(names = c('Hill', 'LowerL', 'UpperL', 'EC50')))
    }
    plot(mod, main = react_data() %>% pull(ID) %>% unique() %>% as.character(),
         height = 200, width = 300)
  })
  
  react_data_batch <- eventReactive(input$buttonSelectBatch,{
    df <- read_csv(input$fileSelectBatch$datapath)
    df <- df %>% rename(ID = UQ(sym(input$idSelectBatch)),
                        Response = UQ(sym(input$resSelectBatch)),
                        Conc = UQ(sym(input$concSelectBatch)))
    if (input$rescheckSelectBatch == TRUE){
      df <- df %>% mutate(Response = Response/100)
    }
    if (input$restypeSelectBatch == 'Inhibition'){
      df <- df %>% mutate(Response = 1 - Response)
    }
    df <- df %>% dplyr::select(ID, Response, Conc) %>%
      mutate(ID = factor(ID, levels = unique(ID)))
    df <- df %>% group_split(ID)
    
    if (input$lowerlimSelectBatch == TRUE){
      res <- map(df, 
                 possibly(~ fit_model_batch(.x, lc = TRUE), NA))
    } else {
      res <- map(df, 
                 possibly(~ fit_model_batch(.x, lc = FALSE), NA))
    }
    #res <- res[-which(is.na(res))]
    res <- bind_rows(res)
    return(res)
  })
  
  output$tableOutBatch <- DT::renderDataTable({
    react_data_batch()
  })
  
  output$fileDownloadBatch <- downloadHandler(
    filename = 'LL4R_batchResult.csv',
    content = function(file){
      write_csv(react_data_batch(), file)
    }
  )
}
