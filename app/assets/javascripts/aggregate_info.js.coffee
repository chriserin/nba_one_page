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

  $(".team-boxscore .boxscore-link").on 'click', ->
    $(".team-boxscore").css("display", "none")
    $(".opponent-boxscore").css("display", "block")

  $(".opponent-boxscore .boxscore-link").on 'click', ->
    $(".opponent-boxscore").css("display", "none")
    $(".team-boxscore").css("display", "block")

  $(".graph").on 'graph:click', (event, index) ->
    $(".standings, .team-games").css("height", "402px").css("overflow", "hidden")
    $(".scroll-pane").css("height", "376px").css("overflow", "hidden")
    $(".scroll-pane:visible").each ->
      $(this).data('jsp').reinitialise()

    $(".graph-info thead, .graph-info tbody").empty()
    $(".graph-info thead").append("<tr><th colspan='3'>#{$(".flotr-titles .flotr-title").text()} 10 games prior to #{moment.utc(window.raw_points[index][0]).format("M/DD")}</th></tr>")

    items_count = 0
    not_null_count = 0
    for j in [index..0]
      items_count++
      if window.raw_points[j][1] != null
        not_null_count++
      if not_null_count == 10
        break

    for datum in window.raw_points[index + 1 - items_count..index]
      if datum[1] != null
        $(".graph-info tbody").prepend($("<tr data-time='#{datum[0]}' data-team='Chicago Bulls'><td>#{moment.utc(datum[0]).format("M/DD")}</td><td>#{datum[2]}</td><td><strong>#{datum[1]}</strong> #{window.stat}</td></tr>"))

    $(".graph-info-container").css("display", "block")

