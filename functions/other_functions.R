get_time_string <- function(x) {
  hours <- ifelse (floor(x/3600 + x%%3600) == x,"0", as.character(floor(x/Hours)))
  minutes <- ifelse (floor(x/60 + x%%60) == x,"0", as.character(floor(x/60)))
  seconds <- x%%60

  time_string <- str_glue(str_pad(hours,2,"left","0"),str_pad(minutes,2,"left","0"),str_pad(seconds,2,"left","0"),.sep = ":")

  return(time_string)
}
get_time_string <- Vectorize(get_time_string)

get_optimum_cluster_number <- function(data) {
  clust <- NbClust::NbClust(data %>% select(-id) %>% scale(), method = 'complete', index = 'all', max.nc = round(nrow(data)/2,0))$Best.nc[1,]
  return(as.integer(names(sort(table(as.integer(clust)),decreasing=TRUE)[1])))
}

get_cluster <- function(data, nclust) {
  kmeans <- kmeans(data %>% select(-id) %>% scale(), centers = nclust, nstart = 10)
  data$cluster_number <- kmeans$cluster
  return(data %>% arrange(cluster_number))
}

get_table_from_tracks <- function(data, pageSize = 10) {
  table <- reactable(
    data = data,
    columns = list(
      .rownames = colDef(name = "#", width = 40),
      TITLE = colDef(html = TRUE, minWidth = 200),
      ALBUM = colDef(html = TRUE)
    ),
    rownames = TRUE,
    highlight = TRUE,
    defaultPageSize = pageSize,
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

  return(table)
}

get_mean_features <- function(clustered_features) {
  mean_features <- clustered_features %>%
    group_by(cluster_number) %>%
    summarise(
      energy = mean(energy),
      danceability = mean(danceability),
      speechiness = mean(speechiness),
      acousticness = mean(acousticness),
      instrumentalness = mean(instrumentalness),
      valence = mean(valence)
    )
  return(mean_features)
}

get_cluster_spiders <- function(mean_features) {
  spiders <- lapply(mean_features$cluster_number, function(i) {
    mean_features[i,-1] |>
      tidyr::gather(key = "Feature") |>
      e_charts(Feature, backgroundColor = "rgba(0,0,0,0)") |>
      e_title(text = NULL) |>
      e_radar(value, max = 1, name = glue("Cluster - {i}")) |>
      e_tooltip(trigger = "item") |>
      e_legend(show = FALSE) |>
      e_radar_opts(
        radius = "60%",
        axisName = list(color = "#1db954"),
        axisLine = list(show = TRUE, lineStyle = list(opacity = .2)),
        splitLine = list(show = TRUE, lineStyle = list(opacity = .2))
      ) |>
      e_color(color = "#1db954")
  })

  return(spiders)
}
