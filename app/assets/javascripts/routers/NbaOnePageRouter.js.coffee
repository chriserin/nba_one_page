jQuery ->
  class NbaOnePage.Routers.NbaOnePageRouter extends Backbone.Router
    routes:
      "": "index"
      "stat_totals/:player/:stat":         "loadTotalsGraph"
      "stat_totals_former_players/:player/:stat": "loadFormerPlayersGraph"

    index: =>

    loadTotalsGraph: (player, stat) =>
      @loadGraph("stat_totals", player, stat)
      NbaOnePage.ViewState["section_navigation"].navigateTo("stat-totals")

    loadFormerPlayersGraph: (player, stat) =>
      @loadGraph("stat_totals_former_players", player, stat)
      NbaOnePage.ViewState["section_navigation"].navigateTo("former-players")

    loadGraph: (viewName, player, stat) =>
      NbaOnePage.ViewState[viewName].updateSection(player, stat)
