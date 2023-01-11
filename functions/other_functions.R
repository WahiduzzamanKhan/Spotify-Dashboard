get_time_string <- function(x) {
  hours <- ifelse (floor(x/3600 + x%%3600) == x,"0", as.character(floor(x/Hours)))
  minutes <- ifelse (floor(x/60 + x%%60) == x,"0", as.character(floor(x/60)))
  seconds <- x%%60

  time_string <- str_glue(str_pad(hours,2,"left","0"),str_pad(minutes,2,"left","0"),str_pad(seconds,2,"left","0"),.sep = ":")

  return(time_string)
}
get_time_string <- Vectorize(get_time_string)
