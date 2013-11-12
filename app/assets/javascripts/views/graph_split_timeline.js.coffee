jQuery ->
  class NbaOnePage.Views.GraphSplitTimeline extends NbaOnePage.Views.ModularView
    el: 'section.stat-totals .graph-split-timeline'

    initialize: (options) ->
      @initIndicators()
      @year = options.year
      @eventNameSpace = options.eventNameSpace || 'stat_totals'
      @graph = options.morrisGraph
      @anchorsMap = {}
      for datum, index in @graph.data
        $(@el).append("<div class=anchor data-index=#{index}></div>")
        anchor = $(@el).find("[data-index=#{index}]").css('left', "#{Math.round(datum._x)}px")
        @anchorsMap[Math.round(datum._x)] = anchor

      $(@el).find( ".timeline-location" ).draggable({ snap: ".anchor", snapTolerance: 8, snapMode: "outer", axis: "x" })
      $(@el).find( ".timeline-location" ).draggable(drag: =>
        @setHighlightPosition()
        @determineReport()
      )

      $(@el).find( ".timeline-highlight").draggable({ snap: ".anchor", snapTolerance: 8, snapMode: "outer", axis: "x" })
      $(@el).find( ".timeline-highlight" ).draggable(drag: =>
        @moveTimelineLocations()
        @determineReport()
      )

      @setIndicatorPositions()
      @setHighlightPosition()
      @determineReport()

    moveTimelineLocations: ->
      anchorKeys = _.keys(@anchorsMap)
      leftA = parseInt($(@el).find(".timeline-highlight").css('left').replace("px", ""))
      leftB = leftA + parseInt($(@el).find(".timeline-highlight").css('width').replace("px", ""))
      $(@el).find(".timeline-location").slice(0,1).css(left: "#{leftA}px")
      $(@el).find(".timeline-location").slice(1,2).css(left: "#{leftB}px")

    determineReport: ->

      indexes = @timelineIndexes()
      console.log(indexes)
      indexRanges = @timelineIndexRanges(indexes, _.keys(@anchorsMap).length)
      @reportSplits(indexRanges) if indexes.length == 2

    timelineIndexRanges: (indexes, length) ->
      indexRanges = []
      indexRanges.push([0, indexes[0]]) if indexes[0] isnt 0
      indexRanges.push([indexes[0] + 1, indexes[1]]) if indexes[0] isnt 0
      indexRanges.push([0, indexes[1]]) if indexes[0] is 0
      indexRanges.push([indexes[1] + 1, length - 1])
      return _.filter(indexRanges, (r) -> r[0] isnt r[1])

    timelineIndexes: ->
      indexes = []
      currentIndex = 0
      $(@el).find(".timeline-location").each (locationIndex, location) =>
        console.log("LOCATION: #{location.offsetLeft}")
        for left, anchorIndex in _.keys(@anchorsMap)
          if left <= location.offsetLeft
            currentIndex = anchorIndex
          else
            indexes.push currentIndex
            break
      indexes.sort()

    setHighlightPosition: ->
      leftA = $(@el).find(".timeline-location").slice(0,1).css('left').replace("px", "")
      leftB = $(@el).find(".timeline-location").slice(1,2).css('left').replace("px", "")
      $(@el).find(".timeline-highlight").css({left: "#{leftA}px", width: "#{leftB - leftA}px"})

    initIndicators: ->
      $(@el).append(JST["templates/timeline_indicator"]) for i in [0..1]
      $(@el).find(".timeline-location").slice(1,2).css('margin-top': "-20px")
      $(@el).append("<span class='timeline-highlight'></span")

    setIndicatorPositions: ->
      anchorKeys = _.keys(@anchorsMap)
      locationA = $(@el).find(".timeline-location").slice(0,1)
      leftA = anchorKeys[Math.round((anchorKeys.length / 3) * 1) - 1]
      leftB = anchorKeys[(Math.round(anchorKeys.length / 3) * 2) - 1]
      locationA.css(left: "#{leftA}px")
      $(@el).find(".timeline-location").slice(1,2).css(left: "#{leftB}px")

    reportSplits: (indexRanges) =>
      highlitedRange = indexRanges[1] || indexRanges[0]
      $($(@el).parent()).find(".graph-split-report").empty()
      for range in indexRanges
        $($(@el).parent()).find(".graph-split-report").append(@calculate(range[0], range[1]))
      $($(@el).parent()).find(".split-report.i#{highlitedRange[0]}").css('background',  'rgba(27, 182, 193, 0.3)')

    calculate: (start, end) ->
      console.log("START: #{start} END: #{end}")
      split = new NbaOnePage.Models.RolledDataSplit(@graph.options.data, start, end)
      JST['templates/split_report']({'split': split})
