class NovayaGazetaNewsRetriever < NewsRetriever
  LOAD_MORE = "Загрузить ещё"

  private

  def get_articles_urls
    @articles_urls = doc.xpath("//article").map { |article| article.xpath("..") }.map { |a| a.attr('href').value }
  end

  def load_more
    current_urls_count = get_articles_urls.count
    button_klass = doc.xpath("//button").find { |b| b.text == LOAD_MORE }.attributes["class"].value
    button = @browser.button(:class => button_klass)
    button.scroll.to
    button.click
    Watir::Wait.until(:timeout =>  60) { get_articles_urls.count > current_urls_count }
  end
end