window.NbaOnePage = {
  Models: {},
  Collections: {},
  Views: {},
  Routers: {},
  ViewState: {},
  Data: {GraphPoints: []},
  State: {},
  initialize: function(year) {
    NbaOnePage.router = new NbaOnePage.Routers.NbaOnePageRouter();

    var factory = new NbaOnePage.ViewFactory()
    NbaOnePage.ViewState["standings"] = factory.create(NbaOnePage.Views.StandingsView)
    NbaOnePage.ViewState["boxscores"] = factory.create(NbaOnePage.Views.Boxscores)
    NbaOnePage.ViewState["boxscores_summary"] = factory.create(NbaOnePage.Views.BoxscoreSummary)
    NbaOnePage.ViewState["games"] = factory.create(NbaOnePage.Views.Games)
    NbaOnePage.ViewState["section_navigation"] = factory.create(NbaOnePage.Views.SectionNavigation)

    NbaOnePage.ViewState["stat_totals"] = factory.create(NbaOnePage.Views.StatTotals)
    NbaOnePage.ViewState["graph_container"] = factory.create(NbaOnePage.Views.GraphContainer, {'year': year})
    NbaOnePage.ViewState["stat_totals_former_players"] = factory.create(NbaOnePage.Views.StatTotals, { 'el': 'section.former-players', 'eventNameSpace': 'stat_totals_former_players'})
    NbaOnePage.ViewState["graph_container_former_players"] = factory.create(NbaOnePage.Views.GraphContainer, {'year': year, 'el': 'section.former-players .graph-container', 'eventNameSpace': 'stat_totals_former_players'})

    NbaOnePage.ViewState["stat_totals_former_players"].defaultClick()
    NbaOnePage.ViewState["stat_totals"].defaultClick()

    //$(".stat-totals table").tablesorter()
    $(".former-players table").tablesorter()
    $(".standings table").tablesorter()


    if (!Backbone.history.started) {
      Backbone.history.start();
      Backbone.history.started = true;
    }
  }
};
