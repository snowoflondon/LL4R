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
}