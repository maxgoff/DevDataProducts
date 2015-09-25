# server.R

library(quantmod)
library(ggplot2)
library(reshape2)
library(dygraphs)
#source("helpers.R")

shinyServer(function(input, output) {
  
  output$timeseriesplot <- renderPlot ({
    
 
   data = readRDS('data/UFOSightings.Rda')
    
    from = input$dates[1]
    to = input$dates[2]
    grp = subset(data, DATE > from & DATE < to)
    av = round(ave(grp$SIGHTINGS),2)
    av_p = as.character(av[1])
    mm=max(grp$SIGHTINGS)
    y=100
    if(mm < 100) y=round(mm,0)
     
    message=paste("   Ave Sightings/Month: ", av_p, sep="")
    ggplot(grp, aes(x=DATE,y=SIGHTINGS)) + 
      geom_line(aes(y=SIGHTINGS, colour="Num Sightings")) + 
      stat_smooth(aes(y=SIGHTINGS, colour="Trend")) +
      scale_color_manual(values=c("Trend"="blue", "Num Sightings"="red")) +
    annotate(geom="text", x=as.Date(from+((to-from)/2)), y=-10, label=message)
   
  })
  
  output$shapeHistogram <- renderPlot({
    
    cnt = readRDS('data/UFOdata.Rda')
    
    from = input$dates[1]
    to = input$dates[2]
    
    grp2 = subset(cnt, DATE > from & DATE < to)
    grpType = count(grp2$SHAPE)
    grpType=grp2
   # colnames(grpType)[1] = "SHAPE"
  #  colnames(grpType)[2] = "Frequency"
    grpType$MONTH <- as.integer(grpType$MONTH)
  ggplot(grpType, aes(MONTH, fill=SHAPE)) + geom_bar(binwidth=diff(range(grpType$MONTH))/30) +
    scale_x_continuous(breaks=1:12)
   # ggplot(grpType, aes(x=SHAPE, y=Frequency)) + geom_bar(stat="identity")
   # ggplot(grpType, aes(MONTH, fill=SHAPE)) + 
    #  geom_bar(data=grpType, stat="identity", binwidth=0.75) +
    #  scale_x_continuous(breaks=1:12)
  })
  output$timeOfDay <- renderPlot({
    
    cnt = readRDS('data/UFOdata.Rda')
    
    from = input$dates[1]
    to = input$dates[2]
    
    grp3 = subset(cnt, DATE > from & DATE < to)
    
    grpType = count(grp3$HOUR)
    grpType = grp3
  #  colnames(grpType)[1] = "Hour"
  #  colnames(grpType)[2] = "Frequency"
    ggplot(grpType, aes(x=HOUR, fill=SHAPE)) + geom_bar()
   # ggplot(grpType, aes(x=Hour, y=Frequency, fill=SHAPE)) + geom_bar(stat="identity") 
  })
  
  output$table1 = renderDataTable({
    data = readRDS('data/UFOSightings.Rda')
    data
  }, options = list(orderClasses = TRUE))
  output$text1 <- renderText({ paste(" ", input$checkGroup)})
  
  output$table2 = renderDataTable({
    cnt = readRDS('data/UFOdata.Rda')
    cnt
  }, options = list(orderClasses = TRUE))
  
  output$table3 = renderDataTable({
    t = read.csv('data/SHAPES.csv')
    t$X <- NULL
    t$X.1 <- NULL
    t <- t[1:11,]
    t
  })
  output$text1 <- renderText({ paste(" ", input$checkGroup)})
  
  output$hover_info <- renderPrint({
    if(!is.null(input$plot_hover)){
      hover=input$plot_hover
      dist=cntV$DATE
      cat(paste("Date: ", dist))
    }
  })
  
 
  
})