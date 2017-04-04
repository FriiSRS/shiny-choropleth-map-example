
#
# This is a template for creating a leaflet chroropleth map shiny application.
# This app uses mock data that resembles survey answers to several major & minor categories
# This app is based on rstudio's 'superzip' example authored by Joe Cheng.
#
# Author: Jasper Ginn
#

library(leaflet)
library(RColorBrewer)
library(scales)
library(lattice)
library(dplyr)
library(reshape2)
library(ggplot2)
library(plotly)

# Server
function(input, output, session) {

  # Put country shapedata in temporary var
  shp2 <- shp

  # Create mock data for testing purpose
  source("functions/mapfunctions/mockdata.R")
  mock.data.all <- mockData(countries = countries, ISO3.codes = ISO3)

  # Mutate mock data for main categories
  mock.data.main <- mock.data.all$data.major.cats %>%
    melt(., id.vars = c("country", "ISO3.codes"))

  # Pick the highest value for category
  io <- mock.data.main  %>%
    group_by(country) %>%
    filter(value == max(value)) %>%
    ungroup() %>%
    tbl_df() %>%
    select(country, value, variable) %>%
    mutate(value = round(value, digits=2)) %>%
    unique()
    # Remove where country == NA
    #filter(!is.na(country))

  # Join mockdata to shapefile
  shp2@data <- shp@data %>%
    left_join(., io, by=c("name"="country"))

  # Popup
  popup <- paste0("<strong>Country: </strong>",
                  shp2@data$name,
                  "<br><strong>Most important category: </strong>",
                  shp2@data$variable,
                  " (",
                  (shp2@data$value * 100), "%", ")")

  #
  # Leaflet map
  #

  output$map <- renderLeaflet({
    # Coropleth map
    leaflet(data = shp2) %>%
      # Add legend
      addLegend(colors = cus.pal, position = "bottomleft",
                labels = major.cats, opacity = 1, title = "Major Categories") %>%
      # Add polygons
      addPolygons(fillColor = ~pal.major(variable),
                  fillOpacity = 0.6,
                  color = "#BDBDC3",
                  weight = 1,
                  popup = popup) %>%
      # Set view on area between Europe & USA
      setView(lng = -27.5097656, lat = 29.0801758, zoom = 3)
  })

  #
  # Last update (this should come from a database)
  #

  output$lastUpdate <- renderText({
    paste0("Last update: ", as.character(Sys.time()))
  })

  #
  # Create charts for side panel
  #

  # Reactive function to subset data
  countryMajorData <- reactive({
    if(input$countries == "-") {
      return(NULL)
    } else {
      return(
        mock.data.main %>% filter(country == input$countries)
      )
    }
  })

  # Bar chart major categories
  output$majorCats <- renderPlot({
    d <- countryMajorData()
    if(is.null(d)) return(NULL)
    d <- d %>%
      mutate(country = as.character(country))
    # Plot
    p <- ggplot(d, aes(x=variable, y=value, fill = variable)) +
           geom_bar(stat = "identity") +
           theme_cfi_scientific() +
           scale_fill_manual(values = rep("#2b8cbe", length(d$variable))) +
      scale_x_discrete(name="") +
      scale_y_continuous(name="", labels = percent) +
      theme(axis.text.x = element_text(angle = 60, hjust = 1, size = 12),
            axis.text.y = element_text(size = 12),
            legend.position = "none")
    # To output
    print(p)
  })

  # Create data for minor categories
  countryMinorData <- reactive({
    if(input$countries == "-") {
      return(NULL)
    } else if(input$majorCategories == "-") {
      return(NULL)
    } else {
      r <- mock.data.all$data.minor.cats[[input$majorCategories]] %>%
        filter(country == input$countries) %>%
        # Melt
        melt(., id.vars = c("country", "ISO3.codes"))
      r$variable <- unname(sapply(as.character(r$variable), function(x) {
        stringr::str_split(x, " \\(")[[1]][1]
      } ))
      r
    }
  })

  # Bar chart minor categories
  output$minorCats <- renderPlot({
    d <- countryMinorData()
    if(is.null(d)) return(NULL)
    d <- d %>%
      mutate(country = as.character(country))
    # Plot
    p <- ggplot(d, aes(x=variable, y=value, fill = variable)) +
      geom_bar(stat = "identity") +
      theme_cfi_scientific() +
      scale_fill_manual(values = rep("#2b8cbe", length(d$variable))) +
      scale_x_discrete(name="", labels = abbreviate) +
      scale_y_continuous(name="", labels = percent) +
      theme(axis.text.x = element_text(angle = 60, hjust = 1, size = 10),
            axis.text.y = element_text(size = 12),
            legend.position = "none")
    # To output
    print(p)
  })

}
