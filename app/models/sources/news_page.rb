class Sources::NewsPage < Sources::BrowserContainer
  def open
    @browser.goto @source.base_url + @source.articles_path
    Watir::Wait.until { loaded? }
  end

  def close
    @browser.close
  end

  def articles_urls
    raise NotImplemented "NotImplemented for abstract class"
  end

  def doc
    Nokogiri::HTML.parse(@browser.html)
  end

  def loaded?
    articles_urls.count > 0
  end
end