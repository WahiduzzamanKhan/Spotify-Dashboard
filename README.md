# Spotify-Dashboard

This is a R/Shiny app that can analyze your taste in music based on your Spotify history

You can connect your Spotify account, then the app will get your listening history from Spotify and show you some cool information and visualizations.

## Features

- Connect to your Spotify account
- See your top artists
- See your favorite genres
- See your favorite tracks
- Cluster analysis of your liked tracks

## How to use

- Go to https://developer.spotify.com and log in
- Create an app
- Edit the app's settings and set the redirect uri to `http://127.0.0.1:8080`
- Clone this repository
- Open the `.Rprofile` file with any text editor and insert your app credentials
- Open terminal and cd to the cloned repository
- Run the command `R -e "renv::restore()\n shiny::runApp(port = 8080)"`
- Open your browser and go to `http://127.0.0.1:8080`
