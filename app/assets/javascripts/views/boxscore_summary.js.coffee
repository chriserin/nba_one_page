jQuery ->
  class NbaOnePage.Views.BoxscoreSummary extends NbaOnePage.Views.ModularView
    el: 'section.boxscores-summary'
    events:
      'click .boxscore-summary' : 'clickBoxscoreSummary'

    initialize: ->
      $(".team-boxscore").addClass("selected")

    clickBoxscoreSummary: (e) ->
      $currentTarget = $(e.currentTarget)
      boxscoreDate = $currentTarget.data("game-date")
      boxscoreTeam = $currentTarget.data("team")

      NbaOnePage.router.navigate(["boxscore", boxscoreDate, boxscoreTeam].join("/"), {trigger: true})
