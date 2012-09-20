jQuery ->
  class NbaOnePage.ViewFactory
    constructor: ->
      @eventBus = _.extend {}, Backbone.Events
      @registry =
        factory: @
    register: (key, value) ->
      @registry[key] = value
    create: (ViewClass, options) ->
      options = options or {}
      passedOptions = _.extend options, @registry, eventBus: @eventBus
      klass = ViewClass
      klass.prototype.eventBus = @eventBus
      new klass(passedOptions)
