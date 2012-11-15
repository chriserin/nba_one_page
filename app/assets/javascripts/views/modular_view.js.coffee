class NbaOnePage.Views.ModularView extends Backbone.View
  delegateEvents: (events) ->
    super
    @globalEvents = @globalEvents or {}
    for event, handler of @globalEvents
      if @eventNameSpace
        @eventBus.bind "#{@eventNameSpace}:" + event, _.bind @[handler], @
      else
        @eventBus.bind event, _.bind @[handler], @

