jQuery ->
  class NbaOnePage.Views.StandingsView extends NbaOnePage.Views.ModularView
    el: "section.games-info"
    events:
      "click .conference-link": "conferenceClick"
      "click .division-label": "divisionClick"
      "click tr": "gameRowClick"
      "click nav.section-content li"  : "navConferenceClick"

    gameRowClick: (event) ->
      @eventBus.trigger('boxscores:load', event)

    conferenceClick: (e) ->
      $currentTarget = $(e.currentTarget)
      division = $currentTarget.data("division")

      $(".standings").css("display", "none")
      $(".#{$currentTarget.text()}.standings").css("display", "block")
      @selectDivision(division)

    divisionClick: (e) ->
      $currentTarget = $(e.currentTarget)
      @selectDivision($currentTarget.data("division"))

    selectDivision: (division) ->
      $(".division-label, .division").removeClass("selected")
      $(".division-label[data-division=#{division}]").addClass("selected")
      $(".#{division}").addClass("selected")

    navConferenceClick: (event) ->
      $(@el).find("nav.section-content li").removeClass("selected")
      $currentTarget = $(event.currentTarget)
      $currentTarget.addClass("selected")

      $(".standings").css("display", "none")
      $(".#{$currentTarget.text()}.standings").css("display", "block")
      @selectDivision(division)
