class ArticleParser
  def initialize(article_link)
    @article = Nokogiri::HTML(open(article_link["href"]))
    yield self
  end
  
  def article_tagline
    tagline = @article.at_css('p.stand-first-alone') || @article.at_css('p#stand-first')
    tagline.content if tagline
  end
  
  def each_paragraph
    @article.css('div#article-body-blocks p').each { |paragraph| yield paragraph.content }
  end
end
