require 'open-uri'

module ScrappingDrivers
  class OpenUriScrappingDriver < ScrappingDriver
    def open_page
      URI.open(@page.url)
    end

    def html
      open_page
    end
  end
end