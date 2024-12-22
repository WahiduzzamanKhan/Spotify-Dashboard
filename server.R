# defining server logic ----------------------------------------------
server <- function(input, output, session) {
  # create reactive values
  auth_code_availabe <- reactiveVal(FALSE)
  refresh_token_available <- reactiveVal(FALSE)
  tokens <- reactiveValues(access_token = NULL, refresh_token = NULL)

  observeEvent(
    session$clientData,
    {
      full_url <- parse_url(paste0(
        session$clientData$url_protocol, "//",
        session$clientData$url_hostname,
        if (!is.null(session$clientData$url_port) && session$clientData$url_port != "") paste0(":", session$clientData$url_port) else "",
        session$clientData$url_pathname,
        session$clientData$url_search
      ))

      # if url contains code, use it to get access token
      if (!is.null(full_url$query$code)) {
        auth_code_availabe(TRUE)
        temp <- get_access_token(authorization_code = full_url$query$code, redirect_uri = redirect_uri)

        tokens$access_token <- temp$access_token
        tokens$refresh_token <- temp$refresh_token

        # save refresh token as browser cookie
        set_cookie(
          cookie_name = "refresh_token",
          cookie_value = tokens$refresh_token,
          same_site = "strict"
        )

        # remove the code from browser address bar
        runjs("
          const baseUrl = window.location.origin;
          window.history.replaceState(null, '', baseUrl);
          document.title = 'Spotify Dashboard'
        ")
      } else {
        # Access cookies from the HTTP header
        refresh_token <- get_cookie("refresh_token")

        req(refresh_token)

        refresh_token_available(TRUE)

        temp <- refresh_access_token(refresh_token = refresh_token)
        tokens$access_token <- temp$access_token

        if (!is.null(temp$refresh_token)) {
          tokens$refresh_token <- temp$refresh_token
          # save refresh token as browser cookie
          set_cookie(
            cookie_name = "refresh_token",
            cookie_value = tokens$refresh_token,
            same_site = "strict"
          )
        }

        runjs("document.title = 'Spotify Dashboard';")
      }
    }
  )

  # create reactive value to hold user data
  data_store <- reactiveValues(
    top_artists = NULL,
    top_tracks = NULL,
    saved_tracks = NULL,
    clustered_features = NULL
  )

  # show authorizatino promp when the user is not signed in
  output$authorization_prompt <- renderUI({
    req(!(isTruthy(auth_code_availabe()) | isTruthy(refresh_token_available())))
    spotify_info_card(
      card_title = "Authorize",
      card_body = "Authorize the app and give permission to read your Spotify data",
      card_button_id = "authorize",
      card_button_label = "Authorize",
      color = "green"
    )
  })

  # when authorize button is clicked, generate authorization link,
  # then open a new browser tab to that link
  observeEvent(
    input$authorize,
    {
      auth_url <- get_auth_url(scope = scopes, redirect_uri = redirect_uri)
      runjs(paste0("window.open('", auth_url, "', '_self')"))
    }
  )

  # create the user profile view
  output$user_profile <- renderUI({
    req(tokens$access_token)

    user_profile <- get_user_profile(tokens$access_token)
    followed_artists <- get_followed_artists(tokens$access_token)

    profile_card(
      name = user_profile$display_name,
      email = user_profile$email,
      image_url = user_profile$images[[1]]$url,
      follower_count = user_profile$followers$total,
      following_count = followed_artists$artists$total
    )
  })

  # take user input for analysis type
  output$analysis_type_selector <- renderUI({
    req(tokens$access_token)

    div(
      class = "container",
      custom_radio_input(
        inputId = "analysis_type",
        choiceNames = list(HTML(paste0('<i class="fa-solid fa-user"></i>', "Artists")), HTML(paste0('<i class="fa-solid fa-music"></i>', "Tracks"))),
        choiceValues = list("artists", "tracks")
      )
    )
  })

  # get appropriate data for the analysis
  observeEvent(
    input$analysis_type,
    {
      if (input$analysis_type == "artists" & is.null(data_store$top_artists)) {
        data_store$top_artists <<- get_top_artists(access_token = tokens$access_token, time_range = "long_term")
      } else if (input$analysis_type == "tracks" & is.null(data_store$top_tracks)) {
        data_store$top_tracks <<- get_top_tracks(access_token = tokens$access_token, time_range = "long_term")
        data_store$saved_tracks <<- get_saved_tracks(access_token = tokens$access_token)

        if (nrow(data_store$saved_tracks$items) > 5) {
          features <- get_track_features(access_token = tokens$access_token, paste0(data_store$saved_tracks$items$track$id, collapse = ","))
          features <- get_cluster(data = features, nclust = get_optimum_cluster_number(features))
          data_store$clustered_features <<- features
        }
      }
    }
  )

  output$top_genre_chart <- renderEcharts4r({
    top_genre_chart(data_store$top_artists$items$genre)
  })
  output$artists_popularity_chart <- renderHighchart({
    artists_popularity_chart(data_store$top_artists)
  })



  output$analysis <- renderUI({
    req(input$analysis_type)

    if (input$analysis_type == "artists") {
      tagList(
        div(class = "container", top_artists_card(data_store$top_artists$items)),
        div(
          class = "container two-charts-row",
          echarts4rOutput("top_genre_chart"),
          highchartOutput("artists_popularity_chart")
        ),
        div(class = "container", popularity_analysis_verdict(data_store$top_artists$items))
      )
    } else if (input$analysis_type == "tracks") {
      tagList(
        div(class = "container", top_tracks_table(data_store$top_tracks$items)),
        div(class = "container", saved_tracks_table(data_store$saved_tracks$items$track)),
        div(class = "container", get_cluster_view(data_store$saved_tracks, data_store$clustered_features))
      )
    }
  })
}
