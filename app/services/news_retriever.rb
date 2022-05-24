class NewsRetriever
  include MyLogger

  def initialize(article_retriever:, source:, logger:, browser: Watir::Browser.new)
    @browser = browser
    @articles_urls = []
    @source = source
    @article_retriever = article_retriever
    @logger = logger
  end

  def call
    with_logging("open_main_page")    { open_main_page }
    with_logging("load_more")         { load_more }
    with_logging("get_articles_urls") { get_articles_urls }
    with_logging("filter_new_articles_urls") { filter_new_articles_urls }
    with_logging("save_articles")     { save_articles }
  end

  protected

=begin
  Declare sub-class where:
  1) define BASE_URL. define NEWS_URL too in case it's different from BASE_URL.
  2) define load_more method if needed.
  3) define get_articles_urls, where
     - parse main page 
     - save urls list in @articles_urls 
=end

  attr_reader :logger

  def open_main_page
    @browser.goto @source.news_url.present? ? @source.news_url : @source.base_url
    Watir::Wait.until { loaded? }
  end

  def load_more
  end

  def get_articles_urls
    raise "Not implemented for abstract class: method 'get_articles_urls' was called."
  end

  def filter_new_articles_urls
    existing_urls = @source.articles.pluck(:url)
    @articles_urls = @articles_urls.delete_if { |url| existing_urls.include?(url) }
  end

  def save_articles
    @articles_urls.each do |url| 
      @article_retriever.retrieve_article(url)
    end
  end

  def doc
    Nokogiri::HTML.parse(@browser.html)
  end

  def loaded?
    get_articles_urls.count > 0
  end
end