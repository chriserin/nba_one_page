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
      leftSplit = indexes[0]
      rightSplit = indexes[1]
      indexRanges = []
      indexRanges.push([0, leftSplit - 1]) if leftSplit isnt 0
      indexRanges.push([leftSplit, rightSplit]) if leftSplit isnt 0
      indexRanges.push([0, rightSplit]) if leftSplit is 0
      indexRanges.push([rightSplit + 1, length - 1])
      return indexRanges#_.filter(indexRanges, (r) -> r[0] isnt r[1])

    timelineIndexes: ->
      indexes = []
      currentIndex = 0
      sortedLocations = $(@el).find(".timeline-location").sort (l, r) -> l.offsetLeft > r.offsetLeft ? 1 : -1
      [@getAnchorIndex(sortedLocations[0].offsetLeft, false), @getAnchorIndex(sortedLocations[1].offsetLeft, true)]

    getAnchorIndex: (offset, leftSide = true) ->
      currentIndex = 0
      for left, anchorIndex in _.keys(@anchorsMap)
        if leftSide and left <= offset
          currentIndex = anchorIndex
        else if !leftSide and left >= offset
          return anchorIndex
      return currentIndex

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
