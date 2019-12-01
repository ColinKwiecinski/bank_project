library(shiny)
library(markdown)
library(shinythemes)
source("analysis.R")

navbarPage(
    theme = shinythemes::shinytheme("flatly"),
    title = "Bank Visualization Generator",
    
    tabPanel(
        "Main Plots",
        titlePanel("Data Visualization"),
         # Sidebar viz controls
         sidebarLayout(
             sidebarPanel(
                 # Data input
                 fileInput(
                     inputId = "input_df",
                     label = "Bank Data CSV",
                     multiple = FALSE,
                     accept = c("text/csv", 
                                "text/comma-seperated-values",
                                "text/plain",
                                ".csv"),
                     buttonLabel = "Browse"
                     
                 ),
                 dateInput(
                     inputId = "startDate",
                     label = "Start Date",
                     value = "2017-01-01",
                     format = "yyyy-mm-dd",
                     startview = "month",
                     weekstart = 0,
                     language = "en"
                 ), 
                 dateInput(
                     inputId = "endDate",
                     label = "End Date",
                     value = "2100-01-01",
                     format = "yyyy-mm-dd",
                     startview = "month",
                     weekstart = 0,
                     language = "en"
                 ), 
                 helpText(
                     "Terms to filter data by.
                     Leave as \"NULL\" if not in use."
                 ),
                 textInput(
                     inputId = "term_1",
                     label = "Term 1",
                     value = "QFC"
                 ),
                 textInput(
                     inputId = "term_2",
                     label = "Term 2",
                     value = "COSTCO WHSE"
                 ),
                 textInput(
                     inputId = "term_3",
                     label = "Term 3",
                     value = "SAFEWAY"
                 ),
                 textInput(
                     inputId = "term_4",
                     label = "Term 4",
                     value = "NULL"
                 ),
                 textInput(
                     inputId = "term_5",
                     label = "Term 5",
                     value = "NULL"
                 )
             ),
             mainPanel(
                 tabsetPanel(
                     type = "tabs",
                     tabPanel(
                         "Barplot",
                         plotlyOutput("main_barplot")
                     ),
                     tabPanel(
                         "Lineplot",
                         plotlyOutput("main_lineplot")
                     ),
                     tabPanel(
                         "Filtered Barplot",
                         plotlyOutput("filtered_barplot")
                     ),
                     tabPanel(
                         "Filtered Lineplot",
                         plotlyOutput("filtered_lineplot")
                     ),
                     tabPanel(
                         "Filtered Datatable",
                         dataTableOutput("filtered_datatable")
                     ),
                     tabPanel(
                         "Main Datatable",
                         dataTableOutput("main_datatable")
                     )
                 )
             )
        )
    )
)

