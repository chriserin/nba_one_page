require './test/test_helper'

class StatTableTest < MiniTest::Unit::TestCase
  def test_render_table
    fragment = Nokogiri::HTML.fragment(Nba::Html::StatTable.render([], :boxscore))
    assert_equal "table", fragment.children[0].name
    assert_equal 1, fragment.css("table").length
  end

  def test_render_headers
    fragment = Nokogiri::HTML.fragment(Nba::Html::StatTable.render_headers(:boxscore))
    assert_operator 5, :<, fragment.css("th").length
  end

  def test_render_headers_totals
    fragment = Nokogiri::HTML.fragment(Nba::Html::StatTable.render_headers(:totals))
    assert_operator 5, :<, fragment.css("th").length
    assert_operator 0, :<, fragment.css("th[class='minutes']").length
    assert_operator 0, :<, fragment.css("th[class='games']").length
  end

  def test_render_headers_per_36
    fragment = Nokogiri::HTML.fragment(Nba::Html::StatTable.render_headers(:per_36))
    assert_operator 5, :<, fragment.css("th").length
  end

  def test_render_headers_per_game
    fragment = Nokogiri::HTML.fragment(Nba::Html::StatTable.render_headers(:per_game))
    assert_operator 5, :<, fragment.css("th").length
  end

  def test_render_headers_per_advanced
    fragment = Nokogiri::HTML.fragment(Nba::Html::StatTable.render_headers(:adv))
    assert_operator 5, :<, fragment.css("th").length
    assert_operator 0, :<, fragment.css("th[class='minutes']").length
  end

  def test_table_with_lines
    lines = [FakeLine.new(points: 10)]
    fragment = Nokogiri::HTML.fragment(Nba::Html::StatTable.render(lines, :boxscore))
    assert_equal 1, fragment.css("table").length
    assert_equal 1, fragment.css("tbody").length
    assert_equal 1, fragment.css("thead").length
    assert_operator 1, :<=, fragment.css("tr").length
  end

  def test_row_data_points
    lines = [FakeLine.new(points: 10)]
    fragment = Nokogiri::HTML.fragment(Nba::Html::StatTable.render(lines, :boxscore))
    assert_equal "points", fragment.css("td[data-stat=points]")[0].attributes["data-stat"].value
    assert_equal "10", fragment.css("td[data-stat=points]")[0].text()
  end

  def test_cell_class
    lines = [FakeLine.new(points: 10)]
    fragment = Nokogiri::HTML.fragment(Nba::Html::StatTable.render(lines, :boxscore))
    assert_equal "rebounds", fragment.css("td[data-stat=offensive_rebounds]")[0].attributes["class"].value
  end

  def test_percentage
    lines = [FakeLine.new(field_goal_percentage: 0.45346)]
    html = Nba::Html::StatTable.render(lines, :boxscore)
    fragment = Nokogiri::HTML.fragment(html)
    assert_equal ".453", fragment.css("tr td[data-stat=field_goal_percentage]")[0].text()
  end

  def test_headers
    lines = [FakeLine.new()]
    fragment = Nokogiri::HTML.fragment(Nba::Html::StatTable.render(lines, :boxscore))
    assert_operator 10, :<= , fragment.css("th").length
  end

  def test_row_name
    lines = [FakeLine.new(line_name: "Bob")]
    fragment = Nokogiri::HTML.fragment(Nba::Html::StatTable.render(lines, :boxscore))
    assert_equal "Bob", fragment.css("td")[0].text()
  end

  def test_blank_plus_minus_on_difference
    lines = [FakeLine.new(line_name: "Bob", is_difference_total: true)]
    fragment = Nokogiri::HTML.fragment(Nba::Html::StatTable.render(lines, :boxscore))
    assert fragment.css("tr")[1].text.include?("--")

    lines = [FakeLine.new(line_name: "Bob", is_difference_total: false)]
    fragment = Nokogiri::HTML.fragment(Nba::Html::StatTable.render(lines, :boxscore))
    refute fragment.css("tr")[1].text.include?("--")
  end

  def test_table_type_boxscore
    lines = [FakeLine.new(line_name: "Bob", is_difference_total: false)]
    fragment = Nokogiri::HTML.fragment(Nba::Html::StatTable.render(lines, :boxscore))
    assert_equal fragment.css("tr")[0].css("th").count, fragment.css("tr")[1].css("td").count
    assert_includes fragment.css("tr")[0].text, "fg%"
    refute_includes fragment.css("tr")[0].text, "pace"
    refute_includes fragment.css("tr")[0].text, "blk%"
    refute_includes fragment.css("tr")[0].text, "usg%"
  end

  def skip_test_table_type_advanced
    lines = [FakeLine.new(line_name: "Bob", is_difference_total: false)]
    fragment = Nokogiri::HTML.fragment(Nba::Html::StatTable.render(lines, :adv))
    assert_includes fragment.css("tr")[0].text, "pace"
  end

  class FakeLine
    def initialize(values_hash = {})
      @values = values_hash
      @values.default = 0
    end
    def is_difference_total; (@values[:is_difference_total] == true) || false; end
    def is_opponent_total; (@values[:is_opponent_total] == true) || false; end
    def game_date; Date.today; end

    def method_missing(meth, *args, &block)
      @values[meth]
    end
  end
end
