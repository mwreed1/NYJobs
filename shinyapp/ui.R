source("C:/Users/12737/Desktop/Udemy/Data Visualization R and ggplot2/dependencies.R")
source("C:/Users/12737/Desktop/Udemy/Data Visualization R and ggplot2/datasets.R")

repository_url <- "https://github.com/mwreed1/NYJobs"

server <- function(input, output, session) {
  
  # Summarize Data and Plot chart
  data <- reactive({ 
    req(input$job_simple)
    df <- jobs %>% filter(category_simple %in% input$job_simple) %>% group_by(posting_date)  
  })
  
  #Plot
  output$plot <- renderPlot({
    g <- ggplot(data(), aes(x = category_simple, y = mean_starting_salary,
                          fill = posting_date, colour = posting_date))  
    g + geom_bar(stat = "identity", position = "dodge")
    
  })
}



ui <- basicPage(
  h1(strong("NYC Posting Job Salaries from 2018 to Present"), 
     style = "font-size:50px; color: orange"), # TODO: change this name
  a(
    href = repository_url,
    "Link to Github"
  ),
  selectInput(inputId = "job_simple",
              label = "Choose A Job Category",
              list("Building Operations","Communications","Constituent Services",
                   "Engineering","Finance","Health","Human Resources","Legal","Policy, Research & Analysis",
                   "Public Safety","Social Services", "Technology & Data")),
  
  plotOutput("plot")
)





shinyApp(ui = ui, server = server)
