Capybara.register_driver :selenium do |app|  
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara.javascript_driver = :chrome_headless

Capybara.configure do |config|  
  config.default_max_wait_time = 5 # seconds
  config.default_driver = :selenium_headless
end

