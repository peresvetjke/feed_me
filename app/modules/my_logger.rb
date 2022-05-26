class ArticlesUpdatesLogger
  @@instance ||= Logger.new("#{Rails.root}/log/updates_manager.log")
  
  def self.instance
    return @@instance
  end
  
  private_class_method :new
end

module MyLogger
  def log(message)
    logger = ArticlesUpdatesLogger.instance
    logger.debug( message )
  end

  def with_logging(description)
    logger = ArticlesUpdatesLogger.instance
    begin
      logger.debug( "Starting #{description}" )
      yield
      logger.debug( "Completed #{description}" )
    rescue => e
      logger.error( "#{description} failed!!")
      logger.error( e )
      raise
    end
  end
end