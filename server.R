library(shiny)
source("analysis.R")


shinyServer(function(input, output) {
    infile <- reactive({ input$input_df })
    main_df <- reactive({ read.csv(infile()$datapath, stringsAsFactors = FALSE) })
    startDate <- reactive({ input$startDate })
    endDate <- reactive({ input$endDate })
    term1 <- reactive({ input$term_1 })
    term2 <- reactive({ input$term_2 })
    term3 <- reactive({ input$term_3 })
    term4 <- reactive({ input$term_4 })
    term5 <- reactive({ input$term_5 })
    deposit <- reactive({ get_monthly_df(get_deposits(main_df()), startDate(), endDate()) })
    spend <- reactive ({ get_monthly_df(get_spend(main_df()), startDate(), endDate()) })
    filtered_df <- reactive({ get_filtered_df(main_df(), term1(), term2(), term3(), term4(), term5()) })
    
    output$main_barplot <- renderPlotly(
        create_full_barplot(deposit(), spend())
    )
    
    output$main_lineplot <- renderPlotly(
        create_cumsum_lineplot(main_df())
    )
    
    output$filtered_barplot <- 
            renderPlotly(
        create_grocery_barplot(main_df(), startDate(), endDate(), term1(), term2(), term3(), term4(), term5()) 
    )
    
    output$filtered_lineplot <- renderPlotly(
        create_grocery_lineplot(main_df(), startDate(), endDate(), term1(), term2(), term3(), term4(), term5())
    )
    
    output$filtered_datatable <- renderDataTable(
        filtered_df()
        #get_monthly_df(filtered_df(), startDate(), endDate())
    )
    
    output$main_datatable <- renderDataTable(
        main_df()
    )
})
