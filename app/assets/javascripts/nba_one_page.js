window.NbaOnePage = {
  Models: {},
  Collections: {},
  Views: {},
  Routers: {},
  ViewState: {},
  Data: {GraphPoints: []},
  State: {},
  initialize: function(data) {
    new NbaOnePage.Routers.NbaOnePageRouter({ collection: this.tasks, users: this.users });

    if (!Backbone.history.started) {
      Backbone.history.start();
      Backbone.history.started = true;
    }

    var factory = new NbaOnePage.ViewFactory()
    NbaOnePage.ViewState["standings"] = factory.create(NbaOnePage.Views.StandingsView)
    NbaOnePage.ViewState["header"] = factory.create(NbaOnePage.Views.Header)
    NbaOnePage.ViewState["boxscores"] = factory.create(NbaOnePage.Views.Boxscores)
    NbaOnePage.ViewState["graph"] = factory.create(NbaOnePage.Views.GraphContainer)
    NbaOnePage.ViewState["stat_totals"] = factory.create(NbaOnePage.Views.StatTotals)
    NbaOnePage.ViewState["graph_info"] = factory.create(NbaOnePage.Views.GraphInfo)
    NbaOnePage.ViewState["games"] = factory.create(NbaOnePage.Views.Games)

    //trigger click to initialize the graph.  maybe belongs in view initialization code?
    $(".totals tr:nth-child(9) td:nth-child(12)").trigger("click")
  }
};
