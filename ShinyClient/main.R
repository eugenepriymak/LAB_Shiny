install.packages("shiny")
install.packages("httr")
install.packages("rjson")


source("UI_layout/UI_layout.R")
source("UI_behavior/UI_behavior.R")


shinyApp(ui=ui, server=server)