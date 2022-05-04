class UpdatesManager
  SERVICES = [
    { source_title: "Новая газета", service_name: NovayaGazetaArticlesRetriever },
    { source_title: "Медуза", service_name: MeduzaArticlesRetriever }
  ]

  Retriever = Struct.new(:source_title, :service_name, :source, keyword_init: true)

  def initialize
    @services = load_services
  end

  def call
    notice "Updates manager has started the job. You will get the notice once it's finished."

    @services.each do |update_service| 
      service = update_service.service_name.new(
        source: update_service.source, 
        logger: logger
      )
      service.call
    end

    notice "Updates manager finished the job (update page to check new articles)."
  end

  private

  def notice(message)
    Turbo::StreamsChannel.broadcast_update_to('notice', target: 'notice', partial: 'shared/notice', locals: { notice: message } )
  end

  def logger
    @logger ||= Logger.new("#{Rails.root}/log/updates_manager.log")
  end

  def load_services
    SERVICES.each_with_object([]) do |service, services|
      services << Retriever.new(
        source_title: service[:source_title],
        service_name: service[:service_name],
        source: Source.find_by(title: service[:source_title])
      )
    end
  end
end