# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
#

$ ->
  $(".stat-totals tbody td").on 'click', ->
    stat = $(this).attr("data-stat")
    player = $(this).parent().attr("data-player")
    column_index = $(this).index()
    row_index = $(this).parent().index()
    return if column_index is 0
    get_data(player, stat)
    $(".stat-totals td, .stat-totals tr").removeClass("highlited")
    $(".stat-totals td:nth-child(#{column_index + 1})").addClass("highlited")
    $(".stat-totals tr:nth-child(#{row_index + 1})").addClass("highlited")
    $(".legend .player").text(player)
    $(".legend .statistic").text(prepare_stat(stat))

  $(".totals tr:nth-child(9) td:nth-child(12)").trigger("click")

options = {
  colors: {'rgba(18, 50, 180, 1)'}
  shadowSize: 0;
  HtmlText : true,
  points: {
    show: true,
    radius: .2
  },
  lines: {show: true},
  xaxis : {
    mode : 'time',
    labelsAngle : 45
  },
  yaxis : {
    autoscale: true,
    autoscaleMargin : 1
  },
  selection : {
    mode : 'x'
  },
  mouse: {
    track: true,
    lineColor: 'purple',
    relative: true,
    position: 'ne',
    sensibility: 4,
    trackDecimals: 2,
    trackFormatter: (o) ->
      "#{o.series.data[o.index][2]}"
  },
  grid: {
    color: '#aaaaaa',      
    backgroundColor: '#fcfcfc', 
    backgroundImage: null, 
    watermarkAlpha: 0.4,   
    tickColor: '#DDDDDD',  
    labelMargin: 9,        
    verticalLines: true,   
    minorVerticalLines: true, 
    horizontalLines: true, 
    minorHorizontalLines: true, 
    outlineWidth: 2,       
    outline : 'sw',      
    circular: false        
  }
}

get_data = (player = "Derrick Rose", stat = "points", data_index = 0) ->
  window.raw_points = window.raw_points || []
  $.getJSON "rolled_data/#{encodeURIComponent(player)}/#{stat}.json", (data) ->
    window.graph = draw_graph data["rolled_points"], {title: null }# "#{player} #{prepare_stat(stat)}"}
    window.stat = prepare_stat_abbr(stat)
    window.raw_points[data_index] = data["raw_points"]

draw_graph = (data, opts) ->
  container = $(".graph")[0]
  merged_options = Flotr._.extend(Flotr._.clone(options), opts || {})
  Flotr.draw(container, [{data: data, color: 'rgb(28, 28, 157)'}], merged_options)

prepare_stat = (stat) ->
  stat.split("_").join(" ")

prepare_stat_abbr = (stat) ->
  abbrs = {"minutes": "mins", "field_goals_made": "fgm", "field_goals_attempted": "fga", "threes_made": "3s", "threes_attempted": "3sa", "free_throws_made": "ftm", "free_throws_attempted": "fta", "offensive_rebounds": "orebs", "defensive_rebounds": "drebs", "total_rebounds": "trebs", "assists": "asts", "steals": "stls", "blocks": "blks", "turnovers": "tos", "personal_fouls": "pf", "plus_minus": "+/-", "points": "pts"}
  abbrs[stat]
