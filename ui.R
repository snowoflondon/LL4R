library(tidyverse)
library(shinythemes)
library(shinycssloaders)

restypeChoices <- c('Viability', 'Inhibition')

fluidPage(
  theme = shinytheme('journal'),
  titlePanel('LL4R experimental'),
  tabsetPanel(
    tabPanel('Single analysis',
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
                              label = 'Run single analysis')
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
    ),
    tabPanel('Batch analysis',
      fluidRow(
        column(width = 4,
               verticalLayout(
                 p('Upload your file here!'),
                 fileInput(inputId = 'fileSelectBatch',
                           accept = c('text/csv', 'text/comma-separated-values', '.csv'),
                           label = 'Browse'),
                 textInput(inputId = 'idSelectBatch',
                           label = 'ID column header: ',
                           value = NULL),
                 textInput(inputId = 'resSelectBatch',
                           label = 'Response column header: ',
                           value = NULL),
                 textInput(inputId = 'concSelectBatch',
                           label = 'Conc. column header: ',
                           value = NULL),
                 selectInput(inputId = 'restypeSelectBatch',
                             label = 'Response metric: ',
                             choices = as.list(restypeChoices)),
                 checkboxInput(inputId = 'rescheckSelectBatch',
                               label = 'Response as percentage? Check for yes ',
                               value = FALSE),
                 checkboxInput(inputId = 'lowerlimSelectBatch',
                               label = 'Constrain lower bound at zero? ',
                               value = FALSE),
                 actionButton(inputId = 'buttonSelectBatch',
                              label = 'Run batch analysis')
               ))
      ),
      fluidRow(
        column(width = 12,
               downloadButton(outputId = 'fileDownloadBatch',
                              label = 'Download result table'))
      ),
      fluidRow(
        column(width = 12,
               DT::dataTableOutput(outputId = 'tableOutBatch') %>%
                 shinycssloaders::withSpinner(color = "#0dc5c1"))
      )
    )
  )
)
