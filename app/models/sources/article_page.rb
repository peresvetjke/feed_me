class Sources::ArticlePage < Sources::BrowserContainer
  MONTHS = {
    "января"    => "january",
    "февраля"   => "february",
    "марта"     => "march",
    "апреля"    => "april",
    "мая"       => "may", 
    "июня"      => "june", 
    "июля"      => "july",
    "августа"   => "august",
    "сентября"  => "september",
    "октября"   => "october",
    "ноября"    => "november",
    "декабря"   => "december"
  }

  def initialize(source:, browser:, url:)
    super(source: source, browser: browser)
    @url = url
  end

  def open
    @browser.goto @source.base_url + @url
    Watir::Wait.until { loaded? }
  end

  def params
    doc = Nokogiri::HTML.parse(@browser.html)

    { 
      title: doc.xpath(@source.title_xpath).text,
      body: doc.xpath(@source.body_xpath).text,
      publication_date: Time.find_zone(@source.time_zone).parse(
        doc.xpath(@source.publication_date_xpath)[0].text.sub(/[а-я]+/, MONTHS)
      )
    }
  end

  def close
    @browser.close
  end

  def doc
    Nokogiri::HTML.parse(@browser.html)
  end

  private

  def loaded?
    doc.xpath(@source.title_xpath).present? && doc.xpath(@source.title_xpath).text.present?
  end
end