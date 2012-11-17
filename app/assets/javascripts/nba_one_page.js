window.NbaOnePage = {
  Models: {},
  Collections: {},
  Views: {},
  Routers: {},
  ViewState: {},
  Data: {GraphPoints: []},
  State: {},
  initialize: function(year) {
    new NbaOnePage.Routers.NbaOnePageRouter({ collection: this.tasks, users: this.users });

    if (!Backbone.history.started) {
      Backbone.history.start();
      Backbone.history.started = true;
    }

    var factory = new NbaOnePage.ViewFactory()
    NbaOnePage.ViewState["standings"] = factory.create(NbaOnePage.Views.StandingsView)
    NbaOnePage.ViewState["standings_alt"] = factory.create(NbaOnePage.Views.StandingsAltView)
    NbaOnePage.ViewState["header"] = factory.create(NbaOnePage.Views.Header)
    NbaOnePage.ViewState["boxscores"] = factory.create(NbaOnePage.Views.Boxscores)
    NbaOnePage.ViewState["graph"] = factory.create(NbaOnePage.Views.GraphContainer)
    NbaOnePage.ViewState["stat_totals"] = factory.create(NbaOnePage.Views.StatTotals)
    NbaOnePage.ViewState["stat_totals_former_players"] = factory.create(NbaOnePage.Views.StatTotals, { 'el': 'section.former-players', 'eventNameSpace': 'formerPlayersGrid'})
    NbaOnePage.ViewState["stat_totals_alt"] = factory.create(NbaOnePage.Views.StatTotalsAlt)
    NbaOnePage.ViewState["stat_totals_alt_former_players"] = factory.create(NbaOnePage.Views.StatTotalsAlt, {'el': 'section.former-players', 'eventNameSpace': 'formerPlayersGrid'})
    NbaOnePage.ViewState["graph_info"] = factory.create(NbaOnePage.Views.GraphInfo)
    NbaOnePage.ViewState["games"] = factory.create(NbaOnePage.Views.Games)
    NbaOnePage.ViewState["section_navigation"] = factory.create(NbaOnePage.Views.SectionNavigation)

    NbaOnePage.ViewState["graph_container_alt"] = factory.create(NbaOnePage.Views.GraphContainerAlt, {'year': year})
    NbaOnePage.ViewState["graph_container_alt"] = factory.create(NbaOnePage.Views.GraphContainerAlt, {'year': year, 'el': 'section.former-players .graph-container', 'eventNameSpace': 'formerPlayersGrid'})

    //trigger click to initialize the graph.  maybe belongs in view initialization code?
    $(".totals tr:nth-child(9) td:nth-child(12)").trigger("click")
    $(".former-players tr:nth-child(9) td:nth-child(12)").trigger("click")
  }
};
