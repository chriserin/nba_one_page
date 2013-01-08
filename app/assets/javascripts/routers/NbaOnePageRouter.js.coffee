jQuery ->
  class NbaOnePage.Routers.NbaOnePageRouter extends Backbone.Router
    routes:
      "": "index"
      ":section_name": "navigateToSection"
      ":section_name/:arg_a": "navigateToSection"
      ":section_name/:arg_a/:arg_b": "navigateToSection"
      ":section_name/:arg_a/:arg_b/:arg_c": "navigateToSection"
      #"stat_totals/:player/:stat":         "loadTotalsGraph"
      #"stat_totals_former_players/:player/:stat": "loadFormerPlayersGraph"
      #"boxscore/:date/:team": "navigateToBoxscore"

    index: =>

    navigateToSection: (section_name, args...) =>
      NbaOnePage.ViewState["section_navigation"].navigateTo(section_name).updateSection(args...)

    loadTotalsGraph: (player, stat) =>
      @loadGraph("stat_totals", player, stat)
      NbaOnePage.ViewState["section_navigation"].navigateTo("stat-totals")

    loadFormerPlayersGraph: (player, stat) =>
      @loadGraph("stat_totals_former_players", player, stat)
      NbaOnePage.ViewState["section_navigation"].navigateTo("former-players")

    loadGraph: (viewName, player, stat) =>
      NbaOnePage.ViewState[viewName].updateSection(player, stat)

    loadBoxscore: (date, team) =>

    navigateToBoxscore: (date, team) =>
      NbaOnePage.ViewState["section_navigation"].navigateTo("boxscores.#{date}.#{team}")
