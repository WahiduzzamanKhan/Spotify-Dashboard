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

# profile_card -------------------------------------------------------
profile_card <- function(name, email, image_url, follower_count, following_count) {
  profile_card <- div(
    class = "container",
    div(
      class = "profile-card",
      div(
        class = "image-section",
        img(class = "profile-image", src = image_url, alt = "profile image")
      ),
      div(
        class = "info-section",
        h2(class = "profile-name", name),
        p(class = "profile-email", email),
        div(
          class = "profile-connection",
          p("Following: ", span(class = "number", following_count)),
          p("Followers: ", span(class = "number", follower_count))
        )
      )
    )
  )

  return(profile_card)
}

# custom radio input ---------------------------------------------------
custom_radio_input <- function(inputId, choices = NULL, selected = NULL, width = NULL, choiceNames = NULL, choiceValues = NULL) {
  return(
    div(
      class = "custom-radio-input",
      radioButtons(
        inputId = inputId,
        label = NULL,
        choices = choices,
        selected = selected,
        inline = TRUE,
        width = width,
        choiceNames = choiceNames,
        choiceValues = choiceValues
      )
    )
  )
}

# top artists card -----------------------------------------------------
top_artists_card <- function(top_artists_data) {
  tiles <- list()
  for(i in 1:length(top_artists_data)) {
    tiles[[i]] <- div(
      class = "artist-tile",
      img(class = "artist-cover", src = top_artists_data$images[[i]]$url[[1]]),
      div(
        class = "text-section",
        h3(class = "artist-name", top_artists_data$name[i]),
        div(class = "artist-followers", "Followers: ", span(class = "number", format(top_artists_data$followers$total[i], big.mark = ","))),
        div(class = "artist-popularity", "Popularity: ", span(class = "number", top_artists_data$popularity[i]))
      )
    )
  }

  return(div(class = "top-artists", h3(class = "top-artists-title", "Your All-Time Top Artists"), div(class = "tiles", tiles)))
}

# top genre chart ------------------------------------------------------
top_genre_chart <- function(genre_list){
  message("doing it")
  top_genre <- as.data.frame(table(unlist(genre_list))) %>% select(Genre = Var1, Freq) %>% mutate(Genre = stringr::str_to_title(Genre))
  colors <- e_color_range(top_genre, Freq, colors, colors = c("#FFFFFF", "#1db954"))$colors

  chart <- top_genre %>%
    e_charts(Genre, backgroundColor = "rgba(0,0,0,0)") %>%
    e_title(text = "Your All-Time Top Genre", textStyle = list(color = "#FFFFFF", fontSize = 24, fontWeight = 700, fontFamily = '"Figtree", sans-serif'), left = "center") %>%
    e_pie(
      Freq,
      radius = c("50%", "70%"),
      label = list(
        formatter = "{genre|{b}}",
        lineHeight = 20,
        rich = list(
          genre = list(color = "#FFFFFF")
        )
      )
    ) %>%
    e_legend(show = FALSE) %>%
    e_color(color = colors)

  return(chart)
}

# aritsts popularity chart----------------------------------------------
artists_popularity_chart <- function(top_artists_data) {
  popularity <- top_artists_data$items %>% select(name, popularity)

  chart <- highchart(google_fonts = FALSE) %>%
    hc_chart(type = "column", backgroundColor = "#121212") %>%
    hc_add_series(name = "popularity" , data = popularity$popularity, color ="#1db954" )%>%
    hc_xAxis(
      categories = popularity$name,
      title = list(text = "Arists", style = list(color = "#FFFFFF", fontFamily = '"Figtree", sans-serif')),
      labels = list(style = list(color = "#FFFFFF", fontFamily = '"Figtree", sans-serif'))
    )%>%
    hc_yAxis(
      title = list(text = "Popularity", style = list(color = "#FFFFFF", fontFamily = '"Figtree", sans-serif')),
      labels = list(style = list(color = "#FFFFFF", fontFamily = '"Figtree", sans-serif')),
      gridLineColor = "#b3b3b3"
    )%>%
    hc_title(
      text= "Popularity of Your Top Artists",
      style = list(color = "#FFFFFF", fontSize = "1.5rem", fontWeight = 700, fontFamily = '"Figtree", sans-serif'),
      y = 16
    ) %>%
    hc_legend(enabled = FALSE) %>%
    hc_plotOptions(
      column = list(borderRadius = 5, borderWidth = 0)
    )

  return(chart)
}
