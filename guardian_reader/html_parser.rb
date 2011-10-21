class HTMLParser
  def initialize(html)
    @html = html
    yield self
  end
  
  def each_article
    @html.css('li.b3 h3 a.link-text').each do |link|
      @link = link
      yield link
    end
  end
  
  def article_tagline
    tagline = article.at_css('p.stand-first-alone') || article.at_css('p#stand-first')
    tagline.content if tagline
  end
  
  def each_paragraph
    article.css('div#article-body-blocks p').each { |paragraph| yield paragraph.content }
  end
  
  private
  
  def article
    @article ||= Nokogiri::HTML(open(@link["href"]))
  end
end
