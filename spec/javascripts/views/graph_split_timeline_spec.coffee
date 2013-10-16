describe 'NbaOnePage.Views.GraphSplitTimeline', ->
  describe 'split report', ->
    it 'should render', ->
      data = [{'component_values': {'points': 10}, 'date': 'dx'}, {'component_values': {'points': 20}, 'date': 'dy'}]
      split = new NbaOnePage.Models.RolledDataSplit(data, 0, 1)

      expect(JST['templates/split_report']({'split': split})).not.toBeNull()

  describe 'init', ->
    morrisGraph = {}
    beforeEach ->
      rawData = [
        {'component_values': {'points': 10}, 'date': '2012-01-01', 'formula': 'rolling_average'},
        {'component_values': {'points': 10}, 'date': '2012-01-02'},
        {'component_values': {'points': 10}, 'date': '2012-01-03'},
        {'component_values': {'points': 10}, 'date': '2012-01-04'},
        {'component_values': {'points': 20}, 'date': '2012-01-05'}]
      morrisGraph = {data: [{_x: 5}, {_x: 10}, {_x: 15}, {_x: 20}, {_x: 30}], options: {data: rawData}}
      $("body").empty()

    it 'should init', ->
      $("<section class='test'><div class='graph-split-timeline'></div></section>").appendTo("body")
      timeline = new NbaOnePage.ViewFactory().create(
        NbaOnePage.Views.GraphSplitTimeline, {'el': "section.test .graph-split-timeline", 'eventNameSpace': 'test', 'morrisGraph': morrisGraph}
      )
      expect(timeline).not.toBeNull()

    it 'should provide two timeline indicators', ->
      $("<section class='test'><div class='graph-split-timeline'></div></section>").appendTo("body")
      timeline = new NbaOnePage.ViewFactory().create(
        NbaOnePage.Views.GraphSplitTimeline, {'el': "section.test .graph-split-timeline", 'eventNameSpace': 'test', 'morrisGraph': morrisGraph}
      )
      expect(timeline).not.toBeNull()
      expect($("section.test .timeline-location")).toHaveLength(2)

    it 'should set the indicators at thirds', ->
      $("<section class='test'><div class='graph-split-timeline'></div></section>").appendTo("body")
      timeline = new NbaOnePage.ViewFactory().create(
        NbaOnePage.Views.GraphSplitTimeline, {'el': "section.test .graph-split-timeline", 'eventNameSpace': 'test', 'morrisGraph': morrisGraph}
      )

      expect($(".timeline-location").slice(0,1)).toHaveCss({left: '10px'})
      expect($(".timeline-location").slice(1,2)).toHaveCss({left: '20px'})

    it 'should create report for each split', ->
      $("<section class='test'><div class='graph-split-timeline'></div><div class='graph-split-report'></div></section>").appendTo("body")

      timeline = new NbaOnePage.ViewFactory().create(
        NbaOnePage.Views.GraphSplitTimeline, {'el': "section.test .graph-split-timeline", 'eventNameSpace': 'test', 'morrisGraph': morrisGraph}
      )

      expect($(".graph-split-report")).toHaveLength(1)
      expect($(".split-report")).toHaveLength(3)
