jQuery ->
  class NbaOnePage.Views.Boxscores extends mixOf NbaOnePage.Views.ModularView, NbaOnePage.Views.GridHighlites
    el: 'section.boxscores'
    events:
      'click nav.section-content li'           : 'clickBoxscoreNav'
      'click tbody tr td': 'clickGrid'

    globalEvents:
      'gameClick': 'gameClick'

    initialize: ->
      @eventNameSpace = "boxscores"

    clickGrid: (event) ->
      $currentTarget = $(event.currentTarget)
      cell = new NbaOnePage.Views.StatGridCell($currentTarget)
      @processClickedCell(cell)
      @highliteGridSelection(cell.columnIndex(), cell.rowIndex(), cell.tableType())

    processClickedCell: (cell) ->
      @triggerGridClick(cell.player(), @gameDate(), cell.stat())

    triggerGridClick: (player, gameDate, stat) ->
      @eventBus.trigger("#{@eventNameSpace}:gridClick", player, gameDate, stat)

    clickBoxscoreLink: (event) ->
      $currentTarget = $(event.currentTarget)
      boxscore_to_display = $currentTarget.data("boxscore")

      $(".boxscore").removeClass("selected")
      $(".#{boxscore_to_display}").addClass("selected")

    gameClick: (event) ->
      $currentTarget = $(event.currentTarget)
      gameDate = $currentTarget.data('time')
      NbaOnePage.router.navigate("boxscores/#{gameDate}", {trigger: true})

    defaultClick: () ->
      @find("table").eq(0).find("tr:nth-child(3) td:nth-child(13)").trigger("click")

    loadBoxscore: (team, gameDate) ->
      url = "#{encodeURIComponent(_.string.trim(team))}/boxscore/#{gameDate}"
      $.get url, (data) =>
        $(".boxscore-content").html(data)
        $(".boxscores .section-header").html($(".boxscore-content .section-header").contents())
        $(".boxscore-content .section-header").remove()
        NbaOnePage.ViewState["boxscores"] = @factory.create(NbaOnePage.Views.Boxscores)

    clickBoxscoreNav: (event) ->
      $(@el).find("nav.section-content li").removeClass("selected")
      $currentTarget = $(event.currentTarget)
      $currentTarget.addClass("selected")

      @clickBoxscoreLink(event)

    updateSection: (gameDate) ->
      if gameDate
        team = $(".team-name").text()
        @loadBoxscore(team, gameDate)
        section = NbaOnePage.ViewState["section_navigation"].navigateTo("boxscores")

    gameDate: () ->
      @find("table").eq(0).data("game-date")

    find: (selector) ->
      $(@el).find(selector)
