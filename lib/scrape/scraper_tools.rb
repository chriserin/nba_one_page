module ScraperTools
  def each_table(tables)
    tables.each do |table|
      yield table
    end
  end

  def each_row(table)
    table.css("tr").each do |row|
      yield row
    end
  end

  def each_column(row)
    row.css("td").each do |cell|
      yield cell
    end
  end
end
