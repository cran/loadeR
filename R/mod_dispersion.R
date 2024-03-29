#' dispersion UI Function
#'
#' @param id Internal parameters for shiny.
#'
#' @author Diego Jimenez <diego.jimenez@promidat.com>
#' @return shiny ui module.
#' @export mod_dispersion_ui
#' @import shiny
#' @import shinydashboardPlus
#' 
mod_dispersion_ui <- function(id) {
  ns <- NS(id)
  
  titulo_disp <- tags$div(
    class = "multiple-select-var",
    selectizeInput(
      ns("sel_disp"), NULL, multiple = TRUE, choices = c(""),
      options = list(maxItems = 3))
  )
  
  opc_disp <- tabsOptions(
    tabs.content = list(
      list(options.run(ns("run_disp")), tags$hr(style = "margin-top: 0px;"),
           colourpicker::colourInput(
             ns("col_disp"), labelInput("selcolpoint"), value = "steelblue", 
             allowTransparent = TRUE))
    )
  )
  
  tagList(
    tabBoxPrmdt(
      id = ns("BoxDisp"), opciones = opc_disp, title = titulo_disp,
      tabPanel(
        title = labelInput("disp"), value = "tabDisp",
        echarts4rOutput(ns("plot_disp"), height = "75vh")
      )
    )
  )
}
    
#' dispersion Server Function
#'
#' @param id Internal parameters for shiny.
#' @param updateData shiny reactive values.
#' @param codedioma shiny reactive values.
#'
#' @author Diego Jimenez <diego.jimenez@promidat.com>
#' @return shiny server module.
#' @import shiny
#' @export mod_dispersion_server
#' 
mod_dispersion_server <- function(id, updateData, codedioma) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    # Update on load data
    observeEvent(updateData$datos, {
      datos <- var.numericas(updateData$datos)
      updateSelectInput(session, "sel_disp", choices = colnames(datos))
    })
    
    # Scatter Plot
    output$plot_disp <- renderEcharts4r({
      input$run_disp
      datos <- updateData$datos
      vars  <- input$sel_disp
      color <- isolate(input$col_disp)
      
      if(length(vars) == 2) {
        cod <- code.disp.2d(vars, color)
        isolate(codedioma$code <- append(codedioma$code, cod))
        datos <- data.frame(x = datos[[vars[1]]], y = datos[[vars[2]]],
                            id = row.names(datos))
        
        datos |> e_charts(x) |> e_scatter(y, bind = id, symbol_size = 10) |>
          e_x_axis(x) |> e_y_axis(y) |> e_datazoom(show = FALSE) |>
          e_color(color) |> e_axis_labels(x = vars[1], y = vars[2]) |>
          e_tooltip(formatter = htmlwidgets::JS(paste0(
            "function(params) {
            return('<b>' + params.name + ' </b><br/>", vars[1], 
            ": ' + params.value[0] + '<br />", vars[2], ": ' + params.value[1])
          }"))
          ) |> e_legend(F) |> e_show_loading()
      } else if (length(vars) == 3) {
        cod <- code.disp.3d(vars, color)
        isolate(codedioma$code <- append(codedioma$code, cod))
        datos <- data.frame(
          x = datos[[vars[1]]], y = datos[[vars[2]]],
          z = datos[[vars[3]]], id = row.names(datos)
        )
        
        datos |> e_charts(x) |> e_scatter_3d(y, z, bind = id) |> e_color(color) |>
          e_x_axis_3d(name = vars[1], axisLine = list(lineStyle = list(color = "white"))) |>
          e_y_axis_3d(name = vars[2], axisLine = list(lineStyle = list(color = "white"))) |>
          e_z_axis_3d(name = vars[3], axisLine = list(lineStyle = list(color = "white"))) |>
          e_tooltip(formatter = htmlwidgets::JS(paste0(
            "function(params) {
            return('<b>' + params.name + ' </b><br/>", vars[1], ": ' + params.value[0] + '<br/>", 
            vars[2], ": ' + params.value[1] + '<br/>", vars[3], ": ' + params.value[2])
          }"))
          ) |> e_theme("dark") |> e_show_loading()
      }
    })
  })
}
    
## To be copied in the UI
# mod_dispersion_ui("dispersion_ui_1")
    
## To be copied in the server
# mod_dispersion_server("dispersion_ui_1")

