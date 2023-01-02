# defining server logic ----------------------------------------------
server <- function(input, output, session) {
  # create reactive value to hold access_tokens
  tokens <- reactiveValues(
    access_token = NULL,
    refresh_token = NULL
  )

  # create reactive value to hold user data
  data_store <- reactiveValues(
    top_artists = NULL,
    top_tracks = NULL
  )

  # show authorizatino promp when the user is not signed in
  output$authorization_prompt <- renderUI({
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
      auth_url <- get_auth_url(client_id, scopes, redirect_uri)
      runjs(paste0("window.open('", auth_url, "', '_blank')"))

      showModal(
        spotify_modal(
          modal_title = "Inter the code",
          modal_body = textInput(inputId = "auth_code", label = NULL),
          modal_button_id = "auth_confirm",
          modal_button_label = "Confirm",
          color = "yellow"
        )
      )
    }
  )

  # close the modal when close button is clicked
  observeEvent(
    input$modal_close,
    removeModal()
  )

  # when auth_confirm button is clicked, get the access tokens,
  # then remove the modal and the authorization prompt
  observeEvent(
    input$auth_confirm,
    {
      auth_code <- input$auth_code
      temp <<- get_access_token(auth_code, redirect_uri, client_id, client_secret)

      removeModal()
      removeUI(selector = "#authorization_prompt")

      tokens$access_token <- temp$access_token
      tokens$refresh_token <- temp$refresh_token
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

    tagList(
      div(class = "container", top_artists_card(data_store$top_artists$items)),
      div(
        class = "container two-charts-row",
        echarts4rOutput("top_genre_chart"),
        highchartOutput("artists_popularity_chart")
      ),
      div(class = "container", popularity_analysis_verdict(data_store$top_artists$items))
    )
  })
}
