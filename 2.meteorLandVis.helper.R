
##====================================app_meteorLandVis=================================================##

#Important references: https://catalog.data.gov/dataset/meteorite-landings-api (meteor landings data source)
#                      gifmaker.me (for creating gif animations)
#                      https://rstudio.github.io/leaflet/ (for geospatial data analysis)
#                      https://shiny.rstudio.com/articles/layout-guide.html (R shiny application layout guide for writing UI)

#                      http://zevross.com/blog/2016/04/19/r-powered-web-applications-with-shiny-a-tutorial-and-cheat-sheet-with-40-example-apps/ ...
#                       ... (40 example shiny apps for reference code)

#                       https://shiny.rstudio.com/tutorial/lesson1/ (R shiny written tutorial lessons(1-7))
#                       Book (R for Data science, Hadley Wickham), using tidyverse functions like select, %in%, etc.
#                       jason.duley@nasa.gov (maintainer of the dataset used to produce this app)	

##=====================================================================================================##

#--setting working directory to the project folder
#setwd("C:/Users/pc/Dropbox/and more/data analysis for social scientists, edX/extras/Lets-Work-it-out!")

#--Remember...
#Be extra careful with the brackets, e.g. 49^1/2 = 24.5, 49^(1/2) = 7

#--loading libraries
library(jsonlite)
library(geojsonio)
library(io)
library(mapview)
library(webshot)
library(devtools)
#################(Chunk-1:commented, as code exists in helper_crimeEvolVis)#########
#library(RColorBrewer) 
#library(leaflet) #for geo-spatial plotiing 
#library(tidyverse) #something that one should always have
#library(viridis)
#library(viridisLite)
#library(magrittr) #for using pipes(%>%)
#######################################################################################


##########################################################################################################
##========Chunk-2:commented as the final clean dataset is saved and directly loaded in the workspace============##
#--getting data
#data_met <- fromJSON("2.meteorLandVis.completeDatasetMetLand.json", flatten = TRUE)

#--Cleaning data
#below  lines of code removes NA observations.Notice how the below  code checks that the NA's in...
#...the 'geolocation.latitude' and 'geolocation.longitude' columns exactly match up. If NA's in...
#... 'geolocation.latitude' didn't match one for one for NA's in 'geolocation.longitude' columns...
#..., then we could not have easily removed the rows from the dataset. It is because NA's match...
#...up, that gives us 100% confidence to delete the rows. Below 5 lines of code, logically certifies that...
#... NA's do match up one to one. So, whoever is using this code, no need to worry about NA's...
#... they are taken care of, I just gave an explantion for my future reference.

#NA_in_lat <- sum(is.na(data_met$geolocation.latitude))
#NA_in_long <- sum(is.na(data_met$geolocation.longitude))
#NA_logic <- NA_in_lat == NA_in_long #Note-  'NA_logic' is true(check yourself).
#check_sum <- sum(is.na(data_met$geolocation.latitude) == is.na(data_met$geolocation.longitude)) #if 'check_sum'...
#... equal number of rows(1000), than we can proceed to delete the rows with NA. Spoiler alert: 'check_sum' = 1000

#--deleting rows with NA
#data_met <- data_met[!(is.na(data_met$geolocation.latitude)),]
#data_met$geolocation.latitude <- as.numeric(data_met$geolocation.latitude)
#data_met$geolocation.longitude <- as.numeric(data_met$geolocation.longitude)
#data_met$mass <- as.numeric(data_met$mass)

#--modifying the year field to just keep the 'year' in it and renaming it to yearOnly
#yearOnly <- rep(NA, times = nrow(data_met))
#for(i in 1:nrow(data_met)){
#  split <- strsplit(data_met$year[i],split="")
#  yearOnly[i] <- paste(split[[1]][1],split[[1]][2], split[[1]][3], split[[1]][4], sep = "") 
#}
#data_met <- data_met[,c(1,3:ncol(data_met))]
#data_met[,(ncol(data_met))+1] <- as.numeric(yearOnly) 
#colnames(data_met)[ncol(data_met)] <- "yearOnly"
#data_met <- arrange(data_met, yearOnly) #reordering data_met chronologically using 'yearOnly'
#uniq_yearOnly <- data.frame(uniq = unique(data_met$yearOnly)) #finding 'unique' set of years in 'yearonly'
#uniq_yearOnly <- arrange(uniq_yearOnly,uniq) #arranging 'uniq_yearOnly' in ascending order
#no_of_eras <- 6
#eraNameRange <- list(middleAges = uniq_yearOnly[1:5,], earlyModernPeriod = uniq_yearOnly[6:40,], oilAge = uniq_yearOnly[41:135,], worldWars = uniq_yearOnly[136:180,], atomicAge = uniq_yearOnly[181:205,],informationAge = uniq_yearOnly[206:247,])
#eraNames <- c("middleAges","earlyModernPeriod","oilAge","worldWars","atomicAge","informationAge", "allInOne")

#--adding an additional column named 'eraName' in which 'yearOnly' is classified into era's based on 'eraNameRange' and/or 'eraNmaes'
#counter <- 1
#data_met[,(ncol(data_met))+1] <- c(rep(NA, times = nrow(data_met)))
#for(j in 1:nrow(data_met)){
#  for(jsub in 1:no_of_eras){
#    if(data_met$yearOnly[j] %in% eraNameRange[[jsub]]){
#      data_met[,ncol(data_met)][j] <- eraNames[jsub]
#    }
#  }
#}
#colnames(data_met)[ncol(data_met)] <- "eraName"
##======================================================================================================##
##########################################################################################################


#--loading the "tideedCompleteDataset.csv" into the workspace
#Note: the code in "Chunk-2" was used to generate "tideedCompleteDataset.csv", and then the command in the below commented line was used to write it to an excel file
#readr::write_excel_csv(data_met, "2.meteorLandVis.tideedCompleteDataset.csv")
data_met <- readr::read_csv("2.meteorLandVis.tideedCompleteDataset.csv")
data_met <- as.data.frame(data_met)

#--This piece of code is copied from "Chunk-2" as some of the code ahead needed these varaibles
uniq_yearOnly <- data.frame(uniq = unique(data_met$yearOnly))
uniq_yearOnly <- arrange(uniq_yearOnly,uniq)
eraNameRange <- list(middleAges = uniq_yearOnly[1:5,], earlyModernPeriod = uniq_yearOnly[6:40,], oilAge = uniq_yearOnly[41:135,], worldWars = uniq_yearOnly[136:180,], atomicAge = uniq_yearOnly[181:205,],informationAge = uniq_yearOnly[206:247,])
eraNames <- c("middleAges","earlyModernPeriod","oilAge","worldWars","atomicAge","informationAge", "allInOne")
no_of_eras <- 6

data_met_eraSubsets <- list(rep(NA, times = no_of_eras)) #making a list of subsets of 'data_met'(era wise)

#filling the subsets with the data of the appropriate era
for(k in 1:no_of_eras){
  data_met_eraSubsets[[k]] <- filter(data_met, yearOnly%in%eraNameRange[[k]])
}

maps_eraMeteorLandings <- list(rep(NA, times= no_of_eras))

#making a list of leaflet maps(era wise)
colorErawise <- colorFactor(c("darkblue", "darkgreen","turquoise1","black", "yellow", "red"), data_met$eraName)
for(l in 1:no_of_eras){
  maps_eraMeteorLandings[[l]] <- leaflet(data = data_met_eraSubsets[[l]])%>%setView(lat = 15, lng = 45, zoom = 1)%>%addTiles()%>%addCircleMarkers(lat = ~geolocation.latitude, lng = ~geolocation.longitude, radius = 0.2, color = ~colorErawise(eraName), popup = ~paste("<mark>","Name:","</mark>","<mark>", name, "</mark><br/>","<mark>","Year:", "</mark>","<mark>", yearOnly,"</mark><br/>","<mark>", "Mass in grams:","</mark>", "<mark>", mass, "</mark><br/>", "<mark>", "Era:", "</mark>", "<mark>", eraName, "</mark>"))
}

 data_met_yrWiseSubsets <- list(rep(NA, times = nrow(uniq_yearOnly)))
 data_met_accumlateYrByYr <-data.frame(data_met[1,])
 maps_yrWiseMeteorLandings <- list(rep(NA, times = nrow(uniq_yearOnly)))
 maps_accumlateYrWiseMeteorLandings <- list(rep(NA, times = nrow(uniq_yearOnly)))
 
 counter_rows <- NA
 counting <- 1
 for(m in 1:nrow(uniq_yearOnly)){
   if(m == 1){
   data_met_yrWiseSubsets[[m]] <- filter(data_met, yearOnly%in%as.vector(uniq_yearOnly[1][m,]))
   counter_rows <- nrow(data_met_yrWiseSubsets[[m]])
   maps_yrWiseMeteorLandings[[m]] <- leaflet(data = data_met_yrWiseSubsets[[m]], height = 400, width = 550)%>%setView(lat = 15, lng = 45, zoom =  1)%>%addTiles()%>%addCircleMarkers(lat = ~geolocation.latitude, lng = ~geolocation.longitude, radius = 0.2, color = ~colorErawise(eraName), popup = ~paste("<mark>","Name:","</mark>","<mark>", name, "</mark><br/>","<mark>","Year:", "</mark>","<mark>", yearOnly,"</mark><br/>","<mark>", "Mass in grams:","</mark>", "<mark>", mass, "</mark><br/>", "<mark>", "Era:", "</mark>", "<mark>", eraName, "</mark>"))
   #mapshot(maps_yrWiseMeteorLandings[[m]], paste("C:/Users/pc/Dropbox/and more/data analysis for social scientists, edX/extras/Lets-Work-it-out!/data+otherstuff_meteorLandVis/",sprintf("plot%i_year%i.jpeg",m,uniq_yearOnly[1][m,]), sep = ""))
   data_met_accumlateYrByYr[counting:counter_rows,] <-  data_met_yrWiseSubsets[[m]]
   maps_accumlateYrWiseMeteorLandings[[m]] <- leaflet(data = data_met_accumlateYrByYr, height = 400, width = 550)%>%setView(lat = 15, lng = 45, zoom =  1)%>%addTiles()%>%addCircleMarkers(lat = ~geolocation.latitude, lng = ~geolocation.longitude, radius = 0.2, color = ~colorErawise(eraName), popup = ~paste("<mark>","Name:","</mark>","<mark>", name, "</mark><br/>","<mark>","Year:", "</mark>","<mark>", yearOnly,"</mark><br/>","<mark>", "Mass in grams:","</mark>", "<mark>", mass, "</mark><br/>", "<mark>", "Era:", "</mark>", "<mark>", eraName, "</mark>"))
   counting <- counter_rows + 1
   }
   else{
     data_met_yrWiseSubsets[[m]] <- filter(data_met, yearOnly%in%as.vector(uniq_yearOnly[1][m,]))
     counter_rows <- nrow(data_met_yrWiseSubsets[[m]])
     maps_yrWiseMeteorLandings[[m]] <- leaflet(data = data_met_yrWiseSubsets[[m]], height = 400, width = 550)%>%setView(lat = 15, lng = 45, zoom =  1)%>%addTiles()%>%addCircleMarkers(lat = ~geolocation.latitude, lng = ~geolocation.longitude, radius = 0.2, color = ~colorErawise(eraName), popup = ~paste("<mark>","Name:","</mark>","<mark>", name, "</mark><br/>","<mark>","Year:", "</mark>","<mark>", yearOnly,"</mark><br/>","<mark>", "Mass in grams:","</mark>", "<mark>", mass, "</mark><br/>", "<mark>", "Era:", "</mark>", "<mark>", eraName, "</mark>"))
     data_met_accumlateYrByYr[counting:(counting+counter_rows-1),] <- data_met_yrWiseSubsets[[m]]
     maps_accumlateYrWiseMeteorLandings[[m]] <- leaflet(data = data_met_accumlateYrByYr, height = 400, width = 550)%>%setView(lat = 15, lng = 45, zoom =  1)%>%addTiles()%>%addCircleMarkers(lat = ~geolocation.latitude, lng = ~geolocation.longitude, radius = 0.2, color = ~colorErawise(eraName), popup = ~paste("<mark>","Name:","</mark>","<mark>", name, "</mark><br/>","<mark>","Year:", "</mark>","<mark>", yearOnly,"</mark><br/>","<mark>", "Mass in grams:","</mark>", "<mark>", mass, "</mark><br/>", "<mark>", "Era:", "</mark>", "<mark>", eraName, "</mark>"))   
     counting <- (counting+counter_rows-1)+1
   }
   
 }





