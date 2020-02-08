shinyServer(function(input, output) {

    
    output$playerByPosition <- renderPlotly({
        data <- player_data %>%
            mutate(player_positions = strsplit(as.character(player_positions), ",")  %>% sapply(tail, 1) %>% str_replace_all(" ",repl="")) %>%
            mutate(position = case_when(
                player_positions %in% goalkeeper_position ~ "goalkeeper",
                player_positions %in% defender_position ~ "defender",
                player_positions %in% forward_position ~ "forward",
                player_positions %in% midfielder_position ~ "midfielder"
            )) %>%
            group_by(position) %>%
            summarise(total = n())
        
        data %>%
            plot_ly(labels = ~position, values = ~total, type = "pie") %>% 
            layout(title = "Distribution player position in FIFA 2020",
                   xaxis = list(showgrid = F, zeroline = F, showticklabels= F),
                   yaxis = list(showgrid = F, zeroline = F, showticklabels = F))
    })
    
    output$playerOverall <- renderPlotly({
        player <- player_data %>% 
            select(short_name, overall, potential, club) %>% 
            arrange(desc(overall)) %>% 
            head(20)
        
        plot <- player %>% 
            ggplot(aes(x = reorder(short_name, overall), y = overall)) +
            geom_col(aes(fill = overall,
                         text = glue("Name: {short_name}
                           Club: {club}
                           Overall: {overall}
                           Potential: {potential}"))) +
            scale_fill_gradient(low = "pink",
                                high = "red") +
            coord_flip() +
            theme_minimal() +
            labs(y = "Overall Skill Index",
                 fill = "Skill Index",
                 title = "Top 20 Overall Skill FIFA 2020") +
            theme(axis.title.y = element_blank()) 
           
        
        plotly <- ggplotly(plot, tooltip = "text")
    })
    
    output$playerOverallByAge <- renderPlotly({
        player <- player_data %>% 
            select(overall) %>% 
            group_by(overall) %>% 
            summarise(total = n())
        plot <- player %>% 
            ggplot(aes(x = overall, y = total)) +
            geom_area(fill="#69b3a2", alpha=0.5) +
            geom_line(col="skyblue",
                      alpha=0.5,
                      aes(text = glue("Overall Skill: {overall}
                                      Total Players: {total}"))) +
            xlab("Overall Skill Index") +
            ylab("Total Players") +
            theme_minimal() +
            labs(title = "Distribution Skill Player By Age FIFA 2020")
        
        
        
        plotly <- ggplotly(plot, tooltip = "text")
        
    })
    
    output$leagueOverall <- renderPlotly({
        overallLeague <- player_data %>% 
            filter(international_reputation > 1) %>% 
            group_by(league) %>% 
            summarise(mean_overall = mean(overall)) %>% 
            arrange(desc(mean_overall)) %>% 
            head(10)
        
        plot <- overallLeague %>% 
            ggplot(aes(x = reorder(league, mean_overall), y = mean_overall)) +
            geom_col() +
            coord_flip() +
            theme_minimal()
        
        plotly <- ggplotly(plot, tooltip = "text")
    })
    
    output$playersNationality <- renderPlotly({
        playersNationality <- player_data %>% 
            group_by(nationality) %>% 
            summarise(total = n(),
                      average = as.integer(mean(overall))) %>% 
            arrange(desc(total)) %>% 
            head(20)
        
        plot <- playersNationality %>% 
            ggplot(aes(x = reorder(nationality, total), y = total)) +
            geom_col(aes(fill = nationality,
                         text = glue("Total Players: {total}
                                     Average Skill: {average}"))) +
            coord_flip() +
            theme_minimal() +
            theme(axis.title.y = element_blank(),
                  legend.position = "none") +
            labs(title = "Top 20 Nationality Player FIFA 2020")
        
        plotly <- ggplotly(plot, tooltip = "text")
    })
    
    
    output$totalPlayersBox <- renderValueBox({
        valueBox(
            nrow(player_data), "Total Players", icon = icon("users"),
            color = "blue"
        )
    })
    
    output$totalClubBox <- renderValueBox({
        valueBox(
            NROW(unique(player_data$club)), "Total Clubs", icon = icon("futbol"),
            color = "green"
        )
    })
    
    output$totalNationalityBox <- renderValueBox({
        valueBox(
            NROW(unique(player_data$nationality)), "Total Nationality", icon = icon("flag"),
            color = "red"
        )
    })
        
    output$playerDatabase <- renderDataTable(player_data, options = list(
        pageLength = 20,
        scrollX = TRUE,
        scrollCollapse = TRUE
    ))

})
