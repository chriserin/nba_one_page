jQuery ->
  class NbaOnePage.Views.StandingsAltView extends NbaOnePage.Views.ModularView
    el: "section.standings"
    events:
      "click nav.section-content li"  : "navConferenceClick"

    navConferenceClick: (event) ->
      $(@el).find("nav.section-content li").removeClass("selected")
      $currentTarget = $(event.currentTarget)
      $currentTarget.addClass("selected")

      $("div.standings").css("display", "none")
      $(".#{$currentTarget.text()}.standings").css("display", "block")
