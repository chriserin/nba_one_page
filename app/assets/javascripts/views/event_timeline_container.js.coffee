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
        @addZero(data.plays)
        @plays = data.plays
        timeline = @renderTimeline(data.plays)
        stintsView = @renderStintsView(data.stints)

    addZero: (data) ->
      for datum in data
        datum.zero = 0

    renderStintsView: (stints) ->
      for stint in stints
        @find(".stint-view").append("<div class='stint' style='left: #{@line.transX(stint.start)}px; width: #{@stintWidth(stint)}px;'>#{stint.end - stint.start}</div>")

    stintWidth: (stint) ->
      @line.transX(stint.end) - @line.transX(stint.start)

    renderTimeline: (plays) ->
      return if plays.length is 0
      @find(".event-timeline").empty()

      @line = Morris.Line
        lineType: 'event-timeline'
        element: @find(".event-timeline").get(0)
        data: plays
        numLines: 1
        xkey: 'time'
        ykeys: ['zero']
        ymin: '0'
        ymax: '0'
        labels: ['label']
        lineColors: ['#000066']
        eventLineColors: ['#aaa']
        eventStrokeWidth: 2
        parseTime: false
        lineWidth: 0
        continuousLine: false
        hideHover: 'false'
        hoverCallback: (index) =>
          "#{@toTime(plays[index]['time'])} #{plays[index].description}"
        yLabelFormat: -> ""

    find: (selector) ->
      $(@el).find(selector)

    toTime: (seconds) ->
      quarter = Math.floor(seconds / 720) + 1
      seconds_remaining = quarter * 720 - seconds
      minutes = Math.floor(seconds_remaining / 60)
      seconds_left_over = seconds_remaining - (minutes * 60)
      "Q#{quarter} #{minutes}:#{_.string.sprintf('%02d', seconds_left_over)}"
