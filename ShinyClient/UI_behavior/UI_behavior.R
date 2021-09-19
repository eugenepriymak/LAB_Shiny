library("shiny")
source("DB_interaction/DB_interaction.R")


actualize_cargo_selection = function(current_selection) {
  actual_names = get_cargo_names_from_db()
  actualized_selection = c()
  for (name in current_selection) {
    if (name %in% actual_names) {
      actualized_selection = c(actualized_selection, name)
    }
  }
  return(actualized_selection)
}


calc_amount_func = function(cargo_name, days) {
  day_from = days[1]
  day_to = days[length(days)]
  found_amounts_and_days = get_amounts_and_days_from_db(cargo_name, day_from, day_to)
  
  if ((length(found_amounts_and_days) == 1) && is.na(found_amounts_and_days)) {
    return(NA)
  }
  
  found_amounts = found_amounts_and_days[[1]]
  found_days = found_amounts_and_days[[2]]
  
  amount_func = vector(mode="numeric", length(days))
  ind_in_found = 1
  while (ind_in_found <= length(found_amounts)) {
    found_day = found_days[ind_in_found]
    found_amount = found_amounts[ind_in_found]
    ind_in_days = match(found_day, days)
    amount_func[ind_in_days] = amount_func[ind_in_days] + found_amount
    ind_in_found = ind_in_found + 1
  }
  return(amount_func)
}


calc_amount_funcs = function(cargo_names, days) {
  amount_funcs = list()
  ind = 1
  while (ind <= length(cargo_names)) {
    amount_func = calc_amount_func(cargo_names[ind], days)
    
    if ((length(amount_func) == 1) && (is.na(amount_func))) {
      return(NA)
    }
    
    amount_funcs[[ind]] = calc_amount_func(cargo_names[ind], days)
    ind = ind + 1
  }
  return(amount_funcs)
}


server = function(input, output, session) {
  actualize_cargo_when_input_changed = reactive({
    return(actualize_cargo_selection(input$id_cargo))
    })
  
  
  actualize_cargo_when_draw_button_clicked = eventReactive(input$id_draw, {
    return(actualize_cargo_selection(input$id_cargo))
    })
  
  
  get_day_from_when_draw_button_clicked = eventReactive(input$id_draw, {
    return(input$id_day_from)
    })
  
  
  get_day_to_when_draw_button_clicked = eventReactive(input$id_draw, {
    return(input$id_day_to)
    })
  
  
  get_cargo_when_draw_button_clicked = eventReactive(input$id_draw, {
    return(input$id_cargo_names)
    })
  
  
  output$id_cargo = renderUI({
    selected = actualize_cargo_when_input_changed()
    return(selectInput(inputId="id_cargo",
                       label="Select names of cargo",
                       choices=get_cargo_names_from_db(),
                       selected=selected,
                       multiple=TRUE))
    })
  
  
  output$id_graph = renderPlot({
    cargo_names = actualize_cargo_when_draw_button_clicked()
    day_from = get_day_from_when_draw_button_clicked()
    day_to = get_day_to_when_draw_button_clicked()
    if ((length(cargo_names) == 0) || (day_from > day_to)) {
      return(textOutput("Graph will be here"))
    }
    
    days = seq(day_from, day_to, by=1)
    amount_funcs = calc_amount_funcs(cargo_names, days)
    
    if ((length(amount_funcs) == 1) && (is.na(amount_funcs))) {
      return(textOutput("Graph will be here"))
    }
    
    ind = 1
    plot(days, amount_funcs[[ind]],
         type="l", lwd=3,
         xlab="Days", ylab="Amount")
    ind = ind + 1
    while (ind <= length(amount_funcs)) {
      lines(days, amount_funcs[[ind]],
            type="l", lwd=3)
      ind = ind + 1
    }
    legend("topleft", legend=cargo_names)
    })
}