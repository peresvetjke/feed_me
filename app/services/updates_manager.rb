class UpdatesManager
  SERVICES = [
    { source_title: "Новая газета", service_name: NovayaGazetaArticlesRetriever }
  ]

  Retriever = Struct.new(:source_title, :service_name, :source, keyword_init: true)

  # um = UpdatesManager.new

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
      logger.info("Starting '#{update_service.source_title}' uploading...")
      time = Time.now

      service = update_service.service_name.new(
        source: update_service.source, 
        logger: @logger
      )

      if service.call
        logger.info("Uploading has been succesfully finished.\n
          It took: #{Time.now - time} seconds. \n\
          Records in: #{service.upload_info.records_in}; \n\
          found new: #{service.upload_info.new_articles}; records created: #{service.upload_info.records_created}; \n\
          records out: #{service.upload_info.records_out}")
      end
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