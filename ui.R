library(magrittr)
library(shinythemes)
library(shinycssloaders)
library(bslib)
library(DT)

theme <- bslib::bs_theme(
  bg = "#eeeeee", fg = "#252e3c",
  primary = "#b6d7a8", secondary = "#b6d7a8",
  base_font = font_google("Roboto Serif", local = TRUE),
  code_font = c("Courier", "monospace"),
  heading_font = font_google("Roboto Serif", local = TRUE),
  "input-border-color" = "#f1ebdd"
)

restypeChoices <- c('Viability', 'Inhibition')

fluidPage(
  theme = theme,
  titlePanel('LL4R - dose response fitting using the drc package',
             windowTitle = 'LL4R by snowoflondon'),
  tabsetPanel(
    tabPanel(div('Single analysis', style = "color: #2f4f4f"),
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
                               label = 'Constrain lower bound at zero? Check for yes',
                               value = FALSE),
                 actionButton(inputId = 'buttonSelect',
                              label = 'Run single analysis'),
                 a(href = 'https://cran.r-project.org/web/packages/drc/index.html',
                   'Run using R package drc by Ritz et al',
                   style = 'color: grey;'),
                 a(href = 'https://github.com/snowoflondon/LL4R',
                   'Shiny app source code and documentation',
                   style = 'color: grey;')
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
    tabPanel(div('Batch analysis', style = "color: #2f4f4f"),
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
                               label = 'Constrain lower bound at zero? Check for yes',
                               value = FALSE),
                 actionButton(inputId = 'buttonSelectBatch',
                              label = 'Run batch analysis')
               )),
        column(width = 8,
               DT::dataTableOutput(outputId = 'tableOutBatchSimple') %>%
                 shinycssloaders::withSpinner(color = "#0dc5c1"))
      ),
      fluidRow(
        column(width = 12,
               downloadButton(outputId = 'fileDownloadBatch',
                              label = 'Download result table',
                              style = "margin-top:5px;"))
      ),
      fluidRow(
        column(width = 12,
               DT::dataTableOutput(outputId = 'tableOutBatch') %>%
                 shinycssloaders::withSpinner(color = "#0dc5c1"))
      )
    )
  )
)