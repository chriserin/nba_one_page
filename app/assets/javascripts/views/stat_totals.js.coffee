jQuery ->
  class NbaOnePage.Views.StatTotals extends NbaOnePage.Views.ModularView
    el: 'section.stat-totals'
    events:
      "click tbody tr td": 'statsGridClick'
      "click nav.section-content li": 'clickStatCategory'
      "click th": 'trackSorting'

    globalEvents:
      "splitTypeClick": 'clickNewSplit'

    initialize: (options) ->
      @eventNameSpace = options.eventNameSpace || 'stat_totals'
      @dropDown = @factory.create(NbaOnePage.Views.SplitTypeView, {'el': "section." + $(@el).attr('class') + " span.split-type", 'eventNameSpace': @eventNameSpace})

    statsGridClick: (e) ->
      $currentTarget = $(e.currentTarget)
      cell = new NbaOnePage.Views.StatGridCell($currentTarget)
      @statsGridTarget(cell)

    updateSection: (player, stat) ->
      cell = @getGridCell(player, stat)
      $navTarget = @find("li[data-type=#{cell.tableType()}]")
      @statsGridTarget(cell)
      @targetStatCategory($navTarget)

    statsGridTarget: (targetCell) ->
      return if targetCell.isPlayerNameColumn()

      @triggerGridClick(targetCell.player(), targetCell.stat(), targetCell.team())
      @highliteGridSelection(targetCell.columnIndex(), targetCell.rowIndex(), targetCell.tableType())
      NbaOnePage.router.navigate([@el.classList[0], targetCell.player(), targetCell.stat()].join("/"))

    triggerGridClick: (player, stat, team) ->
      @eventBus.trigger("#{@eventNameSpace}:gridClick", player, stat, team)

    highliteGridSelection: (column, row, tableType) ->
      @find(".highlited").removeClass("highlited")
      @tableRow(tableType, row).addClass("highlited")
      @tableColumn(tableType, column).addClass("highlited")

    getGridCell: (player, stat) ->
      $target = @find("[data-player='#{unescape(player)}'] [data-stat=#{stat}]").eq(0)
      new NbaOnePage.Views.StatGridCell($target)

    clickStatCategory: (event) ->
      $currentTarget = $(event.currentTarget)
      @targetStatCategory($currentTarget)

    targetStatCategory: ($target) ->
      @find("nav.section-content li").removeClass("selected")
      $target.addClass("selected")

      tableType = $target.data("type")
      @allTables().removeClass("selected")
      @table(tableType).addClass("selected")

    defaultClick: () ->
      @find(".totals tr:nth-child(3) td:nth-child(16)").trigger("click")

    trackSorting: (event) ->
      $currentTarget = $(event.currentTarget)
      $currentTarget.parents("table").addClass("sorted")

    clickNewSplit: (splitType) ->
      @find(".tabled-data").load("/Bulls/stats/#{splitType}")

    tableColumn: (tableType, column) ->
      @find("table.#{tableType} tbody td:nth-child(#{column + 1})")

    tableRow: (tableType, row) ->
      @find("table.#{tableType} tbody tr:nth-child(#{row + 1})")

    allTables: ->
      @find("table")

    table: (tableType) ->
      @find("table[data-type='#{tableType}']")

    find: (selector) ->
      $(@el).find(selector)
