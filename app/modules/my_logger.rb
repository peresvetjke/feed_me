module MyLogger
  def with_logging(description, escape_raise: false)
    begin
      logger.debug( "Starting #{description}" )
      yield
      logger.debug( "Completed #{description}" )
    rescue
      logger.error( "#{description} failed!!")
      raise unless escape_raise
    end
  end
end