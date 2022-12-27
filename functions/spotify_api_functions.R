# spotify account authorization functions ---------------------------
get_auth_url <- function(client_id, scope, redirect_uri) {
  response <-   GET(
    url = modify_url(
      url = "https://accounts.spotify.com/authorize",
      query = list(
        response_type = 'code',
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

get_access_token <- function(authorization_code, redirect_uri, client_id, client_secret) {
  response <- POST(
    url = "https://accounts.spotify.com/api/token",
    add_headers(
      "Authorization" = paste0("Basic ", RCurl::base64Encode(paste0(client_id, ":", client_secret))),
      "Content-Type" = "application/x-www-form-urlencoded"
    ),
    body = list(code = authorization_code, redirect_uri = redirect_uri, grant_type = 'authorization_code'),
    encode = "form"
  )

  if (response$status_code == 200) {
    return(content(response))
  } else {
    stop(paste0("status code: ", response$status_code, "\n error: ", content(response)$error))
  }
}

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