# require_relative "#{Rails.root}/app/modules/instance_counter.rb"

module Capybara
  class Session
    # include InstanceCounter

    def initialize(mode, app = nil)
      if app && !app.respond_to?(:call)
        raise TypeError, 'The second parameter to Session::new should be a rack app if passed.'
      end

      @@instance_created = true # rubocop:disable Style/ClassVars
  
      # Was: @mode = mode #=> strange error >>>
        # "/usr/share/rvm/gems/ruby-3.0.0/gems/capybara-3.36.0/lib/capybara/session.rb:103:in `driver': 
        # no driver called [:selenium] was found, available drivers: :rack_test, :selenium, :selenium_headless, :selenium_chrome, :selenium_chrome_headless (Capybara::DriverNotFoundError)""
      # Solved with: 
      @mode = mode.instance_of?(Array) ? mode.first : mode

      @app = app
      if block_given?
        raise 'A configuration block is only accepted when Capybara.threadsafe == true' unless Capybara.threadsafe

        yield config
      end
      @server = if config.run_server && @app && driver.needs_server?
        server_options = { port: config.server_port, host: config.server_host, reportable_errors: config.server_errors }
        server_options[:extra_middleware] = [Capybara::Server::AnimationDisabler] if config.disable_animation
        Capybara::Server.new(@app, **server_options).boot
      end
      @touched = false
    end

    # def destroy
    #   quit
    #   remove_instance
    # end
  end
end