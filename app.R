##=========================================Lets Work it out!============================================##
#--Project-Description:

##======================================================================================================##

#--setting working directory to the project folder
#setwd("C:/Users/pc/Dropbox/and more/data analysis for social scientists, edX/extras/Lets-Work-it-out!")

#--loading libraries and files
library(shiny)
library(shinythemes)
#library(DT)
library(rvest) #for web-scraping
library(sf) #for geo-spatial data manipulation
library(RColorBrewer)
library(leaflet) #for geo-spatial plotiing
library(tidyverse) #something that one should always have
library(viridis)
library(viridisLite)
library(magrittr) #for using pipes(%>%)
library(jsonlite)
library(geojsonio)
#library(io)
#library(mapview)
#library(webshot)
#library(devtools)
#library(git2r)

#source("1.crimeEvolVis.helper.R")
#source("2.meteorLandVis.helper.R")
#save(list = ls(all.names = TRUE), file = "#fullEnvironToRunAllCode.RData", envir = .GlobalEnv)

load(file = "#fullEnvironToRunAllCode.RData")

#--user interface for the app
ui <- fluidPage(
  theme = shinytheme("darkly"),
  navbarPage(
    "Lets Work it out!",
    tabPanel(
      "Welcome",
      imageOutput("welcomePage")
    ),
    tabPanel(
      "About",
     h4("My name is Aarsh. Lets Work it out! is a place where I plan to play around with a lot of ideas spanning
        any field."),
     br(),
     h4("I start with these 2 apps, one of which shows the evolution of crime in the last five years
        using choropleth maps(CrimeEvolVis) and the other(MeteorLandVis) which produces a historical record of all
        the known meteor landings starting from 861 BC on an interactive map and also via an animation."),
     br(),
     h4("Go have a look.")
    ),
    navbarMenu(
      "CrimeEvolVis",
      tabPanel(
        "About",
        h4("This app produces choropleth maps for years 2012-2017. If unfamiliar with choropleth maps, 
           click",shiny::tags$a("here", href="https://en.wikipedia.org/wiki/Choropleth_map"),"to learn more."),
        br(),
          h4("A series of choropleth maps make it easier for us to see the evolution of the particular statistic 
          we are interested in(in this case the crime index for a country) and with that in hand we have a
          big picture in mind that will guide us throughout the rest of the data analysis process.")
      ),
      tabPanel(
        "App",
        sidebarLayout(
          sidebarPanel(
            h3("Crime Evolution"),
            shiny::tags$hr(size = "3"),
            br(),
            h2("How to use the app?"),
            shiny::tags$div(
              shiny::tags$ul(
                shiny::tags$li("If unfamiliar with choropleth maps, click",shiny::tags$a("here", href="https://en.wikipedia.org/wiki/Choropleth_map"),"to learn more"),
                br(),
                shiny::tags$li("Next, select the year from the selectbox below and this app produces a choropleth map displaying the crimeIndex for that year for various countries"),
                br(),
                shiny::tags$li("This is an interactive map, hover your mouse over the countries and this map will bring forward the 'country name' and its 'crime index' for that year")
              )
            ),
            br(),
            selectInput("years", "Year", choices = c("2012", "2013", "2014", "2015", "2016", "2017"), selected = "2012"),
            br(),
            br(),
            br(),
            shiny::tags$small("Note: Please do read the 'More information' section for important information, criticisms(about data used to produce the maps), links.")
            
          ),
          mainPanel(
            leafletOutput("choroplethMap")
          )
        )
        
      ),
      tabPanel(
        "Animation",
        imageOutput("cp_crimeIndex_animation"), #(code for putting in a gif animation)
        br(),
        br(),
        h5("Caution: This animation might give misleading insights as the number of countries for which
            the data is produced varies each year, the variation is not much, but its there. I intend to update this as more data becomes available.
            For most countries the data(and a corresponding color) is there for all years, you might focus on those
            until more data becomes available.")
        
        ###############code for an animation interface with a slider, etc.###########################
        # sidebarLayout(
        #   sidebarPanel(
        #     h3("Crime Evolution"),
        #     shiny::tags$hr(size="3"),
        #     br(),
        #     h2("Crime meter"),
        #     shiny::tags$div(
        #       shiny::tags$ul(
        #         shiny::tags$li("Seeing a choropleth map one year at a time helped us to learn the relative differences b/w different countries crime index.
        #                        If you haven't seen go have a look by clicking the 'app' tab under 'CrimeEvolVis'."),
        #         shiny::tags$li("Playing these individual yearly maps one after another is crucial as it gives us a big picture that is relatively easy to keep
        #                        in mind than a bunch of time-series data on crime index for different countries."),
        #         shiny::tags$li("Moreover when we percieve changes in colors, what we get is much more than just 'insights', we get 
        #                        'precise insights' that are much better than looking at numbers."),
        #         shiny::tags$li("Year '1-6' below correspond to years '2012-2017'."),
        #         br(),
        #         sliderInput("crimeEvolAnimation", "Year", min = 1, max= 6, value = 1, animate = animationOptions(interval = 3500 , loop = FALSE))
        #       )
        #     )
        #     
        #     
        #   ),
        #   mainPanel(
        #     leafletOutput("crimeEvolMaps"),
        #     br(),
        #     h4("Caution: This animation might give misleading insights as the number of countries for which
        #        the data is produced varies each year, the variation is not much, but its there. I intend to update this as more data becomes available.
        #        For most countries the data(and a corresponding color) is there for all years, you might focus on those
        #        until more data becomes available.")
        #       
        #   )
        # )
        ###############################################################################################
      ),
      tabPanel(
        "More information",
        h3("A Note of Caution on data source"),
        br(),
        p("Numbeo is a crowd-sourced global database of reported consumer prices,
          perceived crime rates, quality of health care, other statistics. There has been some criticisms that
          data that numbeo collects is based on 'what people say' and should be interpreted accordingly. 
          For more information on numbeo click ", shiny::tags$a("here.", href = "https://en.wikipedia.org/wiki/Numbeo")), 
        br(),
        p("Also, to know more about numbeo's methodology for collection of the data that supports this app,
          click ", shiny::tags$a("here.", href = "https://www.numbeo.com/crime/"))
        )
        ),
    navbarMenu(
      "meteorLandVis",
      tabPanel(
        "About",
        h4("Meteorite landings have always fascinated me, though I never witnessed one myself, but if I did, it would be
           great to have one small souvenier which has been travelling in space for 1000's of years,
           in my top desk drawer besides my Darth Vader action figure. That is exciting!."),
        br(),
        h4("I got the idea for this app when I was strolling around the",shiny::tags$a("data.gov", href="https://www.data.gov/"),
        "site and I came across a dataset from NASA which had the word 'meteor' and 'landings' in it, so I naturally
           downloaded it and then it struck to me lets put it on a map, and that may have already been done, so I 
           decided to give it some context by first cleaning and then categorizing data according to different eras
           and then I color coded it. That was all good but then I thought that I should produce an animation that
           displays one by one chronologically(for each year) where the meteors fell."),
        br(),
        h4("It would be like witnessing the whole meteor landings history in front of me without dying or getting hurt."),
        br(),
        h4("First off, under the tab named 'app' are the 'era-wise' maps. Then next, under the tab named 'animation' is the animation that I talked about above."),
        br(),
        h4("Go have a look!")
        
      ),
      tabPanel(
        "App",
        sidebarLayout(
          sidebarPanel(
            h3("Meteor Landings Record"),
            shiny::tags$hr(size = "3"),
            br(),
            h2("How to use the app?"),
            shiny::tags$div(
              shiny::tags$ul(
                shiny::tags$li(
                  "Select an Era from the below selectbox."
                ),
                shiny::tags$li(
                  "Corresponding map produced on the right is a map of all the meteor landings in that period as recorded by National Aeronautics and Space Administration(NASA)"
                ),
                shiny::tags$li(
                  "Click on individual points to reveal additional information on the meteorite "
                ),
                shiny::tags$li(
                  "If the map is not loading click on the +, - buttons to refocus the map."
                )
              )
            ),
            br(),
            selectInput("era","Era Name", choices = eraNames, selected = eraNames[4]),
            br(),
            br(),
            br(),
            shiny::tags$small("Note: Please read the more information section for important links and references related to the app.")
          ),
          mainPanel(
            leafletOutput("meteorLandPerEra"),
            br(),
            shiny::tags$div(
              "Below is a mapping from 'Era Name' to 'time period'(in AD):",
              shiny::tags$ol(
                shiny::tags$li("Middle Ages: 500-1500"),
                shiny::tags$li("Early Modern Period: 1500-1800"),
                shiny::tags$li("Oil Age: 1800-1900"),
                shiny::tags$li("World Wars: 1900-1945"),
                shiny::tags$li("Atomic age: 1945-1970"),
                shiny::tags$li("Information age: 1970-presentDay")
              ),
              br(),
              p("Please note that the above time periods are just for reference and are debatable.
                I categorized the era's according to", shiny::tags$a("this", href="https://en.wikipedia.org/wiki/List_of_time_periods#General_periods"), "wikipedia article.")
            )
          )
        )
      ),
      tabPanel(
        "Animation",
        sidebarLayout(
          sidebarPanel(
            h3("Witness meteorite landings without dying or getting hurt!"),
            shiny::tags$hr(size="3"),
            br(),
            h2("Chronological meteorite metre"),
            shiny::tags$div(
              shiny::tags$ul(
                shiny::tags$li(
                  "There are 247 frames, i.e. 247 layers."
                ),
                shiny::tags$li(
                  "Each additional frame adds a new layer on the map that corresponds to a unique year."
                ),
                shiny::tags$li(
                  "E.g. first map = all meteorite landings of year 861, second map = first map + all meteorite landings of year 921,..."
                ),
                shiny::tags$li(
                  "So there are 247 unique years for which data is available. You can pause and click on individual points for getting more information."
                ),
                shiny::tags$li(
                  "The first meteorite record is from year 861 named 'Nogata', to give some context, that was the middle ages."
                ),
                shiny::tags$li(
                  "If the map is not loading click on the +, - buttons to refocus the map."
                ),
                br(),
                sliderInput("chronoMeteorMetre", "Meteor metre", min = 1, max = 247, value = 1, animate = animationOptions(interval = 1000, loop = FALSE))
              )
            )
          ),
          mainPanel(
            leafletOutput("meteorLandAccumlatePerYear")
          )
        )
      ),
      tabPanel(
        "More information",
        h4("Data source: Click",shiny::tags$a("here", href="https://catalog.data.gov/dataset/meteorite-landings-api"),
        "to get access to the complete raw dataset.")
        
      )
    ),
    tabPanel(
      "More to come...",
      h4("I plan to produce more interesting stuff in the future.")
    )
      )
  )

#--server script for the app
server <- function(input, output, session){
  
##=========================================refersToTheWholeProject======================================##

output$welcomePage <- renderImage({
  list(src = "#welcomePage.png", contentType = "image/png", alt = "Welcome Page(png)", width = 1000, height = 500)
}, deleteFile = FALSE)
  
##======================================================================================================##    
  
##=================================================crimeEvolVis=========================================##
  output$choroplethMap <- renderLeaflet({
    input$years
    yr<- c("2012","2013","2014","2015","2016","2017")
    for(l in 1:no_of_years){
      if(input$years == yr[l]){
        return(maps_choropleth[[l]])
        break
      }
    }
    l <- 1
  })
  
#-- code for an animation interface with a slider, etc.############################  
# output$crimeEvolMaps <- renderLeaflet({
#   return(maps_choropleth[[input$crimeEvolAnimation]])
# })  
###################################################################################  
  
 
#-- code for gif animation
   output$cp_crimeIndex_animation <- renderImage({
     list(src = "1.crimeEvolVis.crimeEvolAllYrs.gif",
          contentType = "image/gif", alt = "Crime Evolution gif 2012-2017")
   }, deleteFile = FALSE)
  
  
##======================================================================================================##  

##=================================================meteorLandVis========================================##
output$meteorLandPerEra <- renderLeaflet({
  input$era
  for(n in 1:no_of_eras){
    if(input$era == eraNames[n]){
      return(maps_eraMeteorLandings[[n]])
      break
    }
    else if(input$era == eraNames[7]){
      return(leaflet(data = data_met)%>%setView(lat=15, lng = 45, zoom = 1)%>%addTiles()%>%addCircleMarkers(lat = ~geolocation.latitude, lng = ~geolocation.longitude, radius = 0.2, color = ~colorErawise(eraName), popup = ~paste("Name:","<b>", name, "</b><br/>","Year:", "<b>", yearOnly,"</b><br/>","Mass in grams:", "<b>", mass, "</b><br/>", "Era:", "<b>", eraName, "</b>")))
      break
    }
  }
  n <- 1
})
  
output$meteorLandAccumlatePerYear <- renderLeaflet({
  return(maps_accumlateYrWiseMeteorLandings[[input$chronoMeteorMetre]])
})
  
  
##======================================================================================================##    
}

shinyApp(ui = ui, server = server)
