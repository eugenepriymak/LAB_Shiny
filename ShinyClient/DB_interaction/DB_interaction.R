library("httr")
library("rjson")


HOST = "http://127.0.0.1:8000/"


get_data_from_db = function(url) {
  # TODO: process case when server isn't run. Return list()
  resp = httr::GET(url)
  if (httr::http_type(resp) != "application/json") {
    return(NA)
  }
  resp_content_in_text = httr::content(resp, "text")
  resp_content = rjson::fromJSON(json_str=resp_content_in_text)
  return(resp_content)
}


get_cargo_names_from_db = function() {
  url = paste0(HOST, "get_names/")
  response = get_data_from_db(url)
  names = c()
  ind = 1
  while (ind <= length(response)) {
    names = append(names, response[[ind]]$name)
    ind = ind + 1
  }
  return(names)
}


get_amounts_and_days_from_db = function(cargo_name, day_from, day_to) {
  cargo_name_encoded = URLencode(cargo_name, reserved=TRUE)
  day_from_encoded = URLencode(as.character(day_from))
  day_to_encoded = URLencode(as.character(day_to))
  url = paste0(HOST, "get_amounts_and_days/",
    cargo_name_encoded, "/",
    day_from_encoded, "/",
    day_to_encoded, "/")
  response = get_data_from_db(url)

  if ((length(response) == 1) && is.na(response)) {
    return(NA)
  }
  
  amounts = c()
  days = c()
  ind = 1
  while (ind <= length(response)) {
    amounts = c(amounts, response[[ind]]$amount)
    days = c(days, response[[ind]]$day)
    ind = ind + 1
  }
  return(list(amounts, days))
}