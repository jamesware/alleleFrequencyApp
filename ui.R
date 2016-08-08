# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.

library(shiny)
library(shinyBS)
library(markdown)

# pass "style" argument to fluidRow or tabPanel calls for includeMarkdown sections
mdStyle <- "margin-left: 30px; margin-right: 30px" # specify some margins
  
myTab_home <- function() {
  tabPanel("HOME",
           # includeHTML("./appTextContent/home.html")
           includeMarkdown(file.path(".","appTextContent","home.md")),
           style=mdStyle
           )
  }

myTab1 <- function() {
  tabPanel("calculate AF",
           
           # Application title
           # titlePanel("Maximum credible population allele frequency"),
           
           ##### First row
           fluidRow(
             ##### Sidebar
             column(8,wellPanel(
               radioButtons("inh",
                            "Inheritance:",
                            choices = list("monoallelic","biallelic"),
                            selected = "monoallelic"),
               # bsTooltip("inh", "title", placement = "bottom", trigger = "hover",
               #           options = NULL),
               numericInput("prev",
                            "Prevalence = 1 in ... (people)",
                            min = 1,
                            max = 1e8,
                            value = 500),
               # bsTooltip("prev", "title", placement = "top", trigger = "hover",
               #           options = NULL),
               br(),
               sliderInput("hetA",
                           "Allelic heterogeneity:",
                           min = 0,
                           max = 1,
                           value = 0.1),
               sliderInput("hetG",
                           "Genetic heterogeneity:",
                           min = 0,
                           max = 1,
                           value = 1),
               br(),
               sliderInput("pen",
                           "Penetrance:",
                           min = 0,
                           max = 1,
                           value = 0.5)
             )
             ),
             ##### Main panel
             column(4,
                    h3("Maximum credible population AF:"),
                    h2(textOutput("maxAF"),align="center",style = "color:red")
             )
           ), #end fluidRow
           
           ##### Second row  
           fluidRow(
             ##### Sidebar
             column(8,wellPanel(
               radioButtons("CI",
                            "Confidence:",
                            choices = list(0.9,0.95,0.99,0.999),
                            selected = 0.95,
                            inline=T),
               numericInput("popSize",
                            "Reference population size (alleles)",
                            min = 1,
                            max = 1e8,
                            value = 2*60706)
               
             )),
             ##### Main panel
             column(4,
                    h3("Maximum tolerated reference AC:"),
                    h2(textOutput("maxAC"),align="center",style = "color:red")
             )
           ), #end fluidRow
           fluidRow(includeMarkdown(file.path(".","appTextContent","tab1.md")),
                    style=mdStyle
                    )
           )
  }

myTab2 <- function() {
  tabPanel("calculate AC",
           fluidRow(
             ##### Sidebar
             column(8,wellPanel(
               numericInput("userMaxAF_2",
                            "Maximum population AF",
                            min = 0,
                            max = 1,
                            value = 0.001),
               numericInput("popAN_2",
                            "Reference population size (alleles)",
                            min = 1,
                            max = 1e8,
                            value = 2*60706),
               radioButtons("CI_2",
                            "Confidence:",
                            choices = list(0.9,0.95,0.99,0.999),
                            selected = 0.95,
                            inline=T)
             )),
             ##### Main panel
             column(4,
                    h3("Maximum tolerated reference AC:"),
                    h2(textOutput("userMaxAC"),align="center",style = "color:red")
             )
           ), #end fluidRow
           fluidRow(includeMarkdown(file.path(".","appTextContent","tab2.md")),
                    style=mdStyle
                    )
           )
  }

myTab3 <- function() {
  tabPanel("explore architecture",
  fluidRow(
    ##### Sidebar
      column(8,wellPanel(
        numericInput("prev_3",
                     "Prevalence = 1 in ...",
                     min = 1,
                     max = 1e8,
                     value = 500),
        br(),
        sliderInput("het_3",
                    "Heterogeneity:",
                    min = 0,
                    max = 1,
                    value = 0.1),
        br(),
        sliderInput("pen_3",
                    "Penetrance:",
                    min = 0,
                    max = 1,
                    value = 0.5),
        numericInput("userMaxAF_3",
                     "Maximum credible population AF",
                     min = 0,
                     max = 1,
                     value = 0.001)
      )
      ),
    column(4,
           radioButtons("variable_3",
                        "Choose output:",
                        choices = list("Prevalence","Heterogeneity","Penetrance","max AF"),
                        selected = "Penetrance"),
           br(),
           tableOutput("tab3"))
  ), #end fluidRow
  fluidRow(includeMarkdown(file.path(".","appTextContent","tab3.md")),
           style=mdStyle
           )
  )
  }

myTab4 <- function() {
  tabPanel("inverse AF",
           
           ##### Second row  
           fluidRow(
             ##### Sidebar
             column(8,wellPanel(
               numericInput("AC_4",
                            "Observed population AC",
                            min = 0,
                            max = 1000000,
                            value = 10),
               numericInput("AN_4",
                            "Observed population alleles sequenced (AN)",
                            min = 1,
                            max = 1000000,
                            value = 2*60706),
               radioButtons("CI_4",
                            "Confidence:",
                            choices = list(0.9,0.95,0.99,0.999),
                            selected = 0.95,
                            inline=T)
             )),
             ##### Main panel
             column(4,
                    h3("Filter allele frequency:"),
                    h2(textOutput("filterAF"), align="center", style = "color:red")
             )
           ), #end fluidRow
           fluidRow(includeMarkdown(file.path(".","appTextContent","tab4.md")),
                    style=mdStyle)
  )
  }

myTab_about <- function() {
  tabPanel("about",
           #includeHTML("./appTextContent/about.html"))}
          includeMarkdown(file.path(".","appTextContent","about.md")),
          style=mdStyle
          )
  }


# Define UI for application
ui <- shinyUI(navbarPage("Frequency Filter",
                         # theme = "stylesheet.css",  #to style, insert .css into folder ./www/
                         myTab_home(),                   
                         myTab1(),
                         myTab2(),
                         myTab3(),
                         myTab4(),
                         myTab_about()
                         
))