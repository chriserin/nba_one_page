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
      $.getJSON "/rolled_data/#{encodeURIComponent(player)}/#{stat}/#{@year}.json", (data) =>
        @render_graph(data, stat)
        @setTitle(player, stat)

    setTitle: (player, stat) ->
      stat_without_underscores = stat.replace(/_/g, " ")
      $(@el).find(".graph-specifics .player").text("#{player}")
      $(@el).find(".graph-specifics .stat").text("#{stat_without_underscores}")

    render_graph: (data, stat) ->
      $(@el).find(".graph").empty()
      stat_without_underscores = stat.replace(/_/g, " ")
      Morris.Line
        element: $(@el).find(".graph").get(0)
        data: data
        xkey: 'date'
        ykeys: ['averaged_data']
        ymin: 'auto'
        labels: [stat_without_underscores]
        lineColors: ['#C1261B']
        continuousLine: false
        hoverCallback: (index, options) =>
          game_date = moment(data[index].date).format("MM/DD")
          if(data[index]['averaged_data'])
            title = moment(data[index].start_date).format("MM/DD") + " - " + game_date
          else
            title = "#{game_date} DNP"
          content = "<div class='morris-hover-row-label'>#{title}</div>"
          content += """
            <div class='morris-hover-point' style='color: #C1261B'>
              #{stat_without_underscores}:
              #{data[index]['averaged_data'] || "-"}
            </div>
          """

        dateFormat: (d) -> moment(d).format("MM/DD")
        xLabelFormat: (d) -> moment(d).format("MM/DD")
