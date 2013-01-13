jQuery ->
  class NbaOnePage.Views.StatTotals extends NbaOnePage.Views.ModularView
    el: 'section.stat-totals'
    events:
      "click tbody tr td": 'statsGridClick'
      "click nav.section-content li": 'clickStatCategory'
      "click th": 'trackSorting'

    initialize: (options) ->
      @eventNameSpace = options.eventNameSpace || 'stat_totals'

    statsGridClick: (e) ->
      $currentTarget = $(e.currentTarget)
      @statsGridTarget($currentTarget)

    statsGridTarget: ($target) ->
      columnIndex = $target.index()
      rowIndex = $target.parent().index()
      parentTBody = $target.parents("tbody")
      type = parentTBody.data("type")
      return if columnIndex is 0

      NbaOnePage.State.stat = stat = $target.attr("data-stat")
      NbaOnePage.State.player = player = $target.parent().attr("data-player")
      NbaOnePage.State.team = team = $target.parent().data("team")
      @eventBus.trigger("#{@eventNameSpace}:gridClick", player, stat, team)

      @highliteGridSelection(columnIndex, rowIndex, type)
      NbaOnePage.router.navigate([@el.classList[0], player, stat].join("/"))

    updateSection: (player, stat) ->
      $target = $(@el).find("[data-player='#{unescape(player)}'] [data-stat=#{stat}]").eq(0)
      sectionClass = $target.parents("section").attr("class")
      $navTarget = $("section.#{sectionClass} nav li[data-type=#{$target.parents("tbody").attr("class").split(" ")[0]}]")
      @statsGridTarget($target)
      @targetStatCategory($navTarget)

    highliteGridSelection: (column, row, type) ->
      $(@el).find(".stat-totals td, .stat-totals tr").removeClass("highlited")
      $(@el).find("tbody.#{type} td:nth-child(#{column + 1})").addClass("highlited")
      $(@el).find("tbody.#{type} tr:nth-child(#{row + 1})").addClass("highlited")

    selectStatLink: (event) ->
      $(".selected-stat-group-link").removeClass("selected-stat-group-link")
      $(event.currentTarget).addClass("selected-stat-group-link")
      $(".stat-totals tbody").removeClass("selected-stat-group")

    clickStatCategory: (event) ->
      $currentTarget = $(event.currentTarget)
      @targetStatCategory($currentTarget)

    targetStatCategory: ($target) ->
      $(@el).find("nav.section-content li").removeClass("selected")
      $target.addClass("selected")

      type = $target.data("type")
      $(@el).find("tbody, thead").removeClass("selected")
      $(@el).find("tbody.#{type}, thead.#{type}").addClass("selected")

    defaultClick: () ->
      $(@el).find(".totals tr:nth-child(3) td:nth-child(16)").trigger("click")

    trackSorting: (event) ->
      $currentTarget = $(event.currentTarget)
      $currentTarget.parents("table").addClass("sorted")
