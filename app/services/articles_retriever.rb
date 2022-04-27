require_relative './structs/web_article'
require_relative './structs/upload_info'

class ArticlesRetriever
  attr_reader :upload_info

  def initialize(source:, logger:)
    @source = source
    @logger = logger
    @existing_articles = source.articles
    @upload_info = UploadInfo.new(records_in: @existing_articles.count, records_created: 0)
  end

  def call
    articles = scan_articles_list
    
    new_articles = select_new(articles)
    @upload_info.new_articles = new_articles.count
    
    new_articles.each do |article| 
      grab_article(article)
      save_article(article)
      @upload_info.records_created += 1
    end

    @upload_info.records_out = @source.articles.count
  rescue Exception => e
    @logger.error "Uploading has been interrupted."
    @logger.error e.message
    e.backtrace.each { |line| @logger.error line }
    false
  end

  private

  def scan_articles_list
    raise NotImplemented, "not implemented for abstract class"
    # => Array of WebArticle
  end

  def grab_article(web_article)
    raise NotImplemented, "not implemented for abstract class"
    # => WebArticle
  end

  def select_new(web_articles)
    existing_urls = @source.articles.pluck(:url)
    web_articles.select { |article| !existing_urls.include?(article.url) }
  end

  def save_article(web_article)
    Article.create!(
      title: web_article.title, 
      body: web_article.body, 
      url: web_article.url, 
      publication_date: web_article.publication_date, 
      source: @source
    )
  end
end