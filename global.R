# Load packages ------------------------------------------------------
library(shiny)
library(shinyjs)
library(glue)
library(httr)
library(jsonlite)
library(RCurl)
library(dplyr)
library(stringr)
library(echarts4r)
library(highcharter)
library(reactable)
library(NbClust)
library(cli)
library(cookies)

# Load functions -----------------------------------------------------
source("functions/spotify_api_functions.R")
source("functions/custom_ui_functions.R")
source("functions/other_functions.R")

# load api credentials -----------------------------------------------
set_api_credentials()

# create global variables --------------------------------------------
scopes <- "user-read-private user-read-email playlist-read-private playlist-read-collaborative user-follow-read user-top-read user-read-recently-played user-library-read"
redirect_uri <- "http://localhost:8080"
