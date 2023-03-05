library(markdown)
library(shinythemes)
library(sn)
library (shiny)
library (shinydashboard)
library (shinyWidgets)
library (shinyalert)
library (plyr)
library(dplyr)
library (DT)
library (shinyjs)
library (plotly)
library(tidyverse)
library(ggplot2)
library(ggrepel)
library(caret)


data <- read.csv("crop_recommendation.csv")
data_origin <- subset(data, select = -c(8,8))

ui <- navbarPage("Crop Recommendation",
                 theme = shinytheme("sandstone"),
                 tabPanel("Table",
                          DT::dataTableOutput("table")
                 ),
                 tabPanel("Analysis", 
                          selectInput("datalist", "Choose a column:", c(rownames(t(data_origin)))),
                          column(8, verbatimTextOutput("minval")),
                          column(8, verbatimTextOutput("maxval")),
                          column(8, verbatimTextOutput("summary1")),
                          column(8, verbatimTextOutput("standD")),
                          column(8, verbatimTextOutput("IQR")),
                 ),
                 tabPanel("Histogram",
                          selectInput("datalist", "Choose a column:",
                                      c("All",rownames(t(data_origin)))),
                          column(6,
                                 plotOutput("hist1",width="100%")
                          ),
                          column(6, 
                                 textOutput("probdist")
                                 ),
                          
                 ),
                 tabPanel("Regression",
                          selectInput("datalist", "Choose a column:", c(rownames(t(data_origin)))),
                          column(6,
                                 plotOutput("linearplot",width="100%")
                          ),
                          column(3, textInput("label", 
                                              label = "Enter a label to predict fertility rate(1920 onwards)", 
                                              value = "", 
                                              width = "100%",
                                              placeholder = "Enter label")),
                          column(6,
                                 textOutput("corelation")
                          ),
                          column(6,
                                 textOutput("prediction")
                          ),
                 ),
                 
                 
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  output$table <- DT::renderDataTable({
    DT::datatable(data)
  })
  
  m <- mean(t(subset(data, select = -c(1,1))[2,]))
  row_num <- length(data[,1])
  
  output$linearplot <- renderPlot({
    country <- which(data==input$country)
    Vecy <- t(data_origin)[,country]
    Vecx <- c(1960:2020)
    plot(Vecy~Vecx,main=("Plot"),xlab=c("label"),ylab = "Fertility Rate")
    linmod=lm(Vecy~Vecx)
    abline(linmod)
  })
  
  output$corelation <- renderText({
    country <- which(data==input$country)
    Vecy <- t(data_origin)[,country]
    Vecx <- c(1960:2020)
    plot(Vecy~Vecx)
    linmod=lm(Vecy~Vecx)
    c("Corelation = ",cor(Vecx,Vecy))
  })
  
  
  output$prediction <- renderText({
      country <- which(data==input$country)
      label <- as.numeric(input$label)
    if(input$label!=""&&label>=1920){
      Vecy <- t(data_origin)[,country]
      Vecx <- c(1960:2020)
      plot(Vecy~Vecx)
      linmod=lm(Vecy~Vecx)
      eq = linmod$coefficients[1] + ((linmod$coefficients[2])*(label))
      if(eq>=0){
        c("Prediction = ",eq)
      }
      else{
        c("Prediction = NA")
      }
    }
    else{
      c("Prediction = NA")
    }
  })
  
  
  
  output$hist1 <- renderPlot({
    if(input$datalist=="All"){
      myVec=c()
      val <- 2
      while(val <= row_num){
        myVec <- append(myVec,mean(t(data_origin[val,])))
        val<-val+1
      }
      hist(myVec,col="lightblue", main=("Histogram of Average fertility rate"),ylim=c(0,35),xlab="Average Fertility Rate of all Countries (1960 to 2020)",ylab = "Country Count")
    }
    else{
      myVec=c()
      label <-input$datalist
      hist(data_origin[,label],col="lightblue",main=("Histogram of Average fertility rate"),ylim=c(0,60),xlab=c("Fertility Rate of all countries in ",label),ylab = "Country Count")
    }
  })
  
  
  output$summary1 <- renderPrint({
    if(input$datalist=="All"){
      myVec2=c()
      val <- 2
      while(val <= row_num){
        myVec2 <- append(myVec2,mean(t(data_origin[val,])))
        val<-val+1
      }
      summary(myVec2)
    }
    else{
      label <- input$datalist
      rows <- length(t(data_origin[,2]))
      summary(data_origin[2:rows,label])
    }
  })
  
  
  output$standD <- renderText({
    if(input$datalist=="All"){
      myVec2=c()
      val <- 2
      while(val <= row_num){
        myVec2 <- append(myVec2,mean(t(data_origin[val,])))
        val<-val+1
      }
      c("Standard Deviation: ",sd(myVec2))
    }
    else{
      label <-input$datalist
      rows <- length(t(data_origin[,2]))
      c("Standard Deviation: ",sd(data_origin[2:rows,label]))
    }
  })
  
  output$IQR <- renderText({
    if(input$datalist=="All"){
      myVec2=c()
      val <- 2
      while(val <= row_num){
        myVec2 <- append(myVec2,mean(t(data_origin[val,])))
        val<-val+1
      }
      c("IQR: ",IQR(myVec2))
    }
    else{
      label <-input$datalist
      rows <- length(t(data_origin[,2]))
      c("IQR: ",IQR(data_origin[2:rows,label]))
    }
  })
  
  
  
  
  output$probdist <- renderText({
    if(input$datalist=="All"){
      myVec2=c()
      val <- 2
      while(val <= row_num){
        myVec2 <- append(myVec2,mean(t(data_origin[val,])))
        val<-val+1
      }
      
      if(input$minval=="" && input$maxval!=""){
        c("Probability: ", pnorm(as.numeric(input$maxval),mean(myVec2),sd(myVec2)))
      }
      else if(input$minval!="" && input$maxval==""){
        c("Probability: ", 1-pnorm(as.numeric(input$minval),mean(myVec2),sd(myVec2)))
      }
      else if(input$minval!="" && input$maxval!=""){
        if(as.numeric(input$maxval)>as.numeric(input$minval)){
          prob <- pnorm(as.numeric(input$maxval),mean(myVec2),sd(myVec2))-(pnorm(as.numeric(input$minval),mean(myVec2),sd(myVec2)))
          c("Probability: ",prob)
        }
        else if(as.numeric(input$maxval)<as.numeric(input$minval)){
          prob <- pnorm(as.numeric(input$maxval),mean(myVec2),sd(myVec2))+(1-pnorm(as.numeric(input$minval),mean(myVec2),sd(myVec2)))
          c("Probability: ",prob)
        }
        else{
          c("Probability: 0")
        }
      }
    }
    else{
      label <-input$datalist
      rows <- length(t(data_origin[,2]))
      myVec2=data_origin[2:rows,label]
      if(input$minval=="" && input$maxval!=""){
        c("Probability: ", pnorm(as.numeric(input$maxval),mean(myVec2),sd(myVec2)))
      }
      else if(input$minval!="" && input$maxval==""){
        c("Probability: ", 1-pnorm(as.numeric(input$minval),mean(myVec2),sd(myVec2)))
      }
      else if(input$minval!="" && input$maxval!=""){
        if(as.numeric(input$maxval)>as.numeric(input$minval)){
          prob <- pnorm(as.numeric(input$maxval),mean(myVec2),sd(myVec2))-(pnorm(as.numeric(input$minval),mean(myVec2),sd(myVec2)))
          c("Probability: ",prob)
        }
        else if(as.numeric(input$maxval)<as.numeric(input$minval)){
          prob <- pnorm(as.numeric(input$maxval),mean(myVec2),sd(myVec2))+(1-pnorm(as.numeric(input$minval),mean(myVec2),sd(myVec2)))
          c("Probability: ",prob)
        }
        else{
          c("Probability: 0")
        }
      }
    }
    
  })
  
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)
