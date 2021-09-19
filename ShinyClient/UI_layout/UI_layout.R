library("shiny")


DEFAULT_DAY_FROM_VAL = 1
DEFAULT_DAY_TO_VAL = 1


ui = fluidPage(
  sidebarLayout(
    sidebarPanel(
      uiOutput(outputId="id_cargo"),
      numericInput(inputId="id_day_from",
                   label="From day:",
                   value=DEFAULT_DAY_FROM_VAL),
      numericInput(inputId="id_day_to",
                   label="To day:",
                   value=DEFAULT_DAY_TO_VAL),
      actionButton(inputId="id_draw", label="Draw")
    ),
    mainPanel(
      plotOutput(outputId="id_graph")
    )
  )
)