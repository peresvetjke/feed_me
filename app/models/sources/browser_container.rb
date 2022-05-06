class Sources::BrowserContainer
  attr_reader :browser, :source
  
  def initialize(source:, browser: Watir::Browser.new)
    @source = source
    @browser = browser
  end
end