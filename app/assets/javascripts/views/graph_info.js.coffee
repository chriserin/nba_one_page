jQuery ->
  class NbaOnePage.Views.GraphInfo extends NbaOnePage.Views.ModularView
    el: 'section.graph-info'
    events:
      'click tr': 'gameRowClick'

    globalEvents:
      'graphInfo:displayLastTenGames': 'displayLastTenGames'

    gameRowClick: (event) ->
      @eventBus.trigger('boxscores:load', event)

    displayLastTenGames: (event, closestPoint) ->
      $("section.graph-info").addClass("expanded")
      $("section.games-info").addClass("contracted")
      $(".scroll-pane:visible").each ->
        $(this).data('jsp').reinitialise()
        $(".graph-info tbody").empty()

      itemsCount = @getItemsCount(closestPoint, _.last(NbaOnePage.Data.GraphPoints))

      $infoTable = $(".graph-info tbody")
      for datum in _.last(NbaOnePage.Data.GraphPoints)[closestPoint.point.dataIndex + 1 - itemsCount..closestPoint.point.dataIndex]
        if datum[1] != null
          $infoTable.prepend("<tr data-time='#{datum[0]}' data-team='Chicago Bulls'><td>#{moment.utc(datum[0]).format("M/DD")}</td><td>#{datum[2]}</td><td><strong>#{datum[1]}</strong> #{NbaOnePage.Data.StatisticAbbreviations[NbaOnePage.State.stat]}</td></tr>")

      $(".graph-info thead tr th .player").text(NbaOnePage.State.player)
      $(".graph-info thead tr th .stat").text(NbaOnePage.State.stat)

    getItemsCount: (point, rawPoints) ->
      itemsCount = 0
      notNullCount = 0

      for pointIndex in [point.point.dataIndex..0]
        itemsCount++
        if rawPoints[pointIndex][1] != null
          notNullCount++
        if notNullCount == 10
          break

      return itemsCount
