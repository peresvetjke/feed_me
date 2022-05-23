class UpdatesManager
  include MyLogger

  RETRIEVERS = { 
    "Новая газета" => {
                        news: NovayaGazetaNewsRetriever,
                        article: NovayaGazetaArticleRetriever
                      },
    "Медуза"       => {
                        news: MeduzaNewsRetriever,
                        article: MeduzaArticleRetriever
                      },
  }

  def initialize(sources: nil, logger: nil)
    @sources = sources || Source.all
    @logger = logger || Logger.new("#{Rails.root}/log/updates_manager.log")
    @browser = Watir::Browser
  end

  def call
    @browser.new
    notice "We've started an Updating job and will inform you when it's been finished."
    @sources.each do |source|
      with_logging("'#{source.title}' retrieving") do
        article_retriever = RETRIEVERS[source.title][:article].new(
          browser: @browser,
          source: source,
          logger: @logger
        )

        news_retriever = RETRIEVERS[source.title][:news].new(
          article_retriever: article_retriever,
          browser: @browser,
          source: source,
          logger: @logger
        ).call  
      end
    end
    notice "New articles have been loaded. Please update page."
  ensure
    with_logging("close_browser") { close_browser }
  end

  private

  attr_reader :logger

  def notice(message)
    Turbo::StreamsChannel.broadcast_update_to('notice', target: 'notice', partial: 'shared/notice', locals: { notice: message } )
  end

  def close_browser
    @browser.close
  end
end