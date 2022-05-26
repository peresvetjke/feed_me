class Factories::MeduzaFactory < AbstractFactory
  def news_retriever
    MeduzaNewsRetriever
  end

  def article_retriever
    MeduzaArticleRetriever
  end

  def scrapping_driver
    OpenUriScrappingDriver
  end
end