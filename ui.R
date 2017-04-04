
#
# This is a template for creating a leaflet chroropleth map shiny application.
# This app uses mock data that resembles survey answers to several major & minor categories
# This app is based on rstudio's 'superzip' example authored by Joe Cheng.
#
# Author: Jasper Ginn
#

library(shiny)
library(leaflet)
library(plotly)

# Shiny UI
navbarPage("Shiny Choropleth Map", id="nav",
           tabPanel("Interactive map",
                    div(class="outer",
                        tags$head(
                          # Include our custom CSS
                          includeCSS("www/styles.css")
                        ),
                        # Output leaflet map
                        leafletOutput("map", width="100%", height="100%"),
                        # Sidebar panel
                        absolutePanel(id = "controls",
                                      class = "panel panel-default", fixed = TRUE,
                                      draggable = TRUE, top = 60, left = "auto",
                                      right = 20, bottom = "auto",
                                      width = 300, height = "auto",
                                      h2("Major and sub categories"),
                                      selectInput("countries", "Select a country",
                                                  choices = c("-", countries),
                                                  selected = "-"),
                                      HTML("<p><strong>Main categories</strong></p>"),
                                      # Add output for country that has been selected
                                      plotOutput("majorCats", height = 200),
                                      # Selectize input for category
                                      selectInput("majorCategories", "Select a subcategory",
                                                  choices = c("-", as.character(major.cats)),
                                                  selected = "Economic"),
                                      # Add output for country & category that has been selected
                                      plotOutput("minorCats", height = 200)
                                      ),

                        #
                        # Add citation. Textouput does not work. Not sure why.
                        #

                        tags$div(id="cite",
                                  textOutput("lastUpdate"), "             Design by Jasper Ginn"
                        )
                      )
                  ),

           conditionalPanel("false", icon("crosshair"))
)
