class UpdatesManager
  PAGES = { 
    "Новая газета" => {
                        news_page: Sources::NovayaGazeta::NewsPage,
                        article_page: Sources::NovayaGazeta::ArticlePage
                      },

    "Медуза"       => {
                        news_page: Sources::Meduza::NewsPage,
                        article_page: Sources::Meduza::ArticlePage
                      },
  }

  def initialize
    @logger ||= Logger.new("#{Rails.root}/log/updates_manager.log")
  end

  def call
    notice "Updates manager has started the job. You will get the notice once it's finished."

    browser = Watir::Browser.new
    time = Time.now
    
    Source.each do |s|
      @logger.info("Starting '#{s.title}' uploading...")
      records_in = s.articles.count
      records_created_count = 0
      errors = Hash.new([])

      news_page_klass = PAGES[s.title][:news_page] || Sources::NewsPage
      news_page = news_page_klass.new(browser: browser, source: s)
      existing_urls = s.articles.pluck(:url)
      news_page.open
      new_articles_urls = news_page.articles_urls.delete_if { |article_url| existing_urls.include?(article_url) }
      new_articles_count = new_articles_urls.count

      new_articles_urls.each do |url|
        article_page_klass = PAGES[s.title][:article_page] || Sources::ArticlePage
        article_page = article_page_klass.new(browser: browser, source: s, url: url)
        
        begin
          article_page.open
          params = article_page.params
          s.articles.create!(params.merge(url: url))
          records_created_count += 1
        rescue Exception => e
          @logger.error "Could not grab article: '#{e.message}'\n#{url}"
          errors[e.message] += [url]
        end
      end

      common_output = result_info(
        source: s,
        time_start: time, 
        records_in: records_in, 
        new_articles: new_articles_count, 
        records_created: records_created_count, 
        errors: errors, 
        records_out: s.articles.count
      )

      output = errors.present? ? common_output + errors_info(errors) : common_output
      @logger.info(output)
    end

    browser.close    
    notice "Updates manager has finished the job. You can update page now."
  end

  private

  def result_info(source:, time_start:, records_in:, new_articles:, records_created:, errors:, records_out:)
    "#{source.title} uploading has been finished.\n
      It took: #{Time.now - time_start} seconds. \n\
      Records in: #{records_in}; \n\
      found new: #{new_articles}; records created: #{records_created}; errors: #{errors.values.flatten.count}\n\
      records out: #{records_out}\n\n\n"
  end

  def errors_info(errors)
    ">>>>> Errors info:\n" + errors.map{ |error, urls| "> #{error} (#{urls.count}):\n" + urls.join("\n") + "\n" }.join
  end

  def notice(message)
    Turbo::StreamsChannel.broadcast_update_to('notice', target: 'notice', partial: 'shared/notice', locals: { notice: message } )
  end
end