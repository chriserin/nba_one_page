jQuery ->
  class NbaOnePage.Views.StatTotalsAlt extends NbaOnePage.Views.ModularView
    el: 'section.stat-totals'
    events:
      "click nav.section-content li": 'clickStatCategory'

    clickStatCategory: (event) ->
      $currentTarget = $(event.currentTarget)
      $(@el).find("nav.section-content li").removeClass("selected")
      $currentTarget.addClass("selected")

      type = $currentTarget.data("type")
      $(@el).find("tbody").removeClass("selected")
      $(@el).find("tbody.#{type}").addClass("selected")
