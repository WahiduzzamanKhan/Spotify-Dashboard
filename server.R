# defining server logic ----------------------------------------------
server <- function(input, output, session) {
  # show authorizatino promp when the user is not signed in
  output$authorization_prompt <- renderUI({
    spotify_info_card(
      card_title = "Authorize",
      card_body = "Authorize the app and give permission to read your Spotify data",
      card_button_id = "authorize",
      card_button_label = "Authorize",
      color = "pu"
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
        # div(
        #   class = "custom-modal-content",
        #   div(
        #     class = "modal-header even-columns",
        #     h2(class = "modal-title", "Inter the code"),
        #     actionButton(class = "modal-close", inputId = "modal_close", label = HTML("&times;"))
        #   ),
        #   div(
        #     class = "modal-body",
        #     textInput(inputId = "auth_code", label = NULL)
        #   ),
        #   div(
        #     class = "modal-footer",
        #     actionButton(class = "button-spotify", inputId = "auth_confirm", label = "Confirm")
        #   )
        # )
        spotify_modal(
          modal_title = "Inter the code",
          modal_body = textInput(inputId = "auth_code", label = NULL),
          modal_button_id = "auth_confirm",
          modal_button_label = "Confirm",
          color = "green"
        )
      )
    }
  )

  observeEvent(
    input$modal_close,
    removeModal()
  )

  observeEvent(
    input$auth_confirm,
    {
      auth_code <- input$auth_code
      access_tokens <<- get_access_token(auth_code, redirect_uri, client_id, client_secret)
      removeModal()
      removeUI(selector = "#authorization_prompt")
    }
  )
}
