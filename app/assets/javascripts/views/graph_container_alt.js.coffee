jQuery ->
  class NbaOnePage.Views.GraphContainerAlt extends NbaOnePage.Views.ModularView
    el: 'section.stat-totals .graph-container'

    initialize: (options) ->
      @year = options.year
      @getData()

    getData: (player = "Derrick Rose", stat = "points") ->
      $.getJSON "rolled_data_alt/#{encodeURIComponent(player)}/#{stat}/#{@year}.json", (data) =>
        @render_graph(data, stat)

    render_graph: (data, stat) ->
      Morris.Line
        element: @el
        data: data
        xkey: 'date'
        ykeys: ['averaged_data']
        ymin: 'auto'
        labels: [stat]
        lineColors: ['#C1261B']
        hoverLabelFormat: (d, x) -> moment(d.date).format("MM/DD") + "\n" +  d.description
