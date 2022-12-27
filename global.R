# Load packages ------------------------------------------------------
library(shiny)
library(shinyjs)
library(httr)
library(jsonlite)
library(RCurl)
library(dplyr)

# Load functions -----------------------------------------------------
source("functions/functions.R")

# load api credentials -----------------------------------------------
client_id <- fromJSON("api_credentials.json")[[1]]
client_secret <- fromJSON("api_credentials.json")[[2]]

# create global variables --------------------------------------------
scopes <- "user-read-private user-read-email playlist-read-private playlist-read-collaborative user-follow-read user-top-read user-read-recently-played user-library-read"
redirect_uri <- "https://connector.wahidkhan.me/spotify/"
