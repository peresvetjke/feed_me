require 'webdrivers'
require_relative "./config/capybara.rb"

module ScrappingDrivers
  class CapybaraScrappingDriver < SessionScrappingDriver
    def create_session
      @session = Capybara::Session.new(Capybara.default_driver)
    end

    def open_page
      session.visit(@page.url)
    end

    def destroy_session
      session.quit
    end

    def click(button_text)
      session.click_button button_text
    end

    def html
      session.html
    end
  end
end