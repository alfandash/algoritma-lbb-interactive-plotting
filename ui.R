

#sidebar
sidebar <- dashboardSidebar(
    sidebarMenu(
        menuItem(text = "Summary", icon = icon("home"),
                 tabName = "summary"),
        menuItem(text = "Player Data", icon = icon("users"),
                 tabName = "player_data")
    )
)

#tabPlayerData
fluidPlayerData <- fluidRow(
    box(width = 12, title = "Player Database", solidHeader = T, status = "primary",
        tabsetPanel(
            tabPanel("Data base",
                     dataTableOutput(outputId = "playerDatabase")
                     )
        )
    )
)

#tabHome
fluidSummary <- fluidRow(
    valueBoxOutput("totalPlayersBox"),
    valueBoxOutput("totalClubBox"),
    valueBoxOutput("totalNationalityBox"),
    box( width = 12, title = "Summary", solidHeader = T, status = "primary",
        tabBox( width = 12,
                tabPanel("Best Player Overall Skill",
                         plotlyOutput(outputId = "playerOverall")
                         ),
                tabPanel("Player Nationality",
                         plotlyOutput(outputId = "playersNationality"),
                        ),
                tabPanel("Distribution Skill With Age",
                         plotlyOutput(outputId = "playerOverallByAge"),
                         ),
                tabPanel("Distribution Player Position",
                         plotlyOutput(outputId = "playerByPosition")
                         )
        )
    )
)

#body
body <- dashboardBody(
    tabItems(tabItem(tabName = "summary", fluidSummary),
             tabItem(tabName = "player_data", fluidPlayerData)
             )
)

page <- dashboardPage(
    dashboardHeader(title = "FIFA 2020"),
    sidebar,
    body
)


shinyUI(page)
