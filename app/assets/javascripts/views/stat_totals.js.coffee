jQuery ->
  class NbaOnePage.Views.StatTotals extends mixOf NbaOnePage.Views.ModularView, NbaOnePage.Views.GridHighlites
    el: 'section.stat-totals'
    events:
      "click tbody tr td": 'statsGridClick'
      "click nav.section-content li": 'clickStatCategory'
      "click th": 'trackSorting'

    globalEvents:
      "splitTypeClick": 'clickNewSplit'

    initialize: (options) ->
      @eventNameSpace = options.eventNameSpace || 'stat_totals'
      options = {'el': "section.#{@sectionClass()} span.split-type", 'eventNameSpace': @eventNameSpace}
      @dropDown = @factory.create(NbaOnePage.Views.SplitTypeView, options)

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

    allTables: ->
      @find("table")

    table: (tableType) ->
      @find("table[data-type='#{tableType}']")

    find: (selector) ->
      $(@el).find(selector)

    sectionClass: ->
      $(@el).attr("class")
