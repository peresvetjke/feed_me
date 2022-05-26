module ScrappingDrivers
  MAX_WAIT_TIME = 60

  class ScrappingDriver
    def initialize(page)
      @page = page
    end

    def open_page
      raise "Not implemented for abstract class: method 'open_page' was called."
    end

    def click(button_text)
      raise "Not implemented for abstract class: method 'click' was called."
    end

    def html
      raise "Not implemented for abstract class: method 'html' was called."
    end

    def wait_until(&block)
      raise "No block given." unless block_given?
      
      wait_time = MAX_WAIT_TIME
      
      while wait_time > 0 do
        if yield(@page)
          return true
        else
          sleep 1
          wait_time -= 1
        end
      end

      raise "Waited too long."
    end
  end
end