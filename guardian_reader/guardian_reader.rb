require "rubygems"
require "bundler/setup"
require "nokogiri"
require "open-uri"
require "cgi"
require "green_shoes"
require File.dirname(__FILE__) + "/html_parser"
require File.dirname(__FILE__) + "/article_parser"

Shoes.app(title: "The Guardian", width: 640, height: 480, resizable: false) do
  GUARDIAN_URL = "http://www.guardian.co.uk/"

  stack do
    subtitle "Latest headlines from The Guardian:"
    
    doc = Nokogiri::HTML(open(GUARDIAN_URL))
    HTMLParser.new(doc) do |parser|
      parser.each_article do |article|
        article_title = CGI.escapeHTML(article.content)
        
        para link article_title, click: -> {
          Shoes.app(title: article_title, width: 1024, height: 768) do
            ArticleParser.new(article) do |parser|
              title article_title
              tagline parser.article_tagline
              parser.each_paragraph { |paragraph| para paragraph }
            end
          end
        }
      end
    end
  end
end

