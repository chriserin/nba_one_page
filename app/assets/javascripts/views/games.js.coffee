jQuery ->
  class NbaOnePage.Views.Games extends NbaOnePage.Views.ModularView
    el: 'section.games'

    initialize: () ->
      $("section.games .scroll-pane").jScrollPane()
