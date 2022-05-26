# NOT USED AT THE MOMENT: Capybara is preferred.
# https://stackoverflow.com/questions/50187716/selenium-webdriver-on-multi-threads-in-sidekiq

# require 'webdrivers'

# class WatirScrappingDriver < ScrappingDriver
#   attr_reader :browser

#   def open_browser
#     @browser ||= Watir::Browser.new(:chrome)
#   end

#   def open_page(url)
#     @browser.goto url
#     Watir::Wait.until { @retriever.loaded? }
#     @load_more.call(@retriever, self) if @load_more
#   end

#   def close_browser
#     @browser.close
#   end

#   def click(button_text, &block)
#     if block_given?
#       button = yield(@retriever, @browser, button_text)
#     else
#       button = @browser.button(:text => button_text)
#     end
#     button.scroll.to
#     button.click 
#   end

#   def html
#     @browser.html
#   end
# end