jQuery ->
  class NbaOnePage.Views.GraphSplitTimeline extends NbaOnePage.Views.ModularView
    el: 'section.stat-totals .graph-split-timeline'

    initialize: (options) ->
      @year = options.year
      @eventNameSpace = options.eventNameSpace || 'stat_totals'
      @graph = options.morrisGraph

      @el.append("div.anchor")
