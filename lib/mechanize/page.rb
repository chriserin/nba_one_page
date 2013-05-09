class Mechanize::Page
  def text_of(selector)
    at(selector).text if at(selector)
  end
end
