class UpdatesManager
  SERVICES = [
    { source_title: "Новая газета", service_name: NovayaGazetaArticlesRetriever },
    { source_title: "Медуза", service_name: MeduzaArticlesRetriever }
  ]

  Retriever = Struct.new(:source_title, :service_name, :source, keyword_init: true)

  def initialize
    @services = []
  end

  def call
    load_services
    update
  end

  private

  def logger
    @logger ||= Logger.new("#{Rails.root}/log/updates_manager.log")
  end

  def update
    @services.each do |update_service| 
      service = update_service.service_name.new(
        source: update_service.source, 
        logger: logger
      )


      service.call
    end
  end

  def load_services
    SERVICES.each do |service|
      @services << Retriever.new(
        source_title: service[:source_title],
        service_name: service[:service_name],
        source: Source.find_by(title: service[:source_title])
      )
    end
  end
end