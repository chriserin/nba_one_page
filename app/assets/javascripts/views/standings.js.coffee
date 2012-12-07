jQuery ->
  class NbaOnePage.Views.StandingsView extends NbaOnePage.Views.ModularView
    el: "section.standings"
    events:
      "click nav.section-content li"  : "navConferenceClick"

    initialize: ->

    navConferenceClick: (event) ->
      $(@el).find("nav.section-content li").removeClass("selected")
      $currentTarget = $(event.currentTarget)
      $currentTarget.addClass("selected")

      $("div.standings").removeClass("selected")
      $(".#{$currentTarget.text()}.standings").addClass("selected")
