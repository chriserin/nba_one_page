class NbaOnePage.Views.GridHighlites
  tableColumn: (tableType, column) ->
    @find("table.#{tableType} tbody td:nth-child(#{column + 1})")

  tableRow: (tableType, row) ->
    @find("table.#{tableType} tbody tr:nth-child(#{row + 1})")

  highliteGridSelection: (column, row, tableType) ->
    @find(".highlited").removeClass("highlited")
    @tableRow(tableType, row).addClass("highlited")
    @tableColumn(tableType, column).addClass("highlited")
