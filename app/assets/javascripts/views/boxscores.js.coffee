jQuery ->
  class NbaOnePage.Views.Boxscores extends NbaOnePage.Views.ModularView
    el: 'section.boxscores'
    events:
      'click nav.section-content li'           : 'clickBoxscoreNav'

    globalEvents:
      'boxscores:load': 'loadBoxscore'

    initialize: ->
      #$(".team-boxscore").addClass("selected")

    clickBoxscoreLink: (e) ->
      $currentTarget = $(e.currentTarget)
      boxscore_to_display = $currentTarget.data("boxscore")

      $(".boxscore").removeClass("selected")
      $(".#{boxscore_to_display}").addClass("selected")


    loadBoxscore: (event) ->
      $currentTarget = $(event.currentTarget)
      url = "boxscore/#{encodeURIComponent($currentTarget.data('team'))}/#{$currentTarget.data('time')}"
      $(".boxscores").load url, ->
        $(".game-score").text($(".game-text").data("game-text"))

    clickBoxscoreNav: (event) ->

      $(@el).find("nav.section-content li").removeClass("selected")
      $currentTarget = $(event.currentTarget)
      $currentTarget.addClass("selected")

      @clickBoxscoreLink(event)
