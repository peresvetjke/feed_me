require 'selenium-webdriver'
require 'capybara'
require 'nokogiri'
require_relative './support/web_scrapper_headless'
require_relative './structs/web_article'

class NovayaGazetaArticlesRetriever < ArticlesRetriever
  def initialize(source:, logger:)
    super(source: source, logger: logger)
    @browser = Capybara.current_session
    @driver = @browser.driver.browser
  end

  private

  def scan_articles_list
    @browser.visit @source.base_url + @source.articles_path
    @browser.click_button('Загрузить ещё')

    doc = Nokogiri::HTML(@driver.page_source)
    articles_nodes = doc.css("article")

    articles = []
    articles_nodes.each do |article_node|
      articles << WebArticle.new(
        url: @source.base_url + article_node.parent.attr('href'),
        title: article_node.css('h2').text
      )
    end

    articles
  end

  def grab_article(web_article)
    @browser.visit web_article.url
    web_article.body = @browser.find("#article-body", wait: 10).text
    web_article.publication_date = DateTime.parse(@browser.find("time").text)
    web_article
  end
end