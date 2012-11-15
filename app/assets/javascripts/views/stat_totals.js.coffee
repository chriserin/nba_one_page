jQuery ->
  class NbaOnePage.Views.StatTotals extends NbaOnePage.Views.ModularView
    el: 'section.stat-totals'
    events:
      "click .totals tr td": 'statsGridClick'
      "click .stat-totals thead span": "selectStatLink"
      "click .per-36-link": "selectPer36Link"
      "click .per-game-link": "selectPerGamesLink"
      "click .totals-link": "selectTotalsLink"

    statsGridClick: (e) ->
      $currentTarget = $(e.currentTarget)
      columnIndex = $currentTarget.index()
      rowIndex = $currentTarget.parent().index()
      return if columnIndex is 0

      NbaOnePage.State.stat = stat = $currentTarget.attr("data-stat")
      NbaOnePage.State.player = player = $currentTarget.parent().attr("data-player")
      @eventBus.trigger("statsGrid:click", player, stat)

      @highliteGridSelection(columnIndex, rowIndex)

    highliteGridSelection: (column, row) ->
      $(".stat-totals td, .stat-totals tr").removeClass("highlited")
      $(".stat-totals tbody td:nth-child(#{column + 1})").addClass("highlited")
      $(".stat-totals tbody tr:nth-child(#{row + 1})").addClass("highlited")

    selectStatLink: (event)->
      $(".selected-stat-group-link").removeClass("selected-stat-group-link")
      $(event.currentTarget).addClass("selected-stat-group-link")
      $(".stat-totals tbody").removeClass("selected-stat-group")

    selectTotalsLink: ->
      @selectStatGroup(".totals")
    selectPerGamesLink: ->
      @selectStatGroup(".per-game")
    selectPer36Link: ->
      @selectStatGroup(".per-36")

    selectStatGroup: (statClass) ->
      $(statClass).addClass("selected-stat-group")
