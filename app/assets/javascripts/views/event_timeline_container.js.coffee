jQuery ->
  class Morris.Line extends Morris.Line
    postInit: -> 
      if @options.lineType == 'event-timeline'
        for datum in @data
          datum.x = datum.label
          datum.label = ""
        @xmin = 0 #@data[0].x
        @xmax = 2880 #@data[@data.length - 1].x
        @dirty = true
        @events = [0, 720, 1440, 2160, 2880]
        eventLabels = ['1st', '2nd', '3rd', '4th', 'end']
        @redraw()
        ypos = @bottom + @options.padding / 2
        for event, eventIndex in @events
          @drawXAxisLabel(@transX(event), ypos, eventLabels[eventIndex])

  class NbaOnePage.Views.EventTimelineContainer extends NbaOnePage.Views.ModularView
    el: 'section.boxscores .event-timeline-container'

    initialize: (options) ->
      @eventNameSpace = "boxscores"

    globalEvents:
      'gridClick': 'boxscoreGridClick'

    boxscoreGridClick: (player, gameDate, stat) ->
      @getData(player, gameDate, stat)

    getData: (player, gameDate, stat) ->
      $.getJSON "/playbyplay/#{gameDate}/#{encodeURIComponent(player)}/#{stat}.json", (data) =>
        @addZero(data)
        timeline = @renderTimeline(data)

    addZero: (data) ->
      for datum in data
        datum.zero = 0

    renderTimeline: (data) ->
      return if data.length is 0
      @find(".event-timeline").empty()

      Morris.Line
        lineType: 'event-timeline'
        element: @find(".event-timeline").get(0)
        data: data.reverse()
        numLines: 1
        xkey: 'time'
        ykeys: ['zero']
        ymin: '0'
        ymax: '0'
        labels: ['label']
        lineColors: ['#000066']
        parseTime: false
        lineWidth: 0
        continuousLine: false
        hideHover: 'false'
        hoverCallback: (index) =>
          data[index].description
        yLabelFormat: -> ""

    find: (selector) ->
      $(@el).find(selector)
