require 'selenium-webdriver'
require 'capybara'
require 'nokogiri'
require_relative './support/web_scrapper_headless'
require_relative './structs/web_article'

class ArticlesRetriever
  def initialize(source:, logger:)
    @source = source
    @logger = logger
    @browser = Capybara.current_session
    @driver = @browser.driver.browser    
    @errors = Hash.new([])
  end

  def call
    @logger.info("Starting '#{@source.title}' uploading...")
    time = Time.now
    records_in = @source.articles.count
    records_created_count = 0
    articles = scan_articles_list
    binding.break
    new_articles = select_new(filter_articles(articles))
    new_articles_count = new_articles.count
    
    new_articles.each do |article| 
      begin
        grab_article(article)
        save_article(article)
        records_created_count += 1
      rescue Exception => e
        @logger.error "Could not grab article: '#{e.message}'\n#{article.url}"
        @errors[e.message] += [article.url]
      end
    end

    common_output = result_info(
      time_start: time, 
      records_in: records_in, 
      new_articles: new_articles_count, 
      records_created: records_created_count, 
      errors: @errors, 
      records_out: @source.articles.count
    )

    output = @errors.present? ? common_output + errors_info(@errors) : common_output
    @logger.info(output)
  end

  private

  def result_info(time_start:, records_in:, new_articles:, records_created:, errors:, records_out:)
    "Uploading has been finished.\n
      It took: #{Time.now - time_start} seconds. \n\
      Records in: #{records_in}; \n\
      found new: #{new_articles}; records created: #{records_created}; errors: #{errors.values.flatten.count}\n\
      records out: #{records_out}\n\n\n"
  end

  def errors_info(errors)
    ">>>>> Errors info:\n" + errors.map{ |error, urls| "#{error} (#{urls.count}):\n" + urls.join("\n") + "\n" }.join
  end

  def main_page_before_scan
    # callback to be used in sub-classes
  end

  def scan_articles_list
    @browser.visit @source.base_url + @source.articles_path
    main_page_before_scan

    doc = Nokogiri::HTML(@driver.page_source)
    articles_nodes = doc.css(@source.article_css)

    articles = []
    articles_nodes.each do |article_node|
      articles << WebArticle.new(url: get_article_url(article_node))
    end

    filter_articles(articles)
  end

  def grab_article(web_article)
    @logger.info "visiting '#{web_article.url}'"
    @browser.visit @source.base_url + web_article.url

    web_article.title = @browser.find(@source.title_css, wait: 30).text
    web_article.body = @browser.find(@source.body_css).text
    web_article.publication_date = DateTime.parse(@browser.find(@source.publication_date_css).text)
  end

  def get_article_url
    raise NotImplemented, "not implemented for abstract class"
  end

  def filter_articles(articles)
    articles.delete_if do |article| 
      @source.article_url_exceptions.any? { |e| article.url =~ e }
    end
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