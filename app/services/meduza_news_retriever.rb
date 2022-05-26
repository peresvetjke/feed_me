class MeduzaNewsRetriever < NewsRetriever
  def articles_urls
    doc.xpath("//article//a").map { |a| a.attr('href') }
  end

  def scrapping_driver
    @scrapping_driver ||= ScrappingDrivers::OpenUriScrappingDriver.new(self)
  end
end