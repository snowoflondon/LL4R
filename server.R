library(tidyverse)
library(broom)
library(drc)
library(DT)
library(htmltools)

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
  out <- t %>% dplyr::select(-c(curve, statistic)) %>%
    pivot_longer(-term, names_to = 'Estimate', values_to = 'Values') %>%
    unite('ID', c(term, Estimate), sep = "_") %>%
    pivot_wider(names_from = ID, values_from = Values) %>%
    mutate(RSE = s$rseMat[1,1]) %>%
    mutate(ID = unique(x$ID))
  names(out) <- gsub('_estimate', '', names(out))
  out <- out %>% dplyr::select(
    c(ID, starts_with('EC'), starts_with('H'), 
      starts_with('Low'), starts_with('Upp'), RSE)
  )
  return(out)
}

server <- function(input, output){
  react_data <- eventReactive(input$buttonSelect, {
    df <- read_csv(input$fileSelect$datapath)
    validate(need(
      expr = c(input$idSelect, input$resSelect, input$concSelect) %in%
        colnames(df) %>% all(),
      message = 'Error! Ensure input column headers match headers in the file!'
    ))
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
  
  observeEvent(input$lowerlimSelect, {
    showModal(modalDialog(
      title = 'Caution!',
      'Parameter constraints should only be set if
      user has prior knowlege about the dose-response behavior
      of sample!',
      easyClose = TRUE, footer = NULL
    ))
  }, ignoreInit = TRUE, once = TRUE)
  
  output$tableOut <- DT::renderDataTable(
    caption = htmltools::tags$caption(style = 'caption-side: top; 
                                      text-align: center; 
                                      color:black;  
                                      font-size:200% ;',
                                      'LL4 fit estimates result'),{
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
    validate(need(
      expr = c(input$idSelectBatch, input$resSelectBatch, input$concSelectBatch) %in%
        colnames(df) %>% all(),
      message = 'Error! Ensure input column headers match headers in the file!'
    ))
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
  
  output$tableOutBatch <- DT::renderDataTable(
    caption = htmltools::tags$caption(style = 'caption-side: top; 
                                      text-align: center; 
                                      color:black;  
                                      font-size:200% ;',
                                      'LL4 fit estimates result (detailed)'),{
    react_data_batch()
  })
  
  output$tableOutBatchSimple <- DT::renderDataTable(
    caption = htmltools::tags$caption(style = 'caption-side: top; 
                                      text-align: center; 
                                      color:black;  
                                      font-size:200% ;',
                                      'LL4 fit estimates result (condensed)'), {
    react_data_batch() %>% dplyr::select(
      c('ID', 'EC50', 'Hill', 'LowerL', 'UpperL', 'RSE')
    )
  })
  
  output$fileDownloadBatch <- downloadHandler(
    filename = 'LL4R_batchResult.csv',
    content = function(file){
      write_csv(react_data_batch(), file)
    }
  )
}
