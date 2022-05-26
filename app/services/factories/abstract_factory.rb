class Factories::AbstractFactory
  def source
    raise "Not implemented for abstract class: method 'source' was called."
  end
  
  def news_retriever
    raise "Not implemented for abstract class: method 'news_retriever' was called."
  end

  def article_retriever
    raise "Not implemented for abstract class: method 'article_retriever' was called."
  end

  def scrapping_driver
    raise "Not implemented for abstract class: method 'scrapping_driver' was called."
  end
end