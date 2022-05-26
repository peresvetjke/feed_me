class NewsScrapJob
  include Sidekiq::Job

  def perform(source_title)
    source = Source.find_by(title: source_title)
    source.news_retriever_class.new(source).call
  end
end
