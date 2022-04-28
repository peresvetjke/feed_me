class MeduzaArticlesRetriever < ArticlesRetriever
  private

  def get_article_url(article_node)
    article_node.css('a').attr('href')&.text
  end
end