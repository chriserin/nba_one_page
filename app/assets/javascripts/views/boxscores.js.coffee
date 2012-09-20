jQuery ->
  class NbaOnePage.Views.Boxscores extends NbaOnePage.Views.ModularView
    el: 'section.boxscores'
    events:
      'click .boxscore-link': 'clickBoxscoreLink'

    globalEvents:
      'boxscores:load': 'loadBoxscore'

    clickBoxscoreLink: (e) ->
      $team_boxscore = $(".team-boxscore")
      $opponent_boxscore = $(".opponent-boxscore")
      teamBoxscoreDisplay = $team_boxscore.css("display")

      $team_boxscore.css("display", @reverse(teamBoxscoreDisplay))
      $opponent_boxscore.css("display", teamBoxscoreDisplay)

    reverse: (displayValue) ->
      if displayValue is 'block' then 'none' else 'block'

    loadBoxscore: (event) ->
      $currentTarget = $(event.currentTarget)
      url = "boxscore/#{encodeURIComponent($currentTarget.data('team'))}/#{$currentTarget.data('time')}"
      $(".boxscores").load url, ->
        $(".game-score").text($(".game-text").data("game-text"))
