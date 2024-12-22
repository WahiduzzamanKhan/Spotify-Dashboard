# creating the UI ----------------------------------------------------
ui <- tags$html(
  # adding custom styles ---------------------------------------------
  tags$head(
    tags$meta(content = "width=device-width, initial-scale=1", name = "viewport"),
    tags$link(rel = "preconnect", href = "https://fonts.gstatic.com"),
    tags$link(rel = "stylesheet", href = "https://fonts.googleapis.com/css2?family=Figtree:wght@300;400;500;600;700&display=swap"),
    tags$link(rel = "stylesheet", type = "text/css", href = "styles.css"),
    tags$link(rel = "stylesheet", type = "text/css", href = "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.1/css/all.min.css"),
    tags$script(src = "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.1/js/all.min.js"),
    useShinyjs()
  ),

  # body -------------------------------------------------------------
  tags$body(
    # header ---------------------------------------------------------
    tags$header(
      div(
        class = "container even-columns",
        div(
          class = "logo",
          h1("Spotify Dashboard")
        ),
        HTML(
          '
          <ul class="social-list" role="list" aria-label="social links">
              <li><a aria-label="linkedin" href="https://www.linkedin.com/in/wahiduzzaman-khan-2014134007"><svg class="social-icon">
                <use xlink:href="/img/social-icons.svg#linkedin"></use>
              </svg></a></li>
              <li><a aria-label="stack-overflow" href="https://stackoverflow.com/users/10488754/wahiduzzaman-khan"><svg class="social-icon">
                <use xlink:href="/img/social-icons.svg#stack-overflow"></use>
              </svg></a></li>
              <li><a aria-label="twitter" href="https://twitter.com/WahiduzzamanK11"><svg class="social-icon">
                <use xlink:href="/img/social-icons.svg#twitter"></use>
              </svg></a></li>
              <li><a aria-label="github" href="https://github.com/WahiduzzamanKhan"><svg class="social-icon">
                <use xlink:href="/img/social-icons.svg#github"></use>
              </svg></a></li>
          </ul>
          '
        )
      )
    ),

    # main content ---------------------------------------------------
    uiOutput("authorization_prompt"),
    uiOutput("user_profile"),
    uiOutput("analysis_type_selector"),
    uiOutput("analysis")
  )
)

ui <- add_cookie_handlers(ui)
