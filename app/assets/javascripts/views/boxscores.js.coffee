jQuery ->
  class NbaOnePage.Views.Boxscores extends NbaOnePage.Views.ModularView
    el: 'section.boxscores'
    events:
      'click nav.section-content li'           : 'clickBoxscoreNav'

    globalEvents:
      'boxscores:gameClick': 'gameClick'

    initialize: ->

    clickBoxscoreLink: (e) ->
      $currentTarget = $(e.currentTarget)
      boxscore_to_display = $currentTarget.data("boxscore")

      $(".boxscore").removeClass("selected")
      $(".#{boxscore_to_display}").addClass("selected")

    gameClick: (event) ->
      $currentTarget = $(event.currentTarget)
      gameDate = $currentTarget.data('time')
      NbaOnePage.router.navigate("boxscores/#{gameDate}", {trigger: true})

    loadBoxscore: (team, gameDate) ->
      url = "#{encodeURIComponent(team)}/boxscore/#{gameDate}"
      $.get url, (data) ->
        $(".boxscore-content").html(data)
        $(".boxscores .section-header").html($(".boxscore-content .section-header").contents())
        $(".boxscore-content .section-header").remove()
        NbaOnePage.ViewState["boxscores"] = new NbaOnePage.ViewFactory().create(NbaOnePage.Views.Boxscores)

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
