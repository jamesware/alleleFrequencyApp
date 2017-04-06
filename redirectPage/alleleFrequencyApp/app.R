# Shiny app serves as a redirect page to direct people from the allele frequency apps previous home on shinyapps.io, to its new home on cardiodb.org

library(shiny)
library(markdown)

# pass "style" argument to fluidRow or tabPanel calls for includeMarkdown sections
mdStyle <- "margin-left: 30px; margin-right: 30px" # specify some margins

myTab_home <- function() {
  tabPanel("HOME",
           includeMarkdown(file.path(".","redirect.md")),
           style=mdStyle
  )
}


# Define UI for application
ui <- shinyUI(navbarPage("Frequency Filter",
                         # theme = "stylesheet.css",  #to style, insert .css into folder ./www/
                         myTab_home()
))

# Define server logic required to draw a histogram
server <- shinyServer(function(input, output) {
   })

# Run the application 
shinyApp(ui = ui, server = server)

