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

# aritsts popularity chart ---------------------------------------------
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

# popularity analysis verdict ------------------------------------------
popularity_analysis_verdict <- function(top_artists_data) {
  popularity <- top_artists_data %>% select(name, popularity)
  median <- median(popularity$popularity)

  if (median < 70) {
    view <- div(
      class = "popularity-verdict",
      p("Half or more of your favorite artists have a popularity score less than 70."),
      p("Looks like you know how to appreciate ", span(class = "spark", "underrated gems!!"))
    )
  } else {
    view <- div(
      class = "popularity-verdict",
      p("Half or more of your favorite artists have a popularity score more than 70."),
      p("So that one song you are listening on loop, is most probably ", span(class = "spark", "on everyone's loop!!"))
    )
  }

  return(view)
}

# top tracks table -----------------------------------------------------
top_tracks_table <- function(top_tracks_data) {
  top_tracks_data <- data.frame(
    track_names = top_tracks_data$name,
    track_url = top_tracks_data$external_urls$spotify,
    artist_names = unlist(lapply(top_tracks_data$artists, function(artists) {
      df <- data.frame(name = artists$name, url = artists$external_urls$spotify)
      df <- df %>% mutate(artist = paste0("<a class='artist-name' href='", url, "' target='_blank'>", name, "</a>"))
      return(paste(df$artist, collapse = ", "))
    })),
    album_names = top_tracks_data$album$name,
    album_url = top_tracks_data$album$external_urls$spotify,
    album_art_url = unlist(lapply(top_tracks_data$album$images, function(images) {
      images <- images %>% filter(height == min(height)) %>% select(url)
      return(images$url)
    })),
    track_popularity = top_tracks_data$popularity,
    track_duration = get_time_string(round(top_tracks_data$duration_ms/1000))
  )

  top_tracks_data <- top_tracks_data %>%
    mutate(
      TITLE = paste0("<div class='flex-wrapper'><div class='art-section'><img src='", album_art_url, "'></div><div class='info-section'><a class='track-name' href='", track_url, "' target='_blank'>", track_names, "</a><div>", artist_names, "</div></div></div>"),
      ALBUM = paste0("<a href='", album_url, "' target='_blank'>", album_names, "</a>")
    ) %>%
    select(TITLE, ALBUM, DURATION = track_duration, POPUARITY = track_popularity)

  table <- reactable(
    data = top_tracks_data,
    columns = list(
      .rownames = colDef(name = "#", width = 40),
      TITLE = colDef(html = TRUE, minWidth = 200),
      ALBUM = colDef(html = TRUE)
    ),
    rownames = TRUE,
    highlight = TRUE,
    theme = reactableTheme(
      color = "#aaaaaa",
      backgroundColor = "#121212",
      borderWidth = "1px",
      borderColor = "#272727",
      highlightColor = "#272727",
      rowHighlightStyle = list(
        color = "#FFFFFF"
      ),
      style = list(
        fontFamily = "'Figtree', sans-serif",
        fontSize = ".875rem",
        fontWeight = 400,
        cellPadding = "10px 8px",
        "a" = list(
          color = "#aaaaaa",
          textDecoration = "none",
          "&:hover, &:focus" = list(
            textDecoration = "underline",
            textDecorationThickness = "1px"
          )
        ),
        ".flex-wrapper" = list(
          display = "flex",
          alignItems = "center",
          justifyContent = "flex-start",
          gap = "1rem"
        ),
        ".art-section img" = list(
          width = "40px"
        ),
        ".info-section" = list(
          display = "grid",
          gridTemplateColumns = "1fr"
        ),
        ".track-name" = list(
          color = "#FFFFFF",
          fontSize = "1rem"
        )
      ),
      headerStyle = list(
        color = "#aaaaaa",
        fontWeight = 400,
        fontSize = "0.75rem",
        letterSpacing = "1px",
        textTransform = "uppercase"
      )
    )
  )

  return(div(class = "top-tracks", h3(class = "top-tracks-title", "Your All-Time Top Tracks"), table))
}

# top saved table ------------------------------------------------------
saved_tracks_table <- function(saved_tracks_data) {
  saved_tracks_data <- data.frame(
    track_names = saved_tracks_data$name,
    track_url = saved_tracks_data$external_urls$spotify,
    artist_names = unlist(lapply(saved_tracks_data$artists, function(artists) {
      df <- data.frame(name = artists$name, url = artists$external_urls$spotify)
      df <- df %>% mutate(artist = paste0("<a class='artist-name' href='", url, "' target='_blank'>", name, "</a>"))
      return(paste(df$artist, collapse = ", "))
    })),
    album_names = saved_tracks_data$album$name,
    album_url = saved_tracks_data$album$external_urls$spotify,
    album_art_url = unlist(lapply(saved_tracks_data$album$images, function(images) {
      images <- images %>% filter(height == min(height)) %>% select(url)
      return(images$url)
    })),
    track_popularity = saved_tracks_data$popularity,
    track_duration = get_time_string(round(saved_tracks_data$duration_ms/1000))
  )

  saved_tracks_data <- saved_tracks_data %>%
    mutate(
      TITLE = paste0("<div class='flex-wrapper'><div class='art-section'><img src='", album_art_url, "'></div><div class='info-section'><a class='track-name' href='", track_url, "' target='_blank'>", track_names, "</a><div>", artist_names, "</div></div></div>"),
      ALBUM = paste0("<a href='", album_url, "' target='_blank'>", album_names, "</a>")
    ) %>%
    select(TITLE, ALBUM, DURATION = track_duration, POPUARITY = track_popularity)

  table <- reactable(
    data = saved_tracks_data,
    columns = list(
      .rownames = colDef(name = "#", width = 40),
      TITLE = colDef(html = TRUE, minWidth = 200),
      ALBUM = colDef(html = TRUE)
    ),
    rownames = TRUE,
    highlight = TRUE,
    theme = reactableTheme(
      color = "#aaaaaa",
      backgroundColor = "#121212",
      borderWidth = "1px",
      borderColor = "#272727",
      highlightColor = "#272727",
      rowHighlightStyle = list(
        color = "#FFFFFF"
      ),
      style = list(
        fontFamily = "'Figtree', sans-serif",
        fontSize = ".875rem",
        fontWeight = 400,
        cellPadding = "10px 8px",
        "a" = list(
          color = "#aaaaaa",
          textDecoration = "none",
          "&:hover, &:focus" = list(
            textDecoration = "underline",
            textDecorationThickness = "1px"
          )
        ),
        ".flex-wrapper" = list(
          display = "flex",
          alignItems = "center",
          justifyContent = "flex-start",
          gap = "1rem"
        ),
        ".art-section img" = list(
          width = "40px"
        ),
        ".info-section" = list(
          display = "grid",
          gridTemplateColumns = "1fr"
        ),
        ".track-name" = list(
          color = "#FFFFFF",
          fontSize = "1rem"
        )
      ),
      headerStyle = list(
        color = "#aaaaaa",
        fontWeight = 400,
        fontSize = "0.75rem",
        letterSpacing = "1px",
        textTransform = "uppercase"
      )
    )
  )

  return(div(class = "saved-tracks", h3(class = "saved-tracks-title", "Your Liked Tracks"), table))
  #return(table)
}
