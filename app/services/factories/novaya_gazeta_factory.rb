class Factories::NovayaGazetaFactory < AbstractFactory
  def news_retriever
    NovayaGazetaNewsRetriever
  end

  def article_retriever
    NovayaGazetaArticleRetriever
  end

  def scrapping_driver
    OpenUriScrappingDriver
  end
end