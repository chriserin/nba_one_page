jQuery ->
  class NbaOnePage.Views.Games extends NbaOnePage.Views.ModularView
    el: 'section.games'
    events:
      "click div.games-summary li": "highlightGames"

    initialize: () ->
      $("section.games .scroll-pane").jScrollPane()

    highlightGames: (event) ->
      $currentTarget = $(event.currentTarget)
      breakdown = $currentTarget.data("breakdown")

      $("div.games-summary li").removeClass("selected")
      $currentTarget.addClass("selected")

      $("div.games-wrapper li").removeClass("selected")
      $("div.games-wrapper li.#{breakdown}").addClass("selected")

