# spotify account authorization functions ---------------------------
get_auth_url <- function(
    client_id = Sys.getenv("CLIENT_ID"),
    scope,
    redirect_uri) {
  response <- GET(
    url = modify_url(
      url = "https://accounts.spotify.com/authorize",
      query = list(
        response_type = "code",
        client_id = client_id,
        scope = scope,
        redirect_uri = redirect_uri,
        show_dialog = TRUE
      )
    )
  )

  if (response$status_code == 200) {
    return(response$url)
  } else {
    stop(content(response))
  }
}

get_access_token <- function(
    authorization_code,
    redirect_uri,
    client_id = Sys.getenv("CLIENT_ID"),
    client_secret = Sys.getenv("CLIENT_SECRET")) {
  response <- POST(
    url = "https://accounts.spotify.com/api/token",
    add_headers(
      "Authorization" = paste0("Basic ", RCurl::base64Encode(paste0(client_id, ":", client_secret))),
      "Content-Type" = "application/x-www-form-urlencoded"
    ),
    body = list(code = authorization_code, redirect_uri = redirect_uri, grant_type = "authorization_code"),
    encode = "form"
  )

  if (response$status_code == 200) {
    return(content(response))
  } else {
    stop(paste0("status code: ", response$status_code, "\n error: ", content(response)$error))
  }
}

# functions to fetch user data from spotify -------------------------
get_user_profile <- function(access_token) {
  response <- GET(
    url = "https://api.spotify.com/v1/me",
    add_headers("Authorization" = paste0("Bearer ", access_token)),
    content_type_json()
  )

  if (response$status_code == 200) {
    return(content(response))
  } else {
    stop(paste0("status code: ", response$status_code, "\n error: ", content(response)$error))
  }
}

get_followed_artists <- function(access_token) {
  response <- GET(
    url = "https://api.spotify.com/v1/me/following?type=artist",
    add_headers("Authorization" = paste0("Bearer ", access_token)),
    content_type_json()
  )

  if (response$status_code == 200) {
    return(fromJSON(rawToChar(response$content)))
  } else {
    stop(paste0("status code: ", response$status_code, "\n error: ", content(response)$error))
  }
}

get_top_artists <- function(access_token, time_range = c("long_term", "medium_term", "short_term")) {
  response <- GET(
    url = modify_url(
      url = "https://api.spotify.com/v1/me/top/artists",
      query = list(
        limit = 10,
        time_range = time_range
      )
    ),
    add_headers("Authorization" = paste0("Bearer ", access_token)),
    content_type_json()
  )

  if (response$status_code == 200) {
    return(fromJSON(rawToChar(response$content)))
  } else {
    stop(paste0("status code: ", response$status_code, "\n error: ", content(response)$error))
  }
}

get_top_tracks <- function(access_token, time_range = c("long_term", "medium_term", "short_term")) {
  response <- GET(
    url = modify_url(
      url = "https://api.spotify.com/v1/me/top/tracks",
      query = list(
        limit = 10,
        time_range = time_range
      )
    ),
    add_headers("Authorization" = paste0("Bearer ", access_token)),
    content_type_json()
  )

  if (response$status_code == 200) {
    return(fromJSON(rawToChar(response$content)))
  } else {
    stop(paste0("status code: ", response$status_code, "\n error: ", content(response)$error))
  }
}

get_saved_tracks <- function(access_token) {
  response <- GET(
    url = modify_url(
      url = "https://api.spotify.com/v1/me/tracks",
      query = list(
        limit = 50,
        offset = 0
      )
    ),
    add_headers("Authorization" = paste0("Bearer ", access_token)),
    content_type_json()
  )

  if (response$status_code == 200) {
    return(fromJSON(rawToChar(response$content)))
  } else {
    stop(paste0("status code: ", response$status_code, "\n error: ", content(response)$error))
  }
}

get_track_features <- function(access_token, ids) {
  response <- GET(
    url = "https://api.spotify.com/v1/audio-features",
    query = list(
      ids = ids
    ),
    add_headers("Authorization" = paste0("Bearer ", access_token)),
    content_type_json()
  )

  track_features <- fromJSON(rawToChar(response$content))
  track_features <- track_features$audio_features %>%
    select(id, energy, danceability, speechiness, acousticness, instrumentalness, valence)

  return(track_features)
}
