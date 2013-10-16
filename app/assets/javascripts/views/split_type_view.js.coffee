jQuery ->
  class NbaOnePage.Views.SplitTypeView extends NbaOnePage.Views.ModularView
    el: 'span.split-type'
    events:
      'click span.selected-split-type': 'chooseSplitType'
      'click nav li': 'clickSplitType'

    initialize: (options) ->
      @eventNameSpace = options.eventNameSpace || 'stat_totals'
      $(".split-type nav").hide()

    chooseSplitType: () ->
      $("nav").slideDown('slow')

    clickSplitType: (e) ->
      $currentTarget = $(e.currentTarget)
      splitType = $currentTarget.data("split-type")
      @eventBus.trigger("#{@eventNameSpace}:splitTypeClick", splitType)
      $(".split-type nav").hide()
      $(@el).find(".selected-split-type").html(splitType)
