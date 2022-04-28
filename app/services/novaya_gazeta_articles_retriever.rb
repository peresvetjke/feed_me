require 'selenium-webdriver'
require 'capybara'
require 'nokogiri'
require_relative './support/web_scrapper_headless'
require_relative './structs/web_article'

class NovayaGazetaArticlesRetriever < ArticlesRetriever
  private

  def main_page_before_scan
    @browser.click_button('Загрузить ещё')
  end

  def get_article_url(article_node)
    article_node.parent.attr('href')
  end
end