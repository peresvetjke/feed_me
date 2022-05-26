module ScrappingDrivers
  class SessionScrappingDriver < ScrappingDriver
    attr_reader :session

    # Example:
    # @session = Capybara::Session.new(Capybara.default_driver)
    def create_session
      raise "Not implemented for abstract class: method 'open_session' was called."
    end

    # Example:
    # session&.quit
    def destroy_session
      raise "Not implemented for abstract class: method 'close_session' was called."
    end
  end
end