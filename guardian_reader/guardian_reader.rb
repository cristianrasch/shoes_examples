require "rubygems"
require "bundler/setup"
require "nokogiri"
require "open-uri"
require "green_shoes"
require File.dirname(__FILE__) + "/html_parser"

Shoes.app(title: "The Guardian", width: 640, height: 480, resizable: false) do
  GUARDIAN_URL = "http://www.guardian.co.uk/"

  stack do
    subtitle "Latest headlines from The Guardian:"
    
    doc = Nokogiri::HTML(open(GUARDIAN_URL))
    HTMLParser.new(doc) do |parser|
      parser.each_article do |article|
        para link article.content, click: -> {
          Shoes.app(title: article.content, width: 1024, height: 768) do
            title article.content
            tagline parser.article_tagline
            parser.each_paragraph { |paragraph| para paragraph }
          end
        }
      end
    end
  end
end

