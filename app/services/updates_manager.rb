class UpdatesManager
  include MyLogger

  def initialize(sources: nil)
    @sources = sources || Source.all
  end

  def call
    # notice "We've started an Updating job and will inform you when it's been finished."
    @sources.each do |source|
      with_logging("'#{source.title}' retrieving") do
        NewsScrapJob.perform_async(source.title)
      end
    end
    # notice "New articles have been loaded. Please update page."
  end

  private

  attr_reader :logger

  def notice(message)
    Turbo::StreamsChannel.broadcast_update_to('notice', target: 'notice', partial: 'shared/notice', locals: { notice: message } )
  end
end