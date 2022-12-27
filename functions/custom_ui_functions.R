# spotify_info_card --------------------------------------------------
spotify_info_card <- function(card_title, card_body, card_button_id, card_button_label, color = c("green", "pink", "blue", "purple", "yellow", "grey")) {
  color <- match.arg(color)
  info_card <- div(
    class = "container",
    div(
      class = "info-card",
      style = glue("border: 2px var(--clr-info-card-{color}) solid;"),
      div(
        class = "card-header",
        style = glue("background-color: var(--clr-info-card-{color});"),
        h2(class = "card-title", card_title)
      ),
      div(
        class = "card-body",
        card_body
      ),
      div(
        class = "card-footer",
        actionButton(inputId = card_button_id, class = "button-spotify", label = card_button_label)
      )
    )
  )

  return(info_card)
}

# spotify_modal ------------------------------------------------------
spotify_modal <- function(modal_title, modal_body, modal_button_id, modal_button_label, color = c("green", "pink", "blue", "purple", "yellow", "grey")) {
  color <- match.arg(color)
  modal <- div(
    class = "custom-modal-content",
    div(
      class = "modal-header even-columns",
      style = glue("background-color: var(--clr-info-card-{color});"),
      h2(class = "modal-title", modal_title),
      actionButton(class = "modal-close", inputId = "modal_close", label = HTML("&times;"))
    ),
    div(
      class = "modal-body",
      modal_body
    ),
    div(
      class = "modal-footer",
      actionButton(class = "button-spotify", inputId = modal_button_id, label = modal_button_label)
    )
  )

  return(modal)
}
