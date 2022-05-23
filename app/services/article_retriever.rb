class ArticleRetriever
  include MyLogger

  def initialize(source:, logger:, time_zone: nil, browser: Watir::Browser.new)
    @browser = browser
    @source = source
    @time_zone = @source.time_zone || time_zone
    @article_params = nil
    @logger = logger
  end

  def retrieve_article(url)
    with_logging("open_article_page", escape_raise: true)   { open_article_page(url) }
    with_logging("get_article_params", escape_raise: true)  { get_article_params }
    with_logging("save_article", escape_raise: true)        { save_article(url) }
  end

  protected

=begin
  Declare sub-class where:
  1) define the methods which retrieve from doc - title, body and date _elements_
      - get_title
      - get_body
      - get_date
=end

  attr_reader :logger

  def open_article_page(url)
    @browser.goto @source.base_url + url
    Watir::Wait.until { loaded? }
  end
 
  def get_article_params
    @article_params = { 
      title: get_title.text,
      body: get_body.text,
      publication_date: DateParser.new(time_zone: @time_zone, date: get_date.text).call
    }
  end

  def save_article(url)
    @source.articles.create!(@article_params.merge(url: url))
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
    Nokogiri::HTML.parse(@browser.html)
  end

  def loaded?
    get_title.present? && get_title.text.present?
  end
end