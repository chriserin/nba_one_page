jQuery ->
  class NbaOnePage.Views.Header extends NbaOnePage.Views.ModularView
    el: 'header'

    events:
      'click .show-games': 'showGames'
      'click .show-away-games': 'showAwayGames'
      'click .show-home-games': 'showHomeGames'
      'click .show-standings': 'showStandings'

    showGames: ->
      @displayGamesInfo('all-games')

    showAwayGames: ->
      @displayGamesInfo('away-games')

    showHomeGames: ->
      @displayGamesInfo('home-games')

    showStandings: ->
      @displayGamesInfo('eastern.standings')

    displayGamesInfo: (gamesInfoClass) ->
      $(".standings, .team-games").css("display", "none")
      $(".#{gamesInfoClass}").css("display", "block")
      $(".#{gamesInfoClass} .scroll-pane").jScrollPane({ autoReinitialise: true, maintainPosition: false})
