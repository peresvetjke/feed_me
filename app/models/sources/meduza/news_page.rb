class Sources::Meduza::NewsPage < Sources::NewsPage
  # news_page = Sources::Meduza::NewsPage.new(source: Source.last)

  def articles_urls
    doc.xpath("//article//a").map { |a| a.attr('href') }
    # doc.xpath("//article").map { |article| article.xpath("..") }.map { |a| a.attr('href').value }
  end
end