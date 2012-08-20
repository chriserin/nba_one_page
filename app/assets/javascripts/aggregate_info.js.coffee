$ ->
  $("body").on 'click', '.graph-info tr, .team-games tr', (event) ->
    url = "boxscore/#{encodeURIComponent($(this).data('team'))}/#{$(this).data('time')}"
    $(".boxscores").load url, ->
      $(".game-score").text($(".game-text").data("game-text"))

  $(".western.standings .conference-link").on 'click', ->
    $(".eastern.standings").css("display", "block")
    $(".western.standings").css("display", "none")
    $(".division-label, .division").removeClass("selected")

    $(".central").addClass("selected")
    $("[data-division=central]").addClass("selected")

  $(".eastern.standings .conference-link").on 'click', ->
    $(".western.standings").css("display", "block")
    $(".eastern.standings").css("display", "none")
    $(".division-label, .division").removeClass("selected")

    $(".division.pacific").addClass("selected")
    $("[data-division=pacific]").addClass("selected")

  $(".record-box.show-games").on 'click', ->
    $(".standings").css("display", "none")
    $(".team-games").css("display", "none")
    $(".team-games.all-games").css("display", "block")
    $(".all-games .scroll-pane").jScrollPane({ autoReinitialise: true, maintainPosition: false})

  $(".record-box.show-away-games").on 'click', ->
    $(".standings").css("display", "none")
    $(".team-games").css("display", "none")
    $(".team-games.away-games").css("display", "block")
    $(".away-games .scroll-pane").jScrollPane({ autoReinitialise: true, maintainPosition: false})

  $(".record-box.show-home-games").on 'click', ->
    $(".standings").css("display", "none")
    $(".team-games").css("display", "none")
    $(".team-games.home-games").css("display", "block")
    $(".home-games .scroll-pane").jScrollPane({ autoReinitialise: true, maintainPosition: false})

  $(".record-box.show-standings").on 'click', ->
    $(".team-games").css("display", "none")
    $(".eastern.standings").css("display", "block")

  $(".division-label").on 'click', ->
    $(".division-label, .division").removeClass("selected")

    division = $(this).attr("data-division")
    $(".#{division}").addClass("selected")
    $(this).addClass("selected")

  $("body").on 'click', ".team-boxscore .boxscore-link", ->
    $(".team-boxscore").css("display", "none")
    $(".opponent-boxscore").css("display", "block")

  $("body").on 'click', ".opponent-boxscore .boxscore-link", ->
    $(".opponent-boxscore").css("display", "none")
    $(".team-boxscore").css("display", "block")

  $(".graph").on 'graph:click', (event, closest_point) ->
    $(".standings, .team-games").css("height", "402px").css("overflow", "hidden")
    $(".scroll-pane").css("height", "376px").css("overflow", "hidden")
    $(".scroll-pane:visible").each ->
      $(this).data('jsp').reinitialise()

    $(".graph-info tbody").empty()
    $(".graph-info-container").css("height", "310px")

    items_count = 0
    not_null_count = 0
    for j in [closest_point.point.dataIndex..0]
      items_count++
      if window.raw_points[0][j][1] != null
        not_null_count++
      if not_null_count == 10
        break

    for datum in window.raw_points[closest_point.point.seriesIndex][closest_point.point.dataIndex + 1 - items_count..closest_point.point.dataIndex]
      if datum[1] != null
        $(".graph-info tbody").prepend($("<tr data-time='#{datum[0]}' data-team='Chicago Bulls'><td>#{moment.utc(datum[0]).format("M/DD")}</td><td>#{datum[2]}</td><td><strong>#{datum[1]}</strong> #{window.stat}</td></tr>"))

    $(".graph-info thead tr th .player").text(window.player)
    $(".graph-info thead tr th .stat").text(window.stat_full)
    $(".graph-info-container tbody").css("display", "table-row-group")

  $(".stat-totals thead span").on 'click', ->
    $(".selected-stat-group-link").removeClass("selected-stat-group-link")
    $(this).addClass("selected-stat-group-link")
    $(".stat-totals tbody").removeClass("selected-stat-group")

  $(".per-36-link").on 'click', -> $(".per-36").addClass("selected-stat-group")
  $(".per-game-link").on 'click', -> $(".per-game").addClass("selected-stat-group")
  $(".totals-link").on 'click', -> $(".totals").addClass("selected-stat-group")
