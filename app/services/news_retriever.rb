class NewsRetriever
  include MyLogger

  def initialize(source)
    @source = source
    @articles_urls = []
    @scrapping_driver = nil
  end

  def call
    time_start = Time.now

    with_logging("create_session") { scrapping_driver.create_session } if scrapping_driver.is_a? ScrappingDrivers::SessionScrappingDriver
    with_logging("open_main_page") { open_main_page }
    with_logging("get_articles_urls") { @articles_urls = articles_urls }
    with_logging("filter_new_articles_urls") { @articles_urls = filter_new_articles_urls(@articles_urls) }
    with_logging("save_articles") { save_articles(@articles_urls) }
    log("Articles retrieve jobs (#{@articles_urls.count}) created! It took #{(Time.now - time_start).round} seconds total to perform the job.")
  ensure
    if scrapping_driver.is_a? ScrappingDrivers::SessionScrappingDriver
      with_logging("close_session") { scrapping_driver.destroy_session }
    end
  end

  def url
    @source.news_url.present? ? @source.news_url : @source.base_url
  end

  protected

  # Define in a sub-class what scrapping driver you would like to use.
  #
  # Example: 
  # @scrapping_driver ||= ScrappingDrivers::CapybaraScrappingDriver.new(self) 
  # or
  # @scrapping_driver ||= ScrappingDrivers::OpenUriScrappingDriver.new(self)
  # 
  def scrapping_driver
    raise "Not implemented for abstract class: method 'scrapping_driver' was called."
  end

  # Define in sub-class the way of getting urls list from main page.
  #
  # Example: 
  # doc.xpath("//article").map { |article| article.xpath("..") }.map { |a| a.attr('href').value }
  #
  def articles_urls
    raise "Not implemented for abstract class: method 'get_articles_urls' was called."
  end

  # If you need click "Load more" button or smth like that after main page load 
  # - add logic in sub-classes. 
  #
  # Example:
  # super
  # current_urls_count = page.articles_urls.count
  # scrapping_driver.click "Загрузить ещё"
  # scrapping_driver.wait_until { |page| page.articles_urls.count > current_urls_count }
  #
  def open_main_page
    scrapping_driver.open_page
    scrapping_driver.wait_until { |page| page.loaded? }
  end

  def doc
    Nokogiri::HTML.parse(scrapping_driver.html)
  end
  
  def loaded?
    articles_urls.count > 0
  end

  def filter_new_articles_urls(articles_urls)
    existing_urls = @source.articles.pluck(:url)
    @articles_urls.select { |url| !existing_urls.include?(url) }
  end

  def save_articles(articles_urls)
    @articles_urls.each { |url| ArticleScrapJob.perform_async(@source.title, url) }
  end
end