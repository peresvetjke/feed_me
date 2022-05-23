class MeduzaArticleRetriever < ArticleRetriever
  def get_title
    doc.xpath("//h1")
  end

  def get_body
    doc.xpath("//*[@class='GeneralMaterial-article']")
  end

  def get_date
    doc.xpath("//*[@class='GeneralMaterial-head']//time")
  end
end