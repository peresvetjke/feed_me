class UpdateArticlesJob
  include Sidekiq::Job

  def perform(*args)
    UpdatesManager.new.call
  end
end
