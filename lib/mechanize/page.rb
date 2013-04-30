class Mechanize::Page
  def text_of(selector)
    at(selector).text
  end
end
