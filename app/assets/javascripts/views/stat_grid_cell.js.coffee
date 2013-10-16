jQuery ->
  class NbaOnePage.Views.StatGridCell
    constructor: ($target) ->
      @target = $target

    columnIndex: ->
      @target.index()

    rowIndex: ->
      @target.parent().index()

    parentTable: ->
      @target.parents("table")

    tableType: ->
      @parentTable().data("type")

    stat: ->
      @target.data("stat")

    player: ->
      @target.parent().data("player")

    team: ->
      @target.parent().data("team")

    isPlayerNameColumn: ->
      @columnIndex() == 0
