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
    NbaOnePage.ViewState["timeline"] = factory.create(NbaOnePage.Views.EventTimelineContainer)
    NbaOnePage.ViewState["games"] = factory.create(NbaOnePage.Views.Games)
    NbaOnePage.ViewState["section_navigation"] = factory.create(NbaOnePage.Views.SectionNavigation)

    NbaOnePage.ViewState["stat_totals"] = factory.create(NbaOnePage.Views.StatTotals)
    NbaOnePage.ViewState["graph_container"] = factory.create(NbaOnePage.Views.GraphContainer, {'year': year})

    NbaOnePage.ViewState["team_totals"] = factory.create(NbaOnePage.Views.StatTotals, { 'el': 'section.team-totals', 'eventNameSpace': 'team_totals'})
    NbaOnePage.ViewState["graph_container_team_totals"] = factory.create(NbaOnePage.Views.GraphContainer, {'year': year, 'el': 'section.team-totals .graph-container', 'eventNameSpace': 'team_totals'})
    NbaOnePage.ViewState["opponent_totals"] = factory.create(NbaOnePage.Views.StatTotals, { 'el': 'section.opponent-totals', 'eventNameSpace': 'opponent_totals'})
    NbaOnePage.ViewState["graph_container_opponent_totals"] = factory.create(NbaOnePage.Views.GraphContainer, {'year': year, 'el': 'section.opponent-totals .graph-container', 'eventNameSpace': 'opponent_totals'})
    NbaOnePage.ViewState["difference_totals"] = factory.create(NbaOnePage.Views.StatTotals, { 'el': 'section.difference-totals', 'eventNameSpace': 'difference_totals'})
    NbaOnePage.ViewState["graph_container_difference_totals"] = factory.create(NbaOnePage.Views.GraphContainer, {'year': year, 'el': 'section.difference-totals .graph-container', 'eventNameSpace': 'difference_totals'})

    NbaOnePage.ViewState["stat_totals"].defaultClick()
    NbaOnePage.ViewState["team_totals"].defaultClick()
    NbaOnePage.ViewState["boxscores"].defaultClick()
    NbaOnePage.ViewState["opponent_totals"].defaultClick()
    NbaOnePage.ViewState["difference_totals"].defaultClick()
    $("li[data-breakdown='hard']").trigger('click')

    $(".standings table").tablesorter()
    $(".team-totals table").tablesorter()
    $(".opponent-totals table").tablesorter()
    $(".difference-totals table").tablesorter()

    if (!Backbone.history.started) {
      Backbone.history.start();
      Backbone.history.started = true;
    }
  }
};
