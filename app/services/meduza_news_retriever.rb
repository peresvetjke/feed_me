class MeduzaNewsRetriever < NewsRetriever
  private

  def get_articles_urls
    @articles_urls = doc.xpath("//article//a").map { |a| a.attr('href') }
  end

end