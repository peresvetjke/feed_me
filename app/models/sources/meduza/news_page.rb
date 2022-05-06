class Sources::Meduza::NewsPage < Sources::NewsPage

  def articles_urls
    doc.xpath("//article//a").map { |a| a.attr('href') }
  end
end