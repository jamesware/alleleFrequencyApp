#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to generate output

server <- shinyServer(function(input, output) {

   data <- reactive({
     myPrev = 1/input$prev
     if(input$inh=="monoallelic"){
       myMaxAF = (1/2) * myPrev * input$hetA * input$hetG * (1/input$pen)
     }
     if(input$inh=="biallelic"){
       myMaxAF = sqrt(myPrev) * input$hetA * sqrt(input$hetG) * (1/sqrt(input$pen))
     }
     myMaxAC = qpois(p=as.numeric(input$CI),
           lambda=(2*input$popSize)*(myMaxAF))
     return(list(myMaxAF,myMaxAC))
   }) 
    
   output$maxAF <- renderText({signif(data()[[1]],3)})
   output$maxAC <- renderText({data()[[2]]})
  
   output$userMaxAC <- renderText({
     qpois(p=as.numeric(input$CI_2),
           lambda=(2*input$popSize_2)*(input$userMaxAF_2))
   })
  
   output$tab3 <- renderTable({
       myArchitecture <- data.frame(
         row.names = c("Prevalence","Heterogeneity","Penetrance","max AF"),
         value=rep(NA,4))
       
       myPrev = 1/input$prev_3
       
       if(input$variable_3=="Prevalence"){
        nextValue <- 2 * input$userMaxAF_3 * input$pen_3 * (1/input$het_3)
        if(nextValue<=1){
          myArchitecture["Prevalence",] = nextValue} else if(nextValue>1){
            myArchitecture["Prevalence",] = "outside range (>1)"
        }
       } else {
         myArchitecture["Prevalence",] = format(signif(myPrev,3),scientific=T)
       }
       
       if(input$variable_3=="Heterogeneity"){
         nextValue <- 2 * input$userMaxAF_3 * input$pen_3 * (1/myPrev)
         if(nextValue<=1){
           myArchitecture["Heterogeneity",] = nextValue} else if(nextValue>1){
             myArchitecture["Heterogeneity",] = "outside range (>1)"
           }
       } else {
         myArchitecture["Heterogeneity",] = input$het_3
       }
       
       # if(input$variable_3=="Genetic heterogeneity"){
       #   myArchitecture["Genetic heterogeneity",] = 2 * input$userMaxAF_3 * input$pen_3 * (1/myPrev) * (1/input$hetA_3)
       # } else {
       #   myArchitecture["Genetic heterogeneity",] = input$hetG_3
       # }
       
       if(input$variable_3=="Penetrance"){
         nextValue <- 0.5 * (myPrev) * input$het_3 * (1/input$userMaxAF_3)
         if(nextValue<=1){
           myArchitecture["Penetrance",] = nextValue} else if(nextValue>1){
             myArchitecture["Penetrance",] = "outside range (>1)"
           }
       } else {
         myArchitecture["Penetrance",] = input$pen_3
       }
       
       if(input$variable_3=="max AF"){
         nextValue <- 0.5 * (myPrev) * input$het_3 * (1/input$pen_3)
         if(nextValue<=1){
           myArchitecture["max AF",] = nextValue} else if(nextValue>1){
             myArchitecture["max AF",] = "outside range (>1)"
           }
         } else {
         myArchitecture["max AF",] =  format(signif(input$userMaxAF_3,3),scientific=T) 
       }
       return(myArchitecture)
   })
   
})


#### to run or deploy app:

# Run the application 
# shinyApp(ui = ui, server = server)

## Commands to deploy to shinyapps.io
# library(rsconnect)
# rsconnect::deployApp('alleleFreqApp')