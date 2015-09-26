# server.R

library(quantmod)
library(ggplot2)
library(reshape2)
 
 
library(plyr)

shinyServer(function(input, output, session) {
   
     output$shapeTable <- renderImage ({
         input$goButton
        isolate({
         return(list(src="images/shapesTable.PNG", contentType="image/png", alt="Shapes Table"))  })
     }, deleteFile=FALSE)
    
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
  
  output$value <- renderPrint({ input$dates })
  output$shapeHistogram <- renderPlot({
    
    cnt = readRDS('data/UFOdata.Rda')
    
    from = input$dates[1]
    to = input$dates[2]
    
    grp2 = subset(cnt, DATE > from & DATE < to)
    
    grpType=grp2
  
    grpType$MONTH <- as.integer(grpType$MONTH)
  ggplot(grpType, aes(MONTH, fill=SHAPE)) + geom_bar(binwidth=diff(range(grpType$MONTH))/30) +
    scale_x_continuous(breaks=1:12)
   
  })
  output$timeOfDay <- renderPlot({
    
    cnt = readRDS('data/UFOdata.Rda')
    
    from = input$dates[1]
    to = input$dates[2]
    
    grp3 = subset(cnt, DATE > from & DATE < to)
    
   
    grpType = grp3
  
    ggplot(grpType, aes(x=HOUR, fill=SHAPE)) + geom_bar()
 
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