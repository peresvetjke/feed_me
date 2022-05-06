class Sources::NovayaGazeta::NewsPage < Sources::NewsPage
  # news_page = Sources::NovayaGazeta::NewsPage.new(source: Source.last)
  LOAD_MORE = "Загрузить ещё"

  def open
    super
    load_more
  end

  def articles_urls
    doc.xpath("//article").map { |article| article.xpath("..") }.map { |a| a.attr('href').value }
  end

  private

  def load_more
    current_urls_count = articles_urls.count
    button_klass = doc.xpath("//button").find { |b| b.text == LOAD_MORE }.attributes["class"].value
    button = browser.button(:class => button_klass)
    button.scroll.to
    button.click
    Watir::Wait.until { articles_urls.count > current_urls_count }
  end
end