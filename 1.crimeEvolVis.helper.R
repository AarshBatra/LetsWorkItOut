##===========================================crimeEvolVis====================================================================##
# App description: This app produces interactive choropleth world maps displaying crimeIndex...
#...for various countries around the world, and also an animation for the whole evolution.

#Important references:  https://www.numbeo.com/crime/rankings_by_country.jsp (data on crimeIndex for various countries)
#                       gifmaker.me (for creating gif animations) 
#                       https://rstudio.github.io/leaflet/(for making choropleth maps)
#                       ??missing?? data source from where I downloaded shapefile(for world countries) that was fed to the st_read command of sf...
#                       ...package for further feeding to leaflet as dataset that would allow the use of addpolygons() function

#                       http://strimas.com/r/tidy-sf/(How to use sf package?)   
#                       https://shiny.rstudio.com/articles/layout-guide.html (R shiny application layout guide for writing UI)

#                       http://zevross.com/blog/2016/04/19/r-powered-web-applications-with-shiny-a-tutorial-and-cheat-sheet-with-40-example-apps/ ...
#                       ... (40 example shiny apps for reference code)

#                       https://shiny.rstudio.com/tutorial/lesson1/ (R shiny written tutorial lessons(1-7))
#                       Book (R for Data science, Hadley Wickham), using tidyverse functions like select, %in%, etc.


# A Note of Caution on data source: Numbeo is a crowd-sourced global database of reported consumer prices,...
#...perceived crime rates, quality of health care, other statistics. There has been some criticisms that...
#...data that numbeo collects is based on "what people say" and should be interpreted accordingly,...
#...(for more visit: https://en.wikipedia.org/wiki/Numbeo). Also, to know more about numbeo's methodology...
#... for collection of the data that supports this app, visit: https://www.numbeo.com/crime/
##=======================================================================================================================##

#--setting working directory to the project folder
#setwd("C:/Users/pc/Dropbox/and more/data analysis for social scientists, edX/extras/Lets-Work-it-out!")

#-- Loading libraries
library(rvest) #for web-scraping
library(sf) #for geo-spatial data manipulation
library(RColorBrewer)
library(leaflet) #for geo-spatial plotiing
library(tidyverse) #something that one should always have
library(viridis)
library(viridisLite)
library(magrittr) #for using pipes(%>%)

#-- Web scraping (source: "https://www.numbeo.com/crime/")
year <- 2012
no_of_years <- 6
dataset_complete<- list()


for(i in 1:no_of_years){
  dataset_ind <- NA
  if(year == 2012 || year == 2013){
    youRL <- sprintf("https://www.numbeo.com/crime/rankings_by_country.jsp?title=%i-Q1", year)
    dataset_ind <- youRL%>%read_html()%>%html_nodes(xpath = '//*[@id="t2"]')%>%html_table()
    dataset_ind <- data.frame(dataset_ind)
    
  }
  
  else{
    youRL <- sprintf("https://www.numbeo.com/crime/rankings_by_country.jsp?title=%i", year)
    dataset_ind <- youRL%>%read_html()%>%html_nodes(xpath = '//*[@id="t2"]')%>%html_table()
    dataset_ind <- data.frame(dataset_ind)
  }
  
  year <- year+1
  dataset_complete[[i]] <- dataset_ind
  rm(dataset_ind)
  
}

# -- making a copy of 'dataset_complete' for manipulation
dataset_copy <- NA
assign("dataset_copy", dataset_complete)

# --(reimplement this code chunk using purrr, reason: more cleaner code needed)
# -- removing unnecessary info from 'dataset_copy' and classifying data chronologically and reordering alphbetically 
dataset_years_label <- list(rep(NA, times = no_of_years))
year <- 2012
for(j in 1:no_of_years){
  dataset_years_label[[j]] <- as.data.frame(dataset_copy[[j]])
  dataset_years_label[[j]] <- dataset_years_label[[j]][,2:3]
  dataset_years_label[[j]] <- dataset_years_label[[j]][order(dataset_years_label[[j]]$Country),]
  colnames(dataset_years_label[[j]])[[2]] <- sprintf("crimeIndex_%i",year)
  year <- year+1
}


##==============================Chunk#1-Implementation of choropleth maps using base R================================##

# Ignore this chunk of code if, not implementing choropleth maps using base R.
# Below Code will get you started(also get quite close) for implementing choropleth maps using 'base R' only.
# Also, look out closely for some neat tricks(e.g. %in%)

#-- Getting (country wise) latitude and longtude
#countryCoordinates <- read.xlsx("1.crimeEvolVis.countryCoordinates.xlsx", sheetIndex = 1) 

#-- Rearranging 'countryCoordinates' dataset in an alphabetical order
#countryCoordinates <- countryCoordinates[order(countryCoordinates$Country),]

#-- filtering the 'countryCoordinates' dataset to get only those countries whose 'crime rate' data is available.
#filter1 <- filter(countryCoordinates, Country %in% dataset_2012[,1])
#filter2 <- filter(dataset_2012, dataset_2012[,1] %in% filter1[,1])
#filter1[,4] <- filter2[,2]
#colnames(filter1) <- c("Country", "lat","long", "crimeIndex")

##===================================================================================================================##


##==================Chunk#2- Successful reference code(step by step) as implemented via sf package====================##

# libraries -> tidyverse, sf, rvest, viridis, Rcolorbrewer, leaflet

#(read data into dat) dat <- st_read(dsn ="C:/Users/pc/Dropbox/and more/data analysis for social scientists, edX/extras/Lets-Work-it-out!", layer = "1.crimeEvolVis.TM_WORLD_BORDERS_SIMPL-0.3")
# m <- leaflet(dat) %>%addTiles() 
# m %>% addPolygons()
# pal <- colorBin("YlOrRd", domain = dat$AREA, bins = bins)
# bins <- seq(from = min(dat$AREA), to = max(dat$AREA), by = (max(dat$AREA))/10)
# m%>%addPolygons(fillColor = ~pal(AREA), weight =2, opacity = 1, color = "white", dashArray = 3, fillOpacity = 0.7)
# m%>%addPolygons(fillColor = ~pal(AREA), weight =2, opacity = 1, color = "white", dashArray = 3, fillOpacity = 0.7, highlight = highlightOptions(weight = 5, color = "#666", dashArray = "",fillOpacity = 0.7,bringToFront = TRUE))
# labelMarkers <- sprintf("<strong> %s </strong> <br/> <em> %f </em>", dat$NAME,dat$AREA)%>%lapply(htmltools::HTML)
# m%>%addPolygons(fillColor = ~pal(AREA), weight =2, opacity = 1, color = "white", dashArray = 3, fillOpacity = 0.7, highlight = highlightOptions(weight = 5, color = "#666", dashArray = "",fillOpacity = 0.7,bringToFront = TRUE), label = labelMarkers, labelOptions = labelOptions(style = list("font-weight" = "normal", padding = "3px 8px"),textsize = "15px",direction = "auto"))
# m%>%addLegend(pal, values=~AREA, opacity = 0.7, title= " ", position = "bottomright")

##===================================================================================================================##

#-- Implememting choropleth maps for crimeVis referring "Chunk#2" 

sd_v0 <- st_read(dsn="C:/Users/pc/Dropbox/and more/data analysis for social scientists, edX/extras/Lets-Work-it-out!", layer = "1.crimeEvolVis.TM_WORLD_BORDERS_SIMPL-0.3")
sd_v0 <- sd_v0[order(sd_v0$NAME),]

#making a list of "final" datasets(sd_vF) that will be used to produce a list of choropleth maps(maps).
sd_vF <- list(rep(NA, times = no_of_years))
maps_choropleth <- list(rep(NA, times = no_of_years))
dummy_yr <- 2012
for(k in 1:no_of_years){
  sd_vF[[k]] <- filter(sd_v0, sd_v0$NAME %in% dataset_years_label[[k]]$Country)
  filter0 <- filter(dataset_years_label[[k]], dataset_years_label[[k]]$Country %in% sd_vF[[k]]$NAME)
  sd_vF[[k]][,ncol(sd_vF[[k]])+1] <- filter0[,2]
  
  
 #making choropleth map for sd_vF[[k]] and then store in maps_choropleth[[k]]
 bins <- c(0, 10, 20, 30, 40, 50, 60, 70, 80, 90)
 pal <- colorBin("Reds", domain = sd_vF[[k]]$V13, bins = bins)
 labelMarkers <- sprintf("<strong>%s</strong><br/><em>%s:%f</em>", sd_vF[[k]]$NAME, "Crime Index", sd_vF[[k]]$V13)%>%lapply(htmltools::HTML)
 maps_choropleth[[k]] <- leaflet(sd_vF[[k]])%>%addTiles()%>%addPolygons(fillColor = ~pal(V13), weight = 2, opacity = 1, color="white", dashArray = "3", fillOpacity = 0.7, highlight = highlightOptions(weight = 5, color = "#666", dashArray="", fillOpacity = 0.7, bringToFront = TRUE), label = labelMarkers, labelOptions= labelOptions(style = list("font-weight" = "normal", padding = "3px 8px"), textsize = "15px", direction = "auto"))%>%addLegend(pal = pal, values = ~V13, opacity = 0.7, title = sprintf("CrimeIndex:%i", dummy_yr) , position = "bottomleft")
 dummy_yr <- dummy_yr + 1
}

