jQuery ->
  class NbaOnePage.Views.GraphContainer extends NbaOnePage.Views.ModularView
    el: 'section.stat-totals .graph-container'

    initialize: (options) ->
      @year = options.year
      @eventNameSpace = options.eventNameSpace || 'stat_totals'

    globalEvents:
      'gridClick': 'statsGridClick'

    statsGridClick: (player, stat, team) ->
      @getData(player, stat, team)

    getData: (player = "Derrick Rose", stat = "points", team) ->
      $.getJSON "/rolled_data/#{encodeURIComponent(player)}/#{stat}/#{@year}.json?team=#{team}", (data) =>
        morrisGraph = @render_graph(data, stat)
        @setTitle(player, stat)
        @createSplitTimeline(morrisGraph)

    createSplitTimeline: (morrisGraph) ->
      $(@el).find(".graph-split-timeline").empty()
      @timeline = new NbaOnePage.ViewFactory().create(NbaOnePage.Views.GraphSplitTimeline, {'el': "section." + $(this.el).parents("section").attr('class') + " .graph-split-timeline", 'eventNameSpace': $(this.el).parents("section").attr('class'), 'morrisGraph': morrisGraph})

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
        hideHover: 'auto'
        yLabelFormat: (y) -> Math.round(y * 10) / 10
        hoverCallback: (index, options) =>
          game_date = moment(data[index].date).format("MM/DD")
          if(data[index]['averaged_data'])
            title = "#{moment(data[index].start_date).format("MM/DD")} - #{game_date}"
          else
            title = "#{game_date} DNP"
          content = "<div class='morris-hover-row-label'>#{title}</div>"
          content += "<ul class='morris-hover-games-list'>"
          for data_index in [index..(Math.max(0, index-10))]
            content += """
            <li>#{data[data_index]['description']}</li>
          """
          content += "</ul>"
          content += """
            <div class='morris-hover-point' style='color: #C1261B'>
              #{stat_without_underscores}:
              #{data[index]['averaged_data'] || "-"}
            </div>
          """

        dateFormat: (d) -> moment(d).format("MM/DD")
        xLabelFormat: (d) -> moment(d).format("MM/DD")
