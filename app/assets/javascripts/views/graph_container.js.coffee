jQuery ->
  class NbaOnePage.Views.GraphContainer extends NbaOnePage.Views.ModularView
    el: 'section.graph-container'
    events:
      'graph:click .graph': 'displayGraphInfo'

    globalEvents:
      'statsGrid:click': 'statsGridClick'

    displayGraphInfo: (event, closestPoint) ->
      @eventBus.trigger('graphInfo:displayLastTenGames', event, closestPoint)

    statsGridClick: (player, stat) ->
      @getData(player, stat)

    getData: (player = "Derrick Rose", stat = "points", data_index = 0) ->
      @current_stat = stat
      $.getJSON "rolled_data/#{encodeURIComponent(player)}/#{stat}.json", (data) =>
        NbaOnePage.Data.GraphPoints.push data["raw_points"]
        @drawGraph data["rolled_points"], {title: "#{player} #{stat.split("_").join(" ")}"}

        $(".graph-info thead tr th .player").text(player)
        $(".graph-info thead tr th .stat").text(stat.split("_").join(" "))


    drawGraph: (data, opts) ->
      container = $(".graph")[0]
      mergedOptions = Flotr._.extend(Flotr._.clone(NbaOnePage.Data.TotalStatGraphOptions), opts || {})
      Flotr.draw(container, [{data: data, color: 'rgb(28, 28, 157)'}], mergedOptions)
