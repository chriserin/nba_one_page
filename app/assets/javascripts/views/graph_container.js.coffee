jQuery ->
  class NbaOnePage.Views.GraphContainer extends NbaOnePage.Views.ModularView
    el: 'section.stat-totals .graph-container'

    initialize: (options) ->
      @year = options.year
      @eventNameSpace = options.eventNameSpace || 'stat_totals'

    globalEvents:
      'gridClick': 'statsGridClick'

    statsGridClick: (player, stat) ->
      @getData(player, stat)

    getData: (player = "Derrick Rose", stat = "points") ->
      $.getJSON "rolled_data/#{encodeURIComponent(player)}/#{stat}/#{@year}.json", (data) =>
        @render_graph(data, stat)

    render_graph: (data, stat) ->
      $(@el).empty()
      stat_without_underscores = stat.replace(/_/g, " ")
      Morris.Line
        element: @el
        data: data
        xkey: 'date'
        ykeys: ['averaged_data']
        ymin: 'auto'
        labels: [stat_without_underscores]
        lineColors: ['#C1261B']
        continuousLine: false
        hoverLabelFormat: (label, data) ->
          game_date = moment(data.date).format("MM/DD")
          if(data['averaged_data'])
            moment(data.start_date).format("MM/DD") + " - " + game_date
          else
            "#{game_date} DNP"

        dateFormat: (d) -> moment(d).format("MM/DD")
        xLabelFormat: (d) -> moment(d).format("MM/DD")
