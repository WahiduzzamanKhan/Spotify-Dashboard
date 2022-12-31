# Load packages ------------------------------------------------------
library(shiny)
library(shinyjs)
library(glue)
library(httr)
library(jsonlite)
library(RCurl)
library(dplyr)
library(echarts4r)
library(highcharter)

# Load functions -----------------------------------------------------
source("functions/spotify_api_functions.R")
source("functions/custom_ui_functions.R")

# load api credentials -----------------------------------------------
client_id <- fromJSON("api_credentials.json")[[1]]
client_secret <- fromJSON("api_credentials.json")[[2]]

# create global variables --------------------------------------------
scopes <- "user-read-private user-read-email playlist-read-private playlist-read-collaborative user-follow-read user-top-read user-read-recently-played user-library-read"
redirect_uri <- "https://connector.wahidkhan.me/spotify/"
