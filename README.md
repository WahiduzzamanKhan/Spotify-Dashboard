# Spotify-Dashboard

This is a R/Shiny app that can analyze your taste in music based on your Spotify history

You can connect your Spotify account, then the app will get your listening history from Spotify and show you some cool information and visualizations.

## Features

* Connect to your Spotify account
* See your top artists
* See your favorite genres
* See your favorite tracks
* Cluster analysis of your liked tracks

## How to use

* Go to https://developer.spotify.com and log in
* Create an app
* Edit the app's settings and set the redirect uri to https://connector.wahidkhan.me/spotify/
* Clone this repository to your pc
* Open the `api_credentials.json` file with any text editor
* Replace `CLIENT ID of your Spotify app` and `CLIENT SECRET of your Spotify app` with the client id and client secret of the Sptify developer app that you created and save the file
* Open the `global.R` file with RStudio and install any missing packages
* Click on the `Run app` button

## Packages used
* [shiny](https://github.com/rstudio/shiny)
* [shinyjs](https://deanattali.com/shinyjs/)
* [glue](https://github.com/tidyverse/glue/)
* [httr](https://github.com/r-lib/httr/)
* [jsonlite](https://github.com/jeroen/jsonlite)
* [RCurl](https://github.com/omegahat/RCurl)
* [dplyr](https://github.com/tidyverse/dplyr/)
* [stringr](https://github.com/tidyverse/stringr/)
* [echarts4r](https://github.com/JohnCoene/echarts4r)
* [highcharter](https://github.com/jbkunst/highcharter/)
* [reactable](https://github.com/glin/reactable/)
* [NbClust](https://cran.r-project.org/web/packages/NbClust/index.html)
