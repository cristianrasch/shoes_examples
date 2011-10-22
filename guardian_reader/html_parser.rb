class HTMLParser
  def initialize(html)
    @html = html
    yield self
  end
  
  def each_article
    @html.css('li.b3 h3 a.link-text').each do |link|
      yield link
    end
  end
end
