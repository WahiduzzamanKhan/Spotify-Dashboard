spotify_info_card <- function(card_header, card_body, card_button_id, color) {
  info_card <- div(
    class = "container",
    div(
      class = "info-card",
      style = glue("border: 2px var(--clr-info-card-{color}) solid;"),
      div(
        class = "card-header",
        style = glue("background-color: var(--clr-info-card-{color});"),
        card_header
      ),
      div(
        class = "card-body",
        card_body
      ),
      div(
        class = "card-footer",
        actionButton(inputId = card_button_id, class = "button-spotify", label = "Authorize")
      )
    )
  )

  return(info_card)
}
