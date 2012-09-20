class NbaOnePage.Views.ModularView extends Backbone.View
  delegateEvents: (events) ->
    super
    @globalEvents = @globalEvents or {}
    for event, handler of @globalEvents
      @eventBus.bind event, _.bind @[handler], @
