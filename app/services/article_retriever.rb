class ArticleRetriever
  include MyLogger

  # attr_reader :url 

  def initialize(source)
    @source = source
    @url_path = nil
    @article_params = nil
  end

  def retrieve_article(url_path)
    @url_path = url_path
    start_time = Time.now

    if scrapping_driver.is_a? ScrappingDrivers::SessionScrappingDriver
      with_logging("open_browser")        { scrapping_driver.create_session }
    end
    with_logging("open_article_page")   { open_article_page }
    with_logging("get_article_params")  { @article_params = get_article_params }
    with_logging("save_article")        { save_article }
  ensure
    if scrapping_driver.is_a? ScrappingDrivers::SessionScrappingDriver
      with_logging("close_browser")       { scrapping_driver.destroy_session }
    end
    log("Article saved! It took #{(Time.now - start_time).round} seconds total to perform the job.")
  end

  def scrapping_driver
    raise "Not implemented for abstract class: method 'scrapping_driver' was called."
  end

  def get_title
    raise "Not implemented for abstract class: method 'get_title' was called."
  end

  def get_body
    raise "Not implemented for abstract class: method 'get_body' was called."
  end

  def get_date
    raise "Not implemented for abstract class: method 'get_date' was called."
  end
  
  def doc
    Nokogiri::HTML.parse(scrapping_driver.html)
  end

  def loaded?
    get_title.present? && get_title.text.present?
  end

  # protected

  def open_article_page
    scrapping_driver.open_page
    scrapping_driver.wait_until { |page| page.loaded? }
  end

  def url
    @source.base_url + @url_path
  end
 
  def get_article_params
    { 
      title: get_title.text,
      body: get_body.text,
      publication_date: DateParser.new(time_zone: @source.time_zone, date: get_date.text).call
    }
  end

  def save_article
    @source.articles.create!(@article_params.merge(url: @url_path))
  end
end