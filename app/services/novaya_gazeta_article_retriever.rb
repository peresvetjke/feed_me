class NovayaGazetaArticleRetriever < ArticleRetriever
  private

  def scrapping_driver
    @scrapping_driver ||= ScrappingDrivers::CapybaraScrappingDriver.new(self)
  end

  def get_title
    doc.xpath("//h1")
  end

  def get_body
    doc.xpath("//*[@id='article-body']")
  end

  def get_date
    doc.xpath("//time")[0]
  end
end