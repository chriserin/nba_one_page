jQuery ->
  class NbaOnePage.Views.GraphSplitTimeline extends NbaOnePage.Views.ModularView
    el: 'section.stat-totals .graph-split-timeline'

    initialize: (options) ->
      @year = options.year
      @eventNameSpace = options.eventNameSpace || 'stat_totals'
      @graph = options.morrisGraph

      for datum, index in @graph.data
        $(@el).append("<div class=anchor data-index=#{index}></div>")
        $(@el).find("[data-index=#{index}]").css('left', "#{datum._x}px")
        $( ".timeline-location" ).draggable({ snap: ".anchor", snapMode: "outer", axis: "x" })
        $( ".timeline-location" ).draggable(stop: (e) ->
          report_splits($(e.toElement).data("index"))
        )

    report_splits: (splitIndex) ->
      componentsTotal = null
      for datum, index in @graph.data when index < splitIndex
        if componentsTotal?
          componentsTotal = @totalHash(componentsTotal, datum["component_values"])
        else
          componentsTotal = componentsTotal || datum["component_values"]

      $(".graph-split-report").append(@calculate(componentsTotal))

      componentsTotal = null
      for datum, index in @graph.data when index >= splitIndex
        if componentsTotal?
          componentsTotal = @totalHash(componentsTotal, datum["component_values"])
        else
          componentsTotal = componentsTotal || datum["component_values"]

      $(".graph-split-report").append(@calculate(componentsTotal))

    calculate: (total) ->
      #if total.
      

    totalHash: (hashA, hashB) ->
      result = {}
      for componentKey, componentValue of hashA
        result[componentKey] = componentValue + hashB[componentKey]
      return result
