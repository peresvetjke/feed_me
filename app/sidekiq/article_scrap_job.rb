class ArticleScrapJob
  include Sidekiq::Job

  def perform(source_title, url)
    source = Source.find_by(title: source_title)
    source.article_retriever_class.new(source).retrieve_article(url)
  end
end
