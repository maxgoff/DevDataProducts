### Cousera Project: Developing Data Products

This repo contains the code and refined datasets developed to meet course requirements for Coursera's Developing Data Products (Johns Hopkins) course.  The application is based on data from the National UFO Reporting Center.  The dataset was obtained by scraping their collection of public web pages and tyding the data for processing and visualization.

The project involved creating a shiny application: [shinyapps.io](https://maxgoff.shinyapps.io/DevDataProducts) and a 5-slide online presentation:[rpubs.com](http://rpubs.com/maxgoff/UFO_Explorer)

Pertinent files in this repository include:
* getUFOData.R:  The R script used to scrape data from The National UFO Reporting Center public pages, build the datasets, clean and format for analysis.
* server.R:  The server R script for the shiny application.
* ui.R:  The user interface R script for the shiny application.
* ufoPresentation.Rpres:  The RPresentaion script for the online slide presentation for this project.
* data/*.Rda:  The tidied datasets in R object format to faciliate fast response time and low latency for application startup.
* images/shapesTable.PNG: The SHAPE table displayed benath the date selelector in the left column.

&copy; Max K. Goff 2015 All Rights reserved.

