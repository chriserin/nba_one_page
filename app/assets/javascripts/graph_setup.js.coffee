# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
#

$ ->
  get_data()

  $(".stat_totals td").on 'click', ->
    stat = $(this).attr("data-stat")
    player = $(this).parent().attr("data-player")
    column_index = $(this).index()
    get_data(player, stat)
    $(".stat_totals td, .stat_totals tr").css("background", "transparent")
    highlite_color = "rgba(0, 0, 255, 0.2)"
    $(".stat_totals td:nth-child(#{column_index + 1})").css("background", highlite_color)
    $(this).parent().css("background", highlite_color)

options = {
  shadowSize: 0;
  HtmlText : true,
  points: {
    show: true,
    radius: 1
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
  }
}

get_data = (player = "Derrick Rose", stat = "points") ->
  $.getJSON "rolled_data/#{encodeURIComponent(player)}/#{stat}.json", (data) ->
    window.graph = draw_graph data["rolled_points"], {title: "#{player} #{prepare_stat(stat)}"}
    window.stat = prepare_stat_abbr(stat)
    window.raw_points = data["raw_points"]

draw_graph = (data, opts) ->
  container = $(".graph")[0]
  merged_options = Flotr._.extend(Flotr._.clone(options), opts || {})
  Flotr.draw(container, [data], merged_options)

prepare_stat = (stat) ->
  stat.split("_").join(" ")

prepare_stat_abbr = (stat) ->
  abbrs = {"minutes": "mins", "field_goals_made": "fgm", "field_goals_attempted": "fga", "threes_made": "3s", "threes_attempted": "3sa", "free_throws_made": "ftm", "free_throws_attempted": "fta", "offensive_rebounds": "orebs", "defensive_rebounds": "drebs", "total_rebounds": "trebs", "assists": "asts", "steals": "stls", "blocks": "blks", "turnovers": "tos", "personal_fouls": "pf", "plus_minus": "+/-", "points": "pts"}
  abbrs[stat]
