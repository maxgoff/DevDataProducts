library(XML)
baseUrl <-"http://www.nuforc.org/webreports/"
ulist <- paste(baseUrl, "ndxpost.html", sep="")

doc <- htmlParse(ulist)
links <- xpathSApply( doc, "//a/@href")
free(doc)
ufoPage = paste(baseUrl, links[2], sep="")
ufoData <- as.data.frame(readHTMLTable(ufoPage))
for(n in 3:length(links)){
  ufoData2 = paste(baseUrl, links[n], sep="")
  z <- as.data.frame(readHTMLTable(ufoData2))
  ufoData <- rbind(ufoData,z)
  print(paste("We are at: ", n))
  system("sleep 2")
}
  
saveRDS(ufoData, file="data/ufoDataALL.Rda")

ulist <- paste(baseUrl, "ndxevent.html", sep="")
doc <- htmlParse(ulist)
cnt <- readHTMLTable(doc)
cnt <- as.data.frame(cnt)

# Starting Jan. 1947 -- Roswell occurred the following July
cntS <- cnt[1:789,]
names(cntS) <- gsub("NULL.Reports", "DATE", names(cntS))
names(cntS) <- gsub("NULL.Count", "SIGHTINGS", names(cntS))
cntR <- rev(cntS)

cntR$SIGHTINGS <- as.integer(as.character(cntR$SIGHTINGS))

cntR$DATE <- as.character(paste( "15/",cntR$DATE, sep=""))
cntR$DATE <- as.Date(cntR$DATE, "%d/%m/%Y")
ggp <- ggplot(data=cntR, aes(x=DATE, y=SIGHTINGS, group=1))
ggp + geom_line() + geom_smooth()

saveRDS(cntR, "data/UFOSightings.Rda")


# get geocodes
#library(RCurl)
#library(RJSONIO)

#construct.geocode.url <- function(address, return.call = "json", sensor = "false") {
#  root <- "http://maps.google.com/maps/api/geocode/"
#  u <- paste(root, return.call, "?address=", address, "&sensor=", sensor, sep = "")
#  return(URLencode(u))
#}

#gGeoCode <- function(address,verbose=FALSE) {
#  if(verbose) cat(address,"\n")
#  u <- construct.geocode.url(address)
#  doc <- getURL(u)
#  x <- fromJSON(doc,simplify = FALSE)
#  if(x$status=="OK") {
#    lat <- x$results[[1]]$geometry$location$lat
#    lng <- x$results[[1]]$geometry$location$lng
#    return(c(lat, lng))
#  } else {
#    return(c(NA,NA))
#  }
#}

cleanData <- function(data=cnt) {
    cnt = readRDS("data/ufoDataALL.Rda")
    colnames(cnt)[1]="DateTime"
    v<- cnt$DateTime!=""
    cntV<- cnt[v,]
    x=strsplit(as.character(cntV$DateTime)," ")
    y=data.frame(Reduce(rbind,x))
    cntV$DATE = y$X1
    cntV$TIME = y$X2
    cntV$DateTime<-NULL
    colnames(cntV)[1]= "CITY"
    colnames(cntV)[2] = "STATE"
    colnames(cntV)[3] = "SHAPE"
    colnames(cntV)[4] = "DURATION"
    v<- complete.cases(cntV)
    cntV <- cntV[v,]
    cntV$NULL.Summary = NULL
    cntV$NULL.Posted = NULL
    cntV$SHAPE = as.character(cntV$SHAPE)
    cntV$SHAPE = tolower(cntV$SHAPE)
    v<- cntV$SHAPE==""
    cntV[v,]$SHAPE = "unknown"
    RSHAPEv = grep("circle|crescent|dome|egg|oval|round|sphere|teardrop", cntV$SHAPE)
    LSHAPEv = grep("changed|changing|flash|fireball|flare|light", cntV$SHAPE)
    ASHAPEv = grep("chevron|cone|cross|delta|diamond|formation|hexagon|pyramid|rectangle|triangular|triangle", cntV$SHAPE)
    USHAPEv = grep("cigar|cylinder|disk", cntV$SHAPE)
    OSHAPEv = grep("unknown|other", cntV$SHAPE)
    cntV[RSHAPEv,]$SHAPE = "RShape"
    cntV[LSHAPEv,]$SHAPE = "LShape"
    cntV[ASHAPEv,]$SHAPE = "AShape"
    cntV[USHAPEv,]$SHAPE = "UShape"
    cntV[OSHAPEv,]$SHAPE = "OShape"
    cntV$YEAR <- year(as.Date(cntV$DATE, "%m/%d/%y"))
    cntV$MONTH <- month(as.Date(cntV$DATE, "%m/%d/%y"))
    dt <- as.character(cntV$DATE)
    cntV$DATE <- as.Date(dt, "%m/%d/%y")
    saveRDS(cntV, 'data/UFOdata.Rda')
}