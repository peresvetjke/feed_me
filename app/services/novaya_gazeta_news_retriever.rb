class NovayaGazetaNewsRetriever < NewsRetriever
  def articles_urls
    doc.xpath("//article").map { |article| article.xpath("..") }.map { |a| a.attr('href').value }
  end
  
  def open_main_page
    super
    current_urls_count = articles_urls.count
    scrapping_driver.click "Загрузить ещё"
    scrapping_driver.wait_until { |page| page.articles_urls.count > current_urls_count }
  end

  def scrapping_driver
    @scrapping_driver ||= ScrappingDrivers::CapybaraScrappingDriver.new(self)
  end
end