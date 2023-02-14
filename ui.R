library(tidyverse)
library(shinythemes)
library(shinycssloaders)

restypeChoices <- c('Viability', 'Inhibition')

fluidPage(
  theme = shinytheme('journal'),
  titlePanel('LL4R experimental'),
  fluidRow(
    column(width = 4,
           verticalLayout(
             p('Upload your file here!'),
             fileInput(inputId = 'fileSelect',
                       accept = c('text/csv', 'text/comma-separated-values', '.csv'),
                       label = 'Browse'),
             textInput(inputId = 'idSelect',
                       label = 'ID column header: ',
                       value = NULL),
             textInput(inputId = 'resSelect',
                       label = 'Response column header: ',
                       value = NULL),
             textInput(inputId = 'concSelect',
                       label = 'Conc. column header: ',
                       value = NULL),
             selectInput(inputId = 'restypeSelect',
                         label = 'Response metric: ',
                         choices = as.list(restypeChoices)),
             checkboxInput(inputId = 'rescheckSelect',
                           label = 'Response as percentage? Check for yes ',
                           value = FALSE),
             checkboxInput(inputId = 'lowerlimSelect',
                           label = 'Constrain lower bound at zero? ',
                           value = FALSE),
             actionButton(inputId = 'buttonSelect',
                          label = 'Run')
           )),
      column(width = 8,
             DT::dataTableOutput(outputId = 'tableOut') %>%
               shinycssloaders::withSpinner(color = "#0dc5c1"))
  ),
  fixedRow(
    column(width = 5, style = "height: 600vh;",
           plotOutput(outputId = 'plotOut') %>%
             shinycssloaders::withSpinner(color = "#0dc5c1"))
  )
)