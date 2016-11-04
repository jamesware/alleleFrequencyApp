# alleleFrequencyApp - a Shiny App for allele frequency calculations Copyright (C) 2016 James Ware
# 
# This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.  
# 
# This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.  
# 
# You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA  

library(shiny)
require(stats)
require(binom)

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
           lambda=(input$popSize)*(myMaxAF))
     return(list(myMaxAF,myMaxAC))
   }) 
    
   output$maxAF <- renderText({signif(data()[[1]],3)})
   output$maxAC <- renderText({data()[[2]]})
  
   output$userMaxAC <- renderText({
     qpois(p=as.numeric(input$CI_2),
           lambda=(input$popAN_2)*(input$userMaxAF_2))
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
  
   find_max_ac = function(af,an,ci=.95) {
     # given a desired AF to filter on for Mendelian analyses, what is the max AC that would be expected in a dataset?
     if (af == 0) {
       return (0)
     } else {
       quantile_limit = ci # ci for one-sided, 1-(1-ci)/2 for two-sided
       max_ac = qpois(quantile_limit,an*af)
       return (max_ac)
     }
   }
   
   find_af_filter = function(ac, an, ci=.95, lower=(.1/(2*60706)), upper=2, tol=1e-7, precision=1e-7) { 
     # backward method: given an observed AC, what is the highest AF filter for which one should remove this variant?
     # This function will accept an AC_Adj and an AN_Adj and will return the highest AF filter for which you would want to reject
     # this variant as a potential Mendelian causal allele.# for uniroot to work, lower has to be rarer than a singleton, and upper has to be higher than fixed
     # Important notes about parameters:
     # 1. for uniroot to work, lower has to be rarer than a singleton, and upper has to be higher than fixed (100% AF), 
     #    hence the AF here runs from 0.1 alleles in ExAC to an impossible AF of 200%
     # 2. you need a tight tolerance (tol) to get accurate results from uniroot at low AF, so we use 1e-7 as default. 
     # 3. we also specify a precision (1e-6) for incrementing to find the upper boundary of the range of AFs for which
     #    the 95%CI AC is less than the observed AC
     
     if (is.na(ac) | is.na(an) | ac == 0 | an == 0 | ac == 1) {
       return (0.0)
     } else {
       quantile_limit = ci # ci for one-sided, 1-(1-ci)/2 for two-sided
       # this has been tested and with the default parameters here, uniroot seems to never fail for an AC, AN values
       # in ExAC. still, it's good to have this tryCatch in here for debugging or in case anyone wants to override
       # the defaults. instead of just giving the error/warning message it also tells you which AC and AN values
       # it failed on.
       attempt_uniroot = tryCatch({
         uniroot_result = uniroot(f = function(af,ac,an) { return (ac - 1 - qpois(p=quantile_limit,lambda=an*af)) },lower=lower,upper=upper,ac=ac,an=an,tol=tol)
       }, warning = function(w) {
         print(paste("ac= ",as.character(ac),", an= ",as.character(an)," warning = ",as.character(w),sep=''))
         return (0.0)
       }, error = function(e) {
         print(paste("ac= ",as.character(ac),", an= ",as.character(an)," error = ",as.character(e),sep=''))
         return (0.0)
       }, finally = {
       })
       max_af = round(uniroot_result$root,-log10(precision)) # round to nearest millionth
       while(find_max_ac(af=max_af,an=an) < ac) {
         max_af = max_af + precision # increase by millionths until you find the upper bound - the highest AF for which 95%CI AC is still less than observed AC
       }
       max_af = max_af - precision # back off one unit from the AF that violated the 95%CI AC < obs AC condition
       return (max_af)
     }
   }
   
   output$filterAF = renderText(find_af_filter(ac=input$AC_4, an=input$AN_4, ci=as.numeric(input$CI_4), lower=(.1/(2*1000000)), upper=2, tol=1e-7))
   
########SERVER FOR TAB5 - PENETRANCE CALCULATOR   
   
   # formulae for penetrance and 95% confidence intervals as per Kirov et al. 2014
   # see http://www.biologicalpsychiatryjournal.com/article/S0006-3223(13)00676-8/pdf
   # reproduced from minikel et al
   
   penetrance = function(af_case, af_control, baseline_risk) {
     calculated_penetrance = af_case * baseline_risk / af_control
     estimated_penetrance = pmin(1,pmax(0,calculated_penetrance)) # trim to [0,1] support
     return (estimated_penetrance)
   }
   
   penetrance_confint = function (ac_case, n_case, ac_control, n_control, baseline_risk) {
     # for a genotypic model, use 1*n_case; for allelic, use 2*n_case
     # here, results are virtually identical.
     case_confint = binom::binom.confint(x=ac_case,n=2*n_case,method='wilson')
     control_confint = binom::binom.confint(x=ac_control,n=2*n_control,method='wilson')
     lower_bound = penetrance(case_confint$lower,control_confint$upper,baseline_risk)
     best_estimate = penetrance(case_confint$mean,control_confint$mean,baseline_risk)
     upper_bound = penetrance(case_confint$upper,control_confint$lower,baseline_risk)
     return ( c(lower_bound, best_estimate, upper_bound) )
   }
   
   
   penetrance5 <- reactive({
     myPrev = 1/input$prev_5
     output = penetrance_confint(ac_case=input$caseAC_5,
                        n_case=0.5*input$caseAN_5,
                        ac_control=input$popAC_5,
                        n_control=0.5*input$popAN_5,
                        baseline_risk=myPrev)
     output = signif(output,2)  
     return(paste(output[2],"(",output[1],"-",output[3],")",sep=""))
   }) 
   
   output$penetrance_5 <- renderText({penetrance5()})
   
   })


#### to run or deploy app:

# Run the application 
# shinyApp(ui = ui, server = server)

## Commands to deploy to shinyapps.io
# library(rsconnect)
# rsconnect::deployApp('alleleFreqApp')